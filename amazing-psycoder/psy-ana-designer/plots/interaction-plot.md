# Interaction Plot

## Overview

The interaction diagram uses grouped polylines to show the interaction effect of two factors, which is the most intuitive way to understand the interaction.

## When to use

| Condition | Description |
|------|------|
| Design | Two-factor design (within/between/mixed) |
| Key | Polylines are not parallel → Interaction exists |

## Chart elements

| Element | Function |
|------|------|
| Grouped polyline | One mean polyline for each level |
| Error bars | SE or CI |
| Color/line style | Differentiate between different levels |

## R code

```r
ggplot(data_agg, aes(x=factorA, y=mean_rt, color=factorB, group=factorB)) +
  stat_summary(fun=mean, geom="line", linewidth=1) +
  stat_summary(fun=mean, geom="point", size=3) +
  stat_summary(fun.data=mean_se, geom="errorbar", width=0.1) +
  labs(title="Interaction Plot", x="Factor A", y="Mean RT (ms)") +
  theme_minimal(12)
```

## Interpretation

- **Parallel lines** → No interaction
- **cross lines** → strong interaction (cross interaction)
- **not parallel but not crossing** → weak interaction (ordinal interaction)
- When the interaction is significant, the main effect needs to be interpreted with caution

## Key parameters

| Parameters | Function |
|------|------|
| `group=factorB` | Group by second factor |
| `fun.data=mean_se` | Error bars use SE |
| `width` | Error bar width (0.1) |
