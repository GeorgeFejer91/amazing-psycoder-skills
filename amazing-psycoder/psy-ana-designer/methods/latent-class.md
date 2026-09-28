# Latent Class/Profile Analysis (LCA/LPA)

## Overview

LCA/LPA is a model-based clustering method that determines the optimal number of categories through fitting indicators and divides subjects into mutually exclusive potential subgroups. It is a "people-centered" approach.

**Typical scenario**: Discover three subtypes of mental health based on anxiety, depression, and stress scores; discover two models of cognitive control based on Stroop, Flanker, and N-back performance.

## When to use

| Conditions | Requirements |
|------|------|
| Research design type | Person-centered; subjects are divided into mutually exclusive subgroups based on between-subject variables |
| Dependent variable type | LCA: binary or multi-category indicator; LPA: continuous indicator (usually standardized) |
| Sample information | Determined by class separation, minimum class proportion, number/quality of indicators, missingness, and model complexity; evaluated with design simulation/recovery rate, no universal N threshold |
| The number of indicators | must be sufficient to identify and explain the target category; the number, scale and local dependence are determined by the measurement model and do not mechanically apply a fixed range |
| Key assumptions | Local independence/conditional distribution, model identifiability, missing mechanism and category stability given the category; distribution/variance constraints of LPA need to be declared on a model-by-model basis |
| Class determination | Joint comparative information criterion, likelihood ratio/posterior prediction evidence, classification uncertainty, stability, minimum class interpretability and theory; not determined by a single threshold |
| Common pitfalls | Select categories based solely on fitting indicators while ignoring theoretical significance; insufficient sample size leads to false categories; ignoring local independence violations |

## LCA vs LPA

| Method | Indicator | When to use |
|------|------|--------|
| LCA | Classification indicators | Categorical observation variables |
| LPA | Continuous indicator | Continuous observation variable |

## Model selection

| Indicator | Standard |
|------|------|
| BIC | Lower is better |
| aBIC | Lower is better |
| Entropy | Describe classification uncertainty; explain the consequences of misclassification in conjunction with usage, without a universal "good" threshold |
| LMR-LRT | Compares adjacent class models when their implementations and normal conditions apply; p-values are not the only selection rule |
| BLRT | One of the evidences for comparing adjacent models; verifying the random starting point, repeatability and implementation conditions, without presupposing that it is necessarily more accurate |

## R code

```r
library(mclust)  # LPA
model <- Mclust(data[,c("anxiety","depression","stress")])
summary(model)
plot(model, what="BIC")

# or tidyLPA
library(tidyLPA)
data %>% select(anxiety, depression, stress) %>%
  estimate_profiles(1:5) %>% plot_profiles()
```

## Report Format (APA 7th)

**Method part (Method)**

> We conducted latent profile analysis (LPA) using Mplus 8.8 (Muthén & Muthén, 2017) to identify distinct subgroups of participants based on their scores on the Depression Anxiety Stress Scales (DASS-21; Lovibond & Lovibond, 1995). Models with one through six latent profiles were estimated using robust maximum likelihood estimation with 500 random start values. Model fit was evaluated using the Bayesian information criterion (BIC), sample-size adjusted BIC (aBIC), entropy, and the Lo–Mendell–Rubin adjusted likelihood ratio test (LMR-LRT). The final model was selected based on a combination of fit indices, classification quality, and theoretical interpretability of the profiles (Nylund-Gibson & Choi, 2018).

**Results**

> Table 1 presents the fit indices for the one- through six-profile models. The three-profile solution demonstrated the best balance of fit and parsimony: BIC = 4521.34, aBIC = 4480.12, entropy = 0.86, and a significant LMR-LRT (p = .002) indicating that the three-profile model fit significantly better than the two-profile model. Although the four-profile model yielded a slightly lower BIC (4491.20), the LMR-LRT was nonsignificant (p = .21) and one additional profile contained only 5% of the sample, suggesting over-extraction.
>
> Profile 1 ("Low Distress," n = 132, 44.0%) was characterized by low scores across all three subscales (M_anxiety = 3.21, SD = 2.10; M_depression = 2.89, SD = 1.95; M_stress = 4.12, SD = 2.30). Profile 2 ("Moderate Anxiety," n = 96, 32.0%) showed elevated anxiety (M = 12.45, SD = 3.21) with relatively lower depression (M = 5.67, SD = 2.80) and stress (M = 8.90, SD = 3.10). Profile 3 ("High Comorbid," n = 72, 24.0%) exhibited high scores on all three dimensions (M_anxiety = 18.23, SD = 4.10; M_depression = 16.78, SD = 3.85; M_stress = 19.45, SD = 4.20). These indicator summaries describe the fitted profiles; tests on the same indicators are not independent confirmation because those variables defined the profiles. Figure 1 displays standardized profile means together with classification uncertainty.

**Suggested Table**

| Model | BIC | aBIC | Entropy | LMR-LRT p | Minimum category proportion |
|-------|-----|------|---------|-----------|-------------|
| 1-class | 4820.45 | 4805.12 | — | — | — |
| 2-class | 4650.30 | 4620.55 | .82 | .010 | 38% |
| **3-class** | **4521.34** | **4480.12** | **.86** | **.002** | **24%** |
| 4-class | 4491.20 | 4445.80 | .84 | .210 | 5% |
| 5-class | 4475.60 | 4420.15 | .81 | .350 | 4% |

*Note.* Boldface indicates the selected model. BIC = Bayesian information criterion; aBIC = sample-size adjusted BIC; LMR-LRT = Lo–Mendell–Rubin adjusted likelihood ratio test.
