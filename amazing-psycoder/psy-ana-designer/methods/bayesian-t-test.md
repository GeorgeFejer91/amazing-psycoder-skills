# Bayesian t-test

## Overview

The Bayesian t-test quantifies the relative strength of evidence for H1 and H0. Do not output p value, output **Bayes factor (BF10)**.

## When to use

- Need to quantify evidence of "no difference" (traditional t-test cannot)
- Small sample (traditional methods are not powerful enough)
- Pre-specified in the pre-registered analysis plan
- Continuous monitoring of evidence required (sequential analysis)

## BF10 Interpretation

| BF10 | Strength of evidence | Meaning |
|------|---------|------|
| >100 | Extreme | H1 extremely strong support |
| 30-100 | Very strong | H1 strong support |
| 10-30 | Strong | H1 support |
| 3-10 | Medium | H1 Medium Support |
| 1/3-3 | Weak | Data is not sensitive |
| 1/10-1/3 | Moderate | H0 Moderate Support |
| 1/30-1/10 | Strong | H0 strong support |

## R code

```r
library(BayesFactor)
bf <- ttestBF(formula = rt ~ condition, data = data_agg, paired = TRUE)
print(bf)  # BF10
```

## Report format

> A Bayesian paired t-test compared the two conditions. The Bayes factor (BF10=5.32) provided moderate evidence for H1 over H0.

## Report

APA seventh edition format report example (taking Bayesian paired t test as an example):

**Method Section**: Use Bayesian paired t-test (BayesFactor R package, default prior: Cauchy distribution, scale = √2/2), use BF10 as the Bayes factor, and report the median and 95% highest density interval (HDI) of the posterior distribution.

**Result Part Example**:

> Perform a Bayesian paired t-test on the response times under the two experimental conditions. The results show that the Bayes factor BF10 = 5.32 provides moderate evidence for H1 (there is a difference) relative to H0 (no difference) (Jeffreys, 1961). The median of the posterior distribution is δ = 0.48, 95% HDI [0.12, 0.85], and the effect size corresponds to a moderately small level. The prior is set to Cauchy distribution (scale = √2/2). The robustness test shows that within the prior range of r = 0.5 to 1.0, the change of BF10 does not exceed 12%, and the conclusion is relatively robust.

**Template (English)**:

> A Bayesian paired t-test was conducted to compare response times between the two conditions. The analysis yielded a Bayes factor BF10 = [value], providing [anecdotal/substantial/strong/very strong/decisive] evidence in favor of H[1/0]. The posterior median for the standardized effect size was δ = [value], 95% credible interval [[lower], [upper]]. A default Cauchy prior (scale = √2/2) was used for the effect size under H1.

## Notes

- BF10>3 does not mean "the effect exists" - it is continuous evidence, not a binary decision
- Effect size still needs to be reported (mean of posterior distribution + 95% confidence interval)
- The prior setting affects the BF value (default Cauchy scale=√2/2)
