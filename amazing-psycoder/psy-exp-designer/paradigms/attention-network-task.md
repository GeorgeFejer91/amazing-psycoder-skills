# Attention Network Task (ANT)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/attention_network_task) · PsychoJS

## When to Use

User mentions: ANT, attention network test, alerting, orienting, executive control, Fan task, attention network task. A combined cued reaction time and flanker task that measures three independent attentional networks — alerting, orienting, and executive control — within a single 30-minute session.

## Core Logic

Participants respond to the direction (left or right) of a central arrow target flanked by four other arrows. The flankers can be congruent (same direction as target), incongruent (opposite direction), or neutral (lines without directional information). Target onset is preceded by one of four cue conditions:

- **No cue**: No warning signal (baseline)
- **Center cue**: Fixation point changes briefly (provides temporal alerting but no spatial information)
- **Double cue**: Both possible target locations cued simultaneously (measures alerting — temporal warning without spatial information)
- **Spatial cue**: Valid cue at the exact target location (measures orienting — spatial attention benefit)

Each trial: cue (100 ms) → fixation (400 ms) → target + flankers (max 1700 ms or until response). Participants press left or right arrow key based on the central arrow direction, ignoring flankers. Stimuli are pre-rendered as PNG images (`congLeft.png`, `incongRight.png`, etc.) covering all cue-target-flanker combinations. The condition file (`cond.xlsx`) specifies which stimulus image to display and the correct key response per trial.

**Trial count**: Typically 288 trials total (3 blocks of 96). All combinations of cue type (4) and flanker type (3) are presented, balanced across blocks.

**Attentional network scores** are computed by subtracting reaction times between specific conditions:
- **Alerting effect** = RT(no cue) – RT(double cue). Larger positive values indicate stronger alerting.
- **Orienting effect** = RT(center cue) – RT(spatial cue). Larger positive values indicate stronger orienting.
- **Executive control effect** = RT(incongruent) – RT(congruent). Larger values indicate poorer conflict resolution.

## Must Confirm

- **Cue type design**: Full ANT (4 cue types: no cue, center, double, spatial) or simplified version?
- **Flanker types**: 3 levels (congruent, incongruent, neutral) or 2 (congruent, incongruent only)?
- **Trial count**: Standard 288 trials (3 blocks x 96) or custom?
- **Stimulus format**: Pre-rendered images or programmatically drawn arrows?
- **Response deadline**: Standard 1700 ms or custom?
- **Cue validity**: Spatial cues always valid (100%), or include invalid catch trials?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Cue                      │    │ Target + Flankers        │    │ ITI                      │
│ Content: + at center     │    │ Content: */**/spatial    │    │ Content: ←←←←← or →→→→→ │    │ Content: blank           │
│ Duration: variable       │    │ Duration: 100 ms         │    │ Duration: until key      │    │ Duration: variable        │
│ Response: none           │    │ Response: none           │    │ (deadline ~1700 ms)      │    │ Response: none           │
│ Condition: none          │    │ Condition: {cue_type}    │    │ Response: left/right key │    │ Condition: none          │
│ Data: none               │    │ Data: none               │    │ Condition: {flanker_type}│    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    │ Data: rt, key, acc       │    └──────────────────────────┘
                                                                └──────────────────────────┘
