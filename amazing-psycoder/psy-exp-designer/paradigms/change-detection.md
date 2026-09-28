# Change Detection Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/change-detection) · PsychoJS

## When to Use

User mentions: Change detection, visual working memory, VWM, change blindness, change detection, visual working memory. Measures the capacity and precision of visual working memory by testing whether observers can detect changes between a study array and a test probe.

## Core Logic

Participants view a brief study array containing multiple colored circles at fixed angular positions around a central fixation point. After a short retention interval, a test array is presented that is either identical to the study array (no-change trial) or has one item whose color changed (change trial). Participants respond whether they detected a change (same/different judgment).

**Two-phase design**:

1. **Change Detection Phase**: Participants judge whether any circle changed color. This phase measures basic VWM capacity — can they detect the presence of a change?
2. **Localisation Phase**: Participants identify which specific circle changed. This provides a more sensitive assay of VWM precision — do they know which item changed, not just that something changed?

Each phase has its own instructions, trial loop, and condition files. The set size (number of circles, typically 2–8) varies across trials to parametrically manipulate memory load.

**Stimuli**: Colored circles rendered programmatically at calculated angular positions around fixation (evenly spaced). Colors are specified by RGB values from CSV condition files. Circle positions stay consistent; colors change per trial.

**Trial structure**: fixation (500 ms) → memory array (100–500 ms) → blank retention interval (900–1000 ms) → test array/probe (until response, typically 2000 ms deadline). A progress counter is shown to track trial position within the session.

**Capacity estimation**: VWM capacity (k) is estimated using the formula k = N * (H – FA) / (1 – FA), where N is set size, H is hit rate (correct change detection), and FA is false alarm rate (incorrectly reporting a change on no-change trials).

## Must Confirm

- **Phases**: Both change-detection and localisation phases, or just one?
- **Set sizes**: Which set sizes to include? (typically 2, 4, 6, 8)
- **Stimulus type**: Colored circles, oriented bars, complex shapes, or other?
- **Change type**: Color change only, or also position/orientation changes?
- **Trial count per set size**: How many change and no-change trials per set size?
- **Array duration**: How long is the memory array displayed? Brief (100 ms) to prevent verbal encoding, or longer?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Memory Array             │    │ Retention Interval       │    │ Test Array / Response    │
│ Content: + at center     │    │ Content: N colored circles│   │ Content: blank           │    │ Content: N circles       │
│ Duration: 500 ms         │    │ Duration: 100-500 ms     │    │ Duration: 900-1000 ms    │    │ Duration: until key      │
│ Response: none           │    │ Response: none           │    │ Response: none           │    │ (deadline ~2000 ms)      │
│ Condition: none          │    │ Condition: {set_size}    │    │ Condition: none          │    │ Response: same/diff key  │
│ Data: none               │    │ Data: none               │    │ Data: none               │    │ Condition: {change_type} │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    │ Data: rt, key, acc       │
                                                                                                └──────────────────────────┘
