# Antisaccade Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/antisaccade) · PsychoJS

## When to Use

User mentions: Antisaccade, anti-saccade, inhibitory control, oculomotor inhibition, antisaccade task. Measures the ability to inhibit a reflexive prosaccade toward a peripheral cue and instead generate a voluntary saccade to the opposite location.

## Core Logic

On each trial, a central fixation cross is presented, followed by a brief peripheral cue flash on one side of the screen. After the cue disappears, a target stimulus (often a letter or arrow) appears on the opposite side. The participant must rapidly identify the target by pressing the correct key. The critical manipulation is that the target appears in the opposite hemifield from the cue, requiring inhibition of the prepotent reflexive saccade toward the sudden-onset cue.

Trials are driven by a condition file (`conditions.xlsx`) specifying cue position, target identity, and correct answer for each trial. Trials are randomly shuffled. The cue-target asynchrony and stimulus durations are precisely controlled using frame-accurate timing.

**Response modes**: The participant selects their input method at experiment start — keyboard (left/right arrow keys or letter keys), mouse click (click on target location), or hover (move cursor to target location). This multi-modal input design accommodates different hardware setups and populations.

**Trial structure**: fixation (variable duration, typically 1000–2000 ms) → peripheral cue (brief flash, typically 200 ms) → target at opposite location (brief, typically 100–150 ms, often masked) → response window. Accuracy is determined by comparing the participant's key response to the `corr_ans` column from the condition file. Response time is measured from target onset.

**Conditions**: Typically a mix of prosaccade trials (target same side as cue) and antisaccade trials (target opposite side as cue). The antisaccade error rate (incorrect saccades toward the cue on antisaccade trials) and the latency difference between correct antisaccades and prosaccades (antisaccade cost) are the central dependent measures.

## Must Confirm

- **Response mode**: Keyboard, mouse click, or hover? Which specific keys for keyboard mode?
- **Stimulus identity**: Are targets letters (requiring letter identification), arrows (directional judgment), or simple dots (detection only)?
- **Trial mix**: What proportion of prosaccade vs. antisaccade trials? 50:50 or different ratio?
- **Timing parameters**: Fixation duration, cue duration, target duration, and response deadline?
- **Masking**: Is the target masked (e.g., by a visual pattern) after offset, or does it simply disappear?
- **Eye-tracking integration**: Is this a manual-response-only version, or does it require eye-tracking for saccade measurement?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Peripheral Cue           │    │ Target                   │    │ ITI / Response Window     │
│ Content: + at center     │    │ Content: dot/square      │    │ Content: letter/arrow    │    │ Content: blank           │
│ Duration: 1000-2000 ms   │    │ Duration: ~200 ms        │    │ Duration: 100-150 ms     │    │ Duration: until response │
│ Response: none           │    │ Response: none           │    │ Response: key/click/hover│    │ Response: none           │
│ Condition: none          │    │ Condition: cue_position  │    │ Condition: target_id     │    │ Condition: none          │
│ Data: none               │    │ Data: none               │    │ Data: rt, key, acc       │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

Key measures: antisaccade error rate (proportion of trials where response was toward the cue side), antisaccade latency vs. prosaccade latency (antisaccade cost), and accuracy of target identification. Analyze condition differences (prosaccade vs. antisaccade) via paired t-tests or repeated-measures ANOVA. Higher error rates and longer latencies on antisaccade trials index poorer inhibitory control. Typical findings show patients with frontal lobe damage, schizophrenia, or ADHD have elevated antisaccade error rates.

## References

Hallett, P. E. (1978). Primary and secondary saccades to goals defined by instructions. *Vision Research, 18*(10), 1279–1296. https://doi.org/10.1016/0042-6989(78)90218-3

Munoz, D. P., & Everling, S. (2004). Look away: The anti-saccade task and the voluntary control of eye movement. *Nature Reviews Neuroscience, 5*(3), 218–228. https://doi.org/10.1038/nrn1345

## Do Not Assume

