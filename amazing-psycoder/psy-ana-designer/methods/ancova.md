# Analysis of covariance (ANCOVA)

## Overview

ANCOVA controls the influence of one or more continuous covariates when comparing differences between groups, improving statistical power and precision.

**Typical scenario**: Compare the effects of two training methods and control the impact of pre-test scores. Comparing the Stroop effect between the two groups, controlling for age.

## When to use

| Conditions | Requirements |
|------|------|
| DV | Continuous |
| IV | Classification |
| Covariate | Continuous, linearly related to DV |

## Why use ANCOVA

- Reduce error variance → Improve statistical power
- correct for initial differences between groups (quasi-experimental design)
- Adjusted mean → more accurately estimates treatment effects

## Key assumptions

1. **Covariates are linearly related to DV**
2. **Regression slope homogeneity**: The regression slope of the covariate-DV is the same between each group (the most important assumption). Violation→cannot use standard ANCOVA

## R code

```r
# Load necessary packages
library(car)         # Anova() Type III SS
library(effectsize)  # eta_squared() effect size
library(emmeans)     # Estimated marginal mean (adjusted means)
library(ggplot2)     # Visualization

# ── Simulation data ────────────────────────────────────────
set.seed(123)
n <- 90
group <- factor(rep(c("A", "B", "C"), each = 30))
age <- round(rnorm(n, mean = 25, sd = 5), 1)
# DV: Stroop interference effect (ms), controlling the influence of age
stroop <- 50 +
  ifelse(group == "A", 15, ifelse(group == "B", 28, 2)) +
  0.8 * age + rnorm(n, 0, 10)
df <- data.frame(group, age, stroop)

# ── 1. Check regression slope homogeneity ─────────────────────────────
# The interaction term is not significant → hypothesis is established
homogeneity <- aov(stroop ~ group * age, data = df)
summary(homogeneity)

# ── 2. Fitting the ANCOVA model ───────────────────────────────
model <- aov(stroop ~ group + age, data = df)

# Type III SS (recommended, handles unbalanced designs)
Anova(model, type = "III")

# ── 3. Effect size ──────────────────────────────────────
eta_squared(model, partial = TRUE)

# ── 4. Estimated marginal mean (adjusted means)───────────────────
emm <- emmeans(model, ~ group)
emm
pairs(emm, adjust = "bonferroni")  # Post hoc comparison

# ── 5. Visualization ──────────────────────────────────────
ggplot(df, aes(x = age, y = stroop, color = group)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  labs(
    title = "ANCOVA: Stroop interference effect ~ group + age",
    x = "Age (years)", y = "Stroop interference effect (ms)",
    color = "Group"
  ) +
  theme_minimal()
```

## Report

> ANCOVA compared Stroop interference between groups controlling for age. The group effect was significant after adjustment, F(2,96)=5.32, p=.006, η²p=.10. Adjusted means: Group A=65ms, Group B=78ms, Group C=52ms.

## Alternative method

- No covariates or covariates do not meet the assumptions → One-way ANOVA
- Multiple DV → Multivariate Analysis of Covariance (MANCOVA)
- Covariates and DV nonlinearity → Hierarchical Regression
- The initial difference between groups is large and cannot be corrected by covariates → Propensity Score Matching
- Repeated Measures Design → Repeated Measures ANCOVA
