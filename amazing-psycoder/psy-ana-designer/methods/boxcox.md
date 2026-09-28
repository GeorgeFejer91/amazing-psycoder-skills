# Box-Cox transformation

## Overview

Box-Cox transformation is a **systematic method** to find the optimal power transformation (λ) to make the data close to normal, rather than blindly trying log/sqrt.

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Between/within group comparison, regression, ANOVA and other linear models |
| Dependent variable type | Continuous positive data (such as reaction time, accuracy rate, physiological indicators) |
| Sample information | The uncertainty of λ is determined by the distribution, range, group/hierarchy structure and sample information; report profile/interval and perform transformation sensitivity analysis |
| Key assumptions | Residual normality violates positive skew distribution |

## Formula

y(λ) = (y^λ - 1) / λ (λ≠0); log(y) (λ=0)

λ=1: no conversion; λ=0: log; λ=0.5: sqrt; λ=-1: reciprocal

## R code

```r
library(MASS)
bc <- boxcox(lm(rt ~ condition, data=data))
lambda <- bc$x[which.max(bc$y)]  # Optimal λ
# Apply transformation
data$rt_transformed <- (data$rt^lambda - 1) / lambda
```

## Report

APA 7th format report example:

> The reaction data showed a positively skewed distribution, so Box-Cox transformation (optimal λ = -0.23) was used for normalization. The transformed data met the normality assumption of the ANOVA (Shapiro-Wilk W = 0.98, p = .412). A 2 (group) × 2 (condition) repeated measures analysis of variance was conducted with the transformed reaction time as the dependent variable, and the results showed...

## Notes

- The interpretation of transformed effect sizes has changed (no longer the original ms scale)
- If λ is close to 0.5 or 0, use familiar sqrt or log for easy interpretation
- The λ found by Box-Cox may be "optimal" but difficult to explain → sometimes the best ≠ the most practical
