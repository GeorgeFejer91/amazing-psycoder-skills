# Donut Chart

## Overview

A donut chart is a variation of a pie chart, with an empty center and the arc length of the ring representing the proportion.

## When to use

| Condition | Description |
|------|------|
| Scenario | Proportional display of 2-5 categories |
| ⚠️ | Not recommended for exact comparisons (bar charts are more accurate) |

## R code

```r
library(ggplot2)
data <- data.frame(category=c("A","B","C"), count=c(30,45,25))
data$fraction <- data$count/sum(data$count)
data$ymax <- cumsum(data$fraction)
data$ymin <- c(0, head(data$ymax, n=-1))

ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect(color="white", linewidth=1) +
  coord_polar(theta="y") +
  xlim(c(2,4)) +
  scale_fill_brewer(palette="Set2") +
  theme_void() + theme(legend.position="right")
```

## Dispute

The human eye is not good at comparing angles and arc lengths. Bar charts are better for precise comparisons. Donut charts are only recommended for showing rough proportions of 2-3 categories.

## Key parameters

| Parameters | Function |
|------|------|
| `xlim(c(2,4))` | The inner and outer radii of the ring |
| `coord_polar(theta='y')` | Convert to polar coordinates |
