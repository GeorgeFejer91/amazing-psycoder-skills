# Connected Scatter Plot

## Overview

A connected scatter plot connects the points of time series data with line segments and displays the evolution of the relationship between two variables at the same time.

## When to use

| Condition | Description |
|------|------|
| Scenario | Two variables change together over time |
| Advantages | Show the trajectory, not just the starting point and end point |

## R code

```r
ggplot(data, aes(x=rt, y=accuracy)) +
  geom_path(arrow=arrow(), color="grey70") +
  geom_point(aes(color=time), size=3) +
  scale_color_viridis_c() +
  labs(title="RT-Accuracy Trajectory Over Time") +
  theme_minimal()
```

## vs ordinary scatter plot

Connected scatter plots add a time dimension (path direction), showing 'how to get from A to B' rather than just the locations of A and B.

## Key parameters

| Parameters | Function |
|------|------|
| `geom_path` | Maintain row order concatenation |
| `arrow()` | Add arrow to indicate direction |
| `scale_color_viridis_c()` | Color encoding time |
