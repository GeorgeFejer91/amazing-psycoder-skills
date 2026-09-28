# Cluster Analysis (Cluster Analysis)

## Overview

Cluster analysis divides subjects into homogeneous subgroups based on multiple variables and is often used to discover behavioral patterns.

**Typical scenario**: Divide subjects into two categories: "efficient" and "cautious" based on RT, accuracy and questionnaire scores; discover different performance subtypes of anxiety.

## When to use

| Conditions | Requirements |
|------|------|
| Design | Subject Room |
| DV | Multiple continuous variables (need to be standardized) |
| Goal | Discover homogeneous subpopulations (exploratory) |
| Sample information | Determined by dimension, distance concentration, cluster separation, minimum cluster, and stability goals; evaluated by resampling/simulation, no universal n/p ratio |
| Data requirements | Standardized variables, missing values handled |

## Method

| Method | Features | R package |
|------|------|-----|
| K-means | Pre-specified k classes | `stats::kmeans()` |
| Hierarchical clustering | No pre-specification required, dendrogram visualization | `stats::hclust()` |
| Latent class analysis (LCA) | Based on the model, providing fitting indicators | `poLCA` |

## How to determine k

| Method | Indicator |
|------|------|
| Elbow method (Elbow) | Inflection point of SS within group |
| Silhouette coefficient (Silhouette) | The closer to 1, the better |
| BIC (LCA) | Lower is better |

## R code

```r
# Complete example of cluster analysis
library(tidyverse)
library(cluster)      # Contour coefficient
library(factoextra)   # Cluster visualization
library(effectsize)   # Effect size (eta-squared)

# ============================================
# 1. Data preparation and standardization
# ============================================
set.seed(123)
df <- read.csv("data.csv")  # replaced with actual data file
vars <- df %>% select(RT, accuracy, anxiety, depression)
vars_scaled <- scale(vars)  # Standardized (mean is 0, standard deviation is 1)

# ============================================
# 2. Determine the optimal number of clusters k
# ============================================
# Elbow method: finding the inflection point of the within-group sum of squares (WSS)
fviz_nbclust(vars_scaled, kmeans, method = "wss") +
  labs(title = "Elbow method to determine optimal k")

# Contour coefficient method: the closer to 1, the better
fviz_nbclust(vars_scaled, kmeans, method = "silhouette") +
  labs(title = "Contour coefficient method to determine optimal k")

# ============================================
# 3. Perform K-means clustering (assume k = 3)
# ============================================
k <- 3
km <- kmeans(vars_scaled, centers = k, nstart = 25)
df$cluster <- factor(km$cluster)

# Visualization of clustering results (PCA dimensionality reduction projection)
fviz_cluster(km, data = vars_scaled,
             ellipse.type = "norm",
             palette = "jco",
             ggtheme = theme_minimal(),
             main = paste0("K-means clustering results (k =", k, ")"))

# ============================================
# 4. Clustering feature description
# ============================================
cluster_profile <- df %>%
  group_by(cluster) %>%
  summarise(
    n = n(),
    across(c(RT, accuracy, anxiety, depression),
           list(M = mean, SD = sd), .names = "{.col}_{.fn}")
  )
print(cluster_profile)

# ============================================
# 5. Clustering quality index: silhouette coefficient
# ============================================
sil <- silhouette(km$cluster, dist(vars_scaled))
cat(sprintf("Average silhouette coefficient: %.3f\\n", mean(sil[, 3])))

# ============================================
# 6. External validity verification: difference test between clusters + effect size
# ============================================
# ANOVA tests whether anxiety scores differ between clusters
anova_res <- aov(anxiety ~ cluster, data = df)
summary(anova_res)

# Effect size: eta-squared (generalized eta-squared is suitable for between-subjects designs)
eta_sq <- eta_squared(anova_res, partial = FALSE)
cat(sprintf("eta-squared = %.3f (%.2f%% CI [%.3f, %.3f])\n",
            eta_sq$Eta2, 95,
            eta_sq$CI_low, eta_sq$CI_high))

# Post hoc multiple comparisons (Tukey HSD)
TukeyHSD(anova_res)

# ============================================
# 7. (Optional) Hierarchical clustering
# ============================================
dist_mat <- dist(vars_scaled, method = "euclidean")
hc <- hclust(dist_mat, method = "ward.D2")
fviz_dend(hc, k = k, rect = TRUE,
          main = "Hierarchical clustering dendrogram (Ward method)")
```

## Report

> K-means clustering (k=3, silhouette=0.42) identified three response patterns: fast-accurate (45%), slow-accurate (32%), and fast-inaccurate (23%). Groups differed on anxiety scores, F(2,97)=8.34, p<.001.

## Notes

- Clustering is an exploratory method - results need to be verified in independent samples
- Variables need to be standardized (otherwise variables with large units dominate clustering)
- Different k and algorithms may give different results - reporting stability

## Alternative method

- Discriminant analysis - used to predict group affiliation when group labels are known
- [Factor Analysis](./factor-analysis.md) — Dimensionality reduction discovers underlying dimensional structures rather than dividing subjects into groups
- Latent profile analysis - modeled clustering of continuous variables, providing fit indicators
- Mixed Effects Model—Handling subgroup differences in hierarchical data structures
