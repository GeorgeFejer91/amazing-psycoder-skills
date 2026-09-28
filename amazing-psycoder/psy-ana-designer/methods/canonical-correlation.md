# Canonical Correlation Analysis (CCA)

## Overview

CCA analyzes the overall association between two groups of multiple variables and is a multivariate extension of Pearson correlation.

**Typical scenario**: Overall correlation between 3 cognitive tasks (RT, accuracy, variability) and 4 questionnaire scores (anxiety, depression, stress, fatigue).

## When to use

There are multiple Xs and multiple Ys, and I want to know "how correlated are these two sets of variables as a whole" instead of pairwise testing.

| Conditions | Requirements |
|------|------|
| Design type | Dependent design/observation design, both sets of variables are continuous |
| Variable set X | 2+ continuous variables, allowing moderate correlation between variables but avoiding serious multicollinearity |
| Variable set Y | 2+ continuous variables, allowing moderate correlation between variables but avoiding serious multicollinearity |
| Sample information | Determined by two sets of dimensions, covariance stability, regularization and target canonical correlation; use resampling/external validation, do not apply the variable number × 10 rule |
| Proportion of number of variables | The number of variables in each group is recommended to be ≤ 5-6, and the total number of variables should not exceed 1/10 of the sample size |
| Linear hypothesis | The relationship between the X set and the Y set is linear, and the relationship between each typical variable pair is linear |
| Multivariate normality | The two sets of variables jointly obey the multivariate normal distribution (can be relaxed in large samples) |
| Intra-group collinearity | There is no perfect collinearity within the same variable set (VIF < 10) |

## R code

```r
library(CCA)
X <- data[,c("rt","accuracy","variability")]
Y <- data[,c("anxiety","depression","stress","fatigue")]
cc <- cc(X, Y)
# Canonical correlation coefficient
cc$cor
# Typical loads
cc$xcoef; cc$ycoef
```

## Report

### APA 7th Report Format

> A canonical correlation analysis (CCA) was conducted to examine the overall multivariate relationship between cognitive performance measures (RT, accuracy, RT variability) and mood symptoms (anxiety, depression, stress, fatigue). The overall model was significant, Wilks' Λ = .68, *F*(12, 508.32) = 5.21, *p* < .001.
>
> Two canonical functions emerged as statistically significant. The first canonical correlation was *r*<sub>c</sub> = .52, *p* < .001, accounting for 27.0% of the shared variance between the two variable sets. On the cognitive side, RT loaded most heavily on this function (canonical loading = .85), followed by RT variability (.62) and accuracy (−.48). On the mood side, anxiety showed the strongest loading (.78), followed by stress (.61) and fatigue (.54). This indicates that slower and more variable reaction times were associated with higher anxiety, stress, and fatigue.
>
> The second canonical correlation was *r*<sub>c</sub> = .31, *p* = .012, accounting for an additional 9.6% of shared variance. Accuracy (.72) and depression (.68) were the primary contributors to this function, suggesting that lower accuracy was specifically associated with higher depression scores independent of the first dimension.
>
> Redundancy analysis indicated that the mood variable set explained 18.4% of the variance in the cognitive variables through the first canonical function, and 8.2% through the second. Standardized canonical coefficients and structure coefficients (*r*<sub>s</sub>) are presented in Table X.
