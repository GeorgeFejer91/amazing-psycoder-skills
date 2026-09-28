# psy-exp-reviewer — Experimental audit and evidence gate

> **Version**: v1.4.0 | **Role**: Audit experimental design, configuration, implementation and operation evidence; do not directly modify the code.

## Core Principles

Reviewer does not treat "looks correct" as "can be collected". Evidence is escalated in the following order:

```text
design_confirmed
  → static_review_passed
  → runtime_or_execution_passed
  → ready_for_collection
```

Static code audits can only uncover visible risks; `ready_for_collection` must also have evidence of live smoke-testing on the target machine, including startup, stimulus presentation, response, data saving, interrupt recovery, and graceful exit. All audits should report input ranges, unvalidated items, and evidence file paths.

## Review mode

| Mode | Minimum Input | Maximum Conclusion |
|------|----------|----------|
| `code-audit` | code + config; if final readiness label is required, smoke-test evidence is required | `not_ready_for_collection` when there is no running evidence; `ready_for_collection` when there is sufficient evidence |
| `config-audit` | Config YAML / trial timeline | `pre_code_ready` |
| `implementation-plan-review` | Pseudocode / Architecture plan | Only architectural risks and pending items |
| `triage-only` | Natural language experiment description | Missing information and design risks |
| `blocked` | No input for review | Specify required input |

## Audit scope

- Design fidelity: windows, conditions, scoring, reaction mappings are consistent with config.
- Timing and response: RT origin, response events, timeout, multi-key and exit logic are clear.
- Randomization: seed scope, parsed seed, scale, constraints and counterbalancing are reproducible.
- Stimulation and runtime environment: Resources, fonts, versions, dependencies and target device policies are clear.
- Data semantics: semantic trial-summary; repeated intra-trial events are written to the associated event table; missing RTs do not use numerical sentinels.
- Persistence and recovery: incremental saving, unique identification, duplicate run protection, interruption testing and resource cleanup.
- Running evidence: actual observation in the declared target environment, rather than inferred by static inspection.

## Platform awareness

`code-audit` loads the corresponding specification according to the implementation:

| Platform signature | Specification |
|----------|------|
| PsychoPy (`from psychopy import`, `visual.Window`) | `../psy-exp-coder/psychopy/spec/README.md` |
| jsPsych (`initJsPsych`, `jsPsych.run`) | `../psy-exp-coder/jspsych/spec/README.md` |
| Psychtoolbox (`PsychImaging`, `Screen('Flip'`) | `../psy-exp-coder/psychtoolbox/spec/README.md` |

## Severity and tags

Severity is graded by actual impact on data validity, participant safety, data loss, and correctness of conclusions, rather than by a fixed number of issues.

| Tags | Evidence Requirements |
|------|----------|
| `ready_for_collection` | Zero Critical/Major, and the target machine smoke test has passed and been reviewed |
| `not_ready_for_collection` | Critical/Major exists, or required running evidence is missing/failed |
| `pre_code_ready` | Complete configuration, only means that you can enter code generation |
| `needs_experiment_info` | Key design information is missing |
| `blocked` | Insufficient input to form corresponding conclusion |

The complete protocol, checklist, and output format can be found in [SKILL.md](SKILL.md).
