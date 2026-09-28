# jsPsych (JavaScript)

> **Status**: The current build target is the fixed version of jsPsych 8.x in config. Most of L3's 26 files come from PsychoJS/jsPsych 6/lab.js, which can only extract paradigm logic and cannot copy the API or claim to be runnable as-is.

## Code generation process (unified with PsychoPy, see mapping/ for platform-specific mapping)

```
config.yaml
    │
    ▼
1. Confirm that `runtime.framework_version` is compatible with the core/plugin fixed version, copy [Canonical Code Skeleton](spec/README.md#8-canonical-code-skeleton)
    │
    ▼
2. Parameter area: fill in the display / font / output of config
    │
    ▼
3. Timeline structure: config.windows[] → nested timeline node array
    → For mapping rules, see [mapping/README.md §Windows[] → Timeline node](mapping/README.md#windows--timeline-node mapping jspsych-7x)
    │
    ▼
4. Condition array: config.blocks[].condition_file → JavaScript array (non-external file)
    → Available with `jsPsych.randomization.factorial()` or precomputed on script load
    │
    ▼
5. Response collection: config.windows[].response → `choices: [keys]` + `response_ends_trial: true`
    │
    ▼
6. Correctness judgment: config.response_rules.correct → `on_finish` callback + `compareKeys()`
    │
    ▼
7. Data saving: config.output → `on_data_update` durable checkpoint + `on_finish` original trial-summary final export; analysis and exclusion are not executed on the collection end
    │
    ▼
8. Run Quality Gate (10 items) → Repair → Deliver
```

Key: For the config field mapping corresponding to each step, see [mapping/README.md](mapping/README.md).

## File structure

```
jspsych/
├── README.md ← This file
├── spec/ ← L1: jsPsych 8.x API specification + Canonical Skeleton
│   └── README.md
├── mapping/ ← L2: Config → jsPsych timeline node mapping
│ └── README.md ← Contains legacy→8.x migration table + PsychoJS comparison
├── paradigms/ ← L3: Paradigm reference (experimental logic, non-API reference)
│ ├── README.md ← Paradigm Index + API Alert
│ └── *.md ← 25 paradigm files
└── demo/ ← L4: Pavlovia original export
    └── _raw/ ← 23 .js
```

## Level filling status

| Level | Content |
|------|------|
| L1 `spec/` | jsPsych 8.x pinned Canonical Skeleton + API contract |
| L2 `mapping/` | jsPsych 8.x Config→Code mapping; legacy/PsychoJS is only for migration control |
| L3 `paradigms/` | 25 legacy logic sources. Code blocks belong to quarantine, **API can only come from L1-L2** |
| L4 `demo/` | 23 Pavlovia .js — only for reference experimental logic |

## Mandatory API rules

All generated jsPsych code conforms to (full specification in [spec/README.md](spec/README.md)):

| Category | Required | Use prohibited |
|------|---------|---------|
| Initialization | `initJsPsych()` + `jsPsych.run()` | `jsPsych.init()` |
| Plug-in type | class reference: `jsPsychHtmlKeyboardResponse` | string: `'html-keyboard-response'' |
| No keys | `"NO_KEYS"` (string) | `jsPsych.NO_KEYS` |
| Any key | `"ALL_KEYS"` (string) | `jsPsych.ALL_KEYS` |
| Timeline variable | static placeholder: `timelineVariable('x')`; function: `evaluateTimelineVariable('x')` | v7's `timelineVariable('x', true)` |
| Condition array | Precompute all conditions when script is loaded | `timeline_variables` as function (not supported in runtime generation) |
| Preloading | Completed before the first use of the media preload | Plain text also mechanically adds empty preload, or preload after the media is used |
| RT | `data.rt` (automatic recording) | `Date.now()` manual timing |
| Timing | `trial_duration: N` (ms) | `setTimeout`/`setInterval` |
| Data save | `on_data_update` checkpoint + `on_finish` final `localSave` | Only save at the end or only save in memory |
| Correctness | `jsPsych.pluginAPI.compareKeys()` | Manual `==` comparison (not reliable across browsers) |

## Platform-specific key concepts

jsPsych is a **declarative** experimentation framework — core differences from other platforms:

| Concept | jsPsych way | vs PsychoPy/Psychtoolbox |
|------|-------------|--------------------------|
| Experimental structure | Declarative timeline array (nested) | Imperative loop (for/while) |
| Trial definition | Object `{type: PluginClass, stimulus: ..., choices: ...}` | Function/code block |
| Conditional control | `timeline_variables` array (pure data) | External file loading (xlsx/csv) |
| Accuracy judgment | `on_finish` callback modification `data.correct` | Manual `if resp == corrAns` |
| RT recording | Plug-in automatic recording `data.rt` (ms) | Manual clock reset + key.rt |
| Data saving | Every trial checkpoint + at the end `.filter().localSave()` | Only written out at the end |
| Preloading | `jsPsychPreload` plugin (auto-scanning) | Explicitly pre-create all stimulus objects |

## Quick check on paradigm differences

Implementation points of different paradigms on the current pinned jsPsych 8.x target:

| Paradigm | Key plug-in | Conditional structure | Special logic |
|------|---------|---------|---------|
| Stroop | `jsPsychHtmlKeyboardResponse` | word × color factor array | `stimulus: function()` dynamically generate HTML |
| IAT | verified current plugin/custom nodes | 7-block factory function | Collect original block/RT/error; D-score is calculated in the analysis phase |
| Go/No-go | `jsPsychHtmlKeyboardResponse` | go × no-go ratio | `correctness_field` or `compareKeys` |
| Stop-signal | `jsPsychHtmlKeyboardResponse` | SSD staircase | `jsPsychCallFunction` or custom plugin |
| N-back | `jsPsychHtmlKeyboardResponse` | Programmed sequence | Collect target/lure/response status; d-prime is calculated during analysis phase |

For detailed mapping, see [mapping/README.md § Paradigm Architecture Comparison] (mapping/README.md# Paradigm Architecture Comparison).
