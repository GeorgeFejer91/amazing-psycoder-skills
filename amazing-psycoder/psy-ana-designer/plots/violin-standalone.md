# Violin Plot

## Overview

Violin plot shows the density shape of the data distribution, rotated kernel density curve = violin shape. It has one more layer of distribution information than the box plot and can reveal multi-peaks and skewness.

## When to use

| Condition | Description |
|------|------|
| Scenario | Multiple group distribution comparison |
| Advantages | Show hidden multi-peaks/skewness in box plots |
| Number of groups | 2-8 groups |

## R code

```r
# Basic violin diagram
ggplot(data, aes(x=condition, y=rt, fill=condition)) +
  geom_violin(trim=FALSE, alpha=0.7) +
  scale_fill_viridis_d() +
  labs(title="RT Distribution by Condition", x="Condition", y="RT (ms)") +
  theme_minimal() +
  theme(legend.position="none")

# Violin+Boxplot
ggplot(data, aes(x=condition, y=rt, fill=condition)) +
  geom_violin(trim=FALSE, alpha=0.7) +
  geom_boxplot(width=0.15, fill="white", outlier.shape=NA) +
  scale_fill_viridis_d() +
  labs(title="Violin + Boxplot", x="Condition") +
  theme_minimal()

# Violin + part line
ggplot(data, aes(x=condition, y=rt, fill=condition)) +
  geom_violin(trim=FALSE, alpha=0.7,
              draw_quantiles=c(0.25, 0.5, 0.75)) +
  scale_fill_brewer(palette="Set2") +
  labs(title="Violin with Quartiles") +
  theme_minimal()

# Mirror fiddle grouped by second variable
ggplot(data, aes(x=condition, y=rt, fill=group)) +
  geom_violin(position=position_dodge(0.8), trim=FALSE, alpha=0.7) +
  scale_fill_brewer(palette="Set2") +
  labs(title="Violin by Condition and Group") +
  theme_minimal()
```

## Key parameters

| Parameters | Function | Suggestions |
|------|------|------|
| `trim` | TRUE=trim the tail to the data range | FALSE to see full density |
| `draw_quantiles` | Draw quantiles inside the violin | c(0.25,0.5,0.75) |
| `adjust` | Density bandwidth multiplier | >1 for smoother, <1 for more detail |
| `scale` | "area"/"count"/"width" | "count" makes violins with different sample sizes different widths |

## Interpretation

- Violin shape is symmetric → approximately normal
- A drum at one end of the violin → skew
- Two bulges → Twin Peaks
- The two violins do not overlap → the difference between the groups is large
