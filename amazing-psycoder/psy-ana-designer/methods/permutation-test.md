# Permutation Test (Permutation Test)

## Overview

Permutation test is a kind of non-parametric method that constructs a sampling distribution of zero distribution by randomly shuffling data labels without assuming any theoretical distribution.

**Typical scenario**: Small sample within-subjects design (n<15) and doubt that the normality assumption is unreliable; there is no ready-made parametric test when using non-standard statistics.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design type | Within-subjects design and between-subjects design are both possible, especially suitable for within-subjects paired design |
| Dependent variable type | Continuous variable (such as reaction time, accuracy, score) |
| Sample size requirements | Small samples (n < 20), especially when n < 15, the normality assumption of parameter testing is difficult to verify |
| Key assumptions | Exchangeability of observations under the null hypothesis; does not rely on normality or any theoretical distribution |
| Statistics type | Any custom statistic (mean difference, median difference, trimmed mean, etc.) can be used, not limited to standard test statistics |

## Advantages

- No distribution is assumed
- works with any custom statistic
- More reliable in small samples
- Exact p-value (non-asymptotic)

## R code

```r
# Simple replacement: paired design
observed_diff <- mean(condA - condB)
n_perms <- 10000
perm_diffs <- replicate(n_perms, {
  sign_flip <- sample(c(-1,1), length(condA), replace=TRUE)
  mean((condA - condB) * sign_flip)
})
p_value <- mean(abs(perm_diffs) >= abs(observed_diff))
```

## When to use

- n < 20 and normality cannot be assumed
- Use non-standard statistics (such as median difference)
- As a supplement: report the replacement p value and parameter p value, both are consistent → the conclusion is robust

## Report

APA 7th format report example (within-subjects matched design, 10,000 permutations):

> Use permutation test (10,000 permutations) to compare the difference in reaction time between condition A (*M* = 350 ms, *SD* = 45 ms) and condition B (*M* = 320 ms, *SD* = 40 ms). The results showed that the reaction time of condition A was significantly higher than that of condition B, *p* = .023 (permutation test, two-tailed). The observed mean difference was 30 ms, 95% CI [10, 50] (based on bootstrap percentile method).

English comparison:

> A permutation test (10,000 permutations) was conducted to compare reaction times between Condition A (*M* = 350 ms, *SD* = 45 ms) and Condition B (*M* = 320 ms, *SD* = 40 ms). Results indicated that reaction times in Condition A were significantly higher than in Condition B, *p* = .023 (permutation test, two-tailed). The observed mean difference was 30 ms, 95% CI [10, 50] (based on bootstrap percentile method).

Report key points:
- Explicitly specify the number of substitutions (e.g. 10,000)
- Reports observed effect sizes and permutation *p* values
- Indicate single tail/double tail
- If bootstrap is used to calculate confidence intervals, the method should be stated
- It is recommended to report the parameter test results at the same time as a reference. If the two are consistent, the conclusion will be more robust.

## Limitations

- Computationally intensive (a few seconds for n=10000)
- Cannot be given directly to CI (bootstrap required)

