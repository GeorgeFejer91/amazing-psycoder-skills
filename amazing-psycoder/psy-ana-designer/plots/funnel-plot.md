# Funnel Plot

## Overview

A funnel plot is a diagnostic plot used in a meta-analysis to examine the relationship between effect size and study precision. The x-axis is usually the effect size, and the y-axis is the standard error or precision; its shape may be affected by publication selection, heterogeneity, design quality, and chance fluctuations, and publication bias cannot be "detected" alone.

## When to use

| Condition | Description |
|------|------|
| Scenario | Small study effects/selection mechanism sensitivity checks in meta-analyses |
| Data | Effect size + SE per study |

## R code

```r
library(metafor)
res <- rma(yi=yi, sei=sei, data=dat)
funnel(res, main="Funnel Plot")
# Egger's regression test
regtest(res)
```

## Interpretation

- Approximate symmetry does not prove the absence of publication selection, especially when the number of studies is small or heterogeneity is high.
- Asymmetry suggests that effect size is related to precision; publication selection is only one candidate explanation and needs to be combined with heterogeneity, outcome definition, study quality and sensitivity model judgment.
- Egger regression gives model evidence of small study effects and is not a binary verdict of "present/absent publication bias"; statistical power and calibration are particularly limited when the number of studies is small.

## Key parameters

| Parameters | Function |
|------|------|
| `main` | title |
| `level` | Funnel boundary confidence level |
