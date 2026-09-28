# ROC Curve

## Overview

The ROC curve shows the sensitivity vs. false positive rate of the binary classification model at all possible cutoff points. The area under the curve (AUC) quantifies overall discriminative power.

## When to use

| Condition | Description |
|------|------|
| DV | Two categories (sick/healthy, correct/wrong) |
| Prediction | Continuous score or probability |

## R code

```r
library(pROC)
roc_obj <- roc(data$diagnosis, data$score)
plot(roc_obj, print.auc=TRUE, auc.polygon=TRUE)
```

## Interpretation

- AUC is the probability interpretation of the correct ordering of scores (given the target population and sampling conditions) when randomly selecting a pair of positive/negative samples; reporting interval with internal/external validation.
- AUC=0.5 indicates that there is no overall ranking discriminant information in this direction; lower than 0.5 may also reflect that the scoring direction encoding is opposite.
- "Acceptable/Excellent" depends on application consequences, reference standards, category spectrum, and alternatives and does not use the `.7/.8/.9` generic tags.
- The ROC does not reflect calibration, predicted values ​​at prevalence, or decision utility at selected thresholds; these need to be evaluated separately.
