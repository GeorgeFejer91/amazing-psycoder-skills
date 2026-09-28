# Priming Paradigm

> **Structure ref**: [spec-template.md](../references/spec-template.md)
> **Standards**: [timing](../references/timing.md) · [data recording](../references/data-recording.md) · [randomization](../references/randomization.md) · [missing info](../references/missing-information.md) · [condition file](../references/condition-file.md)

## When to Use

User mentions: Priming, priming, prime-target, masked prime, semantic priming, affective priming.

## Core Logic

A prime stimulus briefly precedes a target. Measures prime influence on target processing. Variants: semantic, affective, masked, response, negative priming.

## Must Confirm

Before generating priming code, confirm ALL of these:

1. **Priming type**: semantic, affective, masked, response, negative?
2. **Prime visibility**: masked (subliminal, ~20–60 ms) or visible (supraliminal)?
3. If masked: forward mask? Backward mask? Mask type?
4. **Prime-target relationship**: congruent/incongruent? Related/unrelated?
5. **SOA**: fixed or varied? What value/range?
6. **Response type**: lexical decision, categorization, evaluation?
7. **Catch trials**: prime visibility checks?
8. **Prime-only condition**: baseline measurement?
9. **ITI duration**: Trial interval and variation range?
10. **OS & font**: What operating system is it running on? If using Chinese stimuli, confirm the font
11. **Display**: Full screen or window? Stimulus size and screen location?
12. **Instruction text**: Instruction content?

## Do Not Assume

- Do not assume forward + backward mask — some omit one or both
- Do not assume one SOA — priming effects vary with SOA
- Do not assume congruent/incongruent labeling — may be related/unrelated
- Do not assume prime duration — masked 20–60 ms, supraliminal 200–500 ms
- Do not assume response is about the target — in response priming, prime carries response info
- Do not assume target is always visible — some designs degrade target visibility

## Timing Precision

Masked priming requires frame-accurate timing:
- Use `win.flip()` for duration control, not `core.wait()`
- Validate with photodiode if prime is intended subliminal
- LCD pixel response time may make 16.7 ms primes partially visible

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| prime | str | Prime stimulus identity |
| target | str | Target stimulus identity |
| prime_type | str | `"related"`, `"unrelated"`, or `"neutral"` |
| soa | int | Stimulus onset asynchrony (ms) |
| mask_present | int | 1 if mask used, 0 if not |

## Data Output Columns

| Column | Type | Description |
|--------|------|-------------|
| prime | str | Prime stimulus identity |
| target | str | Target stimulus identity |
| prime_type | str | `"congruent"`, `"incongruent"`, or `"neutral"` |
| soa | float | Stimulus onset asynchrony (ms) |
| prime_duration | float | Prime presentation duration (ms) |
| mask_type | str | `"forward"`, `"backward"`, `"none"`, or `"both"` |

## Randomization Checks

- Prime-target pairings must be counterbalanced (each target paired with each prime type equally)
- No more than 3 consecutive same-response trials
- Related/unrelated ratio balanced per block
- Verify SOA distribution if SOA is varied

## Common Failure Modes

- Using `core.wait()` for prime duration instead of frame counting
- Not clearing keyboard buffer between prime and target
- Marking all fast RTs as errors (masked priming can produce very fast RTs)

## References

Forster, K. I., & Davis, C. (1984). Repetition priming and frequency attenuation in lexical access. *Journal of Experimental Psychology: Learning, Memory, and Cognition*, *10*(4), 680–698. https://doi.org/10.1037/0278-7393.10.4.680

Meyer, D. E., & Schvaneveldt, R. W. (1971). Facilitation in recognizing pairs of words: Evidence of a dependence between retrieval operations. *Journal of Experimental Psychology*, *90*(2), 227–234. https://doi.org/10.1037/h0031564

Neely, J. H. (1977). Semantic priming and retrieval from lexical memory: Roles of inhibitionless spreading activation and limited-capacity attention. *Journal of Experimental Psychology: General*, *106*(3), 226–254. https://doi.org/10.1037/0096-3445.106.3.226

---

## Example

### User Request

> "I want to do a masked priming experiment. First, a 500 ms pre-masker (#####) is presented, and then a 40 ms priming word (which may be a synonym or an unrelated word of the target word) is presented, and then the target word is immediately presented. The subject's task is to judge whether the target word is a real word or a pseudoword (lexical judgment). Press F for real words and J for pseudowords. The priming words and target words are both Chinese two-character words. SOA is fixed at 60 ms. First 30 exercises, then 3 formal blocks of 60 trials each. "

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │ →  │ Window 5                 │
│ Forward Mask             │    │ Prime                    │    │ Target                   │    │ Feedback                 │    │ ITI                      │
│ Content: ##### │ │ Content: Start word │ │ Content: Target word │ │ Content: Correct/wrong │ │ Content: empty │
│ Duration: 500 ms         │    │ Duration: 40 ms          │    │ Duration: until key      │    │ Duration: 500 ms         │    │ Duration: 1000 ms        │
│ Response: none           │    │ Response: none           │    │ Response: f/j            │    │ Response: none           │    │ Response: none           │
│ File: none               │    │ File: none (text)        │    │ File: none (text)        │    │ File: none               │    │ File: none               │
│ Condition: none          │    │ Condition: {prime}       │    │ Condition: {target}      │    │ Condition: {correct_resp}│    │ Condition: none          │
│ Data: none               │    │ Data: none               │    │ Data: rt, key, acc       │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Forward Mask | ##### | 500 ms | none | none | none | none |
| Prime | Start word | 40 ms (frame-counted) | none | none (text) | {prime} | none |
| Target | target word | until key (deadline 3000 ms) | f=real word, j=fake word | none (text) | {target} | rt, key, acc |
| Feedback | Correct/Error | 500 ms | none | none | {correct_response} | none |
| ITI | empty | 1000 ms | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Masked Semantic Priming (Chinese) |
| Platform | PsychoPy |
| Task type | Masked priming (lexical decision) |
| Forward mask | ##### (500 ms) |
| Prime duration | 40 ms |
| SOA | 60 ms |
| Target duration | Until response, deadline 3000 ms |
| Prime-target relationship | Related (synonyms) vs Unrelated (unrelated words) |
| Response | Lexical decision: F=real word, J=fake word |
| Stimuli | Chinese two-character words |
| Phases | Instruction → Practice(30) → Block1-3(60 each) |

### Missing Information / Questions

1. Backward mask? Not mentioned → assumed none (prime → target directly)
2. Prime visibility check? Not mentioned → will ask: "Do you need to start a word visibility check trial?"
3. Word list: user needs to provide or confirm word pairs
4. Nonword ratio? Not stated → will ask: "What proportion of false word trials are there?"

### Assumptions

- No backward mask (prime → target directly, SOA=60 ms: 40 ms prime + 20 ms gap)
- Frame-accurate timing: prime = 2 frames at 60Hz (~33 ms) or 3 frames (~50 ms)
- Chinese font: PingFang.ttc (macOS)
- ITI: 1000 ms fixed
- No trial-level feedback in formal blocks

### Expected Code Architecture

```
masked_priming.py
├── Parameters (word list path, timing in frames, font config)
├── Window setup
├── Load word list → generate condition table
├── Preload masks and text stims
├── Trial loop:
│   ├── Forward mask (500 ms, frame-counted)
│   ├── Prime (40 ms, frame-counted)
│   ├── Target (until response, deadline 3000 ms)
│   └── ITI (1000 ms)
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

Base columns + prime, target, prime_type, soa, prime_duration, mask_type
