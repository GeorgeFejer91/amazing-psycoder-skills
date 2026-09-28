# ROC Analysis (Receiver Operating Characteristic)

## Overview

ROC analysis evaluates the discriminative ability of the two-classification model and quantifies the classification performance through AUC (area under the curve). It is widely used in clinical psychology to evaluate diagnostic tools.

**Typical Scenario**: Evaluate the classification accuracy of anxiety scores for clinical diagnoses; evaluate the ability of behavioral indicators to distinguish ADHD from controls.

## When to use

| Conditions | Requirements |
|------|------|
| Study design | Diagnostic/predictive validation design; target population, sampling plan, prediction time points and defensible reference standards need to be clearly defined |
| Dependent variable type | Binary classification (such as diseased/not diseased, positive/negative) |
| Independent variable type | Continuous variables or ordered categorical variables (such as scale scores, biological indicators) |
| Sample information | Determined by the number of positive/negative cases, target AUC/sensitivity specificity accuracy, threshold selection and verification scheme; plan two types of sample information separately |
| Key checks | Reference standard misclassification/validation bias, case-control sampling, repeated/clustered observations, predictor evaluation time points consistent with target application; threshold selection must be separate from validation |
| Extensions/Limitations | Corresponding ROC/discriminant extensions are required for multi-category, time-outcome or clustered data; when there is no reliable reference standard, the interpretation of ordinary two-category ROC is limited; nominal predictors need to first define verifiable scoring rules |

## Key indicators

| Indicator | Meaning | Standard |
|------|------|------|
| AUC | Overall discriminative power | 0.5=Random, 0.7=Acceptable, 0.8=Good, 0.9=Excellent |
| Sensitivity | True positive rate (detection rate) | — |
| Specificity | True negative rate (error rate) | — |
| Youden index | Sens+Spec-1 | Determine the optimal cutoff point |

## R code

```r
library(pROC)
roc_obj <- roc(data$diagnosis, data$score)
auc(roc_obj)
plot(roc_obj)
coords(roc_obj, "best")  # Optimal cutoff point
```

## Report

APA 7th format report example:

> A receiver operating characteristic (ROC) analysis was conducted to evaluate the diagnostic accuracy of the anxiety score for identifying clinical anxiety disorder (as determined by structured clinical interview). The area under the ROC curve (AUC) was 0.82, 95% CI [0.75, 0.89], indicating good discriminatory ability between individuals with and without the disorder (Hosmer & Lemeshow, 2000). The optimal cutoff score of 45 was identified using the Youden index (Youden, 1950), yielding a sensitivity of 78% and specificity of 74%. Figure 1 presents the ROC curve.

Key elements to report in APA 7th format:
- AUC value and its 95% confidence interval
- Qualitative description of discriminative ability (reference standard: 0.5 = random, 0.7–0.8 = acceptable, 0.8–0.9 = good, ≥ 0.9 = excellent)
- Method for determining the optimal cutoff point (such as Youden index) and the corresponding sensitivity and specificity
- Description of source, blinding, risk of misclassification and missing validation of reference standards
- Figure number reference (Figure 1)
