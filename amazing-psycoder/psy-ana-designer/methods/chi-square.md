# Chi-square Test (Chi-square Test)

## Overview

Chi-square test is used to analyze the relationship between categorical variables.

**Typical scenario**: Whether there is a difference in the distribution of Go/No-go error types (false negatives/false positives) under the two conditions; whether the gender distribution of subjects in different experimental conditions is balanced.

## When to use

| Conditions | Requirements |
|------|------|
| Variable type | Two categorical variables (nominal or ordinal) |
| Observation independence | Each observation is independent of each other (non-paired/non-repeated measurements) |
| Sparse cells | Check expected frequency distribution and table dimensions; choose asymptotic, exact, permutation/Monte Carlo or modeled methods by design without automatic switching of "any cell <5" |
| Sample/Design | Determined by cell probabilities, table dimensions, and target power; Yates/Fisher is not mechanically triggered by total sample size |
| Paired design | If it is paired/repeated measures dichotomous data, use McNemar test |

## Variations

| Test | When to use |
|------|--------|
| Goodness of fit | Single categorical variable, test whether the distribution is in line with expectations |
| Independence | Whether two categorical variables are independent |
| McNemar | Paired two-category (same subject pre- and post-test) |

## Effect size

| Indicator | Applicable |
|------|------|
| Cramér's V | Chi-square independence test; combines table dimensions, fields and uncertainty interpretation, does not apply universal small/medium/large thresholds |
| Phi (φ) | 2×2 table |

## R code

```r
# Load necessary packages
library(effectsize)   # is used to calculate Cramér's V equivalent effect size
library(tidyverse)    # Data processing

# ============================================
# Example: Chi-square test of independence
# Research question: Are there differences in subjects' answer types (correct/wrong) under different experimental conditions (A/B)?
# ============================================

# Create contingency table
observed <- matrix(c(45, 15, 30, 28), nrow = 2, byrow = TRUE)
rownames(observed) <- c("Condition A", "Condition B")
colnames(observed) <- c("Correct", "Error")
print("Contingency table:")
print(observed)

# Perform Chi-Square Independence Test
chisq_result <- chisq.test(observed)
print(chisq_result)

# Check expected frequencies (verify whether Fisher's exact test is required)
print("Expected frequency:")
print(chisq_result$expected)

# Calculate effect size Cramér's V
v_result <- cramers_v(observed)
print(paste("Cramér's V =", round(v_result$Cramers_v, 3)))

# Calculate standardized residuals (explore sources of differences)
print("Standardized residuals:")
print(chisq_result$stdres)

# ============================================
# Alternative: If expected frequency < 5, use Fisher's exact test
# ============================================
fisher_result <- fisher.test(observed)
print("Fisher's exact test results:")
print(fisher_result)

# ============================================
# Goodness of fit test example
# Research question: Does the distribution of subjects among the four choices conform to a uniform distribution?
# ============================================
choices <- c(A = 35, B = 28, C = 42, D = 20)
chisq_gof <- chisq.test(choices, p = rep(1/4, 4))
print("Goodness of fit test:")
print(chisq_gof)

# Goodness of fit effect size Cohen's w
w_result <- cohens_w(choices, p = rep(1/4, 4))
print(paste("Cohen's w =", round(w_result$Cohens_w, 3)))
```

## Report

### APA 7th Report Format

> A chi-square test of independence showed a significant association between experimental condition and response type, χ²(1, N = 118) = 4.16, p = .041, Cramér's V = .19. Condition A had a higher accuracy rate (75.0%) than condition B (51.7%).

**Chinese example:**

> A chi-square independence test was conducted on the correct answer rates of subjects under different experimental conditions. The results showed that there was a significant correlation between conditions and answer types (χ²(1, N = 118) = 4.16, p = .041, Cramér's V = 0.19), indicating that the correct rate of condition A (75.0%) was significantly higher than that of condition B (51.7%).

### List of report elements

- Test name (Chi-square test of independence/Goodness of fit test/McNemar test)
- Degrees of freedom (df) vs. sample size (N)
- χ² value, p value (accurate to 2-3 decimal places)
- Effect size and its confidence interval (Cramér's V or φ, or Cohen's w for goodness of fit)
- Descriptive statistics (frequency/percentage of each cell, or standardized residuals)
- If significant, explain the source of the difference through the direction of the residual

## Notes

- Efficient inference based on overall distribution of expected frequencies, table dimensions and design choices; Fisher, Monte Carlo/permutation or model methods each have their own scope of application
- Chi-square is almost always significant with large samples - more attention should be paid to effect size
- Chi-square only tests "whether it is independent" and does not test "direction of difference"

## Alternative method

- Fisher's exact test - used when expected frequency < 5 or small samples
- McNemar's test - comparison of paired binary data
- Cochran's Q test — binary comparison of multiple related samples
- Log-linear model – complex correlation analysis of multiple categorical variables
- Logistic Regression — a model that predicts a binary dependent variable
