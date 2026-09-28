# Significance Annotation

## Overview

Add statistical test results (p value, significance star) to the chart so that the chart comes with statistical conclusions. Commonly used `ggsignif` or `ggpubr` packages.

## When to use

| Condition | Description |
|------|------|
| Scenario | Any chart that needs to be marked with significance |
| Annotation | p-value or asterisk (*), comparison bracket |

## R code

```r
library(ggsignif)
ggplot(data, aes(x=condition, y=rt)) +
  geom_boxplot() +
  geom_signif(comparisons=list(c("congruent","incongruent")),
              map_signif_level=TRUE,  # Automatic asterisk
              test="t.test", test.args=list(paired=TRUE)) +
  labs(title="Stroop Effect") + theme_minimal()

# Manually specify p-value
geom_signif(comparisons=list(c("A","B")),
            annotations="p = .003",
            y_position=550)
```

## Asterisk convention

| p-value | asterisk |
|-----|------|
| < .001 | *** |
| < .01 | ** |
| < .05 | * |
| ≥ .05 | ns |

## Key parameters

| Parameters | Function |
|------|------|
| `comparisons` | List of comparison pairs |
| `map_signif_level` | TRUE=automatic asterisk, FALSE=manual p-value |
| `test` | Test method (t.test/wilcox.test) |
| `y_position` | Y coordinate position of brackets |

## Interpretation

| p-value | asterisk |
|-----|------|
| <.001| *** |
| <.01 | ** |
| <.05 | * |
| ≥.05| ns |

## Notes

When comparing multiple comparisons, pay attention to the position of the brackets to avoid overlapping. Use paired=TRUE for within-subjects designs.
