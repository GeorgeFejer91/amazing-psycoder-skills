# Moderated Mediation

## Overview

Moderated mediation tests whether the mediation effect changes with the level of the moderator variable - combining the logic of mediation and moderation.

**Typical scenario**: The mediating path of Anxiety (X) → Attention Bias (M) → Stroop (Y), is there any difference between high and low working memory capacity (W) groups?

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Experimental or quasi-experimental design, including independent variables (X), mediating variables (M), dependent variables (Y) and at least one moderator variable (W) |
| Dependent variable type | Continuous variable (such as reaction time, accuracy, scale score) |
| Sample information | Determined by conditional indirect effects, moderator distribution/reliability, path model, and interval accuracy; simulated with Monte Carlo/design, no universal N threshold |
| Mediating path premise | The mediating path of X→M or M→Y (or both) has been established in theory or preliminary experiments |
| Key assumptions | (1) There is a linear relationship between variables; (2) There is no serious multicollinearity; (3) The interaction term between the moderator variable and the mediating path has a theoretical basis; (4) The Bootstrap confidence interval does not cross zero as the basis for significance judgment |

## Key concepts

- **Conditional indirect effect**: Is a×b different at different levels of W?
- **Index of Moderated Mediation**: Quantifies the extent of the mediation effect changing with W. Bootstrap CI does not cross 0 → moderated mediation is significant

## Two types

| Type | Definition | Test |
|------|------|------|
| First stage adjustment | W adjusts X→M path | W×X predicts M |
| Second stage adjustment | W adjusts M→Y path | W×M predicts Y |

## R code

```r
library(lavaan)
model <- '
  M ~ a1*X + a2*W + a3*X:W    # The first stage is adjusted by W
  Y ~ b*M + c*X
  indirect.low := (a1+a3*(-1))*b    # When W is low
  indirect.high := (a1+a3*(1))*b    # When W is high
  diff := indirect.high - indirect.low  # Difference
'
fit <- sem(model, data=data, se="bootstrap", bootstrap=5000)
```

## Report format

> Moderated mediation examined whether working memory capacity (W) moderated the indirect effect of anxiety on Stroop through attention bias. The index of moderated mediation was significant, index=0.12, Bootstrap 95%CI [0.04, 0.21], indicating that the mediation pathway was stronger at higher working memory levels.

## Report

### APA 7th format example

> A moderated mediation model (Model 7; Hayes, 2018) was tested using structural equation modeling with 5,000 bootstrap resamples. Anxiety (X) was the independent variable, attention bias (M) the mediator, Stroop interference score (Y) the dependent variable, and working memory capacity (W) the moderator of the X→M path. Results indicated a significant index of moderated mediation, *index* = 0.12, 95% CI [0.04, 0.21]. The conditional indirect effect was significant at high levels of working memory (+1 SD), *ab* = 0.18, 95% CI [0.08, 0.30], but not at low levels (−1 SD), *ab* = 0.02, 95% CI [−0.05, 0.10]. These findings suggest that the indirect effect of anxiety on Stroop performance via attention bias is contingent upon working memory capacity, such that the mediation pathway is stronger for individuals with higher working memory levels.

### APA Form Suggestions

Report the following key metrics in the text:

| Effect | Estimate | SE | Bootstrap 95% CI |
|------|--------|-----|--------------------|
| Adjusted mediation index (Index) | 0.12 | 0.04 | [0.04, 0.21] |
| Conditional indirect effect (W = −1 SD) | 0.02 | 0.04 | [−0.05, 0.10] |
| Conditional indirect effect (W = +1 SD) | 0.18 | 0.06 | [0.08, 0.30] |
