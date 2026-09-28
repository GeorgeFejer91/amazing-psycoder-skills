# Multiple Imputation / MICE

## Overview

Multiple imputation is a candidate method for handling missing data under defensible missingness mechanisms and compatible imputation models. Create multiple imputed data sets, analyze them separately, and propagate imputation uncertainty according to the corresponding merge rules; it is not an automatic default for all missingness problems.

**Typical scenario**: 20% of subjects are missing RT in some trials; some subjects do not complete all questionnaires; subjects are lost in longitudinal studies.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Applicable to all types of designs containing missing data, such as experimental design, quasi-experimental design, longitudinal study, questionnaire study, etc. |
| Dependent variable type | Continuous variables (RT, score, etc., the most common), binary categorical variables, ordered categorical variables, count variables |
| Information Request | Designed based on sample structure, missingness patterns/proportions, variable support sets, imputation model complexity, and Monte Carlo errors; does not use a fixed "complete cases × number of variables" or 50% threshold in lieu of diagnosis |
| Key assumptions | **MAR** (Missing at Random): Missingness only depends on the observed data and does not depend on the missing value itself; **The imputation model must include all variables** in the analysis model** (including interaction terms and dependent variables); auxiliary variables can be introduced to improve the imputation accuracy |

## Why is it not deleted in a row?

- Column deletion: discard any rows with deletions → bias (if deletions are non-random) + loss of power
- Mean imputation: underestimation of standard errors → false positive inflation
- Multiple imputation: propagates imputation uncertainty when imputation/analytical models are compatible and missing assumptions are defensible; no guarantee of unbiasedness

## MICE process

1. Select a sufficient number of imputed data sets through Monte Carlo error/stability diagnostics instead of applying `m=5-20`
2. Each data set is analyzed independently
3. Rubin's rules combined results (estimate + SE + CI)

## R code

```r
library(mice)
imp <- mice(data, m=10, method="pmm", seed=2024)
fit <- with(imp, lmer(rt ~ condition + (1|subject)))
pool(fit)
```

## Report

### Brief example

> Missing data (12% of trials) were handled with multiple imputation (m=10, MICE). Pooled results showed a significant condition effect, b=45.2, 95%CI [38.1,52.3], p<.001. Sensitivity analysis with listwise deletion yielded consistent results (b=43.8).

### APA 7th Full Report Format

> Missing data were handled using multiple imputation by chained equations under a prespecified MAR assumption justified from the data-collection process and observed predictors of missingness. The imputation model included all analysis-model terms plus declared auxiliary variables, respected variable supports and the multilevel structure, and was checked with trace/distribution/convergence diagnostics. The number of imputations was selected to make Monte Carlo error acceptably small. Estimates and uncertainty were pooled using rules compatible with the fitted analysis, and sensitivity analyses examined departures from the MAR assumption. Little's MCAR test was not used to claim MAR, because a non-significant MCAR test does not establish that mechanism.
