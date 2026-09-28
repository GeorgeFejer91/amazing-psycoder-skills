# Multidimensional Scaling (MDS)

## Overview

MDS reduces high-dimensional similarity/distance data to 2D/3D space to visualize the "psychological distance" between objects.

**Typical scenario**: Similarity judgment of 8 emotions → 2D emotion space (valence × arousal); Perceptual similarity of faces → "face space".

## When to use

| Conditions | Requirements |
|------|------|
| Data type | Distance matrix or similarity matrix (n × n) |
| Measurement level | Metric MDS requires equidistant/equal ratio data; Non-metric MDS only requires sequential data |
| Sample requirements | A single distance matrix is enough; INDSCAL requires multiple subject matrices (recommended ≥10) |
| Key assumptions | Metric MDS: distance satisfies triangle inequality; Non-metric MDS: maintains rank relationship under monotonic transformation |
| Number of dimensions | k < n-1, usually k=2 or 3 for visualization |
| Applicable situations | Exploring stimulus spatial structure, testing dimensional theory, brand perception positioning, and visualizing psychological distance |

## Type

| Method | Input | Output |
|------|------|------|
| Metric MDS | Distance matrix | Coordinates |
| Non-metric MDS | Sorting (similarity) | Coordinates (maintaining rank) |
| INDSCAL | Distance matrix of multiple subjects | Common space + individual weight |

## R code

```r
# From similarity matrix to 2D coordinates
fit <- cmdscale(dist_matrix, k=2)
plot(fit, type="n"); text(fit, labels=names)

# Non-metric MDS
library(MASS)
fit <- isoMDS(dist_matrix, k=2)
```

## Report

APA 7th format report example:

> Use the non-metric multidimensional scaling method (Non-metric MDS) to analyze the similarity scoring matrix of 8 kinds of emotional words. The Stress value of the two-dimensional solution is 0.06, indicating that the model fits well (Stress < 0.10). Dimension 1 is interpreted as "pleasure" (Valence: high-load end is "happy" and "satisfied", low-load end is "angry" and "sadness"), and dimension 2 is interpreted as "arousal" (Arousal: high-load end is "angry" and "fear", low-load end is "calm" and "sleepy"). The two-dimensional topographic map shows a ring structure, which is consistent with Russell's (1980) emotional ring model.

**Report elements**: ①MDS type (Metric / Non-metric / INDSCAL) ②Distance/similarity input and data source ③Dimensions and Stress values ​​of the solution ④The naming, explanation basis and typical stimulus coordinates of each dimension ⑤Comparison of results with theoretical expectations or previous studies.

## Evaluation

Stress must incorporate the number of dimensions, distance structure, sample size, random baseline/permutation, and usage explanation; the fixed `.05/.10/.20` labels are not universal fit criteria across datasets.
