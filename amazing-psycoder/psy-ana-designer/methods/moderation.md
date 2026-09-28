# Moderation Analysis

## Overview

Moderation analysis tests whether a third variable (W) changes the **strength or direction** of the relationship between X and Y. Equivalent to "interaction effect".

**Typical scenario**: Whether the impact of stress (X) on task performance (Y) is buffered by social support (W). Social support is the moderating variable.

## When to use

| Conditions | Requirements |
|------|------|
| Research question | Test whether the third variable changes the **strength** or **direction** of the X→Y relationship |
| Independent variable (X) | Continuous variable (can also be a categorical variable) |
| Dependent variable (Y) | Continuous variable |
| Moderator variable (W) | Continuous variable or categorical variable (such as gender, experimental condition) |
| Sample information | Determined by interaction effects, predictor distribution/reliability, group imbalance, and target interval accuracy; using design simulation/power analysis, no universal N threshold |
| Core assumptions | Linear relationship, independence and normality of residuals, homogeneity of variances, no multicollinearity |
| Data preprocessing | It is recommended that continuous independent variables and adjustment variables be centered before calculating the product term |
| Significance of the interaction term | X×W The significance of the interaction term is the prerequisite for the establishment of the moderating effect |

## Model

```
        W (manipulated variable)
        │
X ──────→ Y
        
X×W ────→ Y (the interaction term is the key)
```

- **Interaction term is significant** → W moderates the relationship of X→Y
- The interaction term is not significant → W is not adjusted

## Simple Slopes

After the interaction is significant, a simple slope must be done:
- At high values of W (+1SD): Effect of X on Y?
- On the mean of W: What is the effect of X on Y?
- At low values of W (-1SD): Effect of X on Y?

## R code

```r
library(interactions)
model <- lm(Y ~ X * W, data=data)  # X*W = X + W + X:W
summary(model)

# Simple slope
sim_slopes(model, pred=X, modx=W)
interact_plot(model, pred=X, modx=W)
```

## Visualization of continuous adjustment variables

Johnson-Neyman plot: Shows which interval of W the effect of X is significant. More accurate than the traditional method of ±1SD.

## Report format

> A moderation analysis examined whether social support (W) moderated the effect of stress (X) on performance (Y). The interaction was significant, b=-0.25, t(96)=-3.12, p=.002. Simple slopes revealed that stress reduced performance under low support (b=-0.45, p<.001) but not under high support (b=-0.05, p=.42).

## Report Format (APA 7th)

Moderation analysis uses hierarchical multiple regression to test whether [W] moderates the relationship between [X] and [Y]. All continuous predictor variables were centered to reduce multicollinearity. The overall model is significant, *F*([df1], [df2]) = [F], *p* = [p], *R*² = [R²].

The interaction term between [X] and [W] is significant, *b* = [b], *SE* = [SE], 95% CI [[LL], [UL]], *t*([df]) = [t], *p* = [p], Δ*R*² = [ΔR²], indicating that [W] significantly moderates the effect of [X] on [Y].

Simple slope analysis (Aiken & West, 1991) shows:
- Under low [W] (-1 *SD*) conditions, the effect of [X] on [Y] [significant/not significant], *b* = [b], *t*([df]) = [t], *p* = [p];
- Under the condition of mean [W], the effect of [X] on [Y] [significant/not significant], *b* = [b], *t*([df]) = [t], *p* = [p];
- Under the condition of high [W] (+1 *SD*), the effect of [X] on [Y] is [significant/not significant], *b* = [b], *t*([df]) = [t], *p* = [p].

The above results show that as [W] increases, the effect of [X] on [Y] [increases/decreases/reverses direction]. Figure [X] shows an interaction plot of the moderation effect versus a simple slope.

## Common errors

- ❌ Directly report "significant adjustment" without doing a simple slope - unable to explain the direction of the effect
- ❌ Continuous variables are multiplied without centering - leading to multicollinearity
- ❌ The interaction is not significant and a simple slope is forced
