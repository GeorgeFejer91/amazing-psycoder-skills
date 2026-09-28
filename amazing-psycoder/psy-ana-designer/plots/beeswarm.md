# Beeswarm Plot

## Overview

The bee swarm chart arranges each data point on both sides of the classification axis, and the points do not overlap, making it clearer than jitter scatter points. Suitable for displaying data per subject and with a moderate number of observations.

## When to use

| Condition | Description |
|------|------|
| Scenario | Display all individual data to avoid overlap |
| Number of observations | 10-200 per condition (too many will overflow) |

## R code

```r
library(ggbeeswarm)
ggplot(data, aes(x=condition, y=rt, color=condition)) +
  geom_beeswarm(size=2, alpha=0.7, cex=2) +
  stat_summary(fun=mean, geom="point", size=4, color="red", shape=18) +
  labs(title="RT by Condition", x="Condition", y="RT (ms)") +
  theme_minimal() + theme(legend.position="none")
```

## Key parameters

| Parameters | Function |
|------|------|
| `cex` | Point spacing (the larger, the more dispersed) |
| `size` | Point size |
| `priority` | Prioritize ("ascending"/"descending"/"random") |

## vs Rain Cloud Picture

The rain cloud diagram has a density layer to show the distribution shape, and the bee swarm diagram only shows individual points. When the point is <50, the bee swarm picture will be clearer, and when the point is >100, the rain cloud picture will be better.
