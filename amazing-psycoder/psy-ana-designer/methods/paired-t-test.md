# Paired Samples t-test

## Overview

The paired t test is used to compare the mean differences between the same group of subjects under two conditions. It is the most commonly used statistical method in psychological experiments.

**Typical scenario**: Stroop consistent vs inconsistent RT, comparison of scores before and after intervention.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Within-subjects (within-subjects) |
| Condition number | Exactly 2 |
| DV | Continuous variable (RT/score/rating) |
| Data requirements | Differences are approximately normal |

## Hypothesis and test

1. **Difference normality**: The difference between the two conditions obeys a normal distribution. Note that the original data is not normal, but the difference is normal.
2. **No extreme outliers**: Extreme differences can seriously distort t values and effect sizes

R: `shapiro.test(diff)`  Python: `scipy.stats.shapiro(diff)`

**When violated**: Mild non-normality→t-test is robust to n>30; Severe non-normality→Wilcoxon signed-rank test.

## Effect size: Cohen's d_z

| size | d_z |
|------|-----|
| small | 0.2 |
| Medium | 0.5 |
| Large | 0.8 |

d_z = mean difference / SD of difference. d_z is recommended over d_av in paired designs—d_z reflects within-subjects effect consistency and is usually greater than d_av. Stroop typical d_z≈0.4-0.6.

R: `effectsize::repeated_measures_d(dv ~ cond \| subject, data)`
Python: `pingouin.compute_effsize(x, y, paired=True, eftype='cohen')`

## Sample size reference (80% power)

| d_z | Required subjects |
|-----|---------|
| 0.2 | ~200 |
| 0.5 | ~34 |
| 0.8 | ~15 |

## R code

```r
# Load necessary packages
library(tidyverse)
library(effectsize)
library(ggdist)

# Simulate Stroop experimental data (consistent vs inconsistent)
set.seed(42)
n <- 30
df_wide <- tibble(
  id          = 1:n,
  congruent   = rnorm(n, mean = 450, sd = 80),
  incongruent = rnorm(n, mean = 520, sd = 95)
)

# Convert to long format
df <- df_wide |>
  pivot_longer(-id, names_to = "condition", values_to = "rt") |>
  mutate(condition = factor(condition, levels = c("congruent", "incongruent")))

# 1. Paired t-test
t_res <- t.test(rt ~ condition, data = df, paired = TRUE)
t_res

# 2. Effect size (Cohen's d_z)
d_res <- repeated_measures_d(rt ~ condition | subject_id, data = df)
d_res

# 3. Mean difference + 95% CI
diff_vals <- df_wide$incongruent - df_wide$congruent
ci_diff   <- t.test(diff_vals)$conf.int
sprintf("Mean diff = %.2f, 95%% CI [%.2f, %.2f]",
        mean(diff_vals), ci_diff[1], ci_diff[2])

# 4. Difference normality test
shapiro.test(diff_vals)

# 5. Rain cloud diagram + individual connection diagram
ggplot(df, aes(x = condition, y = rt, fill = condition)) +
  stat_halfeye(adjust = 0.5, width = 0.6, justification = -0.2,
               point_colour = NA) +
  geom_boxplot(width = 0.15, outlier.color = NA, alpha = 0.5) +
  geom_line(aes(group = id), color = "grey60", alpha = 0.4) +
  geom_point(aes(group = id), size = 2, alpha = 0.7) +
  scale_fill_manual(values = c("#56B4E9", "#E69F00")) +
  labs(x = "Condition", y = "Response Time (ms)",
       title = "Paired t-test: Congruent vs Incongruent") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")
```

## APA 7th Report Format

> A paired-samples t-test compared RT in congruent (M=450, SD=80) and incongruent (M=520, SD=95) conditions. Results: t(29)=5.32, p<.001, Cohen's d_z=0.97, 95% CI [0.65,1.29].

## Output
1. t value, df, p value
2. Mean difference + 95%CI
3. Cohen's d_z + 95%CI
4. Difference normality test
5. Rain cloud diagram + individual connection diagram

## Common errors
- ❌ Use independent t-test for intra-subject comparison (losing paired pairs, the power is greatly reduced)
- ❌ Test original normality instead of difference normality
- ❌ report d_av instead of d_z

## Alternative method
- **lmer**: When all trials need to be used and random effects are processed
- **Wilcoxon signed rank**: Difference is not normal
- **BayesFactor**: H0 support needs to be quantified
