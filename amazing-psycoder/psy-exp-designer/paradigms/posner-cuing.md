# Posner Cuing Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/posner) · reference

## When to Use

User mentions: Posner cuing, spatial cuing, covert attention, endogenous/exogenous attention, Posner cue task, spatial attention. Measures the ability to orient covert spatial attention in response to predictive or non-predictive cues, dissociating voluntary (endogenous) and reflexive (exogenous) orienting.

## Core Logic

Participants fixate on a central point and respond as quickly as possible to a target that appears in one of two (or more) peripheral locations. Before target onset, a cue directs attention to a location. On valid trials (typically ~80% of cued trials), the target appears at the cued location. On invalid trials (~20%), the target appears at the uncued location. Neutral trials (no directional cue) provide a baseline.

The cuing effect (invalid RT – valid RT) measures the cost-plus-benefit of spatial attention. Two cue types are typically used: peripheral cues (a brief flash at the target location, e.g., 50 ms) that elicit reflexive, exogenous attention shifting, and central symbolic cues (an arrow at fixation) that require voluntary, endogenous attention shifting. Peripheral cues produce rapid (peak ~100-150 ms) but transient facilitation followed by inhibition of return (IOR) at longer cue-target intervals (>300 ms). Central cues produce slower but sustained facilitation.

Key temporal parameter: stimulus onset asynchrony (SOA) between cue and target is varied (e.g., 100, 300, 500, 800 ms) to map the time course of attentional effects. Short SOAs with peripheral cues show facilitation; long SOAs show IOR (slower responses to cued vs. uncued locations).

## Data Analysis

Compute mean RT for valid, invalid, and neutral conditions. Test cuing effect (invalid – valid RT) and its subscores: benefit (neutral – valid), cost (invalid – neutral). Analyze cuing effect as a function of SOA and cue type. IOR is indexed by valid > invalid RT at long SOAs. Compare cuing effects between populations (e.g., reduced cuing effects in neglect, schizophrenia; altered IOR in ADHD).

## Must Confirm

- **Target type**: Gabor patch, simple shape, or letter? What visual properties (spatial frequency, contrast, size)?
- **Cue type**: Peripheral box cue (reflexive exogenous), central arrow (voluntary endogenous), or both?
- **Cue validity ratio**: What proportion valid vs invalid? (typically 80% valid / 20% invalid)
- **SOA values**: What cue-target onset asynchronies to use? (e.g., 100, 300, 500, 800 ms)
- **Trial counts**: How many trials per condition × SOA combination?
- **Response mapping**: Left/right arrow keys for left/right target? Or detection key (one key for any target)?

## Trial Window Timeline

From the psychtoolbox reference implementation (Gabor target, peripheral box cue):

