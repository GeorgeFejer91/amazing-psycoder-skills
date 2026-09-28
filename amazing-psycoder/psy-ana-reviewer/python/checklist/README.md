# Reviewer — Python audit checklist

First read the confirmed `analysis_config.yaml`. Static keywords can only assist positioning and cannot replace the review of estimand, hierarchy and model semantics.

## Evidence door

| Inspection | Pass Standard |
|------|----------|
| Config/schema | Script reads config; validates input columns, types, IDs, levels and units |
| Data flow | Exclusion/missing/transformation has sources, reasons, before and after counts and saveable logs |
| Estimand/model | The formula, family/link are consistent with the ending type, target estimand, and clustering structure |
| stochastic steps | only stochastic steps require explicit RNG/seed, and record sampling/parallel settings |
| Diagnostics | Check the actual model for convergence, residuals, overdispersion, impact points, or posterior diagnostics |
| Inference | Main conclusions preserve target estimates and uncertainties; multiplicity is consistent with config |
| Output/Environment | Tables, sample flows, execution logs and package/interpreter versions are saved |

## High risk mode (determined based on context)

- User-specific absolute paths, implicit notebook state, or undocumented manual data editing.
- Duplicate binary data using plain `statsmodels.Logit/GLM` but claiming to implement random effects; should support target-level GLMM, GEE, Bayesian hierarchical models, or informed aggregate analysis.
- Use independent observations `ttest_ind`/OLS for paired, repeated or clustered data.
- Do Shapiro/Levene on all model machinery, or ignore more relevant model diagnostics.
- Only p-value/R² is reported, missing the target estimate and interval specified by config.
- There is no RNG control for stochastic functions; conversely, deterministic `scipy.stats` tests do not require `random_state`.
- `iterrows()`/`apply()` is only graded if it actually causes a performance or semantic error, and does not automatically fail.

## Result Review Additional Items

`result-audit` must see the clean execution log, generated tables, environment information, and warning/convergence status, and check sample flow, estimated direction, units, and report conclusions. Otherwise the highest label is `ready_for_execution`.
