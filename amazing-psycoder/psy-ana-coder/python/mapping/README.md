# Python Analysis Platform — Config → Code Mapping

## Field mapping

| Config path | Python code location | Mapping rules |
|------------|---------------|---------|
| `experiment.data_path` + `file_format` + `loader_options` + `multi_file` | format-dispatch loader | Use the path within the project; single/multiple files are loaded by contract and retained source file/row provenance, not fixed to CSV |
| `runtime.language_version` + `dependency_file` | Start access control + environment manifest | Accurately check the Python patch version; the dependency file must exist and correspond to the actual imports |
| `design.ivs[].name` | `groupby("{name}")` | as grouping column |
| `design.dvs[].name` | `agg({name}=('dv','mean'))` | DV column name |
| `design.dvs[].type` | Result distribution verification | continuous/binary/ordinal/count must be consistent with the selected model family |
| `design.observation_level` + `design.clustering` | Dependency structure | Implemented by subject/item/session/site level, no mechanical mapping design_type |
| `questions[].selected_method` | Estimator | Direct implementation; blocks and returns Designer if missing or no reliable implementation in Python |
| `cleaning.rt_lower` / `rt_upper` | reason-coded mask + exclusion log | Execute according to the meaning/boundary operator of config, retain raw row; do not delete silently |
| `cleaning.accuracy_min` | subject-level QC table + reason-coded exclusion | Calculated only under confirmed levels/denominators/rules |
| `cleaning.trial_exclusion` | config-specific rule function | Do not mechanically interpret arbitrary values as SD trimming |
| `cleaning.missing_policy` | policy-specific implementation + diagnostics/sensitivity | Deletion, imputation, likelihood or weighting methods need to be compatible with missing mechanisms, hierarchies and estimands; `IterativeImputer` is not a general replacement for MICE |
| `model.stochastic` + `model.seed` | Environment settings | Set seed only in random steps, and record sampling/parallel configuration |
| `model.contrast` | `"contrast_coding": "{value}"` → patsy | treatment/sum/helmert |
| `model.correction` | claim-family-aware contrast/inference layer | planned/hierarchical/Tukey/Holm/Bonferroni/FDR/none etc. supported by config and estimator |
| `output.save_path` | project-bound output directory | Created after verifying that it does not exceed the project root directory; all results are written to this directory |
| `output.report_format` | Jupyter notebook or Quarto | ipynb/qmd |
| `output.figures` | Conditional branch | raincloud/boxplot/interaction/scatter |
| `output.effect_sizes` | Estimation and uncertainty branch | Output the raw/standardized/probability/OR and other claim-compatible estimates of the config statement; not uniformly mapped to d/η²/R² |

## Formula verification example (not automatic default)

| Design | Fixed Effects | Random Effects |
|------|---------|---------|
| Single factor within subject | `dv ~ condition` | `groups="subject_id", re_formula="~condition"` |
| Single factor between subjects | `dv ~ condition` | — |
| Two factors within subjects | `dv ~ A * B` | `groups="subject_id", re_formula="~A*B"` |
| Mixed design | `dv ~ A * B` | `groups="subject_id"` (within subjects A, between subjects B) |
| With covariates | `dv ~ condition + covariate` | `groups="subject_id", re_formula="~condition"` |

## Chart mapping

| Config `output.figures` value | Python code |
|---------------------------|-----------|
| `raincloud` | `ptitprince.RainCloud()` or violin+stripplot combination |
| `individual` | `sns.lineplot()` + individual line |
| `boxplot` | `sns.boxplot()` + `sns.stripplot()` |
| `interaction` | `sns.pointplot()` + error bars |

## R ↔ Python comparison

| R function | Python equivalent |
|--------|-----------|
| format-dispatch loader | pandas matching reader (`read_csv`/`read_excel`/`read_parquet`/`read_json`) |
| `filter()` | `df[df['col'] > x]` |
| `group_by() %>% summarise()` | `df.groupby().agg()` |
| `mutate()` | `df['new'] = ...` |
| `t.test(paired=TRUE)` | `scipy.stats.ttest_rel()` |
| `t.test(var.equal=FALSE)` | `scipy.stats.ttest_ind(..., equal_var=False)` |
| `aov_ez()` | No universal equivalent; only considered for design/missing/covariance/correction contract compatibility `pingouin.rm_anova()` |
| `lmer()` | `statsmodels.MixedLM()` only if its grouping/variance-component can express the confirmed structure; otherwise use the verified implementation or block |
| `glmer(binomial)` | Bambi Bernoulli multilevel model; or use `BinomialBayesMixedGLM` when the restrictions are clear. Normal `Logit()` has no random effects |
| Model diagnosis | estimator-specific residual/convergence/dispersion/posterior-predictive checks |
| `leveneTest()` | `scipy.stats.levene()` |
| `cohens_d()` | `pingouin.compute_effsize(eftype='cohen')` |
| `eta_squared()` | `pingouin.anova(detailed=True)` |
| `emmeans()` | No universal equivalent; constructs the declared marginal contrast using the selected model's prediction/design matrix and covariance. `pairwise_tukeyhsd()` only applies to its simple independent group scenario |
| `ggplot2` | `seaborn` + `matplotlib` |
| `ggsave()` | `plt.savefig()` |
| `sessionInfo()` | exact `platform.python_version()` check + platform + actual imported-distribution snapshot + declared dependency artifact |

## Model implements access control

Uses the same estimand/hierarchy contract as the R platform, but does not assume API equivalence. If there is no verified implementation in the Python ecosystem, report dependency restrictions and return to Designer to choose a confirmed alternative; it is forbidden to use ordinary `Logit()` to pretend to be GLMM.
