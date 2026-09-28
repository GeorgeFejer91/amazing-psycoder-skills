# N-Back Paradigm

> **Structure ref**: [spec-template.md](../references/spec-template.md)
> **Standards**: [timing](../references/timing.md) · [data recording](../references/data-recording.md) · [randomization](../references/randomization.md) · [missing info](../references/missing-information.md) · [condition file](../references/condition-file.md)

## When to Use

User mentions: N-back, working memory, working memory, n-back task, 1-back, 2-back, 3-back, letter n-back, spatial n-back.

## Core Logic

Participants view a sequence of stimuli and judge whether the current stimulus matches the one presented N trials ago. Measures working memory updating and maintenance. Typical: ~33% match trials, ~120-200 total trials, blocked by n-level or mixed.

The sequential n-back task requires participants to continuously update and maintain information in working memory. At each step, a new stimulus is presented and the participant must compare it to the stimulus that appeared N positions earlier in the sequence. The n-back level determines working memory load, with levels typically ranging from 2-back to 5-back. The task can be configured so that different n-back levels are selected from a startup dialog. Responses can be made via keyboard press or mouse click / touchscreen tap, making it suitable for both lab-based and online/tablet administration.

Variants:
- **Letter/verbal**: Stimuli are letters or words. Match = same identity.
- **Spatial**: Stimuli appear at locations. Match = same location.
- **Picture/object**: Stimuli are pictures. Match = same image.
- **Dual**: Two modalities simultaneously (e.g., letter + location).

## Must Confirm

Before generating N-back code, confirm ALL of these:

1. **Stimulus type**: letters, spatial locations, pictures, or dual?
2. **N-level(s)**: 1-back, 2-back, 3-back? Blocked by level or mixed?
3. **Match ratio**: what proportion are match trials? (typically 33%)
4. **Response mapping**: one key for match, another for non-match? Or match-only response?
5. **Stimulus set**: which letters/positions/images? How many unique items?
6. **Stimulus duration**: fixed or until response? Typical: 500 ms presentation + 1500-2500 ms response window
7. **Total trial count**: how many trials total and per n-level?
8. **Lure trials**: include near-lures (e.g., match at n±1 position)? These increase difficulty and diagnostic value.
9. **First N trials**: The first N trials cannot form a matching judgment, how to deal with it? (marked as excluded)
10. **ITI/fixation**: Is the fixation point displayed between trials? Time and scope of change?
11. **OS & font**: What operating system is it running on? If using Chinese, confirm the font
12. **Display**: Full screen or window? Stimulus size and screen location?
13. **Instruction text**: Instruction content? How to explain the N-back task to subjects?

## Do Not Assume

- Do not assume letter stimuli — spatial and picture variants are equally common
- Do not assume a single n-level — multi-level designs are standard
- Do not assume 33% match ratio — some designs use 25% or 50%
- Do not assume match/non-match key mapping — some use match-only (press only on match, withhold on non-match)
- Do not assume blocked design — event-related mixed designs exist
- Do not assume lure trials are unnecessary — they are best practice for high n-levels

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| n_level | int | Working memory load (1, 2, 3) |
| stimulus | str | Current stimulus identity |
| match_target | str | Stimulus from N trials ago |
| is_match | int | 1 if match trial, 0 if non-match |
| lure_type | str | `"none"`, `"n-1"`, `"n+1"` |

## Data Output Columns

| Column | Type | Description |
|--------|------|-------------|
| n_level | int | Working memory load (1, 2, 3) |
| stimulus | str | Current stimulus identity |
| target | str | Stimulus N trials ago (match target) |
| trial_type | str | `"match"` or `"nonmatch"` |
| lure_type | str | `"none"`, `"n-1"`, `"n+1"`, or `"other"` (if lures used) |

## Data Analysis

Primary outcome measures for the N-back task:

