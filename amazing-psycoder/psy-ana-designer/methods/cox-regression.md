# Cox Proportional Hazards

## Overview

Cox regression analysis of censored event time to examine the relationship between covariates and conditional event rates (hazard). Candidates are only if the estimand of the scientific question is indeed time-to-event and the event/time origin/censoring mechanism is clearly defined.

**Typical scenario**: From the beginning of treatment to relapse, from study enrollment to withdrawal, from the beginning of follow-up to the first symptom relief.

**Hard exclusion**: SSRT is not an ordinary survival time. Stop-signal trials and "stop success time" are not censored survival observations. Use an established stop-signal estimator and retain the original go RT, SSD, and stop success/failure fields.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Longitudinal/follow-up design (the time of event occurrence and censoring status need to be recorded) |
| Dependent variable | Time of event + whether it occurred (censored) |
| Independent variable | Continuous or categorical variable |
| Information Requirements | Number of events, censoring ratio, predictor complexity, and target accuracy determine sample size; do not use fixed EPV rules instead of design analysis |
| Key diagnosis | Proportional hazards, continuous variable functional form, influence points, censoring mechanism and model stability; Schoenfeld test/figure is one of the evidences, and `p > .05` is not used to declare the hypothesis is true |
| Dependency structure | Repeated events, center/therapist clustering or multi-state processes need to be expanded accordingly and cannot be treated as independent single event samples |

## Key output

- **Hazard Ratio (HR)**: Conditional event rate ratio relative to an explicit reference group; direction depends on event encoding and does not automatically equate to "better/worse"
- **Survival Curve**: Kaplan-Meier plot
- **Proportional Hazards Test**: Schoenfeld residuals

## R code

```r
library(survival)
model <- coxph(Surv(time, event) ~ condition + age, data=data)
summary(model)
# Proportional hazard test
cox.zph(model)
```

## Report

APA 7th format report example:

> In this illustrative report, a Cox proportional hazards model examined time from treatment entry to first relapse, with administrative censoring at the end of follow-up and age included as a prespecified covariate. The intervention group had a lower conditional relapse rate than the control group, HR = 0.55, 95% CI [0.38, 0.79], p = .001. Proportional-hazards diagnostics and sensitivity analyses using an alternative time-varying effect specification were reported alongside the model.

**Report Highlights**:
- Reports proportional hazards hypothesis test results (χ² and p-values)
—Reports the overall model fit (likelihood ratio test or Wald test)
- Report HR, 95% CI, and p-value for each predictor variable
- Clarify the event, reference group, time scale and conditionality when interpreting HR; when necessary, also report absolute survival probability or limit the average survival time and other more easily interpretable quantities
