# One-way Repeated Measures ANOVA — Within-subjects

## Overview

Within-subject one-way ANOVA is used to compare the mean differences of the same group of subjects under three or more conditions. It is an extension of paired t-test.

**Typical scenario**: RT comparison of three difficulty Stroops, accuracy comparison of four memory loads.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Within subjects, 3+ conditions |
| DV | Continuous variable |
| Assumption | Normal + spherical symmetry |

## Hypothesis and test

1. **Normality**: Each conditional data is approximately normal
2. **Sphericity**: The difference variances of all condition pairs are equal. Mauchly test. p<0.05→violation→Greenhouse-Geisser correction
3. **No extreme outliers**

## Effect size: η²p (partial eta square)

| Size | η²p |
|------|-----|
| small | 0.01 |
| Medium | 0.06 |
| Large | 0.14 |

η²p = Proportion of variance explained by the conditional effect (excluding inter-subject variation).

## Post hoc comparison

After the ANOVA is significant, pairwise comparisons must be made:
- Bonferroni: the most conservative
- Tukey HSD: Applies to all pairs
- FDR: Exploratory Analysis

**Key**: p-values for post hoc comparisons must be corrected for multiple comparisons.

## Alternative method
- **lmer**: Recommended replacement, higher effectiveness, better handling of imbalances
- **Friedman**: Non-normal or serious violation of spherical symmetry
- **GG corrected ANOVA**: spherical symmetry violated but normal

## R code

```r
# Load necessary libraries
library(tidyverse)
library(rstatix)      # Convenient for ANOVA, effect size, and post hoc testing
library(afex)         # Repeated measures ANOVA automatically applying GG/HF correction

# ============================================
# Sample data: reaction time (ms) of 30 subjects under 3 conditions
# ============================================
set.seed(42)
n <- 30
df <- data.frame(
  id       = factor(rep(1:n, 3)),
  cond     = factor(rep(c("easy", "medium", "hard"), each = n)),
  rt       = c(rnorm(n, 400, 50),
               rnorm(n, 480, 55),
               rnorm(n, 580, 65))
)
head(df)

# ============================================
# Descriptive statistics
# ============================================
df %>%
  group_by(cond) %>%
  summarise(M = mean(rt), SD = sd(rt), N = n())

# ============================================
# Repeated measures ANOVA (afex: automatically output GG/HF correction results)
# ============================================
aov_res <- aov_car(rt ~ cond + Error(id/cond), data = df)
summary(aov_res)
nice(aov_res)  # Neat output table

# ============================================
# Spherical Symmetry Test (Mauchly's Test)
# ============================================
aov_ez <- anova_test(data = df, dv = rt, wid = id, within = cond)
aov_ez  # Automatically includes Mauchly test and GG corrected p-value

# ============================================
# Effect size: partial eta-squared
# ============================================
get_anova_table(aov_ez, correction = TRUE)  # Contains η²p

# or manual extraction:
eta_sq <- aov_ez$ANOVA[["ges"]]            # Generalized partial eta square
cat(sprintf("Generalized η² = %.3f\n", eta_sq))

# ============================================
# Post hoc pairwise comparison (Bonferroni correction)
# ============================================
pairwise_t_test(data = df, rt ~ cond, paired = TRUE,
                p.adjust.method = "bonferroni") %>%
  select(-.y.)

# Report Cohen's d as effect size
df %>%
  pairwise_t_test(rt ~ cond, paired = TRUE,
                  p.adjust.method = "bonferroni") %>%
  mutate(cohens_d = statistic / sqrt(n))  # Paired Cohen's d approximation

# ============================================
# Alternative: Manual lm model (for lme4 replacement)
# ============================================
# library(lme4)
# library(lmerTest)
# m_lmer <- lmer(rt ~ cond + (1 | id), data = df)
# anova(m_lmer)
```

## Report format

> A one-way repeated measures ANOVA examined RT across three difficulty levels (easy/medium/hard). Mauchly's test indicated violation of sphericity (p=.02), so Greenhouse-Geisser correction was applied. The main effect was significant, F(1.6, 46.4)=12.34, p<.001, η²p=.30.