- **Accuracy (d')**: Compute hit rate (correct match responses) and false alarm rate (incorrect match responses on non-match trials). d' = z(hit rate) - z(false alarm rate). Higher d' indicates better discrimination.
- **Mean RT on correct trials**: Compare RTs across n-back levels (e.g., 1-back vs. 2-back vs. 3-back). Increasing RT with higher n-level reflects increasing working memory load.
- **N-level effect**: Compare accuracy and RT as a function of n-back level. Performance typically declines (lower accuracy, longer RT) as n increases.
- **Lure analysis**: If lure trials are included, compare error rates for n-1 lures, n+1 lures, and non-lure non-match trials. Higher error rates on near-lures indicate less precise memory representations.

## Randomization Checks

- Match trial ratio verified after shuffle (typically 33%)
- If lures used: verify lure distribution across block
- No more than 3 consecutive match trials
- If blocked by n-level: block order counterbalanced across subjects
- Stimulus sequence constrained: each stimulus appears at controlled frequency

## Common Failure Modes

- Incorrect match detection: forgetting that first N trials have no match target
- Not accounting for lure trials in match/non-match ratio
- Poor stimulus timing: stimulus + ISI must allow cognitive updating
- Confusing n-back with simple recognition memory (n-back requires continuous updating, not just old/new judgment)
- Not pre-generating the full stimulus sequence before the block (needed for match target verification)

## References

Gevins, A., & Cutillo, B. (1993). Spatiotemporal dynamics of component processes in human working memory. *Electroencephalography and Clinical Neurophysiology*, *87*(3), 128–143. https://doi.org/10.1016/0013-4694(93)90119-G

Jaeggi, S. M., Buschkuehl, M., Perrig, W. J., & Meier, B. (2010). The concurrent validity of the N-back task as a working memory measure. *Memory*, *18*(4), 394–412. https://doi.org/10.1080/09658211003702171

Kirchner, W. K. (1958). Age differences in short-term retention of rapidly changing information. *Journal of Experimental Psychology*, *55*(4), 352–358. https://doi.org/10.1037/h0043688

Owen, A. M., McMillan, K. M., Laird, A. R., & Bullmore, E. (2005). N-back working memory paradigm: A meta-analysis of normative functional neuroimaging studies. *Human Brain Mapping*, *25*(1), 46–59. https://doi.org/10.1002/hbm.20131

---

## Example

### User Request

> "I want to do a letter N-back experiment, including two levels of 1-back and 2-back. The stimuli are uppercase consonant letters (B, C, D, F, G, H, J, K, L, M, N, P, Q, R, S, T, V, W, X, Z), matching trials accounted for 33%. Each N-back level was followed by 2 formal blocks of 30 trials each, with a response window of 2500 ms. The order of N-back levels was balanced across subjects.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Letter Stimulus          │    │ Feedback                 │    │ ITI                      │
│ Content: + │ │ Content: {stimulus} │ │ Content: True/Wrong │ │ Content: empty │
│ Duration: 500 ms         │    │ Duration: 500 ms         │    │ Duration: 500 ms         │    │ Duration: 1000 ms        │
│ Response: none           │    │ Response: none           │    │ Response: none           │    │ Response: none           │
│ File: none               │    │ File: none (text)        │    │ File: none               │    │ File: none               │
│ Condition: none          │    │ Condition: {stimulus}    │    │ Condition: {correct_resp}│    │ Condition: none          │
│ Data: none               │    │ Data: none               │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
│                               │                         │→  │
│                               │    ┌──────────────────────┐    │
│                               │    │ Window 2b            │    │
│                               │    │ Response             │    │
│                               │    │ Content: {stimulus}  │    │
│                               │    │ Duration: 2500 ms    │    │
│                               │    │ Response: f/j        │    │
│                               │    │ File: none           │    │
│                               │    │ Condition: {trial_type}│   │
│                               │    │ Data: rt, key, acc   │    │
│                               │    └──────────────────────┘    │
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Fixation | + | 500 ms | none | none | none | none |
| Stimulus | Letter {stimulus} | 500 ms | none | none (text) | {stimulus} | none |
| Response | Letter {stimulus} | 2500 ms (deadline) | f=match, j=nonmatch | none | {trial_type} | rt, key, acc |
| Feedback | Correct/Wrong/Too Slow | 500 ms | none | none | {correct_response} | none |
| ITI | empty | 1000 ms | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Letter N-Back Task |
| Platform | PsychoPy |
| Task type | N-back (working memory) |
| N-levels | 1-back, 2-back (blocked) |
| Stimulus set | 20 uppercase consonants |
| Match ratio | 33% match, 67% non-match |
| Stimulus duration | 500 ms |
| Response window | 2500 ms |
| Response mapping | F=match, J=non-match |
| Phases | Instruction → 1-back Practice(20) → 1-back Block1-2(30 each) → 2-back Practice(20) → 2-back Block1-2(30 each) |

### Missing Information

1. ITI not stated → assumed 1000 ms (design assumption)
2. Fixation not stated → assumed 500 ms
3. Feedback in formal blocks? → will ask

### Assumptions

- Blocked design: each n-level in separate blocks with clear transitions
- N-level order counterbalanced across subjects
- Pre-generated stimulus sequence before each block (needed to verify match/non-match labels)
- First N trials in each block cannot be match trials (no target N-back)
- No lure trials (user didn't mention them)
- Feedback in practice only

### Expected Code Architecture

```
n_back_letter.py
├── Parameters (n_levels, stimulus_set, match_ratio, timing)
├── Window setup
├── Pre-generate stimulus sequence per block:
│   ├── Randomly select from 20 consonants
│   ├── Label each trial: match (matches N-back) or non-match
│   ├── First N trials always labeled non-match (no target exists)
│   └── Verify match ratio ≈ 33%
├── Trial loop:
│   ├── Fixation (500 ms)
│   ├── Stimulus (500 ms)
│   ├── Response window (2500 ms, f/j keys)
│   ├── Feedback (practice only, 500 ms)
│   └── ITI (1000 ms)
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

Base columns + n_level, stimulus, target, trial_type, lure_type
