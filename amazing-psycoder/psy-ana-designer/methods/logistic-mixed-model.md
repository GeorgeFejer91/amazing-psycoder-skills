# Logistic Mixed Model / glmer

## Overview

Logistic mixed models were used for dichotomous dependent variables (correct/incorrect, yes/no). Mainly used in psychology for **accuracy analysis**, especially when the data is close to the ceiling or floor.

## When to use

| Conditions | Requirements |
|------|------|
| DV | Two categories (0/1, correct/wrong) |
| Design | Within subjects, random effects need to be modeled |
| **Must use** | Any condition accuracy >90% or <10% |

## Why can’t we use ANOVA to measure accuracy?

- Proportional data are naturally non-normal (constrained to be between 0-1)
- The variance is severely compressed when approaching the ceiling (~95%) → ANOVA false positives soar
- Each trial is 0/1 data, and the logistic model directly models the probability, not an approximation
- Clearly recommended by methodological journals (Psychonomic Bulletin & Review, etc.)

## Model formula

```r
glmer(acc ~ condition + (1+condition|subject), 
      data=data, family=binomial,
      control=glmerControl(optimizer="bobyqa"))
```

## Effect size: Odds Ratio

OR = exp(fixef(model)). OR>1=increased probability, OR<1=decreased probability. For example, OR=1.5 means that the correct probability under condition B is 50% higher than that under condition A.

## When the accuracy is between 70-90%

Both methods are acceptable, but glmer is safer:
- If the journal has strict method requirements → glmer
- If the domain convention is still ANOVA → use ANOVA but label "proportional data, close to the normality assumption boundary"

## Report example

> A logistic mixed model examined accuracy across conditions. The odds of correct response were significantly higher in congruent (95%) vs incongruent (88%) condition, OR=2.35, z=4.12, p<.001.
