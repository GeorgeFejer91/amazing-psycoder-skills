# Correlation Ellipse

## Overview

Superimpose the confidence ellipse on the scatter plot to show the strength and direction of the relationship between the two variables. Narrower and longer ellipses = stronger correlation.

## When to use

| Condition | Description |
|------|------|
| Scenario | Scatter plot + visual enhancement of correlation |
| Advantages | Ellipse shape = correlation strength and direction |

## R code

```r
ggplot(data, aes(x=rt, y=accuracy)) +
  geom_point(alpha=0.5) +
  stat_ellipse(level=0.95, color="red", linewidth=1) +
  labs(title="RT vs Accuracy (95% Confidence Ellipse)") +
  theme_minimal()
```

## Interpretation

- Ellipse is narrow and long = strong correlation
- Ellipse is close to circle = weak correlation
- Ellipse tilt direction = positive/negative correlation
- The ellipse contains about 95% of the data points
