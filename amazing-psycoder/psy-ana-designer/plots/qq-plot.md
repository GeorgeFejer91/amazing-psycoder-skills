# QQ Plot (Quantile-Quantile Plot)

## Overview

QQ plot compares data quantiles with theoretical normal distribution quantiles. Points falling on the diagonal = data are normal. Is a visual aid for normality testing.

## When to use

| Condition | Description |
|------|------|
| Scenario | Normality Hypothesis Test |
| Group | Facet by condition |
| Fit | Shapiro-Wilk test value |

## R code

```r
ggplot(data, aes(sample=rt)) +
  geom_qq() + geom_qq_line(color="red") +
  facet_wrap(~condition) +
  labs(title="Q-Q Plots by Condition") +
  theme_minimal()
```

## Interpretation

- Points closely fit the diagonal → Normal ✓
- Both ends deviate from the diagonal (upward/sag) → heavy tail distribution
- S-shaped deviation → skewed distribution
- One end deviates significantly → outlier

## Key parameters

| Parameters | Function |
|------|------|
| `sample=var` | Variable to test |
| `geom_qq_line(color='red')` | Reference diagonal |
| `facet_wrap(~group)` | Group facets |
