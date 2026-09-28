# Treemap

## Overview

Treemaps use nested rectangles to display the proportions of hierarchical data. Area = numerical size. Suitable for displaying multi-level compositions.

## When to use

| Condition | Description |
|------|------|
| Scene | Hierarchical scale data |
| Advantages | More efficient use of space than pie charts |

## R code

```r
library(treemap)
treemap(data,
        index=c("category","subcategory"),
        vSize="value",
        vColor="value",
        type="value",
        palette="YlGnBu",
        title="Hierarchical Composition")
```

## vs pie chart

Tree charts use space more efficiently than pie charts and can display multi-level hierarchies. Fits >5 categories.

## Key parameters

| Parameters | Function |
|------|------|
| `index` | Hierarchical categorical variable |
| `vSize` | area variable |
| `vColor` | Color variable |
| `palette` | color scheme |
