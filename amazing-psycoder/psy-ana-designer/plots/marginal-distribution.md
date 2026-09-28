# Marginal Distribution

## Overview

Add a histogram or density chart to the edges of the X-axis and Y-axis of the scatter plot to simultaneously display the relationship between the two variables and their respective distributions. It is a high information density chart recommended by APA.

## When to use

| Condition | Description |
|------|------|
| Scenario | Correlation + distribution of two continuous variables |
| Advantages | One picture shows the relationship + respective distribution |

## R code

```r
library(ggExtra)
p <- ggplot(data, aes(x=anxiety, y=stroop_rt)) +
  geom_point(alpha=0.5, size=2, color="#69b3a2") +
  geom_smooth(method="lm", se=TRUE, color="red") +
  theme_minimal()
ggMarginal(p, type="density", fill="#69b3a2", alpha=0.5)
# type="histogram" for histograms
```

## Interpretation

- Main picture: Relationship between two variables (scatter points + regression line)
- Top: X variable distribution
- Right side: Y variable distribution
- Distribution deviates from normal → Consider transformation or non-parametric methods
