# PsychoPy Platform

> **Status**: The generation process is unified with other platforms (same 8-step Config→Code process). 28 paradigm references, 45 demos.

## Generate code process (see mapping/ for platform-specific mapping)

```
config.yaml
    │
    ▼
1. Copy [Canonical Code Skeleton](spec/README.md#19-canonical-code-skeleton)
    │
    ▼
2. Parameter area: fill in the display / timing / font / audio / participant_info of config
    │
    ▼
3. Stimulus preloading: extract {col} from config.windows[].content → create TextBox2/ImageStim
    │
    ▼
4. Trial loop: Press config.windows[] to select the window mode (merge/sequence/timing)
    → For details, see [mapping/README.md §Windows[] → Three window modes](mapping/README.md#windows--trial-Event loop three window modes)
    │
    ▼
5. Response collection: config.windows[].response → PTB keyboard + getKeys(waitRelease=False)
    │
    ▼
6. Correctness judgment: config.response_rules.correct → double judgment (inside the loop + outside the loop)
    │
    ▼
7. Data saving: config.output → ExperimentHandler + TrialHandler + incremental flush
    │
    ▼
8. Run Quality Gate (10 items) → Repair → Deliver
```

Key: For the config field mapping corresponding to each step, see [mapping/README.md](mapping/README.md).

## File structure

```
psychopy/
├── README.md ← This file
├── spec/ ← L1: API specification + Canonical Skeleton
│   └── README.md
├── mapping/ ← L2: Config → PsychoPy code mapping
│   └── README.md
├── paradigms/ ← L3: Paradigm reference (experimental logic, non-API reference)
│ ├── README.md ← Paradigm Index + API Alert
│ └── *.md ← 28 paradigm files (excluding index/README)
└── demo/ ← L4: Pavlovia original export
    └── _raw/ ← 45 .py (v3.1 old API)
```

## Level filling status

| Level | Content |
|------|------|
| L1 `spec/` | Canonical Skeleton + API specification (PTB keyboard, getFutureFlipTime, callOnFlip, Sound, TextBox2, ExperimentHandler, DlgFromDict) + 19 anti-patterns |
| L2 `mapping/` | Three version difference comparison + three window modes + Config→Code complete mapping + 12-step template implementation + Audio/participant information mapping |
| L3 `paradigms/` | 28 paradigms — experimental logic reference. **API mode is based on spec, and the old API in the paradigm code is not used** |
| L4 `demo/` | 45 Pavlovia .py — Reference only to experimental logic |

## Mandatory API rules

All generated PsychoPy code conforms to (full specification in [spec/README.md](spec/README.md)):

| Category | Required | Use prohibited |
|------|---------|---------|
| Timing Keyboard | Explicitly select the `keyboard.Keyboard` backend supported by the target environment and verify | Implicit fallback but claim verified accuracy |
| Key acquisition | Use `kb.getKeys(waitRelease=False)` when continuous refreshing/triggering/exit processing is required | Use blocking wait when the parallel phase work has not been completed |
| RT | `key.rt` returned by the selected backend and record/verify environment | `kb.clock.getTime()` / `time.time()` as key event moment |
| RT starting point | `win.callOnFlip(kb.clock.reset)` | Manual `clock.reset()` before flip |
| Timing | `CountdownTimer` loop + `getFutureFlipTime` | `time.sleep()` / `core.wait()` |
| Audio | Select backend/device by fixed runtime; create sound before looping, use `play(when=)` when supported, target machine measures onset | Claim fixed accuracy based on backend or buffer parameters only |
| Text | `TextBox2` (recommended)/`TextStim` | — |
| Conditional fields | Explicit, schema-validated `trial["field"]` access | `exec()` / `globals()` namespace injection |
| Data saving | `try/finally` + per-trial flush | Save only at the end of the experiment |
| Exit | Escape in keyList + checked every frame | No Escape handling |

## Quick check on paradigm differences

Implementation differences of different paradigms on PsychoPy:

| Normal form | Window mode | Conditional structure | Special logic |
|------|---------|---------|---------|
| Stroop | Single Routine merge | word × color factorial design | `setColor()` dynamic color |
| Go/No-go | Sequential Routine | go × no-go ratio | Double accuracy, correct counter |
| Stop-signal | Timing response loop | SSD staircase | `CountdownTimer`, stop signal inserted in the middle |
| Dot-probe | Sequence Routine | cue position × target position | congruency encoding in condition file |
| N-back | Sequential Routine | Programmed sequence | Ring buffer, lure detection, d-prime |

For detailed window templates and codes, see [mapping/README.md § Paradigm Difference Quick Check] (mapping/README.md# Paradigm Difference Quick Check).
