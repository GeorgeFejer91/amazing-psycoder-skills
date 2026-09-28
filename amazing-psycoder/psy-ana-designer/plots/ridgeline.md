# Ridgeline Plot

## Overview

Ridge plot is multiple density plots stacked along the Y-axis to compare the distribution shape of 3+ groups or 3+ time points. When the conditions to be compared are >= 3, it is more compact and elegant than multiple histograms.

## When to use

| Condition | Description |
|------|------|
| Scenario | 3+ group distribution comparison, longitudinal multiple time points |
| DV | Continuous |
| Advantages | Space saving, distribution changes are clear at a glance |

## R code

```r
library(ggridges)
ggplot(data, aes(x=rt, y=condition, fill=condition)) +
  geom_density_ridges(alpha=0.7, scale=1.5) +
  scale_fill_viridis_d() +
  labs(title="RT Distribution by Condition", x="RT (ms)", y="Condition") +
  theme_ridges()
```

## Interpretation

- Peak shifts to the right → RT increases between conditions
- peak becomes wider → variability increases
- Multimodal → Possibly mixed subpopulations
- Degree of overlap → Size of difference between conditions

## Key parameters

| Parameters | Function |
|------|------|
| `scale` | Degree of overlap (>1=greater overlap) |
| `quantile_lines` | TRUE=Add median lines |
| `fill` | color map |
