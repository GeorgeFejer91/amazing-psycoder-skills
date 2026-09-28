# Raincloud Plot

## Overview

The rain cloud plot integrates three visualizations: violin plot (density distribution), box plot (quartile + median) and scatter plot (individual data points) to display complete information of the data in one graph.

**Core Concept**: The bar chart hides individual differences and distribution shapes, and the rain cloud chart displays them all.

## When to use

| Condition | Description |
|------|------|
| Design | Comparison between two groups within subjects |
| DV | Continuous variables (RT, scores, etc.) |
| Data requirements | Multiple trials or means per subject per condition |
| Not applicable | Between-subjects design (replaced with box lines + scatter points) |

## Chart elements

| Element | Function |
|------|------|
| Violin | Displays the density shape of the data distribution |
| Boxplot | Display median, quartiles, range |
| Jitter | Display data points for each subject |

## R code

```r
ggplot(data, aes(x=condition, y=rt, fill=condition, color=condition)) +
  ggrain::geom_rain(alpha=0.5, point.size=1) +
  scale_fill_brewer(palette="Set2") +
  labs(title="RT by Condition", x="Condition", y="RT (ms)") +
  theme_minimal(base_size=12)
```

## Python code

```python
# Manual combination: violin + box + strip
sns.violinplot(data=df, x='condition', y='rt', inner=None)
sns.boxplot(data=df, x='condition', y='rt', width=0.15)
sns.stripplot(data=df, x='condition', y='rt', alpha=0.3, size=3)
# or ptitprince.RainCloud()
```

## Output

Save as `fig1_raincloud.png`, 300dpi, 6 inches wide by 5 inches high.

## Key parameters

| Parameters | Function |
|------|------|
| `alpha` | violin/scatter transparency (0.3-0.7) |
| `point.size` | Scatter size |
| `palette` | Color scheme (Set2 recommended) |

## Interpretation

- Violin shape comparison = distribution difference
- box line median distance = effect size
-Scatter dispersion = individual differences

## Notes

Within-subjects design is preferred. The between-subjects design is replaced by box lines + scatter points (the connection logic of the rain cloud diagram does not apply).
