# Bubble Chart

## Overview

The bubble chart is an extension of the scatter chart, using the size of the points to represent the third continuous variable. Suitable for showing the relationship between 3 variables.

## When to use

| Condition | Description |
|------|------|
| Scenario | Relationship between 3 continuous variables |
| The third variable | expressed in point size (size) |

## R code

```r
ggplot(data, aes(x=rt, y=accuracy, size=sample_size, color=condition)) +
  geom_point(alpha=0.6) +
  scale_size(range=c(1, 10), name="Sample Size") +
  labs(title="RT vs Accuracy by Sample Size") +
  theme_minimal()
```

## Key parameters

| Parameters | Function |
|------|------|
| `size` | Map the point size of the third variable |
| `scale_size(range=c(a,b))` | Point size range |
| `alpha` | transparency |
