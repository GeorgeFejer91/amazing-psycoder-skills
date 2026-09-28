# Independent Samples t-test

## Overview

The independent t-test is used to compare the differences in means of two independent groups of samples. Used in between-subjects designs in psychology.

**Typical scenarios**: Experimental group vs control group, Group A vs Group B (different subjects), comparison of different groups of people.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Between-subjects (between-subjects) |
| Condition number | Exactly 2 |
| DV | Continuous variable |
| Data requirements | Each set of data is approximately normal, with homogeneous or uneven variances |

## Hypothesis and test

1. **Independence**: The two groups of subjects are independent of each other
2. **Sampling Distribution/Outliers**: Assess whether mean difference inference is robust using a combination of design, sample size, graphics, and impact diagnostics; grouped Shapiro p-values are not an automatic switch for changing methods
3. **Variance Model**: Pre-declare Student or Welch in the analysis plan; do not use Levene p-values first and then data-driven selection of tests

**Welch t-test is the default recommendation**: homogeneity of variances is not assumed, degrees of freedom correction is performed. In most cases the Welch is safer than the Student's t.

## Effect estimate

Prioritize reporting of the original mean difference and confidence interval; when comparison across scales is required, report the standardized mean difference and interval consistent with the variance model. `d=.2/.5/.8` is not a substantive size boundary that is common across constructs.

## R code

```r
# Independent t-test - Complete analysis flow

# Example data: experimental group vs control group
exp_group  <- c(88, 92, 85, 90, 87, 93, 89, 91, 86, 94, 90, 88)
ctrl_group <- c(78, 80, 82, 79, 81, 77, 83, 80, 78, 82, 79, 81)
n_exp  <- length(exp_group)
n_ctrl <- length(ctrl_group)

# Descriptive statistics
cat(sprintf("Experimental group: M = %.2f, SD = %.2f, n = %d\\n",
  mean(exp_group), sd(exp_group), n_exp))
cat(sprintf("Control group: M = %.2f, SD = %.2f, n = %d\\n",
  mean(ctrl_group), sd(ctrl_group), n_ctrl))

# 1. Perform Welch's t-test according to the pre-stated variance model
t_result <- t.test(exp_group, ctrl_group, var.equal = FALSE)
cat(sprintf("\nWelch t-test:\n  t(%.2f) = %.3f, p = %.4f\n",
  t_result$parameter, t_result$statistic, t_result$p.value))
cat(sprintf("  Mean difference = %.3f, 95%% CI [%.3f, %.3f]\\n",
  t_result$estimate[1] - t_result$estimate[2],
  t_result$conf.int[1], t_result$conf.int[2]))

# If config declares standardized estimates, use standardized quantities and CIs that are consistent with the target population and variance model.
```

## APA 7th Report Format

> A Welch independent-samples t-test estimated a 70-ms mean difference between the experimental group (M=520, SD=95) and control group (M=450, SD=80), 95% CI [26, 114], t(approximately 57 df)=3.15, p=.003. Any standardized estimate should name its denominator and interval separately.

## Alternative method
- **Mann-Whitney U**: When the target is a distribution/rank probability and its assumptions are consistent with the design; it is not a "substitute for the mean test after Shapiro's significance"
- **Welch's ANOVA**: Three groups+