```

## Data Analysis

Primary measure is working memory capacity (k) estimated from hit and false alarm rates at each set size. Also analyze overall accuracy and response time as a function of set size. Individual differences in k correlate with fluid intelligence, academic performance, and attentional control. For the localisation phase, analyze which-position accuracy as a function of set size.

## References

Luck, S. J., & Vogel, E. K. (1997). The capacity of visual working memory for features and conjunctions. *Nature, 390*(6657), 279–281. https://doi.org/10.1038/36846

Pashler, H. (1988). Familiarity and visual change detection. *Perception & Psychophysics, 44*(4), 369–378. https://doi.org/10.3758/BF03210419

## Do Not Assume

- Do not assume both detection and localisation phases are required — many experiments use only the change-detection phase without asking which item changed
- Do not assume standard set sizes (2, 4, 6, 8) — confirm which set sizes the user wants; some designs use fewer levels or non-standard values
- Do not assume only color changes — changes can involve orientation, shape, spatial position, or feature conjunctions
- Do not assume a 50:50 change/no-change ratio — confirm the ratio explicitly; some designs use 60:40 or other proportions
- Do not assume unlimited response deadline — typical deadline is 2000 ms, but confirm
- Do not assume the memory array duration is fixed at one value — brief durations (100–200 ms) prevent verbal encoding, while longer durations (500 ms+) are sometimes used

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| set_size | int | The number of dots/items in the memory array (such as 2, 4, 6, 8) |
| change_present | int | 1 = change trial, 0 = no change trial |
| change_position | int | Changed target position (1-indexed), -1 or NA for no-change trials |
| target_color | str | The changed target color (RGB or color name), no change trials are NA |

## Variants

- **Single-probe change detection (Single-probe)**: After the memory array disappears, a single probe stimulus is presented (usually a circle marks the location), and the subject judges whether the color/feature of the item at that location is consistent with the memory array. This is the most commonly used variation of measuring visual working memory capacity. See [visual-search.md](visual-search.md) (visual search, shared attention load operation).
- **Whole-display change detection (Whole-display)**: In the test phase, the complete array is re-presented, and the subject judges whether any items have changed. Often combined with the change blindness paradigm, the difficulty of detection is manipulated by flashing or blank intervals.
- **Cueded Change Detection (Cued)**: After the memory array disappears, spatial cues (such as arrows or boxes) are presented, pointing to the location of possible changes. Cues reduce memory load and are used to measure attention allocation and visual working memory accuracy. See [posner-cuing.md](posner-cuing.md) (Spatial Cuing Paradigm).

---

## Example

### User Request

> "I want to do a change detection experiment. The fixation point is first presented in the center of the screen for 500 ms, then the memory array (4 or 6 colored dots, evenly distributed on a virtual circle centered on the central fixation point) is presented for 250 ms, then the blank screen is maintained for 900 ms, and finally the test array is presented until the subject's key press response (up to 2000 ms, timeout is recorded as an error). Half of the trials have a dot color change, and half of the trials have no change. The subject presses the F key to indicate that a change is detected. A total of 240 formal trials (120 trials for each set_size) are performed with PsychoPy.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation Point │ │ Memory Array │ │ Hold Interval │ │ Test Array/Response │
│ Content: + at center │ │ Content: N colored dots │ │ Content: blank │ │ Content: N colored dots │
│ Duration: 500 ms         │    │ Duration: 250 ms         │    │ Duration: 900 ms         │    │ Duration: until key      │
│ Response: none           │    │ Response: none           │    │ Response: none           │    │ (deadline 2000 ms)       │
│ Condition: none │ │ Condition: {set_size} │ │ Condition: none │ │ Response: f=change, j=no change │
│ Data: none               │    │ Data: none               │    │ Data: none               │    │ Condition: {change_present}│
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    │ Data: rt, key, acc       │
                                                                                                └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| fixation point | + | 500 ms | none | none | none |
| Memory array | N colored dots (N=4 or 6) | 250 ms | none | {set_size} | none |
| keep interval | blank | 900 ms | none | none | none |
| Test array | N colored dots | until key (deadline 2000 ms) | f=change, j=no change | {change_present} | rt, key, acc |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Visual change detection task |
| Platform | PsychoPy |
| Task Type | Change Detection (Visual Working Memory) |
| Set sizes | 4, 6 |
| Stimulus type | Colored dots (evenly distributed in the virtual circle) |
| Change type | Color change (single dot) |
| Change/no change ratio | 50:50 |
| Memory array presentation time | 250 ms |
| Hold interval | 900 ms |
| Response window | Maximum 2000 ms |
| Stage | Instructions → Practice (24 trials) → Formal experiment (240 trials, including intermission) |

### Missing Information

1. The color set is not specified (which colors are used? How to control the distinguishability between colors?) → Need to confirm the standard color set or custom RGB values
2. Whether the position judgment stage is included is not specified → Need to confirm whether it is only change detection, or whether position judgment is also required
3. Whether the formal experiment requires intermissions, the interval and number of breaks are not specified → the block division needs to be confirmed

### Assumptions

- Only includes the change detection phase (excluding the position judgment/positioning phase)
- Colors are randomly selected from a predefined standard color set (e.g. 7–9 easily distinguishable colors such as red, blue, green, yellow, purple, orange, cyan, etc.), and the same color combination is not reused between trials
- The dot positions are evenly distributed (the angle interval is 90° when set_size=4, the angle interval is 60° when set_size=6), and the starting angle is random.
- No inter-trial feedback (feedback may be provided only during the practice phase)
- No ITI (the fixation point of the next trial after the end of the hold interval is used as the trial interval)

### Expected Code Architecture

```
change_detection.py
├── Parameters (set_sizes, colors, n_trials, timing, keys)
├── Window setup (fullscreen or windowed)
├── Stimulus preloading:
│   ├── Fixation cross (TextStim: "+")
│   ├── Circle template (ShapeStim, reused with color/position updates)
├── Generate condition dataframe:
│   ├── 240 trials: 120 per set_size, balanced change/no-change
│   ├── Columns: set_size, change_present, change_position, target_color
│   └── Shuffle with constraint (no more than 3 consecutive same type)
├── Trial loop:
│ ├── fixation point (500 ms)
│ ├── memory array (250 ms — N circles at computed positions)
│ ├── Hold interval (900 ms blank)
│ ├── Test array (until response, deadline 2000 ms)
│   │   ├── If change_present=1: one circle color replaced with target_color
│   │   └── If change_present=0: identical to memory array
│   ├── Response recording (f/j keys, rt, acc)
│   └── Block break every 60 trials
├── Data saving: try/finally with incremental CSV writes
├── Escape key check at every window for early exit
```

### Expected Data Columns

Base columns + set_size, change_present, change_position, target_color
