# LASSO / Ridge Regression (Regularization)

## Overview

LASSO and ridge regression shrink the regression coefficients through penalty terms to prevent overfitting. It is particularly useful when there are more predictor variables than subjects, or when variables are highly correlated.

**Typical scenario**: Select the subset that best predicts the Stroop effect from 50 questionnaire items; process >20 highly correlated behavioral indicators.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Observation studies, correlation designs, predictive modeling |
| Dependent variable type | Continuous variables (such as reaction time, questionnaire scores, EEG indicators) |
| Predictor variables | Multiple continuous or categorical variables, allowing the number of predictor variables > the number of subjects |
| Sample requirements | The final number of selected variables is recommended < N/10; the number of variables selected by LASSO is controlled by λ |
| Key assumptions | There is a linear relationship between the dependent variable and the predictor variable; observation independence; no complete collinearity (Ridge can handle high correlation, LASSO will choose one) |

## LASSO vs Ridge

| Method | Punishment | Effect | When to use |
|------|------|------|--------|
| Ridge | λΣβ² (L2) | Shrink but not return to zero | All variables contribute |
| LASSO | λΣ\|β\| (L1) | Some coefficients → 0 (variable selection) | Want to simplify the model |
| Elastic Net | λ1Σ\|β\|+λ2Σβ² | Mixed | Uncertain |

## Choose λ for cross-validation

```r
library(glmnet)
cv_fit <- cv.glmnet(x, y, alpha=1)  # alpha=1 for LASSO
plot(cv_fit)
coef(cv_fit, s="lambda.min")  # Coefficient under optimal lambda
```

## Report

### Brief example

> LASSO regression (λ selected by 10-fold CV) identified 8 of 50 questionnaire items as predictors of Stroop interference. The final model explained 34% of variance, with anxiety and age as the strongest predictors.

### APA 7th format report example

> We conducted a LASSO regression with 10-fold cross-validation to identify which of 50 questionnaire items predicted Stroop interference (congruent minus incongruent RT, ms). The model selected at λ~min~ retained 8 predictors and explained 34% of the variance in Stroop scores, *R*^2^ = .34, MSE = 1245.61. The strongest predictors were trait anxiety (standardized coefficient β = 0.31) and age (β = −0.26), followed by sleep quality (β = 0.19), education years (β = −0.15), and working memory span (β = −0.12). The remaining three items (physical activity, caffeine intake, and BMI) each contributed |β| < 0.10. Bootstrap resampling (1000 iterations) confirmed that trait anxiety and age were selected in over 80% of resamples, supporting the stability of these predictors.

**Chinese control**: Using 10-fold cross-validation LASSO regression, the predictor variables of Stroop interference effect were screened from 50 questionnaire items. The model retains 8 predictor variables under λ~min~, explaining 34% of the variation in Stroop score, *R*^2^ = .34, MSE = 1245.61. The strongest predictor variables were trait anxiety (standardized coefficient β = 0.31) and age (β = −0.26), followed by sleep quality (β = 0.19), years of education (β = −0.15), and working memory span (β = −0.12). The |β| of the remaining three items (exercise volume, caffeine intake, and BMI) are all < 0.10. Bootstrap resampling (1000 times) confirmed that trait anxiety and age were selected in more than 80% of the resamples, supporting the stability of these predictors.

### Report list

- Penalty method used (LASSO / Ridge / Elastic Net) and α value
- λ selection method (CV fold, λ~min~ or λ~1se~)
-The number and names of variables retained in the final model
- model fit index (*R*^2^, MSE or deviance)
-Standardized coefficient (β) and ranking of each variable
- Bootstrap stability test results (if any)

## Notes

- The variables selected by LASSO are unstable - bootstrap test selection frequency
- The p-value of penalized regression cannot be directly interpreted (selection bias)
- It is best to combine traditional regression: LASSO selects variables, traditional regression estimates effects and tests
