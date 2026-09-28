# Repeated Measures Correlation / rmcorr

## Overview

rmcorr is used to calculate the correlation between two variables in repeated measurement data within a subject, solving the independence violation problem of ordinary Pearson r when processing multiple rows of data for each subject.

**Typical scenario**: intra-subject correlation between RT and trial number, correlation between stimulation intensity of each trial and RT.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design type | Within-subject design (within-subject design), each subject is measured repeatedly under multiple conditions |
| Dependent variable type | Both variables are continuous variables (continuous) |
| Argument type | Continuous variable (continuous) or a discrete variable that can be regarded as continuous |
| Sample information | At least repeated observations per person are required to identify within-subject relationships; the number of people, times per person, and missingness are determined by target interval accuracy/slope heterogeneity, and there is no universal total number |
| Data hierarchy | Two levels of nested data: repeated measures (Level 1) nested within subjects (Level 2) |
| Core assumptions | (1) Linear relationship: the two variables are linearly related within subjects; (2) Residual normality; (3) Homoscedasticity; (4) The slope direction of each subject is consistent (rmcorr estimates a common slope and is not suitable for situations where the direction is opposite between subjects) |
| Not applicable | The direction of the slope is inconsistent between subjects (mixed model or individual regression should be used); the data has a nonlinear trend; either of the two variables is a categorical variable |

## Why can’t I use ordinary Pearson r?

Intra-subject data (60 trials per person):
- Pearson r Treat 30 people × 60 = 1800 rows as independent observations → False positive inflation
- Averaging (one r for each subject) → losing within-subject information
- rmcorr: Use ANCOVA to remove differences between subjects and only analyze covariation within subjects

## R code

```r
library(rmcorr)
rmcorr(participant = subject_id, measure1 = rt, measure2 = trial_number, dataset = data)
```

## Output

- r_rm: repeated measurement correlation coefficient (interpretation is the same as Pearson r)
- p value
- 95% CI
- Individual fitting line graph (ggplot)

## Report Format (APA 7th)

**Chinese report template**:

> Use repeated measures correlation (rmcorr) to examine the within-subject correlation between reaction time (RT) and trial number (trial number). The results show that there is a significant negative correlation between the two, *r*~rm~(1428) = -.28, *p* < .001, 95% CI [-.33, -.23], indicating that as the experiment progresses, the subjects' reaction time gradually decreases.

**English report template**:

> A repeated measures correlation (rmcorr) was conducted to examine the within-subject association between reaction time (RT) and trial number. The results revealed a significant negative correlation, *r*~rm~(1428) = -.28, *p* < .001, 95% CI [-.33, -.23], indicating that RT decreased as the experiment progressed.

**Report Highlights**:
- Reports *r*~rm~ values, degrees of freedom (total observations − subjects), *p* values, and 95% confidence intervals.
- Degree of freedom calculation formula: *df* = *N* − *k*, where *N* is the total number of observation rows and *k* is the number of subjects.
- Effect size interpretation: |*r*~rm~| ≈ .10 is a small effect, ≈ .30 is a medium effect, and ≈ .50 is a large effect (same as Pearson *r*).
