# Upset Plot (UpSet Plot)

## Overview

Upset diagram shows the intersection size of multiple sets and is a modern alternative to Venn diagram. Suitable for displaying combination patterns of multiple classification conditions (such as the coexistence of multiple symptoms).

## When to use

| Condition | Description |
|------|------|
| Scenario | Intersection visualization of 3+ sets |
| Data type | Each observation belongs to 0 or more categories |

## R code

```r
library(UpSetR)
upset(data, sets=c("anxiety","depression","stress","fatigue"),
      order.by="freq", main.bar.color="#69b3a2",
      sets.bar.color="#404080")
```

## vs Venn Diagram

- Venn diagram: 2-3 sets are clear, >4 cannot be read
- Upset: any number of sets, sorted by frequency, clear

## Key parameters

| Parameters | Function |
|------|------|
| `sets` | Set name vector |
| `order.by` | freq(order by frequency)/degree |
| `main.bar.color` | Main column color |
