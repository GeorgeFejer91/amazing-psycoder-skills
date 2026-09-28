# Individual connection diagram (Spaghetti Plot)

## Overview

The individual connection diagram uses a line to connect the data points of each subject under the two conditions, and a thick red line is superimposed to represent the group mean. It is the most intuitive way to show changes within subjects.

## When to use

| Condition | Description |
|------|------|
| Design | Comparison between two groups within subjects |
| DV | Continuous variable |
| Key | Demonstrate the direction and magnitude of change at the individual level |

## Chart elements

| Element | Function |
|------|------|
| Gray thin lines (one for each person) | Individual change trajectory |
| Thick red line | Group mean change |
| Big red dot | Mean value of each group |

## R code

```r
data_agg %>% 
  ggplot(aes(x=condition, y=mean_rt, group=subject_id)) +
  geom_line(alpha=0.3, linewidth=0.5) +
  geom_point(alpha=0.3, size=1) +
  stat_summary(aes(group=1), fun=mean, geom="line", linewidth=1.5, color="red") +
  stat_summary(fun=mean, geom="point", size=3, color="red") +
  labs(title="Individual RT Changes", x="Condition", y="Mean RT (ms)") +
  theme_minimal(12)
```

## Interpretation

- Most of the line slopes have the same direction → the conditional effect is robust
- The line is opposite to the group mean → the subject's pattern is abnormal
- Line dense/sparse → individual difference size

## Key parameters

| Parameters | Function |
|------|------|
| `group=subject_id` | Group connections by subject |
| `alpha` | Individual line transparency (0.2-0.4) |
| `stat_summary(fun=mean)` | Overlay group mean line |
