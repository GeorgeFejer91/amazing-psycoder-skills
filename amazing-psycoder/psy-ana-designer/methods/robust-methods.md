# Robust Methods

## Overview

Robust methods are more reliable than traditional methods when dealing with data containing outliers or heavy-tailed distributions, and do not require arbitrarily excluding data.

**Typical scenario**: RT data contains extremely slow responses (cannot be ruled out - it may be a real cognitive process); small sample size and normality cannot be verified.

## Method comparison

| Traditional methods | Robust alternatives | R packages |
|---------|---------|------|
| Mean | Trimmed mean (trimmed mean, go to 5-20%) / Winsorized mean | `WRS2` |
| Independent t-test | Yuen's t-test (trimmed means) | `WRS2::yuen()` |
| Paired t-test | Paired Yuen or percentile Bootstrap | `WRS2` |
| Pearson correlation | Percentile Bootstrap correlation / Skipped correlation | `WRS2` |
| ANOVA | Robust ANOVA (trimmed means) | `WRS2::t1way()` |
| Regression | MM-estimator / Huber M-estimator | `MASS::rlm()` |

## When to use

| Conditions | Requirements |
|------|------|
| The data contains outliers and cannot be excluded | The outliers have theoretical significance and are not experimental errors |
| Distribution heavy tail | Common in RT data, physiological indicators |
| Small sample size cannot verify normality | n < 30, normality test power is insufficient |
| Sensitivity analysis | Consistent conclusions between traditional methods and robust methods increase confidence |
| Homogeneity of variances is not satisfied | Robust methods are more tolerant of variance heterogeneity |

## Comparison with excluding outliers

Trials excluded from ±2.5SD are "hard deleted" and information may be lost. The robust method automatically reduces the weight of extreme values ​​and retains more data.

## R code

```r
# Example of Robust Statistical Methods
library(WRS2)
library(MASS)

# ── Sample data ──
set.seed(42)
group1 <- c(rnorm(18, 350, 40), 680, 720)  # RT, including two extreme slow reactions
group2 <- c(rnorm(18, 380, 45), 450, 470)
df <- data.frame(
  rt    = c(group1, group2),
  group = rep(c("A", "B"), each = 20),
  id    = rep(1:20, 2)
)

# ── 1. Censored mean ──
mean(group1, trim = 0.20)  # Remove 20% from both ends

# ── 2. Yuen's independent samples t test (trimmed means) ──
yuen_result <- yuen(rt ~ group, data = df, tr = 0.20)
print(yuen_result)
# Output includes: Test statistic (Ty), p-value, trimmed means, effect size ξ (xi)

# ── 3. Robust ANOVA (trimmed means) ──
t1way_result <- t1way(rt ~ group, data = df, tr = 0.20)
print(t1way_result)

# ── 4. Matching Yuen ──
yuend(rt ~ group, data = df, tr = 0.20)

# ── 5. Percentile Bootstrap related ──
x <- rnorm(30)
y <- 0.5 * x + rnorm(30, 0, 1)
y[c(5, 25)] <- c(4.5, -4.0)  # Add outliers
pbcor_result <- pbcor(x, y, beta = 0.20)
print(pbcor_result)
# Output includes: Pearson r via bootstrap, p-value, 95% CI

# ── 6. Robust regression (MM-estimator) ──
df_reg <- data.frame(x = rnorm(40), y = rnorm(40))
df_reg$y[c(3, 30)] <- c(8, -7)  # Outlier
mm_fit <- MASS::rlm(y ~ x, data = df_reg, method = "MM")
summary(mm_fit)

# ── Effect size: Robust Cohen's d (Algina et al., 2005) ──
# Based on trimmed means and Winsorized variance
akp.effect <- function(m1, m2, s1, s2, n1, n2, tr = 0.20) {
  h   <- floor(tr * n1)
  g   <- n1 - 2 * h
  sw1 <- sqrt(((n1 - 1) * s1^2) / (g - 1))
  sw2 <- sqrt(((n2 - 1) * s2^2) / (g - 1))
  sp  <- sqrt(((n1 - 1) * sw1^2 + (n2 - 1) * sw2^2) / (n1 + n2 - 2))
  (0.642 + tr) * (m1 - m2) / sp  # Correction coefficient
}
```

## Report

APA 7th format report example:

> Because the reaction data showed a heavy-tailed distribution and contained extremely slow reactions (which could not be excluded due to experimental errors), robust statistical analysis was used. Yuen's independent samples t test was performed on the censored means (trim = 20%) of the two groups, and the results showed that group A (M<sub>t</sub> = 367.4) responded significantly faster than group B (M<sub>t</sub> = 404.8), T<sub>y</sub> = 2.84, ξ = 0.42, p = .009, 95% CI [0.11, 0.73]. The effect size ξ (robust Cohen's d) indicates a medium effect. As a sensitivity analysis, the traditional independent samples t-test concluded consistently (t(38) = 2.51, p = .017), which enhanced the reliability of the conclusion.

## Alternative method

- Traditional parametric test - when normality and homogeneity of variances are met
-[Nonparametric test](nonparametric.md) — converted to rank order, relatively robust to outliers
- [Bootstrap method](bootstrap.md) — Does not rely on distribution assumptions, suitable for small samples
- Mixed effects model - better than culling aggregation when working with hierarchical data
- Bayesian Robust Regression - Using Student-t likelihood estimation instead of the normality assumption

