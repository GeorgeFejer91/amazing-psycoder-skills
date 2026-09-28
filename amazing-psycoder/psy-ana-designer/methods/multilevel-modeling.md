# Multilevel/Cross-layer Modeling (Multilevel Modeling)

## Overview

Multi-level models handle nested data structures. The most common nesting in psychology: trials are nested in subjects, subjects are nested in classes, and classes are nested in schools.

**Typical scenario**: Students (Level-1) are nested in classes (Level-2), and the impact of class atmosphere (Level-2) on student performance (Level-1) is tested.

## When to use

| Conditions | Requirements |
|---|---|
| Research design type | Nested design (trials are nested in subjects, subjects are nested in classes/schools), repeated measures design |
| Dependent variable type | Continuous variable (reaction time, grade, scale score, etc.) |
| Sample information | Plan the number of high-level units, intra-unit observations and imbalance respectively; determined by random effect/fixed effect target, ICC and interval accuracy, give priority to simulation |
| Key premise | There is a significant nested structure in the data (ICC > 0.05); Level-1 variable group mean centering, Level-2 variable total mean centering |

## When to use (vs lmer)

In fact, lmer is a special case of multi-level model. Multilevel terms are more useful when your data have clear levels (repeated measures/nested) and you need to distinguish between within-group and between-group effects:

- Within-subject effect (Level-1): Conditioning effect
- Between-subjects effect (Level-2): Group, demographic variables
- Cross-level interaction: Level-2 variables regulate Level-1 effects

## Model

```r
lmer(rt ~ condition * group + (1+condition|subject), data=data)
```

## Key: Centralization

- Level-1 variable: group mean centered (centered within cluster)
- Level-2 variable: grand mean centered
- Failure to centralize will lead to confusion between between-group and within-group effects

## ICC (Intraclass Correlation Coefficient)

ICC = between-group variance/(between-group variance + within-group variance), measures the necessity of nested structure. ICC > 0.05 → A multilevel model is required.

## Report (APA 7th format)

Multilevel model reports should include model specification, fixed effects, random effects, and model comparison information. The following is an example of APA 7th format:

**Model specification.** A multilevel model was fitted to examine the effect of condition (Level-1 within-subject factor: congruent vs. incongruent) and group (Level-2 between-subject factor: control vs. treatment) on reaction time (RT). The model included random intercepts and random slopes for condition by subject. Level-1 predictor (condition) was group-mean centered; Level-2 predictor (group) was grand-mean centered. Estimation was performed using restricted maximum likelihood (REML) via the `lme4` package in R.

**Fixed effects.** The intercept was significant, *b* = 450.3, *SE* = 18.7, *t*(58) = 24.08, *p* < .001. The main effect of condition was significant, *b* = 30.5, *SE* = 5.2, *t*(58) = 5.87, *p* < .001, with slower RTs in the incongruent condition. The main effect of group was not significant, *b* = 12.8, *SE* = 22.4, *t*(58) = 0.57, *p* = .571. The cross-level interaction between condition and group was significant, *b* = 15.2, *SE* = 4.4, *t*(58) = 3.45, *p* < .001, indicating that the condition effect differed by group: the congruency effect was larger in the treatment group than in the control group.

**Random effects.** The random intercept variance was 2450.6 (*SD* = 49.5) and the random slope variance for condition was 320.4 (*SD* = 17.9), with a correlation between intercept and slope of −.32. The residual variance was 1800.2 (*SD* = 42.4). The ICC was .12, confirming that 12% of the variance in RT was attributable to between-subject differences, justifying the multilevel approach.

**Model comparison.** Adding the cross-level interaction significantly improved model fit over the main-effects-only model, χ²(1) = 11.89, *p* < .001, ΔAIC = −9.9.
