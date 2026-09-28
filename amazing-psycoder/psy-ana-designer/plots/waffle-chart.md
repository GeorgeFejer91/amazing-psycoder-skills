# Waffle Chart

## Overview

The waffle chart uses a square matrix to represent the proportion, with each square representing 1% or a fixed amount. Convey proportional information more accurately than a pie chart.

## When to use

| Condition | Description |
|------|------|
| Scene | Show composition ratio (replacement of pie chart) |
| Advantages | 1 square = fixed unit, intuitive and accurate |

## R code

```r
library(waffle)
parts <- c(Congruent=60, Incongruent=40)
waffle(parts, rows=10, colors=c("#69b3a2","#404080"),
       title="Trial Type Distribution")
```

## vs pie chart

Waffle charts are more accurate than pie charts (humans are not good at comparing angles and areas). Each square = discrete unit, easy to count.

## Key parameters

| Parameters | Function |
|------|------|
| `rows` | Number of rows (control grid size) |
| `colors` | color vector |
| `title` | title |
