# Poisson Regression / Negative Binomial Regression

## Overview

Poisson regression is used to model **count data** (non-negative integers). Negative binomial regression is its extension and deals with overdispersion (variance > mean).

**Typical scenario**: The number of spontaneous blinks by the subject within 20 minutes; the number of errors per condition per subject; the number of utterances in social interactions.

## When to use

| Conditions | Requirements |
|------|------|
| Dependent variable type | Count data (non-negative integers: 0, 1, 2, ...) |
| Experimental design | Between subjects or within subjects |
| Sample information | Determined by total number of events/exposure, zero value, degree of dispersion, prediction parameters and clustering; check identifiability and interval accuracy, do not apply "fixed number of observations per variable" |
| Independence | Observations are independent of each other (does not apply to nested/repeated measures data unless using GEE or mixed models) |
| Degree of dispersion | Poisson: mean ≈ variance; negative binomial: variance > mean acceptable |
| Zero-inflation | If the proportion of zero values is significantly higher than expected by the model, consider a zero-inflation model (zeroinfl) |
| Link function | Default log link, effect size is interpreted as Incidence Rate Ratio (IRR) |

## Poisson vs negative binomial

| Method | Assumptions | When to use |
|------|------|--------|
| Poisson | Mean=variance | Count data |
| **Negative binomial** | Variance > mean acceptable | **Recommended default**—real data almost always has overdispersion |

## R code

```r
library(MASS)
model <- glm.nb(error_count ~ condition, data=data)
summary(model)
exp(coef(model))  # Incidence Rate Ratio
```

## Effect size

IRR (Incidence Rate Ratio): exp(estimate). IRR=1.5→The error rate of condition B is 50% higher than A.

## Zero-inflation model

If a large number of observations are 0 (for example, most trials have no errors), use the zero-inflated model (zeroinfl):

```r
library(pscl)
model <- zeroinfl(error_count ~ condition | 1, data=data, dist="negbin")
```

## Report Format (APA 7th)

Negative binomial regression was used to examine the impact of experimental conditions on the number of errors made by subjects. The results showed that condition B had a significantly higher error rate than condition A, IRR = 1.52, 95% CI [1.18, 1.96], *z* = 3.21, *p* = .001. The model was overall significant, likelihood ratio χ²(1) = 10.85, *p* < .001, McFadden's pseudo *R*² = .06. The overdispersion parameter θ = 2.34 indicates slight overdispersion, supporting the use of negative binomial rather than the standard Poisson model.

### Template

> Use [Poisson/negative binomial] regression to test the effect of [independent variable] on [dependent variable]. The results show that [dependent variable] of [Group/Condition B] is significantly [higher/lower than] [Group/Condition A], IRR = [value], 95% CI [[lower limit], [upper limit]], *z* = [value], *p* = [value]. The model is overall significant, likelihood ratio χ²([df]) = [value], *p* = [value]. Overdispersion parameter θ = [value], [supported/unsupported] using the [Poisson/negative binomial] model.
