# Statistical Power Analysis (Power Analysis)

## Overview

Prospective power analysis can justify a sample size before data collection. Sensitivity analysis can describe the minimum effect size detectable at a chosen power level for a fixed sample size. Neither substitutes for an estimate and uncertainty interval after the study.

**Typical scenario**: "How many subjects do I need to detect an effect at d=0.5?" "How small an effect can I detect at n=30?"

## When to use

| Conditions | Requirements |
|------|------|
| Research design has been determined | Independent variables/dependent variables, experimental design type (between-subjects/within-subjects/mixed) have been clarified |
| The effect size can be estimated | The expected effect size can be obtained from the literature, meta-analysis or pilot experiments (Cohen's d, η², r, etc.) |
| Statistical test has been selected | The statistical method to be used has been determined (t-test, ANOVA, regression, mixed model, etc.) |
| Ethical or resource constraints exist | Sample size justification needs to be submitted to the ethics committee, or limited by budget/time |
| Pre-registration requirements | The journal or platform requires the sample size planning basis to be stated when pre-registering |

> If the above conditions are not met (for example, there is no effect size estimate), **sensitivity analysis** (sensitivity analysis) should be used: fix α, power and n, and infer the minimum detectable effect size.

## Four types of effectiveness analysis

| Type | Given | Find |
|------|------|-----|
| A Priori | α, power, effect size | required n |
| Sensitivity | α, power, n | Minimum detectable effect |
| Post-hoc observed power | α, n, observed effect size | Avoid: it adds no information to the observed p-value and is misleading as a retrospective quality check |
| Sample size planning | Budget/time constraints | Optimal number of subjects |

## Common tools

| Method | R Package |
|------|-----|
| t test/ANOVA | `pwr` |
| Mixed model | `simr` (simulation-based) |
| General | `powerAnalyzeR` |

## Typical value

- Choose α, target power or precision, and a scientifically justified smallest effect of interest for the decision context. Values such as α=.05 and power=.80 are common conventions, not universal requirements.
- Generic "small/medium/large" effect-size labels are illustrative conventions and do not replace a study-specific effect justification.

## R code

### Installation and loading

```r
install.packages("pwr")
library(pwr)
```

### A Priori power analysis (find the required sample size)

Two-sample independent t-test, expected Cohen's d = 0.5, α = 0.05, power = 0.80:

```r
result <- pwr.t.test(
  d         = 0.5,
  sig.level = 0.05,
  power     = 0.80,
  type      = "two.sample",
  alternative = "two.sided"
)
result
# n = 63.77 → Each group requires 64 subjects, 128 in total
```

One-way between-subjects ANOVA (4 groups), expected f = 0.25 (medium effect), α = 0.05, power = 0.80:

```r
pwr.anova.test(
  k         = 4,
  f         = 0.25,
  sig.level = 0.05,
  power     = 0.80
)
# n = 44.60 → Each group requires 45 subjects, 180 in total
```

Correlation coefficient test, expected r = 0.30:

```r
pwr.r.test(
  r         = 0.30,
  sig.level = 0.05,
  power     = 0.80,
  alternative = "two.sided"
)
# n = 84.07 → 85 subjects required
```

### Sensitivity analysis (given n, find the smallest detectable effect size)

```r
# It is known that each group can only recruit 30 subjects, find the minimum detectable d
pwr.t.test(
  n          = 30,
  sig.level  = 0.05,
  power      = 0.80,
  type       = "two.sample",
  alternative = "two.sided"
)
# d = 0.74 → only large effects can be detected
```

After data collection, report the estimated effect and its uncertainty interval. If the sample size is fixed, a sensitivity analysis can describe design capability for a *prespecified* effect size; do not use power computed from the observed effect as evidence about the result.

### Effect size conversion

```r
# There is no universal conversion from d to ANOVA f: it depends on
# the number of groups, allocation, contrast, and assumed group means.

# η² → f (for ANOVA)
eta_sq <- 0.06
f <- sqrt(eta_sq / (1 - eta_sq))
f  # 0.253
```

### Mixed model power analysis (simr)

```r
# install.packages("simr")
library(simr)

# Simulation-based effectiveness estimation using existing model objects
# model <- lmer(RT ~ condition + (1 | subject), data = pilot_data)
# powerSim(model, nsim = 200, test = fixed("condition"))
```

## Report

> An a priori power analysis for a two-sided paired t-test used the prespecified standardized mean paired difference, target power, and alpha level. Report the exact software output, the resulting number of *pairs*, and the assumptions about missing pairs.

## Alternative method

- Equivalence Testing — When the research goal is to evaluate whether the effect falls within a predefined negligible interval, rather than treating "not significant" as no effect
- Bayes Factor — when evidence for competing specified models is the estimand; sequential sampling still requires a defensible prior and stopping/reporting plan
- Effect Size Estimation — When data are available, the effect size and its confidence interval need to be estimated
- Sample Size Planning - when constraints are budget/time rather than statistical power
