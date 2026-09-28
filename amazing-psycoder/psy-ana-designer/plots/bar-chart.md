# Bar Chart

## Overview

The bar chart uses the column height to represent the mean, and the error bars represent SE/CI. is the most common but also the most controversial graph in psychology papers—hiding individual differences and distribution shapes.

## When to use

| Condition | Description |
|------|------|
| Scenario | Between-subjects design, multi-group mean comparison |
| DV | Continuous (mean + error) |
| ⚠️ | Within-subjects design is not recommended - hide individual changes |

## R code

```r
# First calculate the mean and SE
desc <- data %>% group_by(condition) %>%
  summarise(mean=mean(rt), se=sd(rt)/sqrt(n()), .groups="drop")

ggplot(desc, aes(x=condition, y=mean, fill=condition)) +
  geom_col(width=0.6) +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=0.15) +
  scale_fill_brewer(palette="Set2") +
  labs(title="Mean RT by Condition", x="Condition", y="Mean RT (ms)") +
  theme_minimal() + theme(legend.position="none")
```

## Dispute

- Hide distribution shape (normal and bimodal can have the same mean and SE)
- Hide individual data points
- Bar chart for within-subjects design = information loss
- Recommended alternatives: rain cloud diagram (within subjects), box line + scatter point (between subjects)

## Key parameters

| Parameters | Function |
|------|------|
| `width` | Column width (0.4-0.8) |
| `position` | dodge(side by side)/stack(stack)/fill(proportion) |
| `stat` | identity(given value)/count(automatic count) |
