# Mosaic Plot

## Overview

The mosaic plot uses a rectangular area to represent the frequency of the crosstab of categorical variables. The bigger the rectangle = the more combinations there are. Suitable for showing the relationship between two or more categorical variables.

## When to use

| Condition | Description |
|------|------|
| Scenario | Crosstab of 2-3 categorical variables |
| Advantages | Visual display of area frequency, standard residual coloring |

## R code

```r
library(vcd)
mosaic(~ condition + error_type, data=data,
       shade=TRUE, legend=TRUE,
       labeling_args=list(set_varnames=c(condition="Condition",
                                          error_type="Error Type")))
```

## Interpretation

- Rectangular area = number of observations for this combination
- blue = observed > expected (positive residuals)
- red = observed < expected (negative residual)
- The darker the color = the further you deviate from your expectations

## Key parameters

| Parameters | Function |
|------|------|
| `shade=TRUE` | Residual coloring (blue = more than expected, red = less than expected) |
| `legend=TRUE` | Display residual legend |
