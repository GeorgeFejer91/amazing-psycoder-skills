# Boxplot + Scatter (Boxplot + Jitter)

## Overview

The box plot shows the quartile distribution of the data, and the scatter points are overlaid to show the individual data points. Suitable for between-subjects design or multiple group comparisons.

## When to use

| Condition | Description |
|------|------|
| Design | Inter-subject design or multiple group comparison |
| DV | Continuous variable |
| Number of groups | 2-6 groups (more times divided) |

## Chart elements

| Element | Function |
|------|------|
| Box | IQR (25%-75%), median line |
| whiskers | 1.5×IQR range |
| jitter | data points for each subject |

## R code

```r
ggplot(data, aes(x=group, y=rt, fill=group)) +
  geom_boxplot(alpha=0.5, outlier.shape=NA) +
  geom_jitter(width=0.1, alpha=0.3, size=1) +
  scale_fill_brewer(palette="Set2") +
  labs(title="RT by Group", x="Group", y="RT (ms)") +
  theme_minimal(12) + theme(legend.position="none")
```

## vs Rain Cloud Picture

The rain cloud diagram adds a violin density layer, which is more suitable for within-subjects design. Box lines + scattered points are simple and clear, suitable for subjects or multiple groups.

## Key parameters

| Parameters | Function |
|------|------|
| `width` | Box width (0.3-0.6) |
| `outlier.shape` | NA=hide outliers |
| `notch` | TRUE=median notch comparison |
