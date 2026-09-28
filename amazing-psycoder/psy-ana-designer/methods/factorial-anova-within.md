# Two-factor within-subjects ANOVA

## Overview

Two-factor within-subjects ANOVA is used for 2×2 or more complex within-subjects designs. All subjects accepted all combinations of conditions.

**Typical scenario**: 2(Consistency: Consistent/Inconsistent) × 2(SOA: Short/Long) Stroop effect comparison.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Within subjects, two categories IV |
| DV | Continuous |
| Assumptions | Per-condition combination normality + spherical symmetry |

## Key output

- **Main Effect**: The main effect of factor A, the main effect of factor B
- **Interaction**: Is the A×B interaction significant?
- **Simple Effect**: After the interaction is significant, test the effect of A at each level of B

When the interaction is significant, the main effect cannot be explained directly—the simple effects must be analyzed first.

## Effect size: η²p

Reports η²p for each effect (main effect A, main effect B, interaction A×B).

## R code

```r
library(tidyverse)
library(afex)
library(rstatix)

# Simulate 2×2 within-subjects design data (Stroop RT)
set.seed(42)
n <- 30
df <- expand.grid(
  subject = factor(1:n),
  congruency = c("congruent", "incongruent"),
  SOA = c("short", "long")
) %>%
  mutate(
    RT = case_when(
      congruency == "congruent" & SOA == "short"   ~ rnorm(n, 450, 50),
      congruency == "congruent" & SOA == "long"    ~ rnorm(n, 430, 50),
      congruency == "incongruent" & SOA == "short" ~ rnorm(n, 520, 55),
      congruency == "incongruent" & SOA == "long"  ~ rnorm(n, 480, 55)
    )
  )

# Two-factor within-subjects analysis of variance (GG correction + η²p)
model <- aov_ez(
  id = "subject",
  dv = "RT",
  within = c("congruency", "SOA"),
  data = df,
  anova_table = list(correction = "GG", es = "pes")
)
print(model)

# Simple effects analysis (when the interaction is significant)
df %>%
  group_by(SOA) %>%
  anova_test(dv = RT, wid = subject, within = congruency) %>%
  get_anova_table(correction = "GG")

# Descriptive statistics
df %>%
  group_by(congruency, SOA) %>%
  summarise(mean = mean(RT), sd = sd(RT), .groups = "drop")
```

## Report format

> A 2×2 repeated measures ANOVA examined the effects of congruency and SOA on RT. The main effect of congruency was significant, F(1,29)=45.2, p<.001, η²p=.61. The congruency×SOA interaction was significant, F(1,29)=8.3, p=.008, η²p=.22. Simple effects revealed...

## Alternative method

- **lmer**: Recommended alternative, use `lmer(dv ~ A*B + (1+A*B|subject))` directly within the two-factor subject
