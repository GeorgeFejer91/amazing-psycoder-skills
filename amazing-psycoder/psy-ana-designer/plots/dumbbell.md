# Dumbbell Chart

## Overview

The dumbbell chart uses a line segment to connect the values ​​of two points, and the two ends are marked with dots. Ideal for showing before and after changes or comparing two groups, especially when you need to show comparisons of multiple items at the same time.

## When to use

| Condition | Description |
|------|------|
| Scenario | Pre- and post-test comparison, mean comparison of two groups (multiple items) |
| Goal | Show magnitude and direction of change |

## R code

```r
library(ggalt)
ggplot(data, aes(x=pre, xend=post, y=subject)) +
  geom_dumbbell(size=2, color="#e3e2e1",
                colour_x="#5b8124", colour_xend="#bad744",
                dot_guide=TRUE, dot_guide_size=0.25) +
  labs(title="Pre-Post Change", x="Score", y="Subject") +
  theme_minimal()
```

## Interpretation

- Line length = change range
- Left endpoint = pretest, right endpoint = posttest
- color flip (left > right) = score decrease
- Multiple parallel lines = consistent changes; scattered = large individual differences

## Key parameters

| Parameters | Function |
|------|------|
| `size` | line width |
| `colour_x`/`colour_xend` | Starting and ending colors |
| `dot_guide` | TRUE=Add vertical dotted line guide |
