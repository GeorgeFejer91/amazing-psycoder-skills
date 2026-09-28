# Biplot

## Overview

Biplot is the standard visualization for PCA/factor analysis. Point = observation (subject), arrow = variable (loading). Show data structures and variable relationships at the same time.

## When to use

| Condition | Description |
|------|------|
| Scenario | PCA/EFA/CFA result visualization |
| Display | First two principal components + variable loadings |

## R code

```r
library(factoextra)
pca <- prcomp(data[,vars], scale=TRUE)
fviz_pca_biplot(pca, repel=TRUE, col.var="#69b3a2", col.ind="grey60")
```

## Interpretation

- Arrow direction = projection direction of the variable in PC space
- Arrow length = proportion of the variable explained by the first two PCs (cos²)
- Arrows in the same direction = positively correlated variables
- Reverse arrow = negative correlation variable
- point clustering = subject subgroup

## Key parameters

| Parameters | Function |
|------|------|
| `repel` | TRUE=tags do not overlap |
| `col.var` | Arrow color |
| `col.ind` | Individual point color |
