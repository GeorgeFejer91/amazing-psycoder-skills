# Reliability Analysis

## Overview

Reliability analysis evaluates the consistency/stability of scores across a specific population, purpose, and measurement model. Appropriate reliability evidence should generally be reported when substantive inferences need to be made about scale scores, but the indicator must be fit for purpose and α cannot be regarded as a universal certificate of quality for all measurements.

**Typical scenario**: Internal consistency of the 20-item anxiety scale; consistency between two raters.

## When to use

| Conditions | Requirements |
|------|------|
| Data type | Continuous or ordinal classification (Likert scale) |
| Number of items | Determined by construct coverage, model identification and measurement accuracy; more items does not automatically improve content validity |
| Unidimensionality | Scale should measure a single construct (or use hierarchical α/ω) |
| Sample information | Determined by number of items, response distribution, hierarchy/rater structure, and target interval accuracy; report interval or use simulated assessment |
| Missing values | Strategize by missingness mechanism, level, and estimand; there is no general rule of "more than 5% requires multiple imputation" |
| Reverse scoring | Reverse questions must be reversed first and then analyzed |

## Confidence type

| Type | Indicator | When to use |
|------|------|--------|
| Internal consistency | Cronbach's α / McDonald's ω | Multiple question scale |
| Test-retest reliability | ICC or another stability estimate chosen for the design | Repeated measurements intended to be stable; planned true change must be accounted for |
| Interrater reliability | Cohen's κ / ICC | Multiple ratings |

## Cronbach's α Interpretation

Report estimates, uncertainties, items/populations/purposes, and assumptions for α. Acceptability depends on decision consequences, score use, and construct breadth; the fixed `.7/.8/.9` labels are not universal criteria, and very high α may also reflect item redundancy.

## McDonald's ω vs α

ω is based on a declared factor model that relaxes the tau-equivalence assumption for α when the model is suitable; it is not automatically "more accurate" when the model is misfit. Select α, ω, ICC, generalized reliability, or other measures based on the structure and purpose of the measurement and do not require ceremonial reporting of them all.

## R code

```r
# Example of reliability analysis
library(psych)

# Simulation data: 20-item anxiety scale, N=200, 5-point Likert
set.seed(123)
n_items <- 20
n_obs <- 200

# Generate simulation data with relevant structures
items <- matrix(rnorm(n_obs * n_items), nrow = n_obs)
common <- rnorm(n_obs)
df <- data.frame(lapply(1:n_items, function(i) {
  round(pmin(pmax(1 + 0.5 * common + 0.8 * items[, i], 1), 5))
}))
colnames(df) <- paste0("Q", 1:n_items)

# 1. Cronbach's α
alpha_result <- psych::alpha(df)
cat("Cronbach's α:", round(alpha_result$total$raw_alpha, 3), "\n")

# 2. McDonald's ω (reliability based on single-factor model)
omega_result <- psych::omega(df, nfactors = 1, plot = FALSE)
cat("McDonald's ω (total):", round(omega_result$omega.tot, 3), "\n")

# 3. If you delete α after a question
cat("\\nIf you delete α after a question:\\n")
print(round(alpha_result$alpha.drop[, "raw_alpha"], 3))

# 4. The correction questions are always relevant
cat("\\nCorrection questions related to:\\n")
print(round(alpha_result$item.stats$r.drop, 3))

# 5. Descriptive statistics
cat("\\nDescriptive statistics:\\n")
print(psych::describe(df)[, c("mean", "sd", "skew", "kurtosis")])

# 6. Average inter-item correlation (effect size reference)
cat("\\nAverage inter-item correlation:", round(alpha_result$total$average_r, 3), "\n")
```

## Report Format (APA 7th)

**Template**:

> For [population and intended score use], internal consistency was estimated using [coefficient and measurement model]: [estimate and uncertainty interval]. [Additional coefficients, if justified.] The item structure and missing-data treatment were [details]. Descriptive statistics are presented in Table X.

**Example**:

> In this illustrative dataset, the 20-item Anxiety Scale had Cronbach's α = .87, 95% CI [.84, .90], and model-based ω = .89. Interpret these estimates for the specified population and score use after checking the item structure. Values here are placeholders and must be replaced by computed results.

**Table example**:

Table 1  
*Item-Level Descriptive Statistics and Reliability for the Anxiety Scale*

| Question | M | SD | Total correlation of correction questions | α-if-deleted |
|------|---|---|------------|-------------|
| Q1 | 3.24 | 1.12 | .62 | .86 |
| Q2 | 3.51 | 0.98 | .55 | .86 |
| ... | ... | ... | ... | ... |

## Alternative method

- Confirmatory factor analysis (CFA) - assess the construct validity of the scale and test the hypothesis of unidimensionality
- Exploratory Factor Analysis (EFA) — determine the factor structure before reliability analysis
- Item Analysis - Evaluate the discrimination and difficulty of individual items
- Test-retest reliability → using ICC (intraclass correlation coefficient)
- Interrater reliability → Use Cohen's Kappa or Krippendorff's α
- [Bland-Altman Analysis](bland-altman.md) — Evaluation of the consistency of two measurement methods
