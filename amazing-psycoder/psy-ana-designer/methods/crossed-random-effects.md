# Crossed Random Effects

## Overview

When the experiment samples **subject** and **stimulus** at the same time, both are random effects and need to be modeled simultaneously in the model. This is **standard practice** in psycholinguistics and applies to any design in which the stimuli are random samples.

**Typical scenario**: 30 subjects make emotional judgments on 50 face pictures. Both subjects and pictures are random samples → random effects need to be crossed.

## When to use

| Conditions | Requirements |
|------|------|
| Experimental design | Within-subjects design (within-subjects), including two random sampling dimensions of subjects and stimuli |
| Dependent variable type | Continuous variable (such as reaction time, rating, fixation time, etc.) |
| Independent variable type | Categorical variables (such as experimental conditions), which can include within-subjects and between-subjects factors |
| Sample information | The number of subjects and the number of stimuli determine different promotion dimensions respectively; conduct crossover design simulation based on effect, variance component, random slope and target interval accuracy |
| Subject-stimulus relationship | Crossed, non-nested: Each subject is exposed to multiple stimuli, and each stimulus is rated by multiple subjects |
| Key assumptions | Subjects and stimuli are random samples from the corresponding population; normality and homogeneity of variances of random effects |
| Not applicable | Stimuli are fixed effects (such as using only 2 pictures) or stimuli are nested within subjects (such as using different stimulus sets for each subject) |

## Why it must be done

If you only model the subject random effect and ignore the stimulus:
- Systematic differences between stimuli are treated as errors → false positive inflation
- Statistical inference can only be generalized to "these subjects" and cannot be generalized to "these stimuli + other similar stimuli" at the same time

## Model

```r
lmer(rt ~ condition + (1|subject) + (1+condition|item), data=data)
```

**Key**: This is a cross-effect, not nested. There is no hierarchical relationship between subjects and stimuli.

## When needed

- Language study: Subject × Vocabulary/Sentence
- Face/Picture Study: Subject × Stimulus Picture
- Social cognition: Subject × Social scene

## Report

> A linear mixed model with crossed random effects of subjects and items examined the condition effect on RT. The effect was significant, b=35.2, SE=12.1, t=2.91, with random intercepts by subject (SD=85) and by-item random slopes (SD=15).

## Report Format (APA 7th)

**Method part example:**

> We analyzed the data using linear mixed-effects models with crossed random effects, as both participants and stimuli were treated as random samples from their respective populations. The model included condition as a fixed effect, with random intercepts for participants and random intercepts and slopes for condition by stimuli. Model parameters were estimated using restricted maximum likelihood (REML) with the `lme4` package (Version 1.1-35.1; Bates et al., 2015) in R (Version 4.4.0; R Core Team, 2024). Significance of fixed effects was assessed via Satterthwaite-approximated degrees of freedom using the `lmerTest` package (Version 3.1-3; Kuznetsova et al., 2017).
>
> The maximal random-effects structure justified by the design (Barr et al., 2013) was specified as: `dv ~ condition + (1 | participant) + (1 + condition | stimulus)`. When the maximal model failed to converge, we simplified the random-effects structure by removing the correlation term first, then the slope term if non-convergence persisted (Bates et al., 2015).

**Example of result section:**

> A linear mixed-effects model with crossed random effects of participants and stimuli revealed a significant effect of condition on response times, *b* = 35.2, *SE* = 12.1, *t*(52.7) = 2.91, *p* = .005. The random-effects structure included a random intercept for participants (variance = 7225, *SD* = 85.0) and random intercepts and slopes for condition by stimuli (intercept variance = 1024, *SD* = 32.0; slope variance = 225, *SD* = 15.0; correlation between intercept and slope = -.12). The model explained 34% of the total variance in response times (conditional *R*² = .34; marginal *R*² = .12; Nakagawa & Schielzeth, 2013).

**Reference format (APA 7th):**

> Barr, D. J., Levy, R., Scheepers, C., & Tily, H. J. (2013). Random effects structure for confirmatory hypothesis testing: Keep it maximal. *Journal of Memory and Language*, *68*(3), 255–278. https://doi.org/10.1016/j.jml.2012.11.001
>
> Bates, D., Machler, M., Bolker, B., & Walker, S. (2015). Fitting linear mixed-effects models using lme4. *Journal of Statistical Software*, *67*(1), 1–48. https://doi.org/10.18637/jss.v067.i01
>
> Kuznetsova, A., Brockhoff, P. B., & Christensen, R. H. B. (2017). lmerTest package: Tests in linear mixed effects models. *Journal of Statistical Software*, *82*(13), 1–26. https://doi.org/10.18637/jss.v082.i13
>
> Nakagawa, S., & Schielzeth, H. (2013). A general and simple method for obtaining *R*² from generalized linear mixed-effects models. *Methods in Ecology and Evolution*, *4*(2), 133–142. https://doi.org/10.1111/j.2041-210x.2012.00261.x
