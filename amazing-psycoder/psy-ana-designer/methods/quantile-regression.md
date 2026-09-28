# Quantile Regression

## Overview

Quantile regression models **specific quantiles** (such as median, 10th percentile) of DV rather than the mean, revealing differences in effects across different RT segments.

**Typical Scenario**: Does the Stroop effect differ for fast responses (25th percentile) and slow responses (75th percentile)? Reveal whether conditioning effects are concentrated in specific RT segments.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Within-subjects or between-subjects design, comparing two or more experimental conditions |
| Dependent variable type | Continuous variable, usually reaction time (RT), can also be used for other continuous indicators (such as eye movement indicators, physiological data) |
| Sample information | Determined by data density, prediction parameters, clustering and interval accuracy near the target quantile; extreme quantiles usually have less information, apply simulation/resampling evaluation |
| Core hypothesis | Conditional effects may differ at different locations in the DV distribution; focus on effect heterogeneity rather than just differences in means |

## Why not use mean regression?

Mean regression assumes that the effect is constant at all RT levels. However, in real data, the conditioning effect may be small for fast responses (automatic processing) and large for slow responses (failure of controlled processing). Quantile regression directly tests this hypothesis.

## R code

```r
library(quantreg)
model <- rq(rt ~ condition, tau=c(0.25, 0.50, 0.75), data=data)
summary(model)
# Effect versus quantile plot
plot(summary(model))
```

## Report

### APA 7th Format Report Example

> A quantile regression was conducted to examine whether the congruency effect varied across the reaction time distribution. Reaction time (RT) was regressed on congruency condition (congruent vs. incongruent) at three quantiles: τ = .25 (fast responses), τ = .50 (median responses), and τ = .75 (slow responses). Results revealed a significant effect of congruency at all three quantiles, with the effect increasing monotonically from the lower to the upper tail. Specifically, at τ = .25, the congruency effect was 25 ms (95% CI [18, 32]), *b* = 25.00, *SE* = 3.57, *t*(98) = 7.00, *p* < .001. At the median (τ = .50), the effect was 42 ms (95% CI [35, 49]), *b* = 42.00, *SE* = 3.57, *t*(98) = 11.76, *p* < .001. At τ = .75, the effect reached 65 ms (95% CI [55, 75]), *b* = 65.00, *SE* = 5.10, *t*(98) = 12.75, *p* < .001. A Wald test confirmed that the regression coefficients differed significantly across quantiles, χ²(2, *N* = 99) = 15.32, *p* < .001, indicating that slower trials were disproportionately affected by the congruency manipulation. Standard errors were estimated via the bootstrap method with 500 replications. All analyses were performed in R using the *quantreg* package (Version 5.97; Koenker, 2023).
