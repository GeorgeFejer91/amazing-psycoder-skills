# Alluvial/Sankey Plot

## Overview

Alluvial plots show changes in the flow of categorical data between multiple time points or phases. Suitable for category transitions in longitudinal tracking.

## When to use

| Condition | Description |
|------|------|
| Scenario | Vertical classification data (diagnostic changes, stage transitions) |
| Variables | 2-4 classification time points |

## R code

```r
library(ggalluvial)
ggplot(data, aes(axis1=time1, axis2=time2, axis3=time3,
                 y=count)) +
  geom_alluvium(aes(fill=time1), width=0.3) +
  geom_stratum(width=0.3, fill="grey90", color="grey40") +
  geom_text(stat="stratum", aes(label=after_stat(stratum))) +
  scale_x_discrete(limits=c("Time1","Time2","Time3")) +
  labs(title="Diagnostic Category Changes", y="Count") +
  theme_minimal()
```

## Interpretation

- Streaming belt width = number of category conversion people
- Consistent flow band color = most people are in the same category
- Scattered flow = many category transitions
- Narrowband → This conversion occurs in a small number of people

## Key parameters

| Parameters | Function |
|------|------|
| `aes(axis1,axis2,...)` | Categorical variables at each time point |
| `fill` | Flowband color mapping |
| `width` | Width of flow belt and cylinder (0.1-0.4) |
