# Scatter plot + regression line (Scatter + Regression)

## Overview

A scatterplot shows the relationship between two continuous variables, with overlaid regression lines and confidence bands.

## When to use

| Condition | Description |
|------|------|
| Variable | Two continuous variables |
| Goal | Show linear relationship, individual differences |
| Extra | Color/shape can be added to distinguish the third variable |

## R code

```r
ggplot(data, aes(x=anxiety, y=stroop_rt)) +
  geom_point(alpha=0.5, size=2) +
  geom_smooth(method="lm", se=TRUE, color="red") +
  labs(title="Anxiety vs Stroop RT", x="Anxiety Score", y="Stroop RT (ms)") +
  theme_minimal(12)
```

## Interpretation

- Points are evenly distributed on both sides of the regression line → the linear relationship is appropriate
- Funnel shape (variance increases with X) → Heteroskedasticity, needs to be processed
- Outlier → Mark the subject ID and check whether it is reasonable
