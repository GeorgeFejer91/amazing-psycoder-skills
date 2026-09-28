# Parallel Coordinates

## Overview

The parallel coordinate chart uses multiple parallel axes to display high-dimensional data. Each line represents an observation (subject), and the values of the observation on all variables are displayed through multiple axes.

## When to use

| Condition | Description |
|------|------|
| Scenario | Multivariable mode with 4+ continuous variables |
| Advantages | See the individual patterns of all variables in one picture |

## R code

```r
library(GGally)
ggparcoord(data, columns=1:5, groupColumn="condition",
           scale="uniminmax", alphaLines=0.3) +
  scale_color_brewer(palette="Set2") +
  labs(title="Multivariate Profiles by Condition") +
  theme_minimal()
```

## Interpretation

- Parallel lines → the variable cannot differentiate between groups
- crosshatch → the variable is grouped
- Harness Separation→Multivariable Group Differences

## Key parameters

| Parameters | Function |
|------|------|
| `columns` | Selected column range |
| `groupColumn` | Grouping variable |
| `scale` | uniminmax/std/globalminmax |
