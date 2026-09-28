# Cross-Lagged Panel Model (CLPM)

## Overview

CLPM describes autoregressive and cross-lagged correlations between longitudinal variables. Path direction provides predictive evidence over time, but cannot alone determine causal direction without adequately identifying hypotheses, interventions, or natural experiments.

**Typical scenario**: The mutual predictive relationship between anxiety and sleep quality at three time points. Anxiety (t1) → sleep (t2), or sleep (t1) → anxiety (t2)?

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Longitudinal tracking; two waves can estimate limited cross-lagged correlation, and more than three waves will have more stationary/dynamic structure information, but the number of waves itself does not establish causal identification |
| Dependent variable type | Continuous variable. Both constructs need to be measured simultaneously at each wave, with the same measurement interval |
| Sample information | Determined by wave number, reliability, missingness, random intercept/slope, effect size, and estimator; use design simulation instead of universal N threshold |
| Key assumptions | **Stationality**: The cross-lagged path remains stable at different time intervals; **Synchronicity**: Each measurement needs to be completed in the same time window; **Measurement invariance**: The measurement of the same construct at different time points has the same structure (it is recommended to test metric invariance first); **No legacy confusion**: The main third variable has been included in the model |

## Model

```
X(t1) ─────→ X(t2) ────→ X(t3) (autoregressive path)
  │   ↘       │   ↘
  │ Y(t1) │ Y(t2) (cross-lag path)
  ↓           ↓
Y(t1) ────→ Y(t2) ────→ Y(t3)
```

## vs traditional cross-lag

| Model | Features |
|------|------|
| Traditional CLPM | Mixed between-subjects + within-subjects effects |
| **RI-CLPM** (Random Intercept) | **Recommended** - Separating between-subject and within-subject variation |

## R code (lavaan)

```r
model <- '
  # Autoregressive
  X2 ~ X1; X3 ~ X2
  Y2 ~ Y1; Y3 ~ Y2
  # Crossover hysteresis
  Y2 ~ X1; X2 ~ Y1
  Y3 ~ X2; X3 ~ Y2
  # Related to the same time
  X1 ~~ Y1; X2 ~~ Y2; X3 ~~ Y3
'
fit <- sem(model, data=data)
```

## Report

> A random-intercept cross-lagged panel model examined bidirectional lagged associations between anxiety and sleep across 3 waves. Anxiety at t1 predicted lower subsequent sleep conditional on the model (β=-.18, p=.003), whereas the reverse path was imprecisely estimated (β=-.03, p=.61). This asymmetry does not by itself establish that anxiety causally drives sleep disruption; that interpretation depends on the stated identification assumptions and sensitivity analyses.
