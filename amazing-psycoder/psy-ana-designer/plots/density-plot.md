# Density Plot

## Overview

Density plot displays the smooth distribution curve of continuous variables, which is suitable for comparing the distribution shape of multiple conditions.

## When to use

| Condition | Description |
|------|------|
| Scenario | Compare distribution shapes |
| Purpose | Check multimodality, skewness, and distribution differences between groups |

## R code

```r
ggplot(data, aes(x=rt, fill=condition, color=condition)) +
  geom_density(alpha=0.3) +
  labs(title="RT Distribution by Condition", x="RT (ms)", y="Density") +
  theme_minimal()
```

## Interpretation

- Unimodal symmetry → approximately normal
- Long right tail → Positive skewness (common in RT)
- Bimodal → Possibly a mixture of two processes
- Multiple groups of densities do not overlap → large differences between groups

## Key parameters

| Parameters | Function |
|------|------|
| `adjust` | Bandwidth multiplier (>1 smooth, <1 more details) |
| `alpha` | Transparency (0.3-0.5 when overlapping) |
| `bw` | Bandwidth (replaces adjust) |
