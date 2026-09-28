# Psychometric function fitting

## Overview

The psychometric function describes the relationship between stimulus intensity and detection/discrimination probability and is used to estimate thresholds or other curve parameters defined by the task, guess/miss rate, and protocol; thresholds are not universally equal to 75% correct.

**Typical scenario**: In the ladder method, the contrast threshold is estimated by fitting the logistic/Weibull function; the adaptive ladder (1-up-2-down, etc.) converges to 70.7% correct.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design type | Psychophysical method (staircase method, constant stimulus method, adaptive ladder method); within-subjects or between-subjects design is acceptable |
| Dependent variable type | Binary categorical variable (correct/wrong, detected/not detected) or proportional data |
| Information Requirements | Stimulus level coverage, amount of information per level/condition, guess/error rate, target parameters, and accuracy determine number of trials; determined by simulation/design analysis, not set to a fixed 40 or 100–200 threshold |
| Key assumptions | (1) There is a monotonically increasing relationship between stimulus intensity and accuracy; (2) Trial-to-trial independence; (3) No significant fatigue or practice effects; (4) The guessing rate (lapse rate) is controllable or can be parameterized in the model |

## Commonly used functions

| Function | Parameters | Features |
|------|------|------|
| Logistic | α(threshold), β(slope) | Most commonly used |
| Weibull | α, β | Visual Psychophysics |
| Cumulative Gaussian | μ(threshold), σ(SD) | Signal detection framework |

## R code

```r
library(quickpsy)
fit <- quickpsy(data, x=stimulus_intensity, k=correct, n=total_trials,
                grouping=.(condition), fun=logistic_fun)
plot(fit)
# Extraction threshold
fit$thresholds
```

## Report

**APA 7th format report example**:

> Psychometric functions were fitted using a logistic function to estimate the contrast threshold at 75% correct for each condition. The congruent condition showed a significantly lower contrast threshold (α = 0.12, 95% CI [0.09, 0.15]) compared to the incongruent condition (α = 0.18, 95% CI [0.14, 0.22]), t(19) = 3.45, p = .003, Cohen's d = 0.77. The slope parameter did not differ between conditions (β_congruent = 1.12, β_incongruent = 1.08, p = .62). Goodness-of-fit was assessed by visual inspection of observed versus predicted proportions and the deviance statistic, which indicated acceptable fit (D = 12.34, p = .42).

> Psychometric functions (logistic) estimated the contrast threshold at 75% correct. The congruent condition showed a lower threshold (0.12) than incongruent (0.18), indicating better perceptual sensitivity.

**Reporting points**: (1) Describe the fitting function type (logistic/Weibull, etc.); (2) Report the threshold and confidence interval; (3) Report the slope (if relevant); (4) Report the goodness of fit index; (5) If there are multiple conditions, report the statistics of comparison between conditions.

## Notes

- The threshold estimation of the ladder method relies on the ladder rule (such as 1-up-2-down→70.7%)
- Evaluate threshold stability with parameter recovery/simulation, interval width, and fit diagnostics instead of fixed trial number thresholds
- Check goodness of fit: prediction-observation comparison plot
