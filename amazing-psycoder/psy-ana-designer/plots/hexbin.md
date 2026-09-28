# Hexbin Plot

## Overview

When the amount of scatter plot data is extremely large (>10,000 points) and the density cannot be seen clearly due to overlap, hexagonal binning uses color to represent the number of points in each hexagon.

## When to use

| Condition | Description |
|------|------|
| Scenario | Very large sample scatter plot (>5000 points) |
| Advantages | Color-coded density, no overlapping issues |

## R code

```r
ggplot(data, aes(x=rt, y=accuracy)) +
  geom_hex(bins=30) +
  scale_fill_viridis_c() +
  labs(title="RT vs Accuracy (N=50,000)", fill="Count") +
  theme_minimal()
```

## vs scatter plot

When the scatter plot is >5000 points, there is serious overlapping and the density cannot be seen clearly. Hexagonal binning is color-coded for density, suitable for large sample exploration.

## Key parameters

| Parameters | Function |
|------|------|
| `bins` | Number of hexagons (resolution) |
| `scale_fill_viridis_c()` | Color blindness friendly color gradient |
