# Correlogram

## Overview

The correlation diagram visualizes the correlation matrix. The lower half triangle = scatter plot + fitting line, the diagonal = variable name + distribution, and the upper half triangle = correlation coefficient. A picture shows complete information of all pairwise relationships.

## When to use

| Condition | Description |
|------|------|
| Scenario | Exploratory multivariate analysis (3-8 continuous variables) |
| Advantages | One picture = all pairs of scattered points + correlation + distribution |

## R code

```r
library(GGally)
ggpairs(data, columns=c("rt","acc","anxiety","age"),
        upper=list(continuous=wrap("cor", size=3)),
        lower=list(continuous=wrap("smooth", alpha=0.3)),
        diag=list(continuous=wrap("densityDiag", alpha=0.5)))
```

## Interpretation

- Diagonal: Density distribution of each variable
- Lower triangle: scatter plot + loess smooth line
-Upper Triangle: Pearson r + Significance Star
- Outlier → Mark Check

## Key parameters

| Parameters | Function |
|------|------|
| `columns` | Selected variable column number |
| `upper` | Upper triangle (cor is recommended) |
| `lower` | Lower triangle (smooth recommended) |
| `diag` | Diagonal (densityDiag recommended) |
