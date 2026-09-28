# Nonparametric Tests

## Overview

Non-parametric tests do not assume data distribution and are used when the data seriously deviates from normality and the transformation is invalid.

## Method comparison

| Parametric methods | Non-parametric substitutions | Hypotheses to test |
|---------|----------|----------|
| Paired t test | Wilcoxon signed rank | Symmetric distribution of differences |
| Independent t test | Mann-Whitney U | The two groups have similar distribution shapes |
| Within-subjects ANOVA | Friedman | Ranking consistency |
| Between-subjects ANOVA | Kruskal-Wallis | The distribution shapes of each group are similar |

## When to use

| Conditions | Requirements |
|------|------|
| Normality test | Shapiro-Wilk p < .001, QQ plot is obviously curved |
| Data is still non-normal after transformation | log, sqrt, Box-Cox transformation still does not satisfy normality |
| Small sample | n < 20 per condition and normal distribution cannot be assumed |
| Extreme outliers | Extreme outliers exist and cannot be excluded from the data |

## Price

- Statistical power is lower than parametric methods (~95% with normal data)
- The size of the effect size cannot be estimated directly (it can only be judged "whether there is a difference")
- Difficult to scale to complex designs (multiple factors, covariates)

## R code

```r
library(rstatix)
library(ggplot2)

# ── Sample data ────────────────────────────────────────
set.seed(42)
df_long <- data.frame(
  id      = rep(1:20, times = 2),
  cond    = rep(c("pre", "post"), each = 20),
  score   = c(rlnorm(20, 3, 0.5), rlnorm(20, 3.2, 0.5))
)

df_indep <- data.frame(
  group = rep(c("control", "treatment"), each = 15),
  value = c(rlnorm(15, 3, 0.6), rlnorm(15, 3.6, 0.6))
)

# ── 1. Paired Wilcoxon Signed Rank Test ──────────────────────
wilcox_res <- wilcox_test(df_long, score ~ cond, paired = TRUE)
wilcox_eff <- df_long %>%
  wilcox_effsize(score ~ cond, paired = TRUE)
wilcox_res
wilcox_eff   # r = Z / sqrt(N)

# ── 2. Mann-Whitney U test (two independent groups) ────────────────
mwu_res <- wilcox_test(df_indep, value ~ group)
mwu_eff <- df_indep %>%
  wilcox_effsize(value ~ group)
mwu_res
mwu_eff

# ── 3. Friedman test (multiple conditions within subjects) ──────────────────
df_fried <- data.frame(
  id    = rep(1:15, times = 3),
  cond  = rep(c("A", "B", "C"), each = 15),
  score = c(rlnorm(15, 3, 0.4), rlnorm(15, 3.5, 0.4), rlnorm(15, 3.9, 0.4))
)
fried_res <- friedman_test(df_fried, score ~ cond | id)
fried_eff <- df_fried %>%
  friedman_effsize(score ~ cond | id)
fried_res
fried_eff     # Kendall's W

# Post hoc pairwise comparison (paired Wilcoxon + Bonferroni correction)
pwc_fried <- df_fried %>%
  pairwise_wilcox_test(score ~ cond, paired = TRUE,
                       p.adjust.method = "bonferroni")
pwc_fried

# ── 4. Kruskal-Wallis test (multiple groups between subjects) ───────────────
df_kw <- data.frame(
  group = rep(c("G1", "G2", "G3"), each = 12),
  value = c(rlnorm(12, 3, 0.5), rlnorm(12, 3.4, 0.5), rlnorm(12, 4, 0.5))
)
kw_res <- kruskal_test(df_kw, value ~ group)
kw_eff <- df_kw %>%
  kruskal_effsize(value ~ group)
kw_res
kw_eff        # eta²[H] (epsilon-squared)

# Post hoc pairwise comparison (Dunn test + Bonferroni)
pwc_kw <- df_kw %>%
  dunn_test(value ~ group, p.adjust.method = "bonferroni")
pwc_kw

# ── Visualization ─────────────────────────────────────────
ggplot(df_kw, aes(x = group, y = value)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.6) +
  labs(title = "Kruskal-Wallis: Comparison of distribution among groups",
       x = "Group", y = "Observed value") +
  theme_minimal()
```

## Report Format (APA 7th)

**Wilcoxon Signed Rank Test Example:**

> A Wilcoxon signed-rank test indicated that post-test scores (Mdn = 28.5) were significantly higher than pre-test scores (Mdn = 19.2), V = 345, p = .003, r = .66.

**Mann-Whitney U test example:**

> A Mann-Whitney U test revealed that the treatment group (Mdn = 45.3, n = 30) scored significantly higher than the control group (Mdn = 32.1, n = 28), U = 287, p = .021, r = .42.

**Friedman test example:**

> A Friedman test showed a significant difference among the three conditions, χ²(2) = 12.34, p = .002, Kendall's W = .41. Post-hoc pairwise Wilcoxon signed-rank tests with Bonferroni correction revealed significant differences between condition A and C (p = .004), but not between A and B (p = .312).

**Kruskal-Wallis test example:**

> A Kruskal-Wallis H test indicated a significant effect of group on performance, H(2) = 11.56, p = .003, ε² = .26. Dunn's post-hoc tests with Bonferroni correction showed that G3 (Mdn = 52.0) scored significantly higher than G1 (Mdn = 31.5, p = .002). No other comparisons reached significance (all p > .05).

## Alternative method

- Robust statistical methods - Use the censored mean or M estimate when your data contain outliers but you don't want to move completely to a rank-order test
- [Bootstrap](bootstrap.md) — Resampling method that does not rely on distribution assumptions and is suitable for confidence interval estimation
- Data transformation - if there is a slight deviation from normality, try log / sqrt / Box-Cox transformation before using parametric methods
- Bayesian method - can accommodate non-normal distributions, directly models the posterior distribution of parameters, and does not make strict assumptions about the data distribution
