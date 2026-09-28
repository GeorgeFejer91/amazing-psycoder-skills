# Multiple linear regression (Multiple Regression)

## Overview

Multiple regression uses one or more continuous predictor variables to predict a continuous outcome variable. It is widely used in psychology to analyze the joint influence of multiple factors on behavior.

**Typical scenario**: Use age, years of education, and anxiety scores to predict the Stroop interference effect.

## When to use

| Conditions | Requirements |
|------|------|
| DV | Continuous |
| IV | Continuous or categorical (requires dummy encoding) |
| Goal | Predict/explain the variance of DV |

## Key output

- **R²**: Proportion of variance explained by the model as a whole
- **ΔR²**: Variance increment after adding a certain variable (hierarchical regression)
- **β weight**: standardized regression coefficient (relative importance between comparable variables)
- **b**: Unstandardized coefficient (used for prediction)
- **VIF**: Multicollinearity diagnosis (VIF>5→collinearity problem)

## Hierarchical Regression

Enter the variables step by step and check whether the ΔR² of each step is significant:

Step 1: Control variables (age, gender) → R²=.05
Step 2: Main predictor (anxiety) → ΔR²=.12, p<.001
Step 3: Interaction term → ΔR²=.03, p=.04

## R code

```r
# Multiple linear regression - complete analysis process
library(car)       # vif() collinearity diagnosis
library(lm.beta)   # lm.beta() standardized coefficient

# ---- Simulated data ----
set.seed(123)
n <- 100
data <- data.frame(
  age       = rnorm(n, mean = 35, sd = 10),
  education = sample(8:20, n, replace = TRUE),
  anxiety   = rnorm(n, mean = 50, sd = 10)
)
# Construct DV and add real effects + noise
data$stroop <- 50 + 0.5 * data$age - 1.5 * data$education +
               0.8 * data$anxiety + rnorm(n, 0, 8)

# ---- 1. Descriptive statistics and correlation matrix ----
summary(data)
round(cor(data[, c("age", "education", "anxiety", "stroop")]), 3)

# ---- 2. Multiple regression ----
model <- lm(stroop ~ age + education + anxiety, data = data)
summary(model)

# ---- 3. Standardized regression coefficient (β weight) ----
lm.beta::lm.beta(model)

# ---- 4. Multicollinearity Diagnosis (VIF) ----
car::vif(model)          # VIF < 5 means no serious collinearity

# ---- 5. Effect size: Cohen's f² ----
r2 <- summary(model)$r.squared
f2 <- r2 / (1 - r2)
cat(sprintf("Cohen's f² = %.3f (%s)\n", f2,
    ifelse(f2 < 0.15, "small",
    ifelse(f2 < 0.35, "medium", "large"))))
# f²: 0.02 = small, 0.15 = medium, 0.35 = large

# ---- 6. Hierarchical Regression ----
model_step1 <- lm(stroop ~ age, data = data)
model_step2 <- lm(stroop ~ age + education + anxiety, data = data)

# ΔR² Significance test
anova(model_step1, model_step2)

# Each step R²
cat("Step 1 R²:", round(summary(model_step1)$r.squared, 3), "\n")
cat("Step 2 R²:", round(summary(model_step2)$r.squared, 3), "\n")
cat("ΔR²:",
    round(summary(model_step2)$r.squared - summary(model_step1)$r.squared, 3), "\n")

# ---- 7. Durbin-Watson autocorrelation test ----
car::durbinWatsonTest(model)

# ---- 8. Residual diagnostic chart ----
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))
```

## Report format

> A hierarchical multiple regression predicted Stroop interference. Age and gender were entered at Step 1 (R²=.05), followed by anxiety at Step 2 which significantly improved prediction (ΔR²=.12, p<.001). In the final model, anxiety was the strongest predictor, β=.35, t(96)=3.78, p<.001.

## Assumptions

- Linear relationship (scatter plot check)
- Residual Normal
- Homogeneity of residual variances
- No severe multicollinearity (VIF<5)
- No autocorrelation (Durbin-Watson≈2)

## Alternative method

| Method | Applicable Scenario |
|------|----------|
| Stepwise Regression | When there are many predictor variables and automatic screening is required; pay attention to the risk of overfitting |
| Ridge Regression | Alternative to OLS when severe multicollinearity (VIF > 10) |
| LASSO regression | Simultaneous variable selection and regularization, suitable for high-dimensional data |
| Logistic Regression | Replaces multiple regression when DV is a dichotomous variable |
| Hierarchical Linear Model (HLM) | An alternative to multiple regression when the data has a nested structure (such as students nested within classes) |
| [Moderation Effect Analysis (Moderation)](./moderation.md) | Test the interaction effect between variables |
| [Mediation Analysis (Mediation)](./mediation.md) | Test the indirect path through which the independent variable affects the dependent variable through the mediating variable |
