# Histogram (Histogram)

## Overview

Histogram counts continuous variables in bins, and uses column height to represent frequency. It is a basic tool for examining univariate distributions.

## When to use

| Condition | Description |
|------|------|
| Scenario | Univariate distribution check |
| DV | Continuous variable |
| Goal | Determine skewness, multi-peaks, and outliers |

## R code

```r
# Basic histogram
ggplot(data, aes(x=rt)) +
  geom_histogram(bins=30, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  labs(title="RT Distribution", x="RT (ms)", y="Count") +
  theme_minimal()

# Add mean line
ggplot(data, aes(x=rt)) +
  geom_histogram(bins=30, fill="#69b3a2", alpha=0.8) +
  geom_vline(aes(xintercept=mean(rt)), color="red", linetype="dashed", linewidth=1) +
  labs(title="RT Distribution with Mean", x="RT (ms)", y="Count") +
  theme_minimal()

# Grouped histogram (faceted)
ggplot(data, aes(x=rt, fill=condition)) +
  geom_histogram(bins=30, alpha=0.7, position="identity") +
  facet_wrap(~condition, ncol=1) +
  scale_fill_brewer(palette="Set2") +
  labs(title="RT by Condition", x="RT (ms)", y="Count") +
  theme_minimal()

# Grouped Histogram (Overlap)
ggplot(data, aes(x=rt, fill=condition)) +
  geom_histogram(bins=30, alpha=0.5, position="identity") +
  scale_fill_brewer(palette="Set2") +
  labs(title="RT Distribution Overlay", x="RT (ms)") +
  theme_minimal()
```

## Key parameters

| Parameters | Function | Suggestions |
|------|------|------|
| `bins` | Number of bins | 30-50 (trial data), too few = lost information, too many = noise |
| `binwidth` | Box width | Replace bins for more precise control |
| `fill` | fill color | viridis/brewer color blind friendly |
| `color` | Border color | White or light gray |
| `alpha` | transparency | 0.5 when overlapping |
| `position` | position | "identity" (overlap)/"dodge" (side by side) |

## Interpretation

- Symmetric bell shape → approximately normal
- Long right tail → Positive skewness (common in RT)
- long left tail → negative skewness
- bimodal → possible mixing of two processes
