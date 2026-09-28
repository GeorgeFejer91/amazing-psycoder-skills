# Generalized Estimating Equations (GEE)

## Overview

GEE is a **overall average** method for processing repeated measurement data, which is suitable for scenarios that focus on the group average effect rather than individual differences. is an alternative to hybrid models.

**Typical scenario**: Care about the conditional effect of the "average subject" and not about inter-subject variation; two-category DV and no random effect explanation is required.

## When to use

| Conditions | Requirements |
|------|------|
| Design Type | Repeated Measurements/Longitudinal Data (can handle unbalanced number of measurements) |
| Dependent variable type | Continuous (Gaussian), binary classification (Binomial), count (Poisson), etc. |
| Information requirements | Robust sandwich inference relies on cluster number, cluster size/imbalance and correlation structure; small cluster numbers require the design of adapted corrections/alternatives rather than a fixed 30–50 threshold |
| Missing data mechanism | Standard GEE usually requires stronger conditions for missing outcomes; consider weighted GEE, multiple imputation or other estimand-compatible methods under MAR, and do sensitivity analysis |
| Work-related structure | Need to be specified in advance (such as exchangeable, AR-1, unstructured) |
| Model concerns | Overall average effect (group level), not applicable to individual predictions |

## GEE vs hybrid model

| | GEE | Mixed model |
|------|-----|---------|
| Explanation | Overall average | Subject-specific |
| Random effects | None | Yes |
| Correlation Structure | Working Correlation Matrix | Variance-Covariance |
| Missing data | Standard/weighted GEE differs from required assumptions and must be stated | Likelihood model handles incomplete outcomes under its MAR/model assumptions; diagnostic/sensitivity analysis also required |
| Conclusion generalization | Average subject | Individual subject |

## R code

```r
library(geepack)
model <- geeglm(rt ~ condition, id=subject_id, data=data,
                family=gaussian, corstr="exchangeable")
summary(model)
```

## When to use GEE

- requires overall average effect (no individual prediction)
- Scientific estimand is the population average effect, and GEE's correlation/missing/small sample inference covenants are met; estimand cannot be changed just because the GLMM does not converge
- The work-related structure is known (such as exchangeable)

## Report Format (APA 7th)

**Example**:

Use generalized estimating equations (GEE) to analyze repeated measurement reaction time data, with experimental condition (experimental group vs. control group) as the within-subject factor. The model sets the Gaussian distribution family and adopts an exchangeable work-related structure. The results showed a significant main effect of condition, Wald χ²(1) = 12.34, p = .001. The reaction time of the experimental group (M = 350, SE = 15) was significantly shorter than that of the control group (M = 420, SE = 18).
