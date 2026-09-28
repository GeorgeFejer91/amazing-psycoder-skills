# Stacked Area Chart

## Overview

A stacked area chart shows changes in the composition of multiple categories over time. X-axis = time, Y-axis = cumulative amount, color = category.

## When to use

| Condition | Description |
|------|------|
| Scenario | Time Series + Composition Ratio |
| Data | Time × Category × Value |

## R code

```r
ggplot(data, aes(x=time, y=count, fill=category)) +
  geom_area(alpha=0.8, position="fill") +  # position="fill"=scale
  scale_fill_viridis_d() +
  labs(title="Composition Change Over Time", x="Time", y="Proportion") +
  theme_minimal()
```

## Interpretation

- Band width change = increase or decrease in the proportion of a certain category
- Parallel ribbons = stable ratio
- position="stack" (absolute amount) vs "fill" (proportion)
