# Lollipop Chart

## Overview

The lollipop chart uses thin lines + dots to replace the columns of the bar chart, retaining the numerical comparison function but reducing the "ink". An elegant replacement for bar charts.

## When to use

| Condition | Description |
|------|------|
| Scenario | Sorted multiple comparisons |
| Advantages | More concise than bar charts, dots + lines = least ink |

## R code

```r
ggplot(data, aes(x=reorder(condition, mean_rt), y=mean_rt)) +
  geom_segment(aes(xend=condition, yend=0), color="grey", linewidth=1) +
  geom_point(size=4, color="#69b3a2") +
  coord_flip() +
  labs(title="Mean RT by Condition", x="Condition", y="Mean RT (ms)") +
  theme_minimal()
```

## vs bar chart

Lollipop plots use dots to mark values and lines to connect the dots to a baseline. It also displays numerical values, but is visually lighter. Suitable for ranking comparison of ≥5 groups.

## Key parameters

| Parameters | Function |
|------|------|
| `geom_segment(xend,yend=0)` | Line segment from 0 to value |
| `coord_flip()` | Horizontal display (recommended) |
| `reorder()` | Sort by value |
