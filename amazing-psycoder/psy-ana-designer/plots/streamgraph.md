# Streamgraph

## Overview

A flow chart is a variation of a stacked area chart, arranged symmetrically around the center, using flowing shapes to show changes in composition over time. More aesthetically pleasing than a stacked area chart.

## When to use

| Condition | Description |
|------|------|
| Scene | Multi-category composition over time |
| Data | Time × Category × Value |

## R code

```r
library(streamgraph)
streamgraph(data, key="category", value="count", date="year") %>%
  sg_fill_brewer("Set2") %>%
  sg_legend(show=TRUE)
```

## vs stacked area chart

Flow charts are centered and visually more balanced, but their readings are not as accurate as stacked area charts. Suitable for showing overall trends rather than precise values.

## Key parameters

| Parameters | Function |
|------|------|
| `key` | category column |
| `value` | Numeric column |
| `date` | time column |
