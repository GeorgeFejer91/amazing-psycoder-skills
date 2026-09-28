# psy-exp-coder — Experimental code generation/modification/debugging layer

> **Version**: v1.4.0 | Generate platform code from a confirmed config, or make scoped modifications/debugs to existing code. Static passing does not mean that it can be collected.

## Three modes

- `generate`: Requires Designer Gate 5, saved config/criteria table, and `validate_experiment.py` with zero errors.
- `modify`: Read existing code and available config, keeping unauthorized design semantics intact.
- `debug`: First locate the reproducible root cause, then make minimal repairs and rerun relevant verifications.

## Generation principle

1. Read the `runtime` of config and fix the framework/core/plugin/dependency version; do not use the undocumented `latest`.
2. Copy the skeleton from the target platform L1 spec and map the config according to L2 mapping.
3. L3 only provides paradigm logic. Pavlovia/PsychoJS/jsPsych 6/old PsychoPy code blocks are considered isolated sources and the API cannot be copied.
4. Only the instruction, practice, window, feedback and event declared by config are generated; the universal trial template is not applied.
5. Generate semantic trial-summary; repeat events within the trial using the associated event table. The acquisition end retains the original fields and does not calculate SSRT, D-score, d-prime, bias score or perform analysis exclusions.
6. A durable checkpoint is formed for each trial, and all completed/aborted/abnormal paths are cleared.
7. Run platform syntax check, `validate_experiment.py --code`, Quality Gate and Reviewer static review.

## Platform entrance

| Platform | Entry | Key Limitations |
|------|------|----------|
| PsychoPy | [psychopy/README.md](psychopy/README.md) | Backend and timing must be verified according to the target version/machine |
| jsPsych | [jspsych/README.md](jspsych/README.md) | Currently targeting jsPsych 8.x with fixed config; PsychoJS is a standalone runtime |
| Psychtoolbox | [psychtoolbox/README.md](psychtoolbox/README.md) | MATLAB/Octave/PTB version, license and target hardware must be confirmed before running |

## Delivery evidence

Deliver code, conditions/stimulus, dependency manifest, README, static verification report, and smoke-test protocol. Zero static errors at most go into target machine testing; `ready_for_collection` can only be given after the Reviewer has reviewed the actual smoke-test evidence.

For the complete workflow, see [SKILL.md](SKILL.md).
