# Structural Equation Modeling (SEM)

## Overview

SEM combines factor analysis (measurement model) and path analysis (structural model) to simultaneously estimate the relationship between latent variables. It is a general framework for mediation, moderation, and longitudinal analysis.

**Typical scenario**: Test whether "executive function" (latent variable, measured by 3 tasks) mediates the impact of age on the Stroop effect.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Cross-sectional or longitudinal observational design, based on an explicit theoretical model; can also be used to test mediation/moderating paths in experimental designs |
| Dependent variable type | Continuous variable (observation indicators are continuous or ordered classification, latent variables and their indicators can be continuous) |
| Sample information | Determined by model degrees of freedom, loadings, reliability, distribution, missingness, and target effects; use model-specific simulation/power analysis, do not use N≥200 or fixed people per parameter rule |
| Core assumptions | Multivariate normality (can be relaxed with robust estimation such as MLR), linear correlation of observation indicators, measurement model satisfies local independence, and measurement invariance needs to be tested when comparing multiple groups |

## Two sub-models

| Model | Content | Similar |
|------|------|------|
| Measurement model | Latent variables ↔ Observed indicators | CFA |
| Structural model | Regression path between latent variables | Path analysis |

## Common indicators

| Indicator | Standard |
|------|------|
| CFI | >0.95 |
| RMSEA | <0.06 |
| SRMR | <0.08 |
| χ²/df | <3 |

## R code

```r
library(lavaan)
model <- '
  # Measurement model
  EF =~ nback_acc + wisconsin_acc + stroop_rt
  # Structural model
  EF ~ age
  stroop_rt ~ EF + age
'
fit <- sem(model, data=data)
summary(fit, fit.measures=TRUE, standardized=TRUE)
```

## Report

Structural equation modeling was used to examine the mediating role of executive function (EF) between age and Stroop effect. The model fit was good, χ²(24) = 45.32, p = .005, CFI = .96, RMSEA = .05 (90% CI [.02, .07]), SRMR = .04. The indirect effect of EF on the relationship between age and Stroop effect was significant, indirect effect b = 0.23, 95% CI [0.12, 0.35], p < .001, standardized indirect effect β = .31. The direct effect of age on the Stroop effect is not significant (b = 0.08, β = .11, p = .12), indicating that EF plays a complete mediating role. The model and standardized path coefficients are shown in Figure X.

## vs individual mediation analysis

SEM can simultaneously estimate multiple mediators, process latent variables, and evaluate overall model fit. Ordinary regression mediation analysis (stepwise method) is a special case of SEM.
