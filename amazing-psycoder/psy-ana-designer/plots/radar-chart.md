# Radar/Spider Chart

## Overview

Radar charts display multivariate data on multiple axes, with each axis representing a variable. Suitable for displaying multi-dimensional profiles of individuals or groups.

## When to use

| Condition | Description |
|------|------|
| Scenario | Multivariate profile comparison (e.g. 3+ standardized scores on cognitive tasks) |
| Variable | 3-10 consecutive, need to be standardized to the same scale |

## R code

```r
library(fmsb)
# The data needs to contain max/min lines to define the axis range
radar_data <- rbind(rep(1,5), rep(0,5), profile_data)
radarchart(radar_data, axistype=1,
           pcol=rgb(0.2,0.5,0.5,0.9), pfcol=rgb(0.2,0.5,0.5,0.3),
           plwd=2, cglcol="grey", cglty=1, axislabcol="grey",
           caxislabels=seq(0,1,0.25), cglwd=0.8, vlcex=0.8)
```

## Interpretation

- Large polygon area = good overall performance
- A certain axis is prominent = the dimension is strong
- Less overlap between the two groups of polygons = large difference in profile between the groups
- Variables need to be standardized to the same scale (such as Z-score)

## Note

->When there are 10 variables, the graph is crowded and difficult to interpret.
- Axis order affects visual impression
- Not suitable for displaying absolute quantities (replace with parallel coordinates)
