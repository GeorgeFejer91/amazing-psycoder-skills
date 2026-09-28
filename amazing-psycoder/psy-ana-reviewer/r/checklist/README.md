# Reviewer — R audit list

First read the confirmed `analysis_config.yaml`. This list does not substitute grep hits for statistical judgment, nor does it mechanically require that all scripts include seed, Shapiro, Levene, sensitivity analysis, or multiple comparisons.

## Evidence door

| Inspection | Pass Standard |
|------|----------|
| Config/schema | Script reads config; input columns, types, IDs, levels and units are validated |
| Data flow | Each exclusion/deletion/transformation has a source, reason and count before and after; the original data will not be overwritten |
| Estimand/model | Formula, likelihood/link consistent with target estimand, observation hierarchy, repeated measures/item structure |
| Random steps | Check `set.seed()` and sampling/parallel settings only if config declares stochastic |
| Diagnosis | Use residual, convergence, singularity, overdispersion, or impact diagnostics as appropriate for the selected model |
| Inference | Each main conclusion saves target estimates, uncertainties, and necessary multiplicity processing |
| Output/Environment | Write the result table to the declaration path; save config, execution log, `sessionInfo()` and package version |

## High risk mode (determined based on context)

- `setwd()`, user-specific absolute paths, and interactive manual steps lead to non-migration.
- Use independent observation models in repeated/clustered data without aggregating, modeling correlations, or providing a basis for robust covariance.
- Binary/counting/ordinal endings use incompatible Gaussian models.
- View the focal outcome before selecting confirmatory cleaning thresholds, covariates, or models.
- Treat `performance::r2()` as a target effect estimate, or just report p-values.
- Post hoc comparisons with multiple inferences but no pre-stated correction/tiering strategy.
- `save.image()` or workspace implicit state instead of explicit input and output.

## Result Review Additional Items

`result-audit` also needs to check clean run, warning/convergence, sample flow, table and figure values ​​and units, main estimation direction, and whether the report text exceeds the result support range. Without this evidence, the highest possible result is `ready_for_execution`.