- Do not assume the target always appears on the opposite side. In a standard antisaccade task, toward saccade trials (target on the same side as the cue) are typically presented randomly intermixed with antisaccade trials. The trial mix ratio must be explicitly confirmed, and how the two trial types are coded in the conditions file (e.g. the `trial_type` column is labeled `"pro"` or `"anti"`).
- Do not assume keyboard response is the only input mode. The anti-saccade task supports three input modes: keyboard, mouse click, and hover. Before starting the experiment, subjects need to be allowed to select the input mode and confirm the corresponding key mapping or response area definition. If not confirmed, the generated code may only implement keyboard mode, causing it to fail to run on touch screens or devices without keyboards.
- Do not assume the target is always a letter requiring identification. The target stimulus may be a letter (requiring letter identification, such as determining whether the letter is A or E), an arrow (direction judgment, such as pressing the left arrow key), or a simple detection point (detecting whether it appears). Target identity affects how correct responses are defined and the value of the `corr_ans` column in the criteria file.
- Do not assume there is no response deadline. The target rendering time can be shorter than the response window; the exact length must be confirmed by the agreement. It is necessary to clarify the maximum reaction time and omitted response semantics: RT remains missing and records `response_status: timeout`; if the trial is an error or omission according to the task rules, `accuracy = 0` can be set, but numerical sentinels such as `-1` cannot be used to disguise missing values.
- Do not assume eye-tracking data is always required. Many antisaccade experiments use only manual responses (key presses or clicks) to measure measures of behavioral inhibition (error rates, reaction times) without the need for an eye tracker. It is necessary to clarify whether eye tracking hardware needs to be integrated. If not, there is no need to include EyeLink or Tobii communication logic in the code.
- Do not assume the cue-target interval is always zero. The interval between cue disappearance and target appearance (cue-target asynchrony, CTA) may be 0 ms (no interval), 200 ms (gap condition), or vary systematically during the experiment. CTA affects antisaccade latency and error rate, and specific parameters need to be confirmed before generating code.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| cue_pos | str | The position where the peripheral cue appears, `"left"` or `"right"` |
| target_id | str | Identification of the target stimulus (e.g. letter `"A"`/`"E"`, arrow direction `"left"`/`"right"`, or dot detection `"dot"`) |
| trial_type | str | Trial type, `"pro"` (proward saccade, the target is on the same side as the cue) or `"anti"` (anti-saccade, the target is on the opposite side of the cue) |
| corr_ans | str | Correct response keys, such as `"left"`, `"right"`, `"a"`, `"e"`, determined by the target identity |
| target_pos | str | The position where the target appears, `"left"` or `"right"`. Opposite of `cue_pos` in antisaccade trials, can be used to derive `trial_type` |

## Variants

- **Gap/Overlap Antisaccade Task**: Peripheral cues are presented after the fixation point disappears (gap condition, the fixation point disappears 200 ms before the cue appears) or does not disappear (overlap condition, the fixation point continues to appear). Gap conditions reduce antisaccade latency and are used to study attentional disengagement and eye movement preparation mechanisms. Related paradigm: gap-overlap
- **Memory-Guided Antisaccade Task**: The target only flashes for a very short time (such as 50–100 ms), and the subject needs to perform a saccade to the mirror position of the target after a delay period (a few seconds). Increased working memory load serves to dissociate inhibitory control from spatial working memory components, commonly seen in studies of schizophrenia and frontal lobe damage.
- **Mixed Pro/Anti Blocked Design (Mixed/Blocked Design Antisaccade Task)**: Separate the directional saccade and antisaccade trials by blocks (rather than randomly mixing them), and the trial types within each block are the same. There is a clear clue at the beginning of the block indicating the current block type. Used to study task switching costs (switch costs) and top-down inhibitory preparation effects.

---

## Example

### User Request

> "I want to do an antisaccade experiment. The fixation point is first presented in the center of the screen for 1000 to 2000 ms randomly, and then a white square is quickly flashed as a cue on the left or right side for 200 ms. After the cue disappears, an arrow (← or →) is presented in the opposite direction for 150 ms. ms. The subjects need to use the left and right arrow keys to determine the direction of the arrow. The cue position and the target direction are independently randomized. There are 200 trials in total, and 20 practice trials are performed first. "

### Trial Window Timeline

