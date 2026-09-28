# Psychological Network Analysis (Network Analysis)

## Overview

Network analysis models psychological symptoms/behaviors as a network of interconnected nodes rather than as external manifestations of latent variables. Widely used in psychopathology.

**Typical scenario**: Which of the 20 anxiety symptoms are at the center of the network (most influential); how the symptom network changes before and after treatment.

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Mainly cross-sectional design; can also be used for longitudinal data (multi-time point network comparison or time-varying network) |
| Dependent variable type | Continuous variable (symptom score, questionnaire item score, behavior frequency, etc.) |
| Sample requirements | Number of subjects > Number of nodes (number of variables); usually N ≥ 100 to ensure network stability; if the number of nodes is large, it is recommended that N ≥ number of nodes × 3 |
| Key assumptions | Observed variables satisfy multivariate normality (Gaussian graph model); the network is sparse (most partial correlation coefficients are close to 0 and can be regularized by EBICglasso); edges only reflect conditional dependencies rather than causal relationships |

## Core Concept

| Concept | Meaning |
|------|------|
| Node | Observed variables (symptoms/behaviors/questionnaire items) |
| Edge | Partial correlation coefficient (controls all other nodes) |
| Centrality | The importance of a node in the network |
| Sparse | Remove weak edges (EBICglasso / Threshold) |

## Centrality indicator

| Indicator | Meaning |
|------|------|
| Strength | The strength of the connection between this node and other nodes |
| Betweenness | How many shortest paths is this node on (bridge) |
| Closeness | The average distance between this node and other nodes |

## R code

```r
library(qgraph); library(bootnet)
network <- estimateNetwork(data, default="EBICglasso")
plot(network)
# Centrality
centralityPlot(network)
# Bootstrap stability
boot <- bootnet(network, nBoots=1000)
plot(boot, statistics="strength")
```

## Report

### Brief report

> A Gaussian graphical network estimated the anxiety symptom network (EBICglasso). "Worry" showed the highest strength centrality, suggesting it may be a promising intervention target. The network was stable (CS-coefficient=0.44).

### APA 7th Format Complete Report

**Method**

> A Gaussian graphical model was estimated using the graphical LASSO (Least Absolute Shrinkage and Selection Operator) with Extended Bayesian Information Criterion (EBICglasso; tuning parameter γ = 0.5) for model selection (Epskamp & Fried, 2018). The network comprised 20 nodes representing individual anxiety symptoms from the Beck Anxiety Inventory (BAI). Edges represent regularized partial correlations between symptom pairs after conditioning on all other symptoms in the network.

**Results**

> The estimated network is presented in Figure 1. Node strength centrality was calculated as the sum of absolute edge weights connected to each node. Bootstrap stability analysis with 1,000 iterations was conducted using the *bootnet* package (Epskamp et al., 2018) to evaluate the accuracy of edge weights and the stability of centrality indices. The correlation-stability (CS) coefficient for strength centrality was 0.44, exceeding the recommended threshold of 0.25 (indicating adequate stability). The node "Worry" (BAI item 1) exhibited the highest strength centrality (S = 1.24), suggesting it has the strongest direct connections to other symptoms in the network. "Fatigue" (BAI item 13; S = 1.08) and "Restlessness" (BAI item 3; S = 0.97) showed the next highest strength values, indicating these symptoms also occupy central positions in the anxiety symptom network.

## Notes

- The interpretability of centrality depends on the stability of the network (CS-coefficient>0.25)
- Edge ≠ Causality - only conditional dependence
- Be careful when the number of variables > the number of subjects - consider regularization
