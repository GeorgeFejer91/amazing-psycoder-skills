# Dendrogram

## Overview

A dendrogram displays the results of hierarchical clustering, using a branch structure to represent the grouping relationship of data points. It is a necessary visualization for cluster analysis.

## When to use

| Condition | Description |
|------|------|
| Scenario | Hierarchical clustering results |
| Purpose | Determine the optimal number of clusters (pruning height) |

## R code

```r
hc <- hclust(dist(data[,vars]), method="ward.D2")
plot(hc, hang=-1, labels=FALSE, main="Hierarchical Clustering")
rect.hclust(hc, k=3, border="red")  # Mark category 3
```

## Interpretation

- Vertical axis = merge distance (higher = less similar)
- Horizontal axis = observations/clusters
- Low merge = high similarity
- High transverse line → Determine the number of clusters

## Key parameters

| Parameters | Function |
|------|------|
| `method` | Clustering method (ward.D2/complete/average) |
| `hang` | Label hanging position (-1=alignment) |
| `k` | Number of pruning categories |
