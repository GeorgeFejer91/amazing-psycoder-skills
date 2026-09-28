# Bland-Altman Analysis

## Overview

Bland-Altman plots are used to evaluate the **consistency** of two measurement methods, not the correlation. This is the standard for method comparison in medicine and psychology.

**Typical scenario**: Compare whether manual RT coding and automatic RT coding are consistent; compare whether the two versions of the Stroop task give equivalent interference effects.

## When to use

Bland-Altman analysis is suitable for evaluating the agreement between two measurement methods. Before use, confirm whether the following conditions are met:

| Conditions | Requirements |
| --- | --- |
| Design type | Method-comparison / agreement study — the same group of subjects receive two measurement methods at the same time |
| Dependent variable type | Continuous variable (such as reaction time, scale score, physiological index) |
| Sample information | Designed based on target agreement limit interval width, repeated measures structure, heteroskedasticity, and clinical tolerance; reporting uncertainty in agreement limits, no universal N threshold |
| Key assumptions | Conventional bias ± 1.96 SD limits require approximately normal, independent differences with roughly constant spread; inspect trends and use a suitable alternative model when these conditions fail |
| Not applicable scenarios | The two methods measure different constructs; the dependent variable is a categorical or hierarchical variable; the new method is a replacement for the gold standard and only the error of the new method is concerned (in this case, the measurement error model should be used) |

## vs related analysis

Correlation coefficient r=0.95≠The two methods are interchangeable. The Bland-Altman diagram directly answers "How big is the difference between the two methods and whether there is systematic bias".

## Indicator

- **Bias**: The mean difference between the two methods (±0=perfect)
- **95% Limits of Agreement**: For approximately normal differences, bias ± 1.96×SD_diff estimates an interval containing about 95% of future differences. Assess uncertainty in the limits and compare them with prespecified acceptable differences before considering interchangeability.

## R code

```r
library(blandr)
blandr.draw(data$method1, data$method2)
blandr.statistics(data$method1, data$method2)
```

## Report

APA 7th format report example:

> In an illustrative method-comparison analysis, the mean difference was 2.3 ms (SD = 5.5), giving conventional 95% limits of agreement of about -8.5 to 13.1 ms. The plot and a suitably specified trend estimate should be inspected for proportional bias; a nonsignificant correlation test alone cannot establish its absence. Compare uncertainty around the limits with the prespecified acceptable margin before claiming interchangeability.

**Report Highlights**:
- Report bias and its standard deviation
- Report upper and lower bounds and confidence intervals for the 95% limits of agreement (95% LoA)
- Check and report proportionality bias (correlation of difference to mean)
- Discuss whether the agreement limit is narrow enough in conjunction with the acceptance criteria in the field
