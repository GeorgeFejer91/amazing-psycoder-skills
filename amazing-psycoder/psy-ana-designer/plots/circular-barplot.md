# Circular Barplot (Circular Barplot)

## Overview

The donut bar chart arranges the bars in a circular coordinate system, which is suitable for displaying the sorting and comparison of a large number of categories.

## When to use

| Condition | Description |
|------|------|
| Scene | Multi-category sorting (>10 categories), need to be displayed prominently |
| ⚠️ | Not suitable for precise readings (angles are difficult to compare) |

## R code

```r
ggplot(data, aes(x=reorder(label, value), y=value)) +
  geom_bar(stat="identity", fill="#69b3a2", alpha=0.8) +
  coord_polar(start=0) +
  ylim(-max(data$value)*0.2, max(data$value)) +
  theme_void()
```

## vs normal bar chart

Ring bar charts are beautiful but have low accuracy. Recommended to only be used when displaying the **relative ranking** of a category (rather than an exact value).

## Key parameters

| Parameters | Function |
|------|------|
| `coord_polar(start=0)` | Starting angle |
| `ylim` | Y-axis range (need to include negative values to leave the center empty) |
