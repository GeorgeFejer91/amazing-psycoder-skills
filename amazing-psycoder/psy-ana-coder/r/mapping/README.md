# R Analysis Platform — Config → Code Mapping

## Field mapping

Each field of the parsed config YAML maps directly to R code:

| Config Path | R Code Location | Mapping Rules |
|------------|-----------|---------|
| `experiment.data_path` + `file_format` + `loader_options` + `multi_file` | Step 3: format-dispatch loader | Path within the project; single/multiple files are loaded by contract and retained source file/row provenance, not fixed to CSV |
| `runtime.language_version` + `dependency_file` | Step 2: Start access control + environment manifest | Accurately check the R patch version; `renv.lock` must exist and be consistent with the actual loaded package |
| `design.ivs[].name` | Step 6: `group_by({name})` | as grouping column |
| `design.ivs[].levels` | Step 6: Describe the number of statistical groupings | Verify the number of unique values in the column |
| `design.dvs[].name` | Step 6: `summarise(mean_{name}=mean({name}))` | DV column name |
| `design.dvs[].type` | Step 8: outcome-family compatibility check | Only used to verify confirmed methods/distributions/links; cannot automatically select models based on type alone |
| `design.observation_level` + `design.clustering` | Step 8: Dependency structure | Implemented by confirmed subject/item/session/site level, not mechanically inferred from within/between tags |
| `questions[].selected_method` | Step 8: Estimator | Must be implemented directly; if missing or incompatible, stop and return to Designer |
| `questions[].model_formula` | Step 8: Formula string | Replace directly to lmer/glmer |
| `cleaning.rt_lower` / `rt_upper` | Step 4: reason-coded mask + exclusion log | Execute according to the level, boundary and basis declared by config; retain the original row and do not delete silently |
| `cleaning.accuracy_min` | Step 4: subject-level QC table + reason-coded exclusion | Calculate only by confirmed denominator, level and rule |
| `cleaning.trial_exclusion` | Step 4: config-specific rule function | Do not mechanically interpret arbitrary values into SD trimming |
| `cleaning.missing_policy` | Step 4: policy-specific implementation + diagnostics/sensitivity | Deletion, imputation, likelihood or weighting methods must match missing mechanism, hierarchy and estimand; not automatic `na.omit()` or `mice()` |
| `model.stochastic` + `model.seed` | Step 2 | Only random step requires `set.seed()`; also log parallel/sampling settings |
| `model.contrast` | Step 2: `options(contrasts=c("{value}", "contr.poly"))` | treatment/sum/helmert |
| `model.correction` | Step 10: claim-family-aware inference | planned/hierarchical/Tukey/Holm/Bonferroni/FDR/none etc. are supported by the declared claim family and estimator |
| `output.save_path` | Step 11: project-bound output directory | Created after verifying that it does not exceed the project root directory; all results are written to this directory |
| `output.report_format` | Step 12: YAML output field | RMarkdown/Quarto |
| `output.figures` | Step 11: Conditional branch | raincloud/boxplot/interaction/scatter |
| `output.effect_sizes` | Step 9: Estimation and uncertainty branch | Output the raw/standardized/probability/OR and other claim-compatible estimates of the config statement; not uniformly mapped to d/η²/R² |

## Model implements access control

```
selected_method + estimand + outcome family + observation hierarchy
  ├── Compatible and R API verified → Implemented by config
  ├── Formula lacks declared subject/item/session dependency → Block
  └── Method is not confirmed/incompatible → Return to psy-ana-designer, do not change model silently
```

## Data aggregation rules

| Analysis | Aggregation Level | Code |
|------|---------|------|
| Paired t-test | Aggregate only if estimand is subject × condition summary and item depends on processed/argument | `group_by(subj, cond) %>% summarise(m=mean(dv))`, and record denominator/missing rules |
| lmer | Try secondary (no aggregation) | Pass in data_rt directly |
| Descriptive Statistics | Conditions | `group_by(cond) %>% summarize(...)` |
| Subject exclusion | Subject | `group_by(subj) %>% summarize(acc=mean(acc))` |

## Formula verification example (not automatic default)

| Design | Fixed Effects | Random Effects |
|------|---------|---------|
| Single factor within subject | `dv ~ condition` | `(1 + condition \| subject)` |
| Single factor between subjects | `dv ~ condition` | — |
| Two factors within subjects | `dv ~ A * B` | `(1 + A*B \| subject)` |
| Mixed design | `dv ~ A * B` | `(1 + A \| subject)` (A within subjects, B between subjects) |
| With covariates | `dv ~ condition + covariate` | `(1 + condition \| subject)` |

## Chart mapping

| Config `output.figures` value | R code |
|---------------------------|--------|
| `raincloud` | `ggrain::geom_rain()` |
| `individual` | `geom_line(aes(group=subj))` + `stat_summary()` |
| `boxplot` | `geom_boxplot()` + `geom_jitter()` |
| `interaction` | `stat_summary(geom="line")` + `stat_summary(geom="errorbar")` |

## Environment and dependency access control

- Generate and save the `renv.lock` declared in the config, locking only the dependencies required for actual loading and execution.
- Accurately compare the R patch version at startup; clean run saves `sessionInfo()`, and Reviewer checks whether it is consistent with the lockfile.
- The selected method must block and return to the Designer when it is not available in the target R version or locked package version, without silently replacing the API or model.