```
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │ →  │ Window 5                 │
│ Fixation                 │    │ Cue                      │    │ CTI (Gap)                │    │ Target                   │    │ Response + ITI           │
│ Content: fixation dot    │    │ Content: box cue (L/R)   │    │ Content: fixation dot    │    │ Content: Gabor target    │    │ Content: blank grey      │
│ Duration: 500 ms         │    │ + fixation dot           │    │ Duration: 300 ms (CTI)   │    │ Duration: 150 ms         │    │ Duration: until keypress │
│ Response: none           │    │ Duration: 150 ms         │    │ Response: none           │    │ Response: none           │    │ Response: LeftArrow/     │
│ Condition: none          │    │ Response: none           │    │ Condition: {cue_pos}     │    │ Condition: {target_pos}  │    │   RightArrow             │
│ Data: none               │    │ Condition: {cue_pos}     │    │ Data: none               │    │ Data: none               │    │ Data: rt, correctness    │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

2×2 factorial design: cue position (left/right) × target position (left/right). Contingent = same location; Non-contingent = different location. Key parameter: Cue-Target Interval (CTI) — 300ms in reference implementation, varied in full paradigm.

## Condition File Structure

| Column | Values | Description |
|--------|--------|-------------|
| cue_pos | 0=left, 1=right | Position of the box cue |
| target_pos | 0=left, 1=right | Position of the Gabor target |
| correct_response | left/right | Expected key response |
| contingency | contingent/non-contingent | Whether cue and target share location |

Base matrix `[0 0 1 1; 0 1 0 1]` (4 combinations) repeated `numReps` times, then shuffled. `cue_pos == target_pos` → contingent; `cue_pos != target_pos` → non-contingent.

## References

Posner, M. I. (1980). Orienting of attention. *Quarterly Journal of Experimental Psychology, 32*(1), 3–25. https://doi.org/10.1080/00335558008248231

Posner, M. I., Snyder, C. R. R., & Davidson, B. J. (1980). Attention and the detection of signals. *Journal of Experimental Psychology: General, 109*(2), 160–174. https://doi.org/10.1037/0096-3445.109.2.160

Scarfe, P. (n.d.). Posner cuing experiment (Psychtoolbox demo). https://peterscarfe.com/poserCuingExperiment.html

## Do Not Assume

- Do not assume that the clue validity ratio is 80%/20% and must be explicitly confirmed. While classic designs use 80% valid trials, some experiments use 50%/50% or include neutral trials, and the user must be asked directly.
- Do not assume that peripheral cues always appear at the target location. Peripheral cues are usually box flashes or brightness changes, confirming the visual attributes of the cues (boxes, dots, brightness increases and decreases) and their spatial relationship with the target location.
- Do not assume that the central clue must be the arrow symbol. The central cue can be an arrow, text ("left"/"right"), a number or a gaze cue, confirming the specific presentation form of the cue.
- Do not assume only use a single SOA value. The core of the Posner paradigm is to draw the time course curve of attention, which usually requires multiple SOAs (such as 100, 300, 500, 800 ms), and the SOA set must be confirmed.
- Do not assume that the target stimulus type defaults to simple square. Confirm the visual properties of the target: Gabor raster, letters, shape, size, contrast, etc.
- Do not assume that the subject responded by pressing the left and right buttons. It may be a detection reaction (single-key detection of target presence) or a discrimination reaction (distinguishing target attributes), confirming the reaction mapping rules.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| cue_pos | int | cue position: 0=left, 1=right |
| target_pos | int | Target position: 0=left, 1=right |
| soa | float | Cue-target presentation asynchronous (SOA), unit ms |
| validity | str | `"valid"` (cue on same side as target), `"invalid"` (opposite side) or `"neutral"` (no clue) |
| cue_type | str | `"peripheral"` (peripheral cue) or `"central"` (central cue) |

## Variants

- **Peripheral Cue Variant (Exogenous Attention)**: A box flash or brightness change is briefly presented (typically 50-150 ms) at a peripheral location where the target may appear, inducing bottom-up reflexive attentional orienting. A facilitation effect occurs under short SOA, and an inhibition of return (IOR) occurs under long SOA (>300 ms). This is the original form of Posner's classic experiment.
- **Central cue variant (endogenous attention)**: Present arrows, text, or symbolic cues (such as "←" or "→") at the central fixation point, triggering top-down volitional attentional orientation. Longer SOAs (typically >300 ms) are required to produce facilitation effects and are less prone to return inhibition. Associable paradigm: [stroop](../paradigms/stroop.md) (involves central symbol processing).
- **Gaze cue variant (social attention)**: A face picture is presented in the center, and its eye gaze direction is used as a cue to trigger social attention orientation. Even when subjects are told that the cues are not predictive, the attentional shift effect still occurs. Associable paradigm: [dot-probe](../paradigms/dot-probe.md) (involving faces and attentional bias).

## Example

### User request

> "Do a Posner cue task. There is a box on the left and right sides of the screen, with a fixation point in the center. At the beginning of the trial, the left or right box will flash briefly (50ms) as a peripheral cue. 80% of the trials the target appears on one side of the cue (valid), 20% appears on the other side (invalid). The target (letter E) appears 200ms after the flash, and the subject is asked to press the space bar as soon as possible after seeing the target. Target presentation 200ms, 1500ms response window. 200 trials in 4 blocks using PsychoPy.

### Trial window timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │ →  │ Window 5                 │
│ Fixation │ │ Cue │ │ SOA Interval │ │ Target │ │ Response + ITI │
│ Content: Center + left and right boxes │ │ Content: Single-sided box flashing │ │ Content: Center + left and right boxes │ │ Content: Letter E │ │ Content: Blank screen │
│ Duration: 500 ms │ │ Duration: 50 ms │ │ Duration: 150 ms │ │ Duration: 200 ms │ │ Duration: to key │
│ Response: None │ │ Response: None │ │ Response: None │ │ Response: None │ │ (deadline 1500 ms) │
│ Condition: None │ │ Condition: {cue_pos} │ │ Condition: {cue_pos} │ │ Condition: {target_pos} │ │ Response: Space bar │
│ Data: None │ │ Data: None │ │ Data: None │ │ Data: None │ │ Data: rt, acc │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Fixation point | Center + left and right boxes | 500 ms | None | None | None |
| Cue | One-sided box flash | 50 ms | None | {cue_pos} | None |
| SOA interval | center + left and right boxes | 150 ms | None | {cue_pos} | None |
| target | letter E | 200 ms | None | {target_pos} | None |
| reaction+ITI | blank screen | to key (deadline 1500 ms) | space bar | none | rt, acc |

### Analyzed experimental specifications

| Field | Value |
|-------|-------|
| Experiment Name | Posner Peripheral Cue Task |
| Platform | PsychoPy |
| Task type | Posner cuing (exogenous spatial attention) |
| Cue type | Peripheral box flashing (exogenous) |
| Lead duration | 50 ms |
| Target stimulus | Letter E |
| target duration | 200 ms |
| SOA | 200 ms (50 ms clue + 150 ms interval) |
| Lead validity | 80% valid / 20% invalid |
| Reaction mode | Single key detection (space bar) |
| Number of trials | 200 trials (4 blocks × 50) |

### Missing information

1. The fixation point duration is not clearly stated → assumed to be 500 ms (design assumption, needs to be noted)
2. ITI duration not mentioned → user will be asked (fixed/random range)
3. Practice trials are not mentioned → You will be asked whether a practice phase and the number of trials are required
4. Whether to inform the subjects of the predictability of the clues (80% effective) → confirm the content of the instructions

### Key assumptions

- Peripheral clues are changes in box brightness (bold or highlighted), not changes in other visual attributes
- No neutral trials (only valid and invalid conditions)
- No feedback between trials (no feedback is presented in the formal phase)
- Expected RT threshold: 100 ms (below this is marked as an expected response)
- Cue-target SOA fixed at 200 ms (user did not request multiple SOA)

### Code structure

```
posner_cuing.py
├── Parameter definition (cue duration, SOA, target duration, response deadline, number of trials)
├── Window settings (full screen/window mode)
├── Stimulus preloading (fixation point, box, target letter E)
├── Condition table generation (cue_pos × target_pos matrix, 80/20 ratio)
├── Instructions presented
├── Trial cycle:
│ ├── fixation point (500 ms)
│ ├── Cue presentation (50 ms — flashing box)
│ ├── SOA interval (150 ms)
│ ├── Target presentation (200 ms — letter E)
│ ├── Response window (deadline 1500 ms)
│   ├── ITI
│ └── Data record (rt, acc, cue_pos, target_pos, validity)
├── Data saving: try/finally CSV incremental writing
```

### Expected data column

| Column | Type | Description |
|--------|------|-------------|
| cue_pos | int | cue position (0=left, 1=right) |
| target_pos | int | Target position (0=left, 1=right) |
| validity | str | Clue validity: `"valid"` or `"invalid"` |
| soa | float | clue-target SOA (ms) |
| rt | float | reaction time (ms) |
| acc | int | Correct response=1, Error=0 |
| trial_index | int | Trial number (0-based) |
| block | int | Block number |
