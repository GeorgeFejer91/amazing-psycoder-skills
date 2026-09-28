# Word Cloud

## Overview

The word cloud uses font size to represent word frequency and quickly displays the most important words in text data.

## When to use

| Condition | Description |
|------|------|
| Scenario | Text data frequency display |
| Purpose | Qualitative summary, imprecise analysis |

## R code

```r
library(wordcloud2)
wordcloud2(data=word_freq, size=0.5, shape="circle",
           color="random-dark", backgroundColor="white")
```

## Key parameters

| Parameters | Function |
|------|------|
| `size` | Font size scaling |
| `shape` | shape(circle/cardioid/diamond) |
| `color` | Color matching (random-dark/random-light) |
| `backgroundColor` | Background color |

## Interpretation

- Large font size = high frequency words
- Center position = more prominent
- Color matching to distinguish parts of speech

## Notes

is not suitable for precise analysis (the human eye is not good at comparing areas). Recommendations are for qualitative presentation only. Chinese needs to be segmented first (jieba package).
