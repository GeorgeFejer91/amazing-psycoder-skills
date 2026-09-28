# Multivariate Analysis of Variance (MANOVA)

## Overview

MANOVA tests differences between groups simultaneously on multiple dependent variables. When DVs are correlated, it is more effective than doing multiple ANOVAs separately and controls overall false positives.

**Typical scenario**: Test the comprehensive difference between the anxiety group and the control group in the three DVs of RT, accuracy, and RT variability.

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Between-groups design (one classification IV, multiple continuous DVs) |
| DV | 2+ continuous variables, medium correlation (r ≈ 0.3–0.7); if the correlation is too high (r > 0.8), dimensionality reduction can be considered, and if the correlation is too low (r < 0.2), multiple ANOVAs can also be considered |
| IV | 1 or more categorical variables (single factor or multi-factor) |
| Sample information | Determined by number of groups, outcome correlation structure, covariance estimates, effects, and imbalance; used design simulation/stability diagnostics, not using the "fixed number per DV" rule |
| Assumptions | Multivariate normality (the DV joint distribution of each group is approximately multivariate normal), homogeneity of variance-covariance matrices (Box's M test p > .001), independence of observations, no multivariate outliers |

## vs multiple ANOVA

- Multiple ANOVAs: one per DV → cumulative false positives (3 DVs → ~14% at least one falsely significant)
- MANOVA: One test covers all DV → controls overall false positives
- MANOVA can detect differences that cannot be detected by a single ANOVA (linear mode of DV combination)

## Key output

| Statistics | Recommended scenarios |
|--------|---------|
| Pillai's Trace | The most robust, taking priority when assumptions are violated |
| Wilks' Λ | Most commonly used |

## R code

```r
# Load necessary packages
library(car)        # for MANOVA and Box's M test
library(effectsize) # is used for effect size calculations

# ---- Simulated data ----
# Scenario: Anxiety group vs control group, comprehensive differences in RT, accuracy, and RT variability
set.seed(123)
n_per_group <- 40
group <- factor(rep(c("Anxiety group", "Control group"), each = n_per_group))

RT <- c(rnorm(n_per_group, mean = 520, sd = 80),
        rnorm(n_per_group, mean = 450, sd = 75))

accuracy <- c(rnorm(n_per_group, mean = 0.78, sd = 0.10),
              rnorm(n_per_group, mean = 0.88, sd = 0.08))

RT_variability <- c(rnorm(n_per_group, mean = 120, sd = 30),
                    rnorm(n_per_group, mean = 90, sd = 25))

df <- data.frame(group, RT, accuracy, RT_variability)

# ---- Descriptive Statistics ----
cat("=== Descriptive Statistics ===\\n")
print(aggregate(cbind(RT, accuracy, RT_variability) ~ group, data = df, FUN = mean))

# ---- Hypothesis test: Box's M (homogeneity of variance-covariance matrix) ----
cat("\\n=== Box's M Test ===\\n")
box_m <- boxM(cbind(RT, accuracy, RT_variability) ~ group, data = df)
print(box_m)

# ---- MANOVA ----
dv_matrix <- cbind(df$RT, df$accuracy, df$RT_variability)
manova_fit <- manova(dv_matrix ~ group, data = df)

cat("\n=== MANOVA (Pillai's Trace) ===\n")
print(summary(manova_fit, test = "Pillai"))

cat("\n=== MANOVA (Wilks' Λ) ===\n")
print(summary(manova_fit, test = "Wilks"))

# ---- Effect size (partial η²) ----
cat("\\n=== Effect size ===\\n")
print(eta_squared(manova_fit, partial = TRUE))

# ---- Post hoc univariate ANOVA (Bonferroni correction) ----
cat("\\n=== Post hoc univariate ANOVA ===\\n")
dv_names <- c("RT", "accuracy", "RT_variability")
for (dv in dv_names) {
  cat("\n---", dv, "---\n")
  aov_fit <- aov(as.formula(paste(dv, "~ group")), data = df)
  print(summary(aov_fit))
}
```

## Report Format (APA 7th)

**Methods Section** (brief report):

> A one-way multivariate analysis of variance (MANOVA) was conducted to examine the effect of group (anxiety group vs. control group) on three dependent variables: reaction time (RT), accuracy, and RT variability. Assumptions were checked prior to analysis. Box's M test for homogeneity of variance-covariance matrices was non-significant, *M* = 18.23, *p* = .214, indicating the assumption was tenable. Multivariate normality was assessed via Shapiro-Wilk tests on each DV per group; no severe violations were detected.

**Result part**:

> Using Pillai's Trace, the multivariate effect of group was significant, *V* = 0.45, *F*(3, 76) = 11.23, *p* < .001, partial η² = .31. Follow-up univariate ANOVAs with Bonferroni-adjusted alpha (.05/3 = .017) revealed that the anxiety group had significantly slower RT, *F*(1, 78) = 18.45, *p* < .001, η²_p = .19; lower accuracy, *F*(1, 78) = 22.10, *p* < .001, η²_p = .22; and higher RT variability, *F*(1, 78) = 15.67, *p* < .001, η²_p = .17. Descriptive statistics and full model results are presented in Table X.

**APA 7th Key Points**:
- Reports test statistic name (Pillai's Trace / Wilks' Λ), value, *F* value, hypothesis and error degrees of freedom, *p* value, effect size (partial η²).
- If both Pillai's and Wilks' are reported, the basis for selection needs to be stated (e.g. "Due to unequal sample sizes, Pillai's Trace is reported").
- Post hoc univariate analyzes must indicate the multiple comparison correction method and adjusted alpha level.

## Limitations

- Larger sample required (≥20 per condition per DV)
- Assumptions are more difficult to satisfy than ANOVA
- Univariate ANOVA interpretation is still required after significance - multiple comparison correction is required when reporting

## Alternative method

- One-way ANOVA — used when there is only one DV
- MANCOVA — used when you need to control for covariates
- Discriminant analysis - used when focusing on how combinations of variables differentiate between groups
- Repeated measures ANOVA - used when the same group of subjects has multiple time points
- Linear discriminant analysis (LDA) — preferred for classification purposes
