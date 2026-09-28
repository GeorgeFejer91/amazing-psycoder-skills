# psy-ana-reviewer — analysis audit layer

> **Version**: v1.4.0 | Audit analysis design, script, or executed results; do not directly modify the code.

## Review mode and evidence limit

| Mode | Minimum Input | Maximum Tags |
|------|----------|---------|
| `plan-review` | `analysis_config.yaml` | `analysis_plan_ready` |
| `analysis-audit` | config + full script + data schema | `ready_for_execution` |
| `result-audit` | The above materials + clean execution log + generated tables/graphs + environment information | `ready_for_publication` |
| `triage-only` | Research question/bug description | Missing information and risk list |
| `blocked` | Unable to determine range or missing key input | `blocked` |

A static review pass only indicates that the script can enter execution verification, but does not prove that the results are correct or publishable. `ready_for_publication` must have evidence of successful execution and review of results.

## Core Audit

- The research question, estimate, and observation hierarchy are consistent with the model formulation; repeated measures, item, and session dependencies are not ignored.
- Variable type matches likelihood/link function; repeated binary data cannot mark plain `statsmodels.Logit()` as GLMM.
- Excluded, missing, transformed, and derived variables have source, justification, counting, and sensitivity strategies.
- Diagnostics are specific to actual models; there is no mechanical requirement for Shapiro tests on all models.
- Each substantive conclusion is supported by a target effect estimate with uncertainty, rather than just reporting a p-value or R².
- Random seeds are only required if a random process exists; package/runtime environment and input and output manifests are always logged.
- Result review checks execution logs, sample flow, chart values, warnings/convergences, directions and units.

## Severity

| Level | Judgment basis |
|------|----------|
| **Critical** | Will change the main conclusion, use wrong data/model, or the results cannot be traced |
| **Major** | May materially affect estimates/uncertainty/reproducibility and must be resolved before publication |
| **Minor** | Clarity, maintainability, or documentation issues that do not change the substantive conclusions |

## Minimum output

The report must include: review mode, review scope, evidence status, readiness label, findings grouped by severity with documentation/stable targeting, each remediation path, and items that remain unverified.

For the complete workflow, please see [SKILL.md](SKILL.md); for the platform list, please see [R checklist](r/checklist/README.md) and [Python checklist](python/checklist/README.md).
