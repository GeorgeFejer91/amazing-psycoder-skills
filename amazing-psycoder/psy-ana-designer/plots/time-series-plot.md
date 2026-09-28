# Time Series Plot

## Overview

Time series diagram shows the changes of variables over time, which is suitable for longitudinal data and intensive tracking data.

## When to use

| Condition | Description |
|------|------|
| Scenario | Longitudinal tracking, EMA ecological instantaneous assessment |
| Key | Display trends, cycles, intervention breakpoints |

## R code

```r
ggplot(data, aes(x=time, y=score, group=subject_id)) +
  geom_line(alpha=0.3, linewidth=0.3) +
  stat_summary(aes(group=1), fun=mean, geom="line", linewidth=1.5, color="red") +
  geom_vline(xintercept=intervention_day, linetype="dashed") +
  labs(title="Daily Anxiety Scores", x="Day", y="Score") +
  theme_minimal()
```

## Interpretation

- Mean line trend → direction of group change
- Gray individual line → Individual differences
- Change after the dotted line → Intervention effect

## Key parameters

| Parameters | Function |
|------|------|
| `geom_line(aes(group=id))` | Individual trajectory |
| `stat_summary(fun=mean)` | Group mean |
| `geom_vline(xintercept)` | Intervention breakpoint line |
