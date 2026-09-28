# McNemar Test

## Overview

McNemar test is used for **paired binary data** to test whether the changes in classification results between pre- and post-test or two conditions are symmetrical.

**Typical scenario**: The change in the proportion of "in line with clinical diagnosis" before and after treatment; the difference in the right/wrong mode of the two Stroop versions.

## When to use

| Conditions | Requirements |
|------|------|
| DV type | Two categories (yes/no, right/wrong, positive/negative) |
| Design type | Paired design (each subject receives two conditions or pre- and post-test) |
| Sample requirements | Paired samples; complete data are required for both time points/conditions within the subject |
| Key assumptions | Only focus on inconsistent pairs (b and c); standard approximation can be used when b+c ≥ 10, otherwise the exact binomial test needs to be used |
| Data format | 2×2 contingency table, the diagonal is the consistent result (a and d), and the anti-diagonal is the change (b and c) |

## Interpretation of 2×2 table

```
          Condition B
          True False
Condition A is correct for a (consistent) b (wrong)
      Wrong c(change to right) d(consistent)
```

McNemar tests whether b and c are symmetrical - that is, whether the number of people who "get right" and "get wrong" is the same.

## R code

```r
mcnemar.test(table(data$pre, data$post))
```

## Report

> McNemar's test examined whether classification changed from pre to post treatment. Significantly more patients moved from clinical to non-clinical (n=18) than vice versa (n=3), χ²(1)=9.14, p=.002.
