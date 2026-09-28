# Bootstrap method

## Overview

Bootstrap estimates the sampling distribution of a statistic by resampling with replacement from the original data. There is no need to assume theoretical distribution, and the scope of application is extremely wide.

**Typical scenarios**: Confidence interval of effect size, indirect effect test of mediation effect, inference of non-standard statistics.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Within or between subjects |
| DV | Continuous or Categorical |
| Purpose | Effect size CI, mediating indirect effect, non-standard statistical inference |
| Number of resampling | ≥5000 (when reporting CI) |
| Resampling unit | Need to match the analysis unit (within subject → resampling subject) |

## Type

| Type | Method | Applicable |
|------|------|------|
| Non-parametric Bootstrap | Resampling directly from data | General |
| Parameter Bootstrap | Sampling from the fitted distribution | Small sample size but model |
| Residual Bootstrap | Resampled Residual | Regression Model |

## Bootstrap CI method

| Method | Features |
|------|------|
| Percentile | Simple, asymmetrically acceptable |
| BCa (Bias-Corrected) | **Recommended**, corrected bias and skewness |
| Studentized | The most accurate but requires SE estimation |

## R code

```r
library(boot)

# ==== 1. Paired design: Cohen's d's Bootstrap CI ====
# Resample difference scores to preserve within-subject pairing structure
set.seed(123)
n <- 30
rt_congruent    <- rnorm(n, mean = 450, sd = 80)
rt_incongruent  <- rnorm(n, mean = 520, sd = 95)
diff_scores     <- rt_incongruent - rt_congruent

boot_d <- function(d, indices) {
  mean(d[indices]) / sd(d[indices])
}

boot_res <- boot(diff_scores, statistic = boot_d, R = 5000)
boot_res
boot.ci(boot_res, type = "perc")   # Percentile CI
boot.ci(boot_res, type = "bca")    # BCa CI (recommended)

# ==== 2. Independent group: Cohen's d's Bootstrap CI ====
library(effsize)
set.seed(42)
g1 <- rnorm(35, mean = 10, sd = 3)
g2 <- rnorm(35, mean = 12, sd = 3)
n1 <- length(g1); n2 <- length(g2)

d_boot <- replicate(5000, {
  s1 <- sample(g1, n1, replace = TRUE)
  s2 <- sample(g2, n2, replace = TRUE)
  cohen.d(s1, s2)$estimate
})

cat(sprintf(
  "Cohen's d = %.2f, 95%% CI [%.2f, %.2f]\n",
  cohen.d(g1, g2)$estimate,
  quantile(d_boot, 0.025),
  quantile(d_boot, 0.975)
))

# ==== 3. Mediating effect Bootstrap (indirect effect a×b) ====
library(lavaan)

set.seed(1)
n_obs <- 200
X <- rnorm(n_obs)
M <- 0.5 * X + rnorm(n_obs, sd = 0.8)
Y <- 0.3 * M + 0.4 * X + rnorm(n_obs, sd = 0.7)
med_df <- data.frame(X, M, Y)

model <- '
  M ~ a*X
  Y ~ b*M + cp*X
  indirect := a * b
  total    := a * b + cp
'

fit <- sem(model, data = med_df, se = "bootstrap", bootstrap = 5000)
parameterEstimates(fit, boot.ci.type = "bca.simple", level = 0.95)
```

## Report

### APA 7th Report Format (Mean Difference)

> The effect size of paired mean differences was estimated using the Bootstrap method (5000 resamples). The results showed that Cohen's d = 0.62, 95% BCa CI = [0.12, 1.10], and the confidence interval did not include zero, indicating that the difference between the two conditions had a larger than moderate effect size.

### APA 7th Report Format (Mediation Analysis)

> Use the Bootstrap method (5000 resamplings) to test for indirect effects. The results show that ab = 0.28, 95% BCa CI = [0.11, 0.47], and the confidence interval does not include zero, indicating that the mediating effect of M between X and Y is significant.

## Notes

- The number of resamples ≥ 5000 (when reporting CI)
- The resampling unit needs to match the analysis unit (within subject → resampling subject, non-trial)
- Bootstrap cannot save bad data - reasonable sample size and experimental design are still required

## Alternative method

- permutation test - suitable for hypothesis testing rather than interval estimation
- Robust regression — an alternative to traditional regression when dealing with outliers
- Bayesian method - provides the entire posterior distribution rather than a point estimate interval

