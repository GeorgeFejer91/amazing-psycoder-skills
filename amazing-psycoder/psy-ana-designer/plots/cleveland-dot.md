# Cleveland Dot Plot (Cleveland Dot Plot)

## Overview

Cleveland dot plot uses sorted points to display multiple sets of values, which is the best alternative to bar charts. Priority should be given to psychology thesis.

## When to use

| Condition | Description |
|------|------|
| Scenario | Multiple group sorting comparison (≥5 groups) |
| Advantages | Accurately read values, easy to compare and sort |

## R code

```r
ggplot(data, aes(x=mean_rt, y=reorder(condition, mean_rt))) +
  geom_point(size=4, color="#69b3a2") +
  geom_errorbarh(aes(xmin=mean_rt-se, xmax=mean_rt+se), height=0.2) +
  labs(title="Mean RT by Condition", x="Mean RT (ms)", y="Condition") +
  theme_minimal()
```

## Interpretation

- Point horizontal position = mean
- Error bars=SE/CI
- Sort from top to bottom = from high to low
- Point spacing = difference between conditions

## Key parameters

| Parameters | Function |
|------|------|
| `reorder(var, val)` | Sort Y axis by value |
| `geom_errorbarh` | Horizontal error bar |