```text
┌──────────────────────────────┐    ┌──────────────────────────────┐    ┌──────────────────────────────┐    ┌──────────────────────────────┐
│ Window 1                     │ →  │ Window 2                     │ →  │ Window 3                     │ →  │ Window 4                     │
│ Fixation point │ │ Peripheral cues │ │ Target arrow │ │ ITI │
│ Content: + in the center of the screen │ │ Content: white square │ │ Content: ← or → │ │ Content: blank │
│ Duration: 1000-2000 ms Random │ │ Duration: 200 ms │ │ Duration: 150 ms │ │ Duration: 500-1000 ms │
│ Response: None │ │ Response: None │ │ Response: left/right arrow keys │ │ Response: None │
│ Condition: None │ │ Condition: {cue_pos} │ │ Condition: {target_id} │ │ Condition: None │
│ Data: None │ │ Data: None │ │ Data: rt, key, acc │ │ Data: None │
└──────────────────────────────┘    └──────────────────────────────┘    └──────────────────────────────┘    └──────────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Arrow antisaccade task |
| Platform | PsychoPy |
| Task type | Antisaccade task (Antisaccade) |
| Cue stimulus | White square (peripheral flash) |
| Target stimulus | Arrow (← or →) |
| Reaction mode | Left and right arrow keys determine the direction of the target arrow |
| Fixation duration | 1000–2000 ms Random (uniformly distributed) |
| Lead duration | 200 ms |
| target duration | 150 ms |
| Trial mix ratio | 50% toward saccades / 50% against saccades |
| Total number of trials | 200 formal trials + 20 practice trials |
| Reaction Mode | Keyboard (left and right arrow keys) |

### Missing Information

1. The ITI duration is not clearly stated → Assuming 500–1000 ms random, the specific range and distribution method need to be confirmed with the user
2. Whether feedback prompts are needed during the practice phase → Confirmation is required (usually correct/wrong trial secondary feedback is provided during the practice phase, but not during the formal phase)
3. Is there a masking stimulus after the target disappears → The user did not mention masking, assuming that the target disappears directly without masking. Need to confirm whether visual masking is needed to prevent afterimage cues

### Critical Assumptions

- Fixation durations were randomly selected independently in each trial (1000–2000 ms uniformly distributed) without using step changes or adaptive adjustments
- Cue position (left/right) and target arrow direction (←/→) fully cross-balanced (50 trials each) to ensure an even number of trials per condition combination
- The response window starts when the target is presented and ends at 2000 ms from target onset. Timeouts are marked as errors (`acc=0`, `timeout=1`) and RTs are logged as deadline values
- Trial-level feedback (correct/wrong) is provided in the practice phase, no feedback is provided in the formal phase, and rest prompts are displayed between blocks.

### Code Architecture

```
antisaccade.py
├── Parameter settings (fixation point duration range, cue duration, target duration, ITI range, response deadline)
├── Window initialization (full screen or window, background color setting)
├── Stimulus preloading
│ ├── TextStim: fixation point "+"
│ ├── Rect: white clue square (appears on the left/right side)
│ ├── TextStim: Arrow "←" / "→" (appears on the left/right side)
│ └── TextStim: Feedback text "correct"/"wrong" (only in the practice phase)
├── Condition table generation
│ ├── cue_pos × target_id complete crossover (left/right × ←/→ = 4 combinations)
│ ├── trial_type derivation: cue_pos == target_pos → "pro", otherwise → "anti"
│ ├── corr_ans derivation: target_id "left" → corr_ans "left", target_id "right" → corr_ans "right"
│ └── Distribute pro/anti in a 50:50 ratio, 200 trials in total, randomly shuffled
├── Trial loop (executed trial by trial):
│ ├── Fixation point window (1000–2000 ms random, fixed random value is read from the condition table to ensure reproducibility)
│ ├── Cue window (200 ms, the white square is on the left or right, the position is determined by cue_pos)
│ ├── Target window (150 ms, the arrow is rendered at the position specified by target_pos)
│ ├── Response window (deadline 2000 ms, monitor left/right keys, record rt and key)
│ ├── Feedback display (only practice phase, 500 ms correct/error prompt)
│ └── ITI (500–1000 ms random, blank screen)
├── Data saving: try/finally structure, CSV written line by line to ensure data security
└── Exit prompt (thank you at the end of the experiment)
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| trial_index | int | Trial number (0–199) |
| cue_pos | str | The position where the clue appears (`"left"` or `"right"`) |
| target_id | str | Target arrow direction (`"left"` or `"right"`) |
| target_pos | str | The position where the target appears (`"left"` or `"right"`) |
| trial_type | str | Trial type (`"pro"` or `"anti"`) |
| corr_ans | str | Correct response key (`"left"` or `"right"`) |
| fix_dur | float | Actual duration of fixation point (ms) |
| cue_onset | float | cue start presentation time (relative to trial start, s) |
| target_onset | float | Target start presentation time (relative to trial start, s) |
| rt | float | Reaction time (ms, from target onset) |
| key_resp | str | The actual key pressed by the subject (`"left"`, `"right"` or `None`) |
| acc | int | Accuracy rate (1 = correct, 0 = error or timeout) |
| timeout | int | Whether to timeout (1 = no response within timeout, 0 = response within deadline) |
