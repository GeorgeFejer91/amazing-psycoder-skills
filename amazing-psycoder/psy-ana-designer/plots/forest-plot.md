# Forest Plot

## Overview

Forest plots are the standard visualization for meta-analysis. A horizontal line represents the effect size and CI for each study, and a diamond represents the pooled effect size.

## When to use

| Condition | Description |
|------|------|
| Scenario | Meta-Analysis |
| Variable | Effect size+SE/CI |

## R code

```r
library(metafor)
res <- rma(yi=yi, sei=sei, data=dat)
forest(res, slab=paste(Author, Year),
       xlab="Cohen's d", mlab="RE Model")
```

## Interpretation

- First indicate the effect scale and its zero value (the difference is usually 0, the ratio is usually 1); whether the interval crosses the zero value only corresponds to the test under the drawn confidence level, and does not equal "no effect".
- The combined interval needs to be interpreted together with the model, heterogeneity and prediction interval; the diamond being on one side of zero does not mean that all target studies/scenarios have the same directional effect.
- Line length reflects the width of the interval on that scale; accuracy is also affected by model, dependencies, study quality, and heterogeneity estimates.

## Key parameters

| Parameters | Function |
|------|------|
| `slab` | research tags |
| `xlab` | X-axis label (effect size name) |
| `mlab` | Merge effect size labels |
