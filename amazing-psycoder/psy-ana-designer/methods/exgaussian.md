# Ex-Gaussian distribution fitting

## Overview

Ex-Gaussian (exponentially modified Gaussian) is a candidate distribution that describes the right-skewed RT distribution. Common parameters correspond to Gaussian position/scale and exponential tail scale. Parameters are distributional descriptions and should not be directly named "decision speed" "stability" or "attention lapse" without a process model or external evidence, nor are they the gold standard for all RT problems.

**Typical scenario**: In ADHD studies, high τ values ​​(more extreme slow reactions) are core behavioral markers, while μ and σ may be no different from controls.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Between-subjects or within-subjects design; at least two groups or two conditions are required for comparison |
| Dependent variable type | Reaction time (RT), a continuous positive variable, usually in milliseconds |
| Sample information | Determined by hierarchical structure, tail information, effect size and estimator; evaluated with parameter recovery/design simulation, no common trial number/subject number threshold |
| Key checks | Distribution support is compatible with task RT; prediction checks with candidates such as lognormal/shifted-lognormal/process models; verify convergence, parameter recovery and sensitivity to pre-stated cleanup rules, do not automatically add fixed RT/SD culling |

## Three parameters

| Parameters | Psychological explanation | Typical values (ms) |
|------|-----------|----------|
| μ (mu) | Position parameter of Gaussian component; additional evidence required for psychological process explanation | Estimated by task/unit/model |
| σ (sigma) | Scale parameter of the Gaussian component | Estimated by task/unit/model |
| τ/beta | Scale/mean parameter of the exponential component (named by implementation) | Estimated by task/unit/model |

## Why use Ex-Gaussian

Mean/median cannot fully describe the shape of the distribution; Ex-Gaussian can parameterize position, scale and right-tail differences. However, different generation processes may produce similar parameters, and differences in distribution parameters cannot independently identify potential cognitive processes such as “mind wandering”.

## R code

```r
library(brms)
# For illustration only: formulas, priors, sanitization, and random structures must come from a confirmed config.
fit <- brm(
  bf(
    rt ~ condition + (1 + condition | subject_id),
    sigma ~ condition,
    beta ~ condition
  ),
  data = data,
  family = exgaussian(),
  prior = confirmed_priors,
  seed = confirmed_seed
)
summary(fit)
pp_check(fit)
# Also check R-hat/ESS, divergence, posterior predictions and pre-stated candidate distribution sensitivities.
```

## Report Format (APA 7th)

**Method part**:

> Trial-level RTs were modeled with a hierarchical Ex-Gaussian distribution in the pinned `brms` environment. The Gaussian location/scale and exponential-component parameterization followed the documented package version. Cleaning rules were prespecified in the analysis config; no generic fixed-RT or within-cell SD rule was added. The model represented subject/item dependence declared by the design. We reported parameter contrasts with posterior intervals, R-hat/ESS and divergence diagnostics, posterior-predictive checks, and a prespecified comparison with viable alternative RT distributions.

**Result part**:

> The fitted groups differed primarily in the model's exponential-tail parameter, while location and Gaussian-scale contrasts were smaller and less precise. Posterior-predictive checks showed where the Ex-Gaussian captured or missed each group's RT distribution. These are distributional differences; labeling the tail contrast as attentional lapses or the location contrast as decision speed would require independent process-level evidence.

**Form suggestions**:

| Parameters | Declared group/condition comparison | Interval | Model/Predictive diagnosis |
|------|--------------------|------|---------------|
| μ / location | estimate | 95% CrI/CI | R-hat/ESS + posterior predictive fit |
| σ | estimate | 95% CrI/CI | R-hat/ESS + posterior predictive fit |
| beta / exponential scale | estimate | 95% CrI/CI | R-hat/ESS + tail predictive fit |

> *Note.* State the package parameterization and link functions explicitly; `tau` and `beta` names are not interchangeable without checking the implementation. Report participant/trial denominators after cleaning and avoid two-stage individual fitting when the confirmed hierarchical estimand requires joint partial pooling.
