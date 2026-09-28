# Bayesian ANOVA

## Overview

Bayesian ANOVA is a Bayesian alternative to traditional ANOVA that quantifies the strength of evidence (Bayes factor) for each effect rather than just giving a p-value.

**Typical Scenarios**: Need to report evidence of "no difference"; small sample size (traditional ANOVA is underpowered); pre-specified in pre-registered analysis.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Within-subjects design (single factor or multi-factor repeated measures) |
| Dependent variable type | Continuous variable (such as reaction time, accuracy) |
| Sample size requirements | Available for small samples; especially suitable when traditional ANOVA is not powerful |
| Core premise | Set a reasonable prior distribution (default Cauchy prior, r scale parameters need to be reported); sequential analysis requires pre-registered stopping rules |

## Compared with traditional ANOVA

| Traditional ANOVA | Bayesian ANOVA |
|-----------|------------|
| p<.05→Reject H0 | BF10→Quantify H1/H0 relative evidence |
| Not significant ≠ no effect | BF01 quantitative H0 evidence |
| Unable to monitor evidence accumulation | Support sequential analysis |
| Sensitive to sample size | Small sample size still available |

## R code

```r
library(BayesFactor)
bf <- anovaBF(rt ~ condition, data=data_agg, whichRandom="subject")
plot(bf)  # BF per effect
```

## Report (APA 7th format)

### Text report example

> A Bayesian repeated-measures ANOVA was conducted to examine the effect of condition (2 levels: congruent, incongruent) on reaction time (RT). The analysis used the `BayesFactor` package in R (Morey & Rouder, 2018) with default Cauchy priors (r scale = 0.5) on the fixed effects and a Jeffreys prior on the random effect of subject. The model including condition was strongly preferred over the null model, BF<sub>10</sub> = 15.30, indicating that the data are approximately 15 times more likely under the alternative hypothesis than under the null. The inclusion Bayes factor for condition, averaged across all candidate models, was BF<sub>incl</sub> = 12.80, providing strong evidence for an effect of condition on RT (Jeffreys, 1961). Posterior estimates indicated a mean RT difference of 45 ms, 95% credible interval [28, 62].

### Report elements

- **Prior setting**: Explicitly report the prior distribution type and parameters (such as Cauchy prior, r scale = 0.5)
- **Bayes Factor**: Report BF<sub>10</sub> (evidence supporting H1) or BF<sub>01</sub> (evidence supporting H0), and indicate interpretation criteria
- **Include Bayes Factors**: Reports BF<sub>incl</sub>, reflecting the average evidence across models for each factor
- **Posterior Distribution**: When possible, report the posterior mean and 95% confidence interval of the effect size
- **Explanation of strength of evidence**: BF > 3 = moderate evidence, BF > 10 = strong evidence, BF > 100 = extremely strong evidence (Jeffreys, 1961)

## Notes

- The prior setting affects the BF value - report the prior and do sensitivity analysis
- BF10>3 = moderate evidence, >10 = strong evidence
- Calculation may be slow when there are more than 10 within-subject conditions
