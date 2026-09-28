# Mixed ANOVA (Split-plot)

## Overview

Mixed ANOVA includes both within-subjects factors and between-subjects factors.

**Typical scenario**: 2 (group: ADHD/control group, between subjects) × 2 (condition: consistent/incongruent, within subjects) interaction effect.

## When to use

| Conditions | Requirements |
|------|------|
| Design | At least 1 within-subject IV + 1 between-subject IV |
| DV | Continuous |
| Key | Interaction effect of Group × Condition |

## Key output

- **Main effect between groups**: The overall difference in factors between subjects
- **Within-subjects main effect**: Main effect of condition
- **Interaction**: Group × Condition - This is the core of a mixed design. Do group differences differ across conditions?

## Effect size

η²p. The η²p of the interaction effect is usually more interesting than the main effect.

## R code

```r
# Load required packages
library(afex)
library(emmeans)

# Simulation data
set.seed(123)
n_per_group <- 30
data <- data.frame(
  subject  = factor(1:(n_per_group * 2)),
  group    = factor(rep(c("ADHD", "Control"), each = n_per_group)),
  congruent   = c(rnorm(n_per_group, 500, 80), rnorm(n_per_group, 450, 70)),
  incongruent = c(rnorm(n_per_group, 600, 90), rnorm(n_per_group, 500, 75))
)

# Convert to long format
data_long <- reshape(
  data,
  direction = "long",
  varying   = c("congruent", "incongruent"),
  v.names   = "rt",
  timevar   = "condition",
  times     = c("congruent", "incongruent"),
  idvar     = "subject"
)
data_long$condition <- factor(data_long$condition)

# Mixed ANOVA (afex, default GG corrected + partial η²)
model <- aov_ez(
  id          = "subject",
  dv          = "rt",
  between     = "group",
  within      = "condition",
  data        = data_long,
  anova_table = list(correction = "GG", es = "pes")
)

# Output ANOVA table
print(model)

# Simple effect analysis when the interaction effect is significant
em <- emmeans(model, ~ condition | group)
print(pairs(em))
```

## Report format

> A 2(Group)×2(Condition) mixed ANOVA revealed a significant Group×Condition interaction, F(1,58)=6.45, p=.014, η²p=.10. The ADHD group showed a larger congruency effect (M_diff=85ms) than controls (M_diff=45ms).

## Alternative method

- **lmer**: `dv ~ group*condition + (1+condition|subject)`
