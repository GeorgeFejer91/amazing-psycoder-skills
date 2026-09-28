# Meta-analysis

## Overview

Meta-analysis systematically integrates effect sizes from multiple independent studies to produce an overall estimate that is more precise and generalizable.

**Typical scenario**: Integrate interference effect sizes from 15 Stroop studies; test whether the effects are consistent across different experimental paradigms.

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Systematic review and meta-analysis (Systematic review and meta-analysis) |
| Dependent variable type | Standardized effect size (Cohen's d, Hedges' g, OR, r) |
|Research information | Two studies can be combined but the heterogeneity/selection model is extremely unstable; supportable inferences are determined by k, study precision, heterogeneity and dependency structure, and there is no universal k threshold |
| Key assumptions | Independent between studies; Comparable effect sizes; No confounding by heterogeneity |

## Model selection

| Model | Assumptions | When to use |
|------|------|--------|
| Fixed effects | All studies estimate the same true effect | Studies are nearly identical |
| **Random Effects** | True effects vary between studies | **Recommended Default** |

## Key indicators

| Indicator | Meaning |
|------|------|
| Pooled effect size (d/OR/r) | Overall estimate |
| 95%CI | Estimation accuracy |
| I² | Heterogeneity: 25% low/50% medium/75% high |
| τ² | Between-study variance |
| Forest plot | Visualize the effect size of each study |

## Publication bias detection

- Funnel chart + Egger's return
- trim-and-fill
- p-curve analysis

## R code

```r
library(metafor)
res <- rma(yi=effect_sizes, sei=SEs, data=dat, method="REML")
forest(res)
funnel(res)
```

## Report

APA 7th format report example:

> A random-effects meta-analysis (Restricted Maximum Likelihood estimation) was conducted to synthesize the interference effect across k = 15 independent Stroop studies (total N = 645). Results revealed a medium overall effect, d = 0.52, 95% CI [0.38, 0.66], z = 7.24, p < .001. However, substantial heterogeneity was observed, Q(14) = 43.75, p < .001, I² = 68%, τ² = 0.09, indicating that 68% of the total variance was attributable to between-study differences rather than sampling error. Moderator analyses examined whether task paradigm (card vs. trial-by-trial) moderated the effect; the between-group test was not significant, Q<sub>B</sub>(1) = 1.23, p = .267. Publication bias was assessed via funnel plot inspection and Egger's regression, which did not suggest significant asymmetry, z = 1.10, p = .271. A trim-and-fill analysis imputed no missing studies, and the adjusted effect remained unchanged. Sensitivity analyses (leave-one-out) confirmed the robustness of the overall estimate, with d ranging from 0.48 to 0.55.
