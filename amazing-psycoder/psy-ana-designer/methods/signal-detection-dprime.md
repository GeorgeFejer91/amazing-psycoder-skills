# Signal Detection Theory / d'

## Overview

Under the equal-variance Gaussian signal-detection model, hit and false-alarm rates yield distinct summaries of **sensitivity (d')** and **response criterion (c)**. They are model-based summaries, not statistically independent quantities.

**Typical scenarios**: In Go/No-go, N-back, memory recognition and other paradigms, the accuracy is decomposed into d' and c.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Detection task including signal trials (signal present) and noise trials (signal not present) |
| Dependent variable | Binary response ("yes"/"no" or "signal"/"noise") |
| Theoretical basis | Signal detection theory framework, need to calculate hit rate (Hit) and false alarm rate (FA) |
| Trial information | Determined by target hit/false alarm rate accuracy, extreme rate probability, condition number and hierarchical model; use binomial information/simulation planning, no universal number of trials per condition |
| Data premise | Classified data that can calculate hit rate and false alarm rate; extreme values (0 or 1) need to be corrected |

## Key indicators

| Indicator | Formula | Meaning |
|------|------|------|
| **d' (d-prime)** | z(Hit) - z(FA) | Discrimination: the ability to distinguish signal from noise |
| **c (criterion)** | -0.5*(z(Hit)+z(FA)) | Response bias: c>0 conservative, c<0 loose |

- Hit = "Yes" response rate when the signal occurs
- FA = Yes response rate when signal is not present (false alarms)

## Why use d' instead of accuracy

With equally frequent signal and noise trials, both observers have 85% accuracy, but:
- A: Hit=95%, FA=25% → d'≈2.32 and c≈−0.49 (liberal criterion)
- B: Hit=85%, FA=15% → d'≈2.07 and c≈0 (neutral criterion)

The accuracy is the same but the difference in d' is large. Using accuracy alone confuses discrimination and response bias.

## Correct extreme values

When Hit or FA is 0 or 1, the z value is infinite. Commonly used corrections:
- **log-linear**: apply (count+0.5)/(number of trials+1) separately to both hits and false alarms
- **1/(2N)**: The extreme value is replaced by 1/(2×number of trials)

## R code

```r
# Signal detection theory: calculation of d' and c
library(tidyverse)
library(effsize)  # for Cohen's d

# ---- Sample data ----
# Each subject's Hit and FA come from the original response data of the experiment
df <- tibble(
  subject   = 1:30,
  group     = rep(c("ADHD", "Control"), each = 15),
  n_signal  = 50,   # Total number of signal trials
  n_noise   = 50,   # Total number of noise trials
  n_hit     = c(sample(30:45, 15, replace = TRUE), sample(35:48, 15, replace = TRUE)),
  n_fa      = c(sample(10:25, 15, replace = TRUE), sample(3:12,  15, replace = TRUE))
)

# ---- Core function: Calculate d' and c ----
calc_dprime <- function(hit, fa, n_signal, n_noise, correction = "loglinear") {
  # Log-linear correction to avoid extreme values
  if (correction == "loglinear") {
    hit_rate <- (hit + 0.5) / (n_signal + 1)
    fa_rate  <- (fa  + 0.5) / (n_noise  + 1)
  } else if (correction == "halfN") {
    half_hit <- 1 / (2 * n_signal)
    half_fa  <- 1 / (2 * n_noise)
    hit_rate <- pmax(pmin(hit / n_signal, 1 - half_hit), half_hit)
    fa_rate  <- pmax(pmin(fa  / n_noise,  1 - half_fa),  half_fa)
  } else {
    hit_rate <- hit / n_signal
    fa_rate  <- fa  / n_noise
  }

  d_prime <- qnorm(hit_rate) - qnorm(fa_rate)
  c_bias  <- -0.5 * (qnorm(hit_rate) + qnorm(fa_rate))

  tibble(hit_rate, fa_rate, d_prime, c_bias)
}

# ---- Batch calculation ----
results <- df |>
  mutate(calc_dprime(n_hit, n_fa, n_signal, n_noise)) |>
  select(subject, group, hit_rate, fa_rate, d_prime, c_bias)

# ---- Group level descriptive statistics ----
results |>
  group_by(group) |>
  summarise(
    n            = n(),
    mean_dprime  = mean(d_prime),
    sd_dprime    = sd(d_prime),
    mean_c       = mean(c_bias),
    sd_c         = sd(c_bias),
    .groups      = "drop"
  )

# ---- Independent samples t-test + effect size ----
# d' Comparison between groups
t_dprime <- t.test(d_prime ~ group, data = results)
print(t_dprime)

cohens_d_dprime <- cohen.d(d_prime ~ group, data = results)
print(cohens_d_dprime)

# c Comparison between groups
t_c <- t.test(c_bias ~ group, data = results)
print(t_c)

# ---- Visualization ----
ggplot(results, aes(x = group, y = d_prime, fill = group)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +
  geom_jitter(width = 0.1, size = 2) +
  labs(
    title  = "Signal detection theory: Discrimination (d') Comparison between groups",
    y      = "d' (discrimination)",
    x      = NULL
  ) +
  theme_minimal()
```

## Report

**Report template (replace every bracketed field with computed results):**

> Sensitivity and criterion were computed from participant-level hit and false-alarm counts using [correction]. The [group/condition] contrast in d' was [estimate, uncertainty interval, test statistic, p-value if applicable]. The corresponding contrast in c was [estimate and uncertainty interval]. Interpret these estimates under the stated signal-detection assumptions.

**Report Highlights**:
- Report the mean and standard deviation of both d' and c
- Reports inferential statistics (t-values, degrees of freedom, p-values) and effect sizes (Cohen's d, 95% CI)
- If the correction method (log-linear / 1/(2N)) is used, this should be stated in the methods section

## Alternative method

- [ROC Analysis (Receiver Operating Characteristic)](../methods/roc-analysis.md) — An extension of signal detection theory, suitable for multi-level confidence assessment
- [Linear Mixed Model](../methods/linear-mixed-model.md) — When it is necessary to model subject and item random effects at the same time
- [Logistic GLMM](../methods/logistic-mixed-model.md) — Directly models yes/no response probabilities when the independent variables are categorical or continuous
- A' (A-prime) — non-parametric signal detection indicator that does not assume equal variance normal distribution (involved in non-parametric tests)
