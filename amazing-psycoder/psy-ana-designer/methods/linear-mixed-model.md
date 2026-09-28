# Linear Mixed Model / lmer

## Overview

Linear mixed models (LMMs) can be useful for trial-level repeated-measures data when the dependence structure and estimand warrant them. They can model subject and, when applicable, stimulus variation without first aggregating trials. A planned subject-level contrast or repeated-measures ANOVA may be simpler and equally appropriate for some questions.

**Typical scenario**: RT analysis of within-subject designs such as Stroop/Flanker/GoNoGo.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Within-subjects or mixed design |
| DV | Continuous variable |
| Data requirements | Trial-level or repeated data; check the model's residual and dependence assumptions for the chosen outcome scale |
| Advantages | Utilize all trials, handle imbalance, and easily expand covariates |

## Why is better than t test/ANOVA

| Dimensions | t-test/ANOVA | LMM |
|------|-----------|-----|
| Data utilization | Mean → lose inter-trial variation | All trials participate in modeling |
| Statistical power | Depends on the design and estimand | Depends on the number of independent subjects/items, trials, variance components, and model; trials do not multiply the number of independent subjects |
| Unbalanced design | Difficulty | Automatic processing |
| Covariates | Need to reanalyze | Just add + to the formula |
| Missing data | Incomplete pairs/cells can complicate a complete-case analysis | Available observations can contribute under an appropriate missingness model; missingness can still bias inference |

## Random effect structure

**Recommended: (1+condition|subject)** — Random intercept + random slope. Each subject has his or her own baseline RT and condition effects.

If fitting is singular or fails to converge, inspect the data and model specification, then consider a justified simpler random-effects structure or alternative optimizer. Removing a random slope changes the model and must not be an automatic fix.

## Effect size

| Indicator | Formula | Meaning |
|------|------|------|
| Marginal R² | Model-specific variance-accounted-for summary for all fixed effects | Descriptive model summary, not the unique contribution of a single condition effect |
| Conditional R² | Model-specific variance-accounted-for summary for fixed and random effects | Descriptive model summary, not a substitute for diagnostics |

## Report format

> A linear mixed model with condition as fixed effect and random intercepts and slopes by subject was fit. Condition significantly predicted RT, b=45.2, SE=8.3, t(29.0)=5.44, p<.001. Marginal R²=.18, Conditional R²=.72.

## Common errors
- ❌ Omit a subject slope for a within-subject manipulation without checking whether the omission is justified by the design, model fit, and estimand; the effect on uncertainty depends on the data-generating structure
- ❌ Convergence is not checked - downgrade is required for singular fitting
- ❌ Use lme4's native p value - lmerTest or car::Anova is required to obtain the p value
- ❌ Use summary(model)$r.squared - does not exist, use performance::r2()

## R code

```r
# Random intercept + random slope (recommended)
model <- lmer(rt ~ condition + (1 + condition | subject_id),
              data = data_rt, control = lmerControl(optimizer = "bobyqa"))
summary(model)

# Random intercept only (convergence failure degraded)
model <- lmer(rt ~ condition + (1 | subject_id), data = data_rt)
```
