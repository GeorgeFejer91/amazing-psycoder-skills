# psy-ana-coder — Analyze code generation layer

> **Version**: v1.4.0 | Generate R/Python scripts from confirmed analysis configs; do not reinvent research questions or statistical methods.

## Input and output

- Input: `analysis_config.yaml` via `scripts/validate_analysis.py` containing confirmed language/exact version/dependency strategy, problem role, estimand, observation hierarchy, selected method, formula, clean/missing strategy and output contract.
- Output: Configuration driven `.R`/`.py`, optional `.Rmd`/`.qmd`/`.ipynb`, results directory and `analysis-run.json` execution manifest.
- Static generation and review of most flags `ready_for_execution`; `ready_for_publication` can only be evaluated after a clean run with result review.

## Generate structure

1. Read config and verify schema, ID, column type, unit and data level.
2. Capture environment; set seed/backend controls only for declared stochastic steps.
3. Import the data and save source-row, missing, excluded, and transformed provenance.
4. Generate descriptive statistics, models, diagnostics, and sensitivity analyzes consistent with the estimand/hierarchy.
5. Save target effect estimates, uncertainties, necessary multiplicity results and graphs.
6. Write execution status, input/config hash, output manifest, warnings, and environment information.

Python's plain `statsmodels.Logit()` is not a random effects GLMM; repeated binary results need to be implemented using the appropriate GLMM/GEE/Bayesian hierarchy as per the confirmed protocol. R and Python do not need to be forced to produce numerically identical implementations, but both must be faithful to the same estimand and evidence contract.

For complete rules, see [SKILL.md](SKILL.md), [R spec](r/spec/README.md), [Python spec](python/spec/README.md) and the corresponding mapping/checklist.
