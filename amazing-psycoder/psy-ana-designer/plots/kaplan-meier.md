# Kaplan-Meier survival curve

## Overview

The Kaplan-Meier curve shows the probability of event occurrence time and is suitable for analyzing "time → event" data such as Stop-signal tasks and delay discounts.

## When to use

| Condition | Description |
|------|------|
| DV | Time of event + whether it occurred (censored) |
| Grouping | 1-4 group comparison |

## R code

```r
library(survival)
fit <- survfit(Surv(time, event) ~ group, data=data)
plot(fit, col=c("red","blue"), lty=1:2, lwd=2,
     xlab="Time (ms)", ylab="Survival Probability")
legend("topright", legend=levels(data$group), col=c("red","blue"), lty=1:2)
```

## Interpretation

- The curve decreases quickly → the event occurs early
- Curve separation → Difference between groups
- Flat segment → no events in this period
- "+" mark → censored observation

## Key parameters

| Parameters | Function |
|------|------|
| `Surv(time,event)` | Survival object |
| `col` | Group color |
| `lty` | Line type distinction |
