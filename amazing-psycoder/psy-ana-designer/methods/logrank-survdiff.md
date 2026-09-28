# Log-Rank test/survival curve comparison

## Overview

The Log-Rank test compares the event-time curves of two or more groups and is one of the candidate tests for censored group comparisons. It answers the question of weighted differences across the entire curve and does not automatically provide domain-interpretable effect estimates.

**Typical scenario**: The time to relapse/remission under two treatment options, or the time to study withdrawal under different recruitment strategies.

**Hard exclusion**: SSRT requires an established stop-signal estimator. Raw stop-signal trials are not censored survival outcomes, so survival curves do not support an SSRT comparison.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Between-group design (comparison of two or more groups) |
| Dependent variable type | time-to-event, including censored data |
| Sample/Information | Design based on number of events, censoring, curve difference shape, allocation ratio, and target power; no universal “20–30 per group” threshold |
| Core Conditions | Well-defined event/time starting points, independent or modeled observation units, defensible censoring mechanisms; risk of crossover altering the power and interpretation of Log-Rank, alternative estimands/tests should be considered in advance |

## vs Cox regression

Log-Rank: Gives a curve difference test; it should still be accompanied by a pre-specified survival probability difference, restricted mean survival time difference, or other interpretable estimates and intervals.
Cox regression: semi-parametric model, which can add covariates and estimate conditional HR, but relies on its model structure and diagnosis

## R code

```r
library(survival)
# Kaplan-Meier curve
fit <- survfit(Surv(time, event) ~ group, data=data)
plot(fit, col=c("red","blue"), lty=1:2)
# Log-Rank test
survdiff(Surv(time, event) ~ group, data=data)
```

## Report

### APA 7th format example

> In this illustrative report, a log-rank test compared time-to-relapse curves for an intervention group (n = 45) and a control group (n = 48), χ²(1, N = 93) = 6.45, p = .011. Kaplan–Meier estimates were accompanied by a prespecified absolute survival-probability difference at six months with a confidence interval; censoring counts and follow-up distributions were reported by group.

### Chinese report example

> In this example, the Log-Rank test is used to compare the time-to-relapse curves of the intervention group (n = 45) to the control group (n = 48), χ²(1, N = 93) = 6.45, p = .011. The six-month recurrence-free probability difference and its confidence interval are also reported, and the number of censoring and follow-up distribution are reported by group.

### Required information

- test statistic χ², degrees of freedom
-Sample size (N)
- p-values and prespecified, interpretable effect estimates and uncertainties
- censoring/risk set information for each group; median survival time is only reported when estimable and consistent with estimand