```

## Data Analysis

Primary outcomes are the three network scores (alerting, orienting, executive control). Remove error trials and RT outliers (e.g., <200 ms or >3 SD). Analyze by computing mean RT for each condition and deriving the difference scores. Common findings: the three networks are largely independent; executive control deficits are associated with ADHD, schizophrenia, and aging.

## References

Fan, J., McCandliss, B. D., Sommer, T., Raz, A., & Posner, M. I. (2002). Testing the efficiency and independence of attentional networks. *Journal of Cognitive Neuroscience, 14*(3), 340–347. https://doi.org/10.1162/089892902317361886

## Do Not Assume

- Do not assume all 4 clue types are used - some simplified versions of ANT only retain 2 or 3 clue types (e.g. removing double clues or neutral clues). The user’s specific experimental design needs to be confirmed.
- Do not assume that spatial cues are 100% effective - in standard ANT, spatial cues always point to the target location, but the ANT-I variant introduces invalid cue trials to measure the interaction between attention networks. Need to confirm whether invalid clues are needed.
- Do not assume that stimuli must use pre-rendered PNG images - PsychoPy can draw arrows directly using the Polygon component, or use TextStim to render stimuli as Unicode arrow characters (← →). The pre-rendered image method requires the user to provide image files, and programmatic drawing requires confirming the arrow size, spacing and color.
- Do not assume that neutral flanker must be a directionless line - some implementations use "---" lines as neutral conditions, some use arrow-less line segments, and some versions do not set neutral conditions at all (only two flanker types, congruent and incongruent).
- Do not assume that the subject's reaction is only the left and right arrow keys - some implementations use the left and right arrow keys on the keyboard, and some use designated finger keys (such as pressing F with the left index finger and pressing J with the right index finger). Key mapping needs to be confirmed.
- Do not assume the number of practice trials is the standard value - standard ANT usually contains 24 practice trials (1 block), but the user may customize the number of practice trials or omit the practice phase entirely.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| cue_type | str | Cue type: `"no_cue"`, `"center_cue"`, `"double_cue"`, `"spatial_cue"` |
| flanker_type | str | Flanker type: `"congruent"`, `"incongruent"`, `"neutral"` |
| target_direction | str | The direction of the central arrow: `"left"` or `"right"` |
| correct_response | str | Correct key: `"left"` or `"right"` |
| stimulus | str | Stimulus image file name (if presented in image format), such as `"congLeft.png"` |

## Variants

- **ANT-I (Attention Network Test - Interaction)**: Invalid spatial cue trials are introduced based on standard ANT to measure the interaction between the alertness network and the orientation network. The proportion of invalid leads is usually 17–25%, cross-balanced with the flanker type. Reference [eriksen-flanker.md](eriksen-flanker.md).
- **Child ANT**: Replace arrow stimuli with pictures of colored fish (5 fish in a row, target central fish), with fish facing left and right instead of arrow directions. The clues are replaced by animations of bubbles or water plants before the fish appears, which greatly reduces cognitive load and is suitable for children aged 5–10 years.
- **ANT-R (ANT-Revised)**: Optimized version revised by Fan et al. (2009) with shortened cue-target interval and adjusted trial ratio to balance the signal-to-noise ratio of the three networks. The total number of trials is reduced to 144 trials, which is more suitable for neuroimaging experiments such as fMRI.

## Example

### User Request

> "I am going to do an Attention Network Test (ANT) experiment. The fixation point '+' is always displayed in the center of the screen. Each trial starts with the cue presented first: no cue (fixation point remains unchanged), central cue (fixation point becomes bolder), dual cue (upper and lower fixation points become bolder at the same time), or spatial cue (only the location where the target appears becomes bolder). The cue lasts for 100 ms, then the fixation point is restored for 400ms, and then 5 horizontally arranged arrows are presented above or below the fixation point, with the central arrow pointing left or right, and the arrows on both sides are consistent with the center, opposite or have no direction lines. The subject's task is to press the left or right key to determine the direction of the central arrow within 1700ms. There are 3 blocks in total. 96 trials. Implemented with PsychoPy."

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Cue                      │    │ Target + Flankers        │    │ ITI                      │
│ Content: +               │    │ Content: * / ** / spatial │    │ Content: ←←←←← or →→→→→ │    │ Content: blank          │
│ Duration: variable       │    │ Duration: 100 ms          │    │ Duration: until key      │    │ Duration: variable       │
│ (400-1600 ms random) │ │ Response: none │ │ (deadline 1700 ms) │ │ (random) │
│ Response: none           │    │ Condition: {cue_type}     │    │ Response: left/right key │    │ Response: none           │
│ Condition: none          │    │ Data: none                │    │ Condition: {flanker_type}│    │ Condition: none          │
│ Data: none               │    └──────────────────────────┘    │ Data: rt, key, acc       │    │ Data: none               │
└──────────────────────────┘                                    └──────────────────────────┘    └──────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Attention Network Task (ANT) |
| Platform | PsychoPy |
| Task type | Cued flanker task (note network measurement) |
| Cue type | no_cue, center_cue, double_cue, spatial_cue |
| Flanker type | congruent, incongruent, neutral |
| Lead duration | 100 ms |
| cue-target interval | 400 ms |
| Response deadline | 1700 ms |
| Number of Blocks | 3 blocks |
| Number of trials per Block | 96 trials |
| Total number of trials | 288 trials |
| Fixation-cue interval | 400-1600 ms random |
| ITI | Unspecified (pending confirmation) |

### Missing Information

1. The ITI duration is not specified → Will ask (fixed or random range? The ITI of standard ANT usually changes randomly)
2. Does it include a practice phase? Standard ANT usually contains 24 practice trials, but not mentioned by the user → Will ask
3. The specific size, spacing and visual parameters of the arrows are not specified → If you use Polygon to draw, you need to confirm the size, line width and arrangement spacing of the arrows

### Critical Assumptions

- Spatial cues are 100% valid (pointing to the actual location where the target appears), excluding invalid cue trials
- Stimulates programmatic drawing using PsychoPy Polygon components (no need to pre-render PNG images)
- The reaction keys are the left/right arrow keys on the keyboard (Left / Right arrow keys)
- ITI defaults to random 400-1600 ms (consistent with the fixation point duration range, refer to standard ANT)
- Fixation point-cue interval (before cue) defaults to random 400-1600 ms

### Code Architecture

```
ant.py
├── Parameter configuration (lead type, flanker type, duration, number of trials, key mapping)
├── Window settings (full screen/window, background color, unit)
├── Stimulus component pre-creation
│ ├── Gaze point (TextStim: "+")
│ ├── Cue stimulus (TextStim: "*" for various positions of central/double/spatial cues)
│ ├── Arrow stimulus (Polygon: left/right arrow) + neutral line segment (Line)
│ └── Feedback text (TextStim: only used during practice)
├── Condition file generation (all cue_type × flanker_type × target_direction combinations, balanced across blocks)
├── Experimental stage
│ ├── Instructions
│ ├── Practice phase (24 trials, including feedback)
│ └── Formal stage (3 blocks × 96 trials)
├── Trial cycle:
│ ├── Fixation point (random 400-1600 ms)
│ ├── clue (100 ms)
│ ├── Cue-target interval (400 ms, fixation recovery)
│ ├── target + flanker presentation (max 1700 ms or until response)
│ ├── Feedback (Practice phase: correct/wrong/timeout)
│ └── ITI (random)
├── Data saving: try/finally + CSV write line by line
├── Exit control: Escape key check
└── Pay attention to the network score calculation (output the alerting/orienting/executive_control score after the experiment)
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| cue_type | str | Cue type: no_cue / center_cue / double_cue / spatial_cue |
|flanker_type|str|Flanker type: congruent/incongruent/neutral|
| target_direction | str | Center arrow points to: left / right |
| correct_response | str | Correct key: left / right |
| rt | float | reaction time (ms) |
| acc | int | Correctness: 1=correct, 0=wrong |
| alerting_score | float | Alert network score: RT(no_cue) - RT(double_cue) |
| orienting_score | float | Orienting network score: RT(center_cue) - RT(spatial_cue) |
| executive_control_score | float | Executive control score: RT(incongruent) - RT(congruent) |
