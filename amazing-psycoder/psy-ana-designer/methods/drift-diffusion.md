# Drift Diffusion Model (DDM)

## Overview

DDM decomposes the data of the two-choice reaction time task into cognitive sub-components: information accumulation speed, reaction caution, and non-decision time. It is the **standard computational model** in decision neuroscience.

**Typical scenario**: Test whether the Stroop effect changes the speed of information accumulation (v) or the response threshold (a); compare the differences in decision-making components between ADHD and the control group.

## When to use

| Conditions | Requirements |
|------|------|
| **Experimental design type** | Two-choice reaction time tasks (such as perceptual discrimination, lexical judgment, reward decision-making) |
| **Dependent variable type** | Reaction time (RT) + binary classification accuracy (accuracy), the two need to be jointly modeled |
| **Sample Requirements** | Trial requirements depend on the number of free parameters, error rate, participant count, and desired precision; assess identifiability and recovery by simulation for the planned design |
| **Key Assumptions** | (1) The decision-making process is continuous evidence accumulation with noise (Wiener diffusion process); (2) Evidence accumulates to a threshold to trigger a reaction; (3) It is only applicable to two-choice decisions (multiple options need to use multi-choice DDM or LBA instead) |

## Core parameters

| Parameters | Psychological explanation |
|------|-----------|
| **v (drift rate)** | Information accumulation speed—cognitive processing quality. The bigger v = the faster and more accurate |
| **a (boundary)** | Response threshold—speed/accuracy trade-off. Bigger a = slower but accurate |
| **t0 (non-decision time)** | Encoding + motion execution (non-decision part) |
| **z (starting point)** | Prior bias (usually fixed at 0.5 = unbiased) |

## Questions that DDM can answer

- Is the conditional effect by changing **speed**(v) or **caution**(a)?
- Is the difference between groups **decision quality**(v) or **response style**(a)?
- Does the speed-accuracy trade-off explain the conditioning effect?

## R code

```r
library(brms)
# choice must be coded as the lower (0) or upper (1) decision boundary.
# Confirm this coding and the task's stimulus-response mapping before fitting.
fit <- brm(rt | dec(choice) ~ condition + (1 | subject),
           data = data, family = wiener(),
           control = list(adapt_delta = 0.99, max_treedepth = 15),
           iter = 4000, warmup = 2000, chains = 4, cores = 4)
```

## Report

**APA 7th format report example:**

> Response choice and response time were jointly modeled with a Wiener diffusion likelihood. The example model above estimates a condition effect on drift rate; it does not estimate condition effects on boundary separation or non-decision time. Report posterior estimates and intervals for each parameter actually modeled, convergence diagnostics, parameter-recovery checks where possible, and posterior predictive checks before interpreting cognitive mechanisms.

> *Note.* DDM = Drift Diffusion Model; HDI = Highest Density Interval. See the supplementary material for posterior parameter estimates and trajectory plots.

## Notes

- Trial requirements must be justified for the particular model and design; there is no universal 100-trial cutoff.
- Model fitting needs to be checked for convergence and posterior predictions
- Not suitable for multi-option tasks (>2 options)
