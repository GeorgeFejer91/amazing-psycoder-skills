# Line Plot

## Overview

The line chart is the most basic time series visualization, using line segments to connect data at consecutive time points. Suitable for displaying trends and changes.

## When to use

| Condition | Description |
|------|------|
| Scenario | Single variable changes over time |
| data | time × continuous value |

## R code

```r
ggplot(data, aes(x=time, y=value)) +
  geom_line(color="#69b3a2", linewidth=1) +
  geom_point(size=2, color="#69b3a2") +
  labs(title="Value Over Time", x="Time", y="Value") +
  theme_minimal()

# Multiple groups of polylines
ggplot(data, aes(x=time, y=value, color=group)) +
  geom_line(linewidth=1) +
  scale_color_brewer(palette="Set2") +
  labs(title="Group Trends", x="Time", y="Value") +
  theme_minimal()
```

## Key parameters

| Parameters | Function |
|------|------|
| `linewidth` | Line width (default 0.5) |
| `linetype` | Line type (solid/dashed/dotted) |
| `color` | Grouping variable mapping color |

## Interpretation

- Uptrend → increasing over time
- turning point → intervention/event impact
- Multiple line spacing changes→Difference changes between groups

## Notes

The X axis needs to be sorted. When there are multiple lines, there should be no more than 6 colors (otherwise it will be difficult to distinguish).
