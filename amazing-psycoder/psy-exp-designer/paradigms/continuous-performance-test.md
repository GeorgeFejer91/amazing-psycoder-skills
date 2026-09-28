# Continuous Performance Test (CPT)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/continuous_performance_test) · PsychoJS

## When to Use

User mentions: CPT, continuous performance test, sustained attention, vigilance, sustained attention test, continuous performance test. Measures sustained attention and vigilance over an extended period by requiring participants to respond to frequent go stimuli while withholding responses to infrequent no-go targets.

## Core Logic

This implementation is a go/no-go CPT variant. Participants view a rapid stream of letter stimuli presented one at a time. They must press the spacebar for every letter **except** the target letter 'X'. This inverts the typical CPT structure (where the target is rare and requires a response) — here the target 'X' requires response **inhibition**, making it a measure of both sustained attention and inhibitory control.

**Trial structure**: fixation cross (1000 ms) → letter stimulus (1000 ms) → next trial. The keyboard is monitored during the letter presentation window. Each trial's condition comes from `conditions.xlsx` with columns specifying the letter to display and the correct answer (`corrAns`: 'space' for go trials, 'none' for no-go/X trials).

**Accuracy logic**: Two-path accuracy check. When a key is pressed, the response is compared against `corrAns`. When no key is pressed, the code checks whether `corrAns` is 'none' (correct withholding on X trials). A `correct_counter` accumulates correct trials and is displayed as the final score.

**Trial count and target frequency**: The condition file defines the sequence. The target 'X' typically appears on 20–30% of trials. A trial counter (e.g., "Trial 12 / 120") is shown throughout the experiment to provide participant pacing.

**Key dependent variables**:
- **Omission errors**: Failing to press spacebar on non-X trials (indexes inattention)
- **Commission errors**: Pressing spacebar on X trials (indexes impulsivity / inhibitory failure)
- **Reaction time**: For correct go responses; RT variability over time indexes attentional fluctuation
- **d-prime**: Signal detection measure combining hits and false alarms

## Must Confirm

- **CPT variant**: Go/no-go (this version: respond to all except X), X-CPT (respond only to X), AX-CPT (respond to X only when preceded by A), or Identical Pairs?
- **Stimulus type**: Letters (single uppercase), digits, or shapes?
- **Trial count**: Total number of trials? (needs to be substantial, 100–300+, to tax sustained attention)
- **Stimulus and fixation durations**: 1000 ms each, or custom?
- **Response key**: Spacebar for all go responses, or specific keys?
- **No-go target**: Single letter 'X', or multiple no-go stimuli?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Fixation                 │    │ Letter Stimulus          │
│ Content: + at center     │    │ Content: letter (A-Z)    │
│ Duration: 1000 ms        │    │ Duration: 1000 ms        │
│ Response: none           │    │ Response: spacebar       │
│ Condition: none          │    │ (withhold on X)          │
│ Data: none               │    │ Condition: {letter}      │
└──────────────────────────┘    │ Data: rt, key, acc,      │
                                │   omission/commission     │
                                └──────────────────────────┘
