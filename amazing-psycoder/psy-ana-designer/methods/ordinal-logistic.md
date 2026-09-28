#Ordinal Logistic Regression

## Overview

Ordered logistic regression processes ordered categorical dependent variables, such as Likert scale (1-7 points), education level, and satisfaction rating.

**Typical scenario**: Test the impact of experimental conditions on Likert scale scores (1-7); test the impact of grade on academic grade.

## When to use

| Conditions | Requirements |
|------|------|
| DV | Ordered classification (such as Likert 1-7) |
| IV | Continuous or Categorical |

## Why not use ordinary ANOVA

- Likert data is not a continuous variable - it is a discrete ordinal category
- The difference between adjacent scores is not equal (the difficulty of 4→5 may ≠ the difficulty of 1→2)
- Data is truncated (cannot be lower than 1, cannot be higher than 7)
- Ordinal logistic regression does not assume isometry, only order

## R code

```r
library(ordinal)
model <- clm(factor(rating) ~ condition + (1|subject), data=data)
summary(model)
```

## Effect size

OR (Odds Ratio): exp(estimate). OR>1=increased probability of higher rating.

## Report

> Ordinal logistic regression examined the effect of condition on Likert ratings (1-7). The congruent condition was associated with higher confidence ratings, OR=1.85, 95%CI [1.42,2.41], p<.001.
