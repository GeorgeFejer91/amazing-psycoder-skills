# Slope Chart

## Overview

The slope graph uses multiple line segments to connect the values at two points in time. The slope of the line visually displays the direction and magnitude of change. It is more concise than the dumbbell chart and is suitable for showing the changes of a large number of subjects at the same time.

## When to use

| Condition | Description |
|------|------|
| Scenario | Two points in time, multiple individuals/projects |
| Advantages | Quickly identify "who has changed the most" |

## R code

```r
ggplot(data, aes(x=time, y=value, group=subject_id)) +
  geom_line(aes(color=change_direction), alpha=0.6, linewidth=0.8) +
  geom_point(size=2) +
  scale_color_manual(values=c("increase"="red","decrease"="blue","stable"="grey")) +
  labs(title="Individual Changes", x="Time", y="Score") +
  theme_minimal()
```

## Interpretation

- steep rising line = large increase
- Steep descending line = substantial reduction
- flat line = no change
- Color-coded change direction → quickly identify abnormal patterns

## Key parameters

| Parameters | Function |
|------|------|
| `group` | Group by individual |
| `color` | Color by changing direction |
| `alpha` | Transparency (reduced when there are multiple lines) |
