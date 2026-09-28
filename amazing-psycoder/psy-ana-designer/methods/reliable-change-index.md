# Reliable Change Index (RCI)

## Overview

RCI uses an explicit measurement error model to determine whether individual changes before and after are greater than the error expected by the model. It is a common indicator, but conclusions rely on reliability sources, standard error formulas, practice effects, and reference samples; it cannot alone prove treatment causal effects or clinical significance.

**Typical scenario**: After treatment, the anxiety score dropped from 25 to 18. Is the change of 7 points a real improvement or a measurement error?

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Single-group pretest and posttest design (repeated measures) |
| Dependent variable type | Continuous variables (such as scale scores, physiological indicators) |
| Sample requirements | Each individual must have complete pretest and posttest scores; scale reliability must be known (Cronbach's α or test-retest reliability) |
| Key Assumptions | The selected standard error/reliability model applies; pre- and posttest error correlations, regression to the mean, practice effects, and scale measurement invariance are addressed or stated explicitly as limitations |

## Formula

RCI = (X_post - X_pre) / S_diff

The classic Jacobson–Truax form can be written as S_diff = √(2 × SE²), SE = SD × √(1-r). Here `r` must be a reliability estimate suitable for the purpose and reference population; Cronbach's alpha is not automatically equivalent to a test-retest error model. If pre- and post-error correlation or practice effects are considered, the corresponding formula/normative sample model should be used.

## Judgment criteria

- Under the preselected two-sided 95% error model, a common critical value is |RCI| > 1.96; corresponding critical values should be used for different confidence levels.
- "Reliable change" and "crossing the clinical cutoff" are different conditions; the clinical cutoff must have a target population and a basis for measurement.

## R code

```r
RCI <- (post_score - pre_score) / sqrt(2 * (SD_pooled * sqrt(1 - alpha))^2)
```

## Report

> RCI analysis examined individual pre-post changes in anxiety. Of 30 patients, 18 (60%) showed reliable improvement (RCI< -1.96), 10 (33%) showed no reliable change, and 2 (7%) showed reliable deterioration (RCI>1.96).

### APA 7th Report Format

**Method part (Method)**

> Individual-level change was evaluated using the reliable change index (RCI; Jacobson & Truax, 1991). The standard error of measurement was computed as *SE* = *SD* × √(1 − α), where *SD* is the pooled baseline standard deviation and α is the internal consistency (Cronbach's α) of the Beck Anxiety Inventory (BAI) in the current sample (α = .88). The standard error of the difference was then derived as *S*<sub>diff</sub> = √(2 × *SE*²). Participants were classified as reliably improved (RCI < −1.96), reliably deteriorated (RCI > 1.96), or showing no reliable change (|RCI| ≤ 1.96) based on the 95% confidence interval.

**Results**

> Reliable change index analysis examined whether individual pre- to posttreatment changes on the BAI exceeded the prespecified measurement-error model. The standard error of the difference was *S*<sub>diff</sub> = 4.14, corresponding to a 95% critical difference of ±8.11 BAI points. Among 30 completers, 18 (60.0%) showed reliable improvement, 10 (33.3%) no reliable change, and 2 (6.7%) reliable deterioration. Of the 18 reliably improved patients, 14 (77.8%) also crossed the independently justified clinical cutoff. These classifications are descriptive of completers and do not by themselves identify a treatment effect.

**Reference**

> Jacobson, N. S., & Truax, P. (1991). Clinical significance: A statistical approach to defining meaningful change in psychotherapy research. *Journal of Consulting and Clinical Psychology*, *59*(1), 12–19. https://doi.org/10.1037/0022-006X.59.1.12
