# Growth Curve Model

## Overview

The growth curve model is used to analyze data that changes over time and estimate the change trajectories of individuals and groups.

**Typical scenario**: Subject's N-back performance at 5 time points, testing practice effects and individual differences.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Longitudinal, ≥3 time points |
| DV | Continuous |
| Key | Time effect + inter-individual change rate difference |

## Model

```r
lmer(dv ~ time + (1+time|subject), data=long_data)
```

- Fixed effects: coefficient of time = average rate of change
- Random effect: Variance of time = individual difference in rate of change

## Non-linear growth

Add time² to test quadratic growth (acceleration/deceleration changes):
```r
lmer(dv ~ time + I(time^2) + (1+time|subject), data=long_data,
     control = lmerControl(optimizer = "bobyqa"))
```

## Report

> A growth curve model examined changes in N-back performance across 5 sessions. Performance improved linearly, b=2.3, t(34)=5.12, p<.001, with significant individual differences in change rates (SD_slope=1.8).
