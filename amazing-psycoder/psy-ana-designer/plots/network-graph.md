# Network Graph

## Overview

The network diagram shows the partial correlation network between psychological variables. Node = variable, edge = partial correlation coefficient. Used for symptom network analysis, questionnaire item network, etc.

## When to use

| Condition | Description |
|------|------|
| Scenario | Psychological network analysis (psychopathology) |
| Data | Multiple continuous variables |

## R code

```r
library(qgraph)
network <- estimateNetwork(data, default="EBICglasso")
plot(network, layout="spring", theme="colorblind")
```

## Interpretation

- thick/dark edges = strong partial correlation
- Central node (multiple connections) = high Strength centrality
- Green edge = positive correlation, red edge = negative correlation
- Node spacing = connection strength (tight = strong correlation)

## Key parameters

| Parameters | Function |
|------|------|
| `layout` | spring/circle/fruchtermanreingold |
| `cut` | Edge threshold (only display >cut edges) |
| `theme` | colorblind/classic |
