# Bland-Altman diagram

## Overview

Bland-Altman plots were used to evaluate the agreement between the two measurement methods. X-axis = mean of the two methods, Y-axis = difference of the two methods.

## When to use

| Condition | Description |
|------|------|
| Scenario | Comparing the consistency of two measurement methods |
| Key | Not to test correlation, but to test interchangeability |

## R code

```r
library(blandr)
blandr.draw(data$method1, data$method2)
```

## Interpretation

-Middle dotted line = Bias → 0 = No systematic bias
- Upper and lower dashed lines = 95% limit of agreement (LoA)
- 95% of points are within LoA and LoA is clinically/practically acceptable → both methods are interchangeable
- funnel shape → bias changes with measured value

## Key parameters

| Parameters | Function |
|------|------|
| `method1`,`method2` | Numeric vectors of two measurement methods |
| `loa` | Uniform limit width (default 1.96) |
