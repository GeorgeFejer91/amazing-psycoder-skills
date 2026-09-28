# Gantt Chart

## Overview

The Gantt chart uses a horizontal bar chart to display the experimental process timeline, and each task/stage uses the bar length to indicate the duration.

## When to use

| Condition | Description |
|------|------|
| Scenario | Show the temporal structure of the experimental design |
| Purpose | Visual aid for Methods section |

## R code

```r
library(ggplot2)
ggplot(data, aes(x=start_time, xend=end_time, y=task, color=phase)) +
  geom_segment(linewidth=6) +
  labs(title="Experiment Timeline", x="Time (minutes)", y="Task") +
  theme_minimal()
```

## Key parameters

| Parameters | Function |
|------|------|
| `x`/`xend` | Task start and end time |
| `y` | Task name |
| `color` | Stage color grouping |
| `linewidth` | Bar width (6-10 is suitable) |

## Interpretation

- Bar length = task duration
- Bar overlap = parallel tasks
-Color Grouping=Experimental Phase

## Notes

Experimental flow chart suitable for the methodology section. The precise time needs to be marked with a numerical value.
