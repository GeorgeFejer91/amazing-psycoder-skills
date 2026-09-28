# Equivalence Testing (TOST)

## Overview

The equivalence test sets the null hypothesis that the effect falls outside the predefined equivalence interval and is used to evaluate whether the data supports "the effect is so small that it can be ignored in this field." It provides evidence that is controlled by the error rate, not absolute proof that the two groups are identical.

**Typical scenario**: Evaluate whether the difference between the old and new methods or two experimental versions falls within the predefined substantial equivalence range.

## When to use

| Conditions | Requirements |
|------|------|
| Research design type | Two-group independent sample or paired sample design |
| Dependent variable type | Continuous variable (such as reaction time, accuracy, scale score) |
| Sample size requirements | Determined by equivalence boundaries, target power, variance, design, and loss to follow-up; boundaries cannot be relaxed ex post facto due to small samples |
| Key assumptions | Consistent with the estimator used (paired/independent, variance model, distribution/robustness); equivalence boundaries must be set based on domain, measurement, and decision consequences before looking at results |
| Equivalence boundary setting reference | Prefer using the smallest important difference in the original dimensions or a validated normalized boundary; `d=.3/.5` is not a universal default |

## TOST logic

1. Set the equivalent boundary Δ (minimum meaningful effect, such as d=0.3)
2. Do two one-sided t tests:
   - H0a: Effect ≥ +Δ → p1
   - H0b: Effect ≤ -Δ → p2
3. p = max(p1, p2). p<.05 → equivalent

## When to use

- Want to test whether the data supports "difference less than predefined significance boundary"
- Compare the two-way equivalence of the old and new methods; if the question is only "no worse than the old method", a non-inferiority test should be designed instead of calling it an equivalence test
- Check the differences between versions (experimental version A vs B)
- Manipulation check (confirm that IV manipulation does not affect irrelevant variables)

## vs traditional inspection

Traditional test p>.05 = "The point null hypothesis is not rejected", which does not mean that there is no important difference. Only when the confidence interval/two-sided test of the equivalence test falls within a predefined boundary, the data supports the conclusion of equivalence at that boundary.

## R code

```r
library(TOSTER)
tsum_TOST(m1=520, m2=515, sd1=80, sd2=82, n1=30, n2=30,
          low_eqbound_d=-0.3, high_eqbound_d=0.3)
```

## Report

APA 7th format report example:

> We used TOST for the prespecified [independent/paired] contrast with equivalence bounds of [lower, upper] in [units] and α = [.05]. The estimated difference was [estimate], with a 90% confidence interval of [lower, upper]. [The full interval was/was not] contained within the prespecified bounds, so [equivalence was/was not] supported at this margin. Report the two one-sided test statistics and p-values from the actual computation.

Key points:
- Report the equivalent bound Δ and its substantive meaning (such as d_z and original units)
- Reports both t-values and p-values for two one-sided tests
- Reports the overall p-value for the equivalence test (taken as the larger of the two one-sided test p-values)
- For a standard TOST at α = .05, report the corresponding 90% two-sided CI; equivalence is supported only when the entire interval lies strictly within the prespecified bounds.
- Report descriptive statistics (M, SD) to allow readers to assess the actual size of the differences
