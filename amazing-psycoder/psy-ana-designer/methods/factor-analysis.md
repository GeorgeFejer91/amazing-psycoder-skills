# Factor Analysis

## Overview

Factor analysis is used to reveal the underlying structure behind multiple observed variables and is the core method for scale development and validation.

**Typical scenario**: Perform exploratory factor analysis (EFA) on the 20-item anxiety scale and find 3 factors; use confirmatory factor analysis (CFA) to test the hypothesized factor structure.

## When to use

| Conditions | Requirements |
|------|------|
| Variable type | Choose Pearson, polychoric, or other appropriate correlation/estimator based on measurement scale; Likert points by themselves do not determine continuity assumptions |
| Sample information | Determined by commonality, loadings, number of factors, number of items, distribution, and missingness; prioritize design simulation/model stability over fixed N or N/p rules |
| Variable relationships | Correlation structures should support identifiable common factors while checking for near-singular, local dependence, and outlier items |
| Sampling adequacy | KMO/Bartlett can make descriptive diagnoses, but there is no single threshold that proves the data is "suitable" for factor analysis |
| Factor interpretability | The extracted factors can be named and explained in theory |
| Research purpose-EFA | In the early stages of scale development, the factor structure is unknown and dimensions need to be explored |
| Research purpose-CFA | There are existing theoretical hypotheses or previous factor structures that need to be verified |

## EFA vs CFA

| | EFA | CFA |
|------|-----|-----|
| Purpose | Explore structure | Test hypothesis |
| When to use | Early stage of scale development | When there are theoretical hypotheses |
| Number of factors | Data-driven | Theory-driven |
| R package | `psych::fa()` | `lavaan::cfa()` |

## Key indicators

| Indicator | Standard |
|------|------|
| KMO/Bartlett | Interpreted along with correlation matrix, sample size and item quality; no binary passes |
| Number of factors | Give priority to combining parallel analysis, MAP/information criterion, residuals, stability and theory; Kaiser eigenvalue > 1 is only used as an auxiliary |
| Factor loadings | Report estimates and uncertainty/stability; substantive thresholds are determined by scale purpose and sample |
| CFI/TLI/RMSEA/SRMR | Joint viewing and inspection of local mismatches; fixed cutoff is not a substitute for model comparison and measurement theory |

## R code

```r
# Factor analysis: EFA + CFA
library(psych)      # fa(), KMO(), cortest.bartlett()
library(lavaan)     # cfa()
library(GPArotation) # oblimin rotation

# --- 1. Data preparation ---
# Assume df is a data frame containing scale items, item1-item20
items <- df[, grep("^item", names(df))]

# --- 2. Sampling adequacy inspection ---
KMO(items)$MSA
cortest.bartlett(cor(items), n = nrow(items))

# --- 3. Determine the number of factors ---
# Parallel analysis
fa.parallel(items, fa = "fa", fm = "ml")

# scree plot eigenvalues
eigen_vals <- eigen(cor(items))$values
plot(eigen_vals, type = "b", main = "Scree Plot",
     xlab = "Factor Number", ylab = "Eigenvalue")
abline(h = 1, lty = 2)

# --- 4. Exploratory Factor Analysis (EFA) ---
efa <- fa(items, nfactors = 3, rotate = "oblimin", fm = "ml")
print(efa$loadings, cutoff = 0.4, sort = TRUE)
print(efa$Vaccounted)  # Cumulative variance explained rate

# Common factor variance (communalities)
efa$communality

# Factor score (optional)
factor_scores <- factor.scores(items, efa)$scores
df$F1 <- factor_scores[, 1]
df$F2 <- factor_scores[, 2]
df$F3 <- factor_scores[, 3]

# --- 5. Confirmatory Factor Analysis (CFA) ---
model_3f <- '
  F1 =~ item1 + item2 + item5 + item8  + item12 + item16
  F2 =~ item3 + item6 + item9 + item11 + item14 + item18
  F3 =~ item4 + item7 + item10 + item13 + item15 + item20
'
fit <- cfa(model_3f, data = df, estimator = "MLR")
summary(fit, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

# Effect size: Standardized factor loadings
standardizedSolution(fit)

# Effect size: ω coefficient (composite reliability)
compRelSEM(fit)

# Discriminant validity: HTMT
ave <- semTools::AVE(fit)    # Average variance extraction amount
htmt <- semTools::HTMT(fit)  # heterotrait-monotrait ratio
print(htmt)
```

## Report

### APA 7th Report Format

> A principal axis factor analysis with oblimin rotation was conducted on the 20 anxiety items. The Kaiser-Meyer-Olkin measure verified sampling adequacy (KMO = .87, "meritorious"), and Bartlett's test of sphericity was significant, χ²(190) = 1845.32, *p* < .001. Parallel analysis suggested a three-factor solution, which explained 58.4% of the total variance.
>
> Factor 1 (Somatic Anxiety) comprised 6 items with loadings from .58 to .82, explaining 24.1% of variance. Factor 2 (Cognitive Anxiety) comprised 6 items with loadings from .55 to .79, explaining 18.7% of variance. Factor 3 (Avoidance Behavior) comprised 5 items with loadings from .52 to .75, explaining 15.6% of variance. Three items with cross-loadings below .40 or cross-loading difference < .20 were removed.
>
> A confirmatory factor analysis using the MLR estimator was conducted to test the hypothesized three-factor model. The model demonstrated adequate fit: robust χ²(167) = 245.31, *p* < .001, CFI = .93, TLI = .92, RMSEA = .06 (90% CI [.05, .08]), SRMR = .06. All standardized factor loadings were significant (*p* < .001) and ranged from .51 to .81. Composite reliability (ω) exceeded .80 for all factors (ω₁ = .88, ω₂ = .86, ω₃ = .84). The three-factor model showed superior fit compared to a unidimensional model, Δχ²(3) = 186.42, *p* < .001. HTMT values were below .85 for all factor pairs, supporting discriminant validity.

## Alternative method

- Principal component analysis (PCA) - used for dimensionality reduction only, does not assume latent factors
- [Reliability](./reliability.md) — Cronbach's α and ω coefficients
- Structural Equation Modeling (SEM)—Extended analysis of path relationships with latent variables
- [Cluster Analysis (Cluster Analysis)](./cluster-analysis.md) — Classify people, not variables
- [Multidimensional Scaling (MDS)](./mds.md) — Non-parametric dimensionality reduction visualization
