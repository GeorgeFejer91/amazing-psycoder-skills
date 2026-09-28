# Cross-Validation

## Overview

Cross-validation estimates how well the prediction process generalizes to the target data distribution, rather than just evaluating training set fit. The split units, preprocessing nesting, and target deployment distribution determine whether it answers the correct prediction question.

**Typical scenario**: Evaluate the prediction accuracy of the LASSO regression model for new subjects; compare the prediction performance of multiple models.

## When to use

| Conditions | Requirements |
|------|------|
| Research design | Predictive research (non-causal inference) |
| Dependent variable type | Continuous variable (regression) or categorical variable (classification) |
| Information requirements | Determined by number of independent sampling units, number of events/category ratio, model complexity, and target accuracy; no universal `N ≥ 50` threshold |
| Segmentation contract | Segmentation must simulate the target generalization unit (new subject/item/center/time period); all parameter tuning, feature selection, interpolation and standardization are completed within the training fold |
| Not applicable scenarios | Causal effect estimation; Time series prediction (requires time series cross-validation); Data has a hierarchical structure but is not hierarchically segmented |

## Method

| Method | Features | When to use |
|------|------|--------|
| k-fold CV | Test in turns in k parts | k is determined by the number of independent units, computational budget and bias/variance trade-off |
| Leave-One-Out (LOOCV) | Leave one for each independent unit | Need to evaluate high variance, computational cost and target generalization unit, not the automatic default for small samples |
| Repeat k-fold | Randomize multiple times | Evaluate stability |

## R code

```r
library(caret)
# 10-fold CV for linear model
train_control <- trainControl(method="cv", number=10)
model <- train(rt ~ ., data=data, method="lm", trControl=train_control)
print(model$results)  # RMSE, R², MAE
```

## Report

APA 7th format report example (regression model):

> Model predictive performance was evaluated using 10-fold cross-validation with folds split at the participant level, matching the target of prediction for new participants. All preprocessing and tuning occurred within each training fold. The LASSO model yielded RMSE = 45.2, cross-validated R² = .34, and MAE = 34.7, compared with RMSE = 52.1, R² = .28, and MAE = 40.1 for the prespecified comparator. Fold-wise/participant-level uncertainty for the performance difference was reported; no universal “small/medium/large” R² cutoff was imposed.

APA 7th format report example (classification model):

> Classification performance was evaluated using stratified 10-fold cross-validation. The random forest classifier achieved a mean cross-validated AUC of .82 (95% CI [.78, .86]), sensitivity of .74, and specificity of .81, outperforming logistic regression (AUC = .76, 95% CI [.71, .81]).

Report list:
- [ ] Explicit cross-validation method (k-fold / LOOCV / repeated k-fold) and k value
- [ ] Describe the segmentation strategy (subject level/trial level/stratification)
- [ ] Report key performance metrics (RMSE / R² / AUC / Accuracy, etc.)
- [ ] If it involves model comparison, report the performance differences of each model
- [ ] gives the confidence interval of key indicators (recommended)

## Notes

- CV estimates predictive performance, not causal effects
- In a within-subjects design, k-fold needs to be divided at the subject level (not trials)
- If the final model is refitted on all development data, it should be saved with a locked preprocessing/tuning flow; this does not replace independent external validation
