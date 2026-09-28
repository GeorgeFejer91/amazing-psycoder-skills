# Dunnett test / Games-Howell test

## Overview

These methods address different families of group comparisons. Planned comparisons need not wait for a significant omnibus ANOVA when the family and error-control method were specified in advance.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Post hoc comparison of one-way between-subjects ANOVA |
| Dependent variable type | Continuous variable (equal interval/equal ratio) |
| Sample requirements (Dunnett) | One control group + multiple experimental groups; sample sizes can vary, but the variances must be homogeneous |
| Sample requirements (Games-Howell) | The sample sizes of each group may not be equal; Homogeneity of variances is not required |
| Key assumptions (Dunnett) | Normality, independence, homogeneity of variances; fewer comparisons → higher power than Tukey |
| Key assumptions (Games-Howell) | Normality, independence; **not required** homogeneity of variances, **not required** and other sample sizes |

## Dunnett's test

**Multiple groups vs single control group**. Test whether each experimental group is different from the control group, but not between experimental groups.

Applies to: 3 drug doses vs placebo; 2 experimental conditions vs baseline.

```r
library(multcomp)
summary(glht(aov_model, linfct=mcp(group="Dunnett")))
```

is more effective than Tukey (fewer comparisons → lighter correction).

## Games-Howell Test

** Pairwise comparison when variances are uneven + sample sizes are unequal**. Homogeneity of variances and equal sample sizes are not assumed.

```r
library(rstatix)
games_howell_test(data, dv ~ condition)
```

Choose a method from the estimand, variance structure, sample sizes, and planned comparison family. A Levene p-value is diagnostic evidence, not an automatic switch that makes Games-Howell mandatory.

## Select

| Scenario | Method |
|------|------|
| All pairwise comparisons, homogeneous variance | Tukey HSD |
| Compared with the control group only | **Dunnett** |
| Uneven variance, n is not equal | **Games-Howell** |

## Report

APA 7th format report example:

**Dunnett Test:**

> A one-way analysis of variance was conducted with the group as the independent variable (placebo group, low-dose group, medium-dose group, and high-dose group) and the symptom score as the dependent variable. The results showed that there was a significant difference between the groups, F(3, 76) = 5.82, p = .001, η² = .19. Dunnett's post hoc comparison (taking the placebo group as the reference) showed that the mid-dose group (M = 12.40, SD = 3.20) was significantly lower than the placebo group (M = 18.60, SD = 4.10), p = .003, d = 1.68; the high-dose group (M = 10.80, SD = 2.90) was also significantly lower than the placebo group, p < .001, d = 2.19. The difference between the low-dose group (M = 16.90, SD = 3.80) and the placebo group was not significant, p = .342.

**Games-Howell Check:**

> Levene's test showed uneven variances, F(3, 76) = 4.21, p = .008, and the sample sizes of each group were unequal (n₁=15, n₂=22, n₃=18, n₄=25), so Games-Howell post hoc comparison was used. The results showed that there was a significant difference between group A (M = 23.50, SD = 8.10) and group C (M = 14.20, SD = 3.40), p = .012; the other pairwise comparisons were not significant, ps > .05.
