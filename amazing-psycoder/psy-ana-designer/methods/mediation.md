# Mediation Analysis (Mediation Analysis)

## Overview

Mediation analysis estimates the indirect effects defined by the stated path model. Interpreting it as a causal mechanism also requires temporal sequencing, intervention/identification assumptions, no unmeasured confounding, and appropriate sensitivity analyses; a significant indirect effect does not itself prove a mechanism.

**Typical scenario**: Anxiety (X) affects the Stroop interference effect (Y) through attention bias (M). Attentional bias is the mediating variable.

## Model

```
X ──c'──→ Y (direct effect)
  ↘     ↗
    M (indirect effect: a×b)
```

- **Path a**: X→M (The effect of X on the intermediary)
- **Path b**: M→Y (the effect of the mediator on Y, controlling X)
- **Indirect effect (a×b)**: The effect of X affecting Y through M
- **Direct effect (c')**: The direct effect of X on Y (control M)
- **Total effect (c)**: direct + indirect = c' + a×b

## Bootstrap confidence interval

Uncertainty in indirect effects should be determined using methods appropriate to the distribution of the product terms. Bootstrap intervals are a common scheme, but are not the only valid implementation; parametric multiplicative distributions, Monte Carlo, Bayesian posteriors, or design-specific causal mediation methods may also be suitable. Don't rely solely on the crude normal approximation Sobel test.

- The number of Bootstrap resamples is determined by the Monte Carlo error and the target interval accuracy, and the random seed is recorded
- Calculate a×b each time
- Take the 2.5% and 97.5% quantiles as 95%CI
- Report indirect effects and intervals; whether to exclude 0 Answers only prestated tests, does not establish causal mechanisms

## When to use

| Conditions | Requirements |
|------|------|
| Theory-driven | With clear mediating assumptions (timing, causal logic) |
| Design | X before M, M before Y |
| Sample size | Determined by a/b path size, reliability, missingness, design, and target interval accuracy; using simulation/power analysis, no universal n threshold |

## R code

```r
library(lavaan)
model <- '
  M ~ a*X       # path a
  Y ~ b*M + c*X # Path b and c
  indirect := a*b
  total := c + a*b
'
fit <- sem(model, data=data, se="bootstrap", bootstrap=5000)
summary(fit, fit.measures=TRUE)
parameterEstimates(fit, ci=TRUE)
```

## Effect size

| Indicator | Formula | Explanation |
|------|------|------|
| Proportion of indirect effects | a×b / c | Use only when the direction/scale of the total effect makes the ratio stable and meaningful; may be distorted when close to 0 or inconsistent mediation |
| Fully standardized indirect effects | a*×b* | Comparable across studies |

## Report format (APA 7th)

> A mediation analysis examined whether attention bias (M) mediated the effect of anxiety (X) on Stroop interference (Y). The indirect effect was significant, a×b=0.15, Bootstrap 95%CI [0.08, 0.23], accounting for 35% of the total effect.

## Common errors

- ❌ Use only the Baron–Kenny stepwise significance rule, or treat any single CI algorithm as a universal answer
- ❌ Just say "the mediation is significant" without reporting the indirect effect size and CI
- ❌ Cross-sectional data is used as an intermediary - the timing cannot be determined
- ❌ No statistical power analysis (Bootstrap is unstable for small samples)

## Multiple intermediaries

Multiple intermediaries (parallel intermediaries) or chained intermediaries (M1→M2→Y) can be tested at the same time. Using lavaan's multivariate model.