```

## Data Analysis

Key measures: omission errors (misses), commission errors (false alarms), mean RT (and RT variability/SD), signal detection measures (d', criterion). Performance decline across blocks indexes the vigilance decrement. Examine commission errors as a behavioral index of impulsivity/inhibitory control, and omissions/RT variability as indices of inattention. The CPT is widely used in ADHD assessment; elevated commission errors and RT variability are characteristic.

## References

Rosvold, H. E., Mirsky, A. F., Sarason, I., Bransome, E. D., Jr., & Beck, L. H. (1956). A continuous performance test of brain damage. *Journal of Consulting Psychology, 20*(5), 343–350. https://doi.org/10.1037/h0043220

Cohen, J. D., Barch, D. M., Carter, C., & Servan-Schreiber, D. (1999). Context-processing deficits in schizophrenia: Converging evidence from three theoretically motivated cognitive tasks. *Journal of Abnormal Psychology, 108*(1), 120–133. https://doi.org/10.1037/0021-843X.108.1.120

## Do Not Assume

- Do not assume the response rule for CPT is "Press for targets, don't press for non-targets". Standard X-CPT requires the X keystroke for rare targets, but the go/no-go CPT variant requires X suppression for all alphabetic keystrokes. The two rules are completely opposite and you must confirm which one to use before generating code.
- Do not assume RT=NaN on no-go trials is an error. Subjects should have inhibited responses on X trials, so missing RTs are an expected consequence of correct performance and should not be flagged as an anomaly in data cleaning.
- Do not assume conditional files are always randomly generated by code. Some experimental designs require pre-generated pseudo-random sequences to ensure that the target appearance interval and frequency meet the requirements. You should confirm whether it is generated by code or read from an external file.
- Do not assume stimulus types are limited to single uppercase letters. CPT can also use number, shape, or picture stimuli, and the visual characteristics of different stimulus types affect discrimination difficulty and sustained attentional load.
- Do not assume that the fixation point and stimulus presentation time are the same. Although a common default is 1000 ms, the fixation point can be shorter (e.g., 500 ms) to speed up trial pacing, and the stimulus window can be longer (e.g., 1500 ms) to accommodate reaction time requirements.
- Do not assume feedback must exist. Some CPT designs deliberately omit inter-trial feedback to avoid interfering with sustained attention processes, especially since feedback is often not provided during the formal experimental phase.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| letter | str | The letter presented in the current trial (such as `"A"`, `"X"`) |
| corrAns | str | Correct response: `"space"` (requires key press for go trials) or `"none"` (requires suppression for no-go trials) |

## Variants

- **X-CPT (Standard CPT)**: Reacts to the rare target letter X key, but not to other letters. This is the most classic Rosvold et al. (1956) version, with target trials accounting for approximately 20–30%, and primarily measuring sustained attention and vigilance.
- **Go/No-Go CPT**: Reacts to all letter keys except X. Inhibits response. This variation reverses the task from "responding to rare targets" to "responding to frequent go stimuli, inhibiting to rare no-go stimuli", thus measuring both sustained attention and response inhibition abilities. This document describes this variant. See [go-nogo.md](go-nogo.md) for related paradigms.
- **AX-CPT**: The key only reacts when the letter This variant increases contextual processing load and is widely used in the study of cognitive deficits in schizophrenia. For a related paradigm, see context processing tasks.

## Example

#### User request

> "I am going to do a CPT experiment. Capital letters are presented one by one in the center of the screen. Press the space bar when you see any letter, except when you see the letter 500ms, then letters are presented for 800ms, and the response window lasts for 1000ms from the appearance of the letters. Do 10 practice trials first (with feedback), and then do the formal experiment (without feedback).

#### Trial window timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation point │ │ Stimulus presentation │ │ Response window │ │ ITI │
│ Content: + │ │ Content: A-Z (not X/X) │ │ Content: A-Z (not X/X) │ │ Content: Blank │
│ Duration: 500 ms │ │ Duration: 800 ms │ │ Duration: 1000 ms │ │ Duration: 600-1000 ms Random │
│ Response: None │ │ Response: None │ │ Response: space (do not press X) │ │ Response: None │
│ Condition: None │ │ Condition: {letter} │ │ Condition: {corrAns} │ │ Condition: None │
│ Data: None │ │ Data: None │ │ Data: rt, key, acc │ │ Data: None │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

#### Analyzed experimental specifications

| Field | Value |
|------|-----|
| Experiment name | Letter Go/No-Go CPT |
| Platform | jsPsych |
| Task Type | Go/No-Go CPT (press space for all non-X, suppress for X) |
| Stimulus type | Uppercase letters (A-Z) |
| No-go target | X |
| No-go ratio | 20% (30 / 150 trials) |
| Total number of trials | 150 (excluding exercises) |
| Fixation point duration | 500 ms |
| Stimulus presentation duration | 800 ms |
| Response window | 1000 ms (from stimulus onset) |
| ITI | 600-1000 ms random |
| Practice trials | 10 with feedback |
| Formal experiment | 150 trials, no feedback |

#### Missing information

1. Are two or more consecutive X trials allowed? What is the maximum number of consecutive attempts? (Normally no more than 2 consecutive no-gos are allowed)
2. Is the X ratio in the practice phase consistent with the formal phase? (usually consistent, but needs to be confirmed)
3. What is the specific wording of the instruction? Is a rest interval required? (150 trials takes approximately 6-8 minutes, may not require breaks)

#### Key assumptions

- Fixation duration 500 ms is explicitly specified by the user; letter presentation 800 ms + reaction window 1000 ms is explicitly specified by the user
- No feedback in the formal stage (the user clearly stated "No feedback in the formal experiment"), there is feedback in the practice stage
- The condition sequence is randomly generated by the code, the go/no-go ratio is 80:20, and the limit is no more than 2 consecutive no-gos.
- The response key is the space bar, early response (< 100 ms) is marked as invalid

#### Code structure

```
cpt.html (jsPsych plug-in structure)
├── Parameter definition (go_key, no_go_target, ratio, timing)
├── Conditional sequence generation (150 trials, 80:20 go:nogo, limit continuous nogo≤2)
├── Timeline construction:
│ ├── Instructions (html-keyboard-response)
│ ├── Practice phase (10 trials):
│ │ └── Trial cycle:
│ │ ├── fixation point (500 ms, html-keyboard-response disable keys)
│ │ ├── stimulus (800 ms, html-keyboard-response, stimulus_duration: 800, trial_duration: 1800)
│ │ └── Feedback (html-keyboard-response, correct/error/timeout prompt)
│ ├── Official stage prompt (html-keyboard-response)
│ └── Formal stage (150 trials):
│ └── Trial cycle:
│ ├── fixation point (500 ms)
│ ├── stimulus+response (html-keyboard-response, stimulus_duration: 800, trial_duration: 1800)
│ └── ITI (600-1000 ms random)
├── Data saving (jsPsych data → CSV)
└── End page
```

#### Expected data column

| Column | Type | Description |
|--------|------|-------------|
| trial_index | int | Trial number (including exercises) |
| phase | str | `"practice"` or `"test"` |
| stimulus | str | currently rendered letter |
| corrAns | str | Correct response (`"space"` or `"none"`) |
| response | str | The actual key pressed by the subject (`"space"` or `null`) |
| rt | float | Reaction time (ms), null if no-go is properly suppressed |
| acc | int | correctness (1=correct, 0=wrong) |
| commission_error | int | False positive error (for X key=1, otherwise 0) |
| omission_error | int | Omission error (=1 for non-X keys, otherwise 0) |
