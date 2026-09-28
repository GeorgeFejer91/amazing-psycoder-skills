# Gamma Mixed Model (Gamma GLMM)

## Overview

The Gamma mixture model is used to process continuous data that is severely right-skewed (RT data is the most common).

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Within-subjects or between-subjects design, must include random effects structure (such as random intercept, random slope) |
| Dependent variable type | Continuous positive number, severely right-skewed (such as reaction time RT, duration, latency) |
| Data distribution | All observations are positive; the variance increases with the mean (Gamma distribution characteristics) |
| Sample information | Determined by the number of clusters, observations per cluster, random structure, skewness and effects; using simulation and convergence/recovery diagnosis, no fixed number of subjects |
| Link function | Typically using log link, effect sizes are interpreted as ratio changes |
| Key assumptions | Residuals obey Gamma distribution; random effects obey normal distribution; conditions between observations are independent |

## Model

```r
glmer(rt ~ condition + (1+condition|subject),
      data=data, family=Gamma(link="log"))
```

Effect explanation: exp(estimate) = RT ratio. For example, exp(0.2)=1.22, the RT of condition B is 22% higher than that of condition A.

## Comparison with log(RT)+lmer

| Method | Advantages | Disadvantages |
|------|------|------|
| log(RT)+lmer | Simple, good convergence | Interpretation requires reverse transformation |
| Gamma GLMM | Original scale, naturally handles skewness | May converge slowly |

Both methods usually give consistent conclusions. Which one you choose depends on domain conventions and your preference for "explainability".

## Report

APA 7th format report example:

> Gamma mixed model (log link function) was used to analyze the reaction time data, with condition as a fixed effect, subjects and items as random intercepts, and condition as a random slope within subjects. The model showed that reaction time for condition B was significantly longer than condition A, *b* = 0.20, *SE* = 0.06, *z* = 3.33, *p* = .001, 95% CI [0.08, 0.32]. exp(0.20) = 1.22, indicating that the reaction time of condition B is 22% higher than that of condition A on average. Random effects variance revealed large individual differences in baseline reaction times between subjects (SD = 0.15).

Key reporting elements:
- Explicitly specify the link function (link = "log")
- Reports *b* (coefficients on log scale), *SE*, *z*/*t* values, and *p* values
- reports exp(*b*) and its actual meaning (RT ratio or percentage change)
- Report random effects structure and variance components
- If the model has difficulty converging, report the optimizer choice (such as `bobyqa`) and convergence information
