# Correlation

## Overview

Correlation analysis measures the strength of the linear association between two continuous variables.

**Typical scenario**: The relationship between RT and age, the correlation between the performance of the two tasks, and the correlation between the various dimensions of the questionnaire.

## When to use

| Conditions | Requirements |
|------|------|
| Variable type | Two continuous variables (or ordinal variables, use Spearman/Kendall) |
| Relationship form | Linear relationship (check scatter plot; consider curve correlation or transformation when nonlinear) |
| Normality | Pearson requires bivariate normality; Spearman/Kendall does not require this |
| Independence | Each pair of observations is independent (use rmcorr for repeated measurement data) |
| Extreme values | Pearson is sensitive to extreme values; takes precedence when extreme values exist Spearman |
| Sample size | No strict lower limit, but CI is wide when n < 20; small samples are preferred Kendall τ |

## Method selection

| Method | When to use | Assumptions |
|------|--------|------|
| Pearson r | Two variables continuous normal | Linear relationship, no extreme values |
| Spearman ρ | Non-normal/ordinal variables | Monotonic relationships |
| Kendall τ | Small sample, many ties | Monotone relationship |

## Effect size

| r value | explanation |
|------|------|
| 0.1 | small |
| 0.3 | Medium |
| 0.5 | Large |

r² = The proportion of variance that one variable can explain by another variable.

## R code

```r
# Load necessary packages
library(ggplot2)

# Example data: Simulating the relationship between subject age (age) and reaction time (RT)
set.seed(42)
n <- 100
age <- rnorm(n, mean = 35, sd = 12)
RT  <- 500 - 3 * age + rnorm(n, mean = 0, sd = 80)
d   <- data.frame(age, RT)

# -------------------- 1. Descriptive statistics --------------------
cat("Age:", round(mean(d$age), 1), "±", round(sd(d$age), 1), "(M ± SD)\n")
cat("RT:", round(mean(d$RT), 1), "±", round(sd(d$RT), 1), "(M ± SD)\n")

# -------------------- 2. Scatter plot --------------------
ggplot(d, aes(x = age, y = RT)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = TRUE, color = "steelblue") +
  labs(title = "The relationship between age and reaction time",
       x = "Age (years)", y = "Response time (ms)") +
  theme_minimal()

# -------------------- 3. Normality test --------------------
# Pearson's premise: Testing bivariate normality
shapiro.test(d$age)
shapiro.test(d$RT)

# -------------------- 4. Pearson related --------------------
res <- cor.test(d$age, d$RT, method = "pearson")
cat("\nPearson r =", round(res$estimate, 3),
    ", t(", res$parameter, ") = ", round(res$statistic, 2),
    ", p = ", format.pval(res$p.value, digits = 3),
    "\n95% CI: [", round(res$conf.int[1], 3), ", ", round(res$conf.int[2], 3), "]\n", sep = "")

# ------------------ 5. Effect size ------------------
# r itself is the effect size; r² (coefficient of determination) is also reported
r <- res$estimate
cat("r² =", round(r^2, 3), "→", round(r^2 * 100, 1), "% of the RT variance can be explained by age\\n")

# -------------------- 6. Spearman correlation (non-parametric alternative) --------------------
res_sp <- cor.test(d$age, d$RT, method = "spearman")
cat("\nSpearman ρ =", round(res_sp$estimate, 3),
    ", p =", format.pval(res_sp$p.value, digits = 3), "\n")

# -------------------- 7. Kendall τ (recommended for small samples/many ties) --------------------
res_kt <- cor.test(d$age, d$RT, method = "kendall")
cat("Kendall τ =", round(res_kt$estimate, 3),
    ", p =", format.pval(res_kt$p.value, digits = 3), "\n")

# -------------------- 8. Multivariable correlation matrix --------------------
# Assume there are multiple variables
d_multi <- data.frame(
  age   = age,
  RT    = RT,
  score = 60 + 0.5 * age + rnorm(n, 0, 10)
)
cor_matrix <- cor(d_multi, method = "pearson")
cor_pvals <- psych::corr.test(d_multi)$p
print(round(cor_matrix, 3))

# -------------------- 9. Repeated Measures Correlation (rmcorr) --------------------
# Use rmcorr instead of normal Pearson when there are multiple rows of data for each subject
# library(rmcorr)
# rmcorr_result <- rmcorr(participant = subject_id, measure1 = var1, measure2 = var2, dataset = df)
```

## APA report format

> Reaction time was negatively correlated with age, r(98)=-.34, p<.001, 95% CI [-.50, -.16].

## Notes

- Correlation ≠ Causation
- The scatter plot needs to be checked to confirm the linear relationship (r may be close to 0 when non-linear)
- Extreme values have a huge impact on r
- Ordinary Pearson r cannot be used for within-subject repeated measurement data - multiple rows for each subject, violating independence. Use **rmcorr (repeated measures correlation)** instead

## Alternative method

- Simple Linear Regression - When a clear distinction between predictor and outcome variables is required
- [rmcorr (repeated measures correlation)](rmcorr.md) — Correlation analysis for within-subjects repeated measures designs
- Partial correlation - when a third variable needs to be controlled
- Polynomial Correlation/Curve Regression - When the relationship is non-linear
- [Bland-Altman Analysis](bland-altman.md) — Evaluates the agreement of two measures rather than the strength of the association
- [Reliability Analysis (Cronbach's α/ICC)](reliability.md) — Assess the internal consistency or inter-rater agreement of a measurement instrument
