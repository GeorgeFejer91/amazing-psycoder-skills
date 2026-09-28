# Correlation Heatmap

## Overview

The heat map color-codes the correlation coefficient matrix between multiple variables to display all pairwise correlations at a glance.

## When to use

| Condition | Description |
|------|------|
| Scenario | Correlation matrix of 4+ continuous variables |
| Goal | Quickly identify strong and weak correlations |

## R code

```r
library(corrplot)
cor_matrix <- cor(data[,vars], method="pearson")
corrplot(cor_matrix, method="color", type="upper",
         addCoef.col="black", tl.col="black", tl.cex=0.8)
```

## Interpretation

- Dark color = strong correlation (positive or negative)
- light color = weak correlation
- Diagonal=1 (self and self)
-Matrix Symmetry

## Key parameters

| Parameters | Function |
|------|------|
| `method` | color/circle/number |
| `type` | upper/lower/full |
| `addCoef.col` | Correlation coefficient text color |
