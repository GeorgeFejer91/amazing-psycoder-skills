# Time Series Analysis (ARIMA)

## Overview

ARIMA models analyze univariate time series data and are suitable for dense longitudinal measurements (e.g. daily diaries, EMA ecological momentary assessments, physiological signals).

**Typical scenario**: Trend and periodic analysis of 30-day daily anxiety scores; changes in time series before and after intervention (interrupted time series).

## When to use

| Conditions | Requirements |
|------|------|
| Design type | Intensive longitudinal design (daily diary, EMA, physiological signals) or single-subject experimental design |
| Dependent variable type | Continuous variable, repeated measurements at equally spaced time points |
| Information Requirements | Number of time points, pre- and post-intervention coverage, seasonality, effect shape, autocorrelation, and target accuracy determine discriminability/power; do not use fixed 30 or 12-point thresholds |
| Key diagnostics | Stationarity/differences, residual autocorrelation, structural mutations, seasonality, missingness/intervals, and prediction calibration require a combination of graphs and domain knowledge; a single p-value for ADF/Ljung–Box does not prove model adequacy |

## ARIMA(p,d,q)

| Parameter | Meaning |
|------|------|
| AR(p) | Autoregressive order: the current value is predicted by the previous p values |
| I(d) | Difference order: do d times of difference to make the sequence stationary |
| MA(q) | Moving average order: the current value is predicted by the first q prediction errors |

## R code

```r
library(forecast)
fit <- auto.arima(data$anxiety)
summary(fit)
# Residual diagnosis
checkresiduals(fit)
# Prediction
forecast(fit, h=7)  # Next 7 days
plot(forecast(fit, h=7))
```

## Interrupt Time Series (ITS)

Test whether the sequence changes after a certain intervention time point:

```r
model <- lm(outcome ~ time + intervention + time_after, data=data)
```

## Report

**APA 7th format report example:**

> A 30-day intensive longitudinal design was used to examine daily anxiety ratings (0–100 visual analog scale) before and after a cognitive training intervention introduced at Day 15. An ARIMA(1,0,2) model was selected via automatic model selection (Hyndman & Khandakar, 2008) and confirmed by residual diagnostics (Ljung-Box test, *p* = .41). The model revealed a significant autoregressive component, AR(1) = 0.62, 95% CI [0.38, 0.86], *p* < .001, indicating that anxiety on a given day was positively predicted by the previous day's score. The moving average parameters were MA(1) = −0.34, 95% CI [−0.58, −0.10], *p* = .006, and MA(2) = 0.21, 95% CI [0.03, 0.39], *p* = .02.
>
> An interrupted time-series analysis examined the intervention effect. The intervention was associated with an immediate level reduction of 3.2 points, *b* = −3.20, 95% CI [−5.17, −1.23], *t*(26) = −3.32, *p* = .002, and a sustained downward trend of −0.15 points per day post-intervention, *b* = −0.15, 95% CI [−0.29, −0.01], *t*(26) = −2.18, *p* = .04. The overall model explained 48% of the variance in daily anxiety ratings (adjusted *R*² = .42).
