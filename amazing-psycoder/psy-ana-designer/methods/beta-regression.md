# Beta Returns

## Overview

Beta regression is used to model continuous proportion data with values in the (0,1) interval, such as accuracy (non-0/1 trials), attention allocation proportion, and resource allocation proportion.

**Typical scenario**: Compare the proportion of attention allocation between conditions; modeling accuracy (one proportion value per subject per condition, far away from 0 and 1).

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Between-subjects or within-subjects design is acceptable; the dependent variable is continuous proportion data |
| Dependent variable type | Continuous proportion value, the value range is strictly within the (0, 1) open interval |
| Sample information | Determined by mean/accuracy submodel, boundary value, clustering, number of parameters and target interval accuracy; use simulation/identifiability diagnosis, not apply N/10 rule |
| Dependent variable distribution | Proportional data, no stacking at 0 or 1 boundaries; heteroscedasticity acceptable (small variance at the boundaries, large variance at the center) |
| Key assumptions | Observation independence; Specify link function correctly (default logit); No zero/one inflation (if present, use ZOIB model instead); Model coefficients are stable on subsamples |
| Typical data shape | Trials have been aggregated by subject/condition; each subject provides only one proportion value per condition |

## When to use vs glmer

| Method | Data | When to use |
|------|------|--------|
| Beta regression | Proportion (0,1), one value per subject per condition | Trials have been averaged, proportion between 0.1-0.9 |
| glmer(binomial) | 0/1 trials, one trial per row | with original trial data |

## R code

```r
library(betareg)
model <- betareg(accuracy ~ condition, data=data_agg)
summary(model)
```

## Benefits

- Naturally handles heteroscedasticity in proportional data (small variance when close to 0 or 1, large variance when 0.5)
- More intuitive than arcsine transformation (estimates are in the original scale)

## Report Format (APA 7th)

**Example**:

> A beta regression with logit link estimated the association between condition and a continuous attention-allocation proportion in (0, 1). Report the fitted coefficient, uncertainty interval, model diagnostics, and predicted proportions by condition from the actual data. If a pseudo-*R*² is reported, name its definition; it is not generally the percentage of outcome variance explained.

**Key reporting elements**: (1) Link function used (usually logit); (2) Regression coefficient *b*, standard error *SE*, *z* value and *p* value; (3) Effect size indicator (such as pseudo *R*^2 or odds ratio); (4) If the boundary value is transformed (such as (y*(n-1)+0.5)/n), it needs to be disclosed in the methods section.
