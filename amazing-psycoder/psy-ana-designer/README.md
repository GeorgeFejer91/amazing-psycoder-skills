# psy-ana-designer

> v1.4.0 | Design analysis from scientific questions, estimand, data generation process and observation level; output `analysis_config.yaml` v1.2 after confirming language/accurate version/dependency strategy, without generating code.

## Evidence-driven workflow

| Phase | Product | Gate |
|------|------|------|
| 1. Question | confirmatory/exploratory role, primary/secondary, estimand | The main proposition and operationalization are clear; not every record field forces a question |
| 2. Data | Actual schema, ID/project/session, observation hierarchy, missingness and sampling structure | Dependency structure and variable types verifiable |
| 3. Method | selected method, formula, diagnosis, real feasible alternative | The method answers estimand and represents the hierarchy; the user can only choose among feasible alternatives |
| 4. Details | Exclusion/missing/transformation provenance, multiplicity, estimates/intervals, graphs, sensitivity | No universal RT/missing/normality thresholds; rules are grounded and prestated |
| 5. Review | Complete Decision Registry + saved config path | `validate_analysis.py` zero errors, user will confirm and hand it over to Coder |

## Method selection principles

- Determine the target quantity and observation unit first, then select likelihood/link, fixed effects, random/correlated structure; do not work backward from the "most familiar test".
- Trial/event-level duplicate data must represent subject, item, session, etc. correlations. Ordinary independent observations logit is not a random effects GLMM; GEE, GLMM, Bayesian hierarchical model, or informed aggregation answers different estimands.
- Binary, counting, ordinal, proportional, and survival outcomes are modeled by their support sets and generation processes. Beta regression is typically used on the continuous open interval `(0,1)`, not on arbitrary accuracy tables.
- SSRT is designed as a stop-signal task consensus process and saves necessary inputs; it is not a normal Cox/log-rank survival problem.
- Confirmatory analysis cannot be used as a preliminary plan after retrying the threshold/model with the focus outcome. Necessary data-driven selections should be marked exploratory, use blinded/pilot data, or predefined decision/sensitivity rules.
- Only conduct a complete comparison when more than two methods are truly feasible and the choice will affect the conclusion; do not create a companion Candidate A/B.
- seed only constrains the actual random steps, and also records packet, hardware/parallelism, and sampling settings; seed does not guarantee identical values ​​across environments.

## Reference resource routing

`methods/` and `plots/` are candidate cards, not automatic prescriptions, and do not override [SKILL.md](SKILL.md), config schema, platform implementation limitations, or Reviewer conclusions. Code/experience thresholds in the method card must be reviewed against the current problem, software version, and domain.

| Need | Start here |
|------|------------|
| Continuous repeated data | [linear mixed model](methods/linear-mixed-model.md), [crossed random effects](methods/crossed-random-effects.md), [GEE](methods/gee.md) |
| Binary/count/ordered | [logistic mixed model](methods/logistic-mixed-model.md), [Poisson/NB](methods/poisson-regression.md), [ordinal logistic](methods/ordinal-logistic.md) |
| RT distribution/mechanism | [Gamma mixed](methods/gamma-mixed-model.md), [ex-Gaussian](methods/exgaussian.md), [DDM](methods/drift-diffusion.md) |
| Measurement/Longitudinal/Prediction | [reliability](methods/reliability.md), [growth curve](methods/growth-curve.md), [cross-validation](methods/cross-validation.md) |
| Missing/Robustness | [multiple imputation](methods/multiple-imputation.md), [robust methods](methods/robust-methods.md), [bootstrap](methods/bootstrap.md) |
| Charts | Select `plots/` with target estimates and data levels; show individual/item structure and uncertainty, avoid just drawing mean histograms |

For complete rules, see [SKILL.md](SKILL.md) and [config schema](references/config-schema.md).
