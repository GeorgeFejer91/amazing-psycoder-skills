# Mental Rotation Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/mental_rotation) · PsychoJS

## When to Use

User mentions: Mental rotation, spatial cognition, visuospatial processing, mental rotation, spatial cognition. Measures the ability to mentally rotate two-dimensional or three-dimensional objects, a classic paradigm in spatial cognition research.

## Core Logic

Participants view two stimuli presented side by side and must judge whether they are the same (identical) or different (mirror images). One stimulus is rotated relative to the other by varying angular disparities (e.g., 0, 45, 90, 135, 180 degrees). The key finding is that reaction time increases approximately linearly with the angle of rotation, suggesting analog mental transformation.

**This implementation** uses letter-like shapes (e.g., 'F') presented at various orientations — a simplified version of Shepard & Metzler's (1971) classic 3D block-figure paradigm. The left stimulus shows the original letter; the right stimulus shows either the same letter (rotated) or its mirror-reversed version (also rotated). Participants press 's' for same (identical) and 'd' for different (mirror image).

**Condition file** (`MentalRot.csv`): Specifies rotation angle, which image file to display for the left and right positions (`F.png` and `FR.png` for mirror image), and the correct answer. The `TrialHandler` iterates over this file with random or sequential order.

**Trial structure**: Two instruction screens → fixation → stimulus pair (left + right images, until response) → optional feedback → ITI.

**Rotation angle manipulation**: The condition file systematically varies angular disparity. The classic finding is a linear RT increase from 0 to 180 degrees, with a symmetrical decrease from 180 to 360 degrees, producing a peak at 180 degrees.

## Must Confirm

- **Stimulus type**: Letter-like shapes (F, R, G), 3D block figures (Shepard-Metzler style), or abstract polygons?
- **Response mapping**: 's'/'d' for same/different, or arrow keys for left/right judgment, or different mapping?
- **Rotation angles**: Which angular disparities? (typically 0, 45, 90, 135, 180 degrees, in both clockwise and counterclockwise directions)
- **Mirror stimuli**: Is the "different" condition always a mirror image, or can it be a different letter entirely?
- **Trial count**: How many trials per angle? How many repetitions?
- **Practice**: Practice block with feedback before formal trials?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Stimulus Pair            │    │ Feedback (optional)      │    │ ITI                      │
│ Content: + at center     │    │ Content: F (left)        │    │ Content: correct/incorrect│   │ Content: blank           │
│ Duration: 500 ms         │    │   rotated F/R (right)    │    │ Duration: 500 ms         │    │ Duration: 500-1000 ms    │
│ Response: none           │    │ Duration: until key      │    │ Response: none           │    │ Response: none           │
│ Condition: none          │    │ Response: s=same, d=diff │    │ Condition: none          │    │ Condition: none          │
│ Data: none               │    │ Condition: {angle, pair} │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    │ Data: rt, key, acc       │    └──────────────────────────┘    └──────────────────────────┘
                                └──────────────────────────┘
```

## Data Analysis

Plot mean RT as a function of rotation angle (expect a peak-shaped function, linear increase peaking at 180 degrees, then decreasing back toward 0/360). Compute the mental rotation slope (ms/degree) via linear regression on same-pair trials. Compare slopes and intercepts between groups (e.g., sex differences — males typically show faster rotation speed). Also analyze accuracy, which tends to decrease at larger angular disparities.

## References

Shepard, R. N., & Metzler, J. (1971). Mental rotation of three-dimensional objects. *Science, 171*(3972), 701–703. https://doi.org/10.1126/science.171.3972.701

Gray, J. R., & Pasmanter, N. R. (2013). Mental rotation demo. Michigan State University.

## Do Not Assume

- Do not assume the "different" condition always uses mirror-reversed images — in some designs, "different" means a completely different character (e.g., F vs G), not a mirror image of the same letter
- Do not assume rotation angles are symmetric (0-360 in both directions) — some experiments only use 0-180 degrees in one direction, or a subset of angles (e.g., only 0, 60, 120, 180)
- Do not assume same/different response mapping ('s'/'d') — some variants use left/right arrow keys, or ask participants to judge whether the rotated stimulus matches a standard orientation target
- Do not assume the stimuli are 2D letter shapes — the Shepard-Metzler classical paradigm uses 3D block figures rendered at various depth rotations, which differ substantially in visual complexity and cognitive processing
- Do not assume feedback is always shown — in formal blocks, feedback is often omitted to avoid learning effects or speed-accuracy trade-off confounds
- Do not assume identical trial counts across angles — some designs oversample larger angular disparities where errors are more frequent, to ensure sufficient data for psychometric fitting

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| angle | int | Rotation angle (degrees), such as 0, 45, 90, 135, 180 |
| left_stim | str | The file name of the left stimulus image, such as `F.png` |
| right_stim | str | Right stimulus picture file name, such as `F.png` (same) or `FR.png` (mirror) |
| correct_resp | str | Correct response key, `'s'` means the same, `'d'` means different |
| condition | str | Condition type: `"same"` or `"different"` (or `"mirror"`) |

## Variants

- **Shepard-Metzler Classic 3D Edition**: Uses a three-dimensional figure composed of multiple cubes, with stimulus pairs rotating in three-dimensional space. Participants judged whether two figures could coincide with each other through rotation (same object) or be mirror images of each other (different objects). This is the most classic mental rotation paradigm in cognitive psychology. It has high visual complexity and requires stronger spatial imagination ability. To implement this version, you need to prepare a set of 3D rendered multi-angle images.
- **Letter/Character Rotation (2D Symbols)**: Use letters (F, G, R) or abstract symbols with the original or rotated shape on one side and the rotated shape or mirrored version on the other side. The stimulation is simple and easy to standardize, and it is widely used in online experiments and clinical evaluations. This document mainly covers this version.
- **Hand/Body Rotation Version**: A picture of a human hand (or foot) is presented, and participants need to judge whether it is the left hand or the right hand (or left foot/right foot) in the picture. This type of task activates motor imagination and body schema brain areas, involves embodied cognitive processes, and is different from the cognitive mechanism of classic object mental rotation. For reference to reaction time analysis logic, see the data analysis section of [go-nogo.md](go-nogo.md).

## Example

### User Request

> "I am going to do a mental rotation experiment. Two pictures of the letter 'F' are presented simultaneously on the left and right sides of the center of the screen. The left side is always the normally oriented F, and the right side is the rotated F (which may be the original graphic or the mirrored graphic). Participants need to judge whether the two graphics are exactly the same (ignore the rotation). Press the 's' key if they are the same, and press the 'd' key if they are different (mirror). The rotation angles include 0, 45, 90, 135, 180 degrees (one set each for clockwise and counterclockwise). A total of 6 blocks, 48 trials each. The fixation point is presented for 500ms before the trial starts, and the ITI is randomly presented for 600-1000ms. Use PsychoPy.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation │ │ Stimulus Pair │ │ Feedback (Practice only) │ │ ITI │
│ Content: + │ │ Content: F (left) │ │ Content: True/False │ │ Content: Blank │
│ Duration: 500 ms │ │ rotated F/FR (right) │ │ Duration: 800 ms │ │ Duration: 600-1000 ms │
│ Response: none           │    │ Duration: max 3000 ms    │    │ Response: none           │    │ Response: none           │
│ Condition: none          │    │ Response: s=same, d=diff │    │ Condition: none          │    │ Condition: none          │
│ Data: none               │    │ Condition: {angle, cond.}│    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    │ Data: rt, key, acc       │    └──────────────────────────┘    └──────────────────────────┘
                               └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Fixation | + | 500 ms | none | none | none |
| Stimulus Pair | F (left) + rotate F/FR (right) | max 3000 ms (until key pressed) | s (same) / d (different) | {angle, left_stim, right_stim, correct_resp, condition} | rt, key, acc |
| Feedback | True/False (exercise only) | 800 ms | none | none | none |
| ITI | blank | 600-1000 ms random | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Letter mental rotation task |
| Platform | PsychoPy |
| Task Type | Mental Rotation |
| Stimulus type | Letter F (normal orientation vs. mirrored version) |
| Rotation angle | 0, 45, 90, 135, 180 degrees (clockwise/counterclockwise) |
| Reaction mapping | s = same, d = different |
| Stimulus presentation duration | Maximum 3000 ms (terminated by key press) |
| Trial structure | Fixation point (500ms) → Stimulus pair (≤3000ms) → Feedback (only practice) → ITI(600-1000ms) |
| Number of trials | 6 blocks × 48 trials = 288 official trials + 10 practice |
| Feedback | Practice phase only |

### Missing Information

1. The rest between blocks is not specified - it is assumed that the rest interface is displayed after each block, and the user presses the button to continue.
2. The guidance is not provided - the content and presentation method of the guidance need to be confirmed (text + schematic prompt?)
3. The stimulus picture is not provided - it is necessary to confirm that the angle picture file has been prepared (a total of 20 pictures of the 0°/45°/90°/135°/180° version of F and its mirror corresponding version)

### Critical Assumptions

- The left stimulus is always the normally oriented F (0°), the right side is the rotated F or mirrored F. If the left side also needs to be rotated, you need to confirm the angle configuration additionally.
- A set of angles for clockwise/counterclockwise means that there are trials in two directions for each angle (such as 45° clockwise and 45° counterclockwise). The condition arrangement requires pre-specified orientation markers in the condition file
- Response time exceeding 3000ms is considered a timeout (no response) and is recorded as a missing value (accuracy=0, rt=NaN)

### Code Architecture

```
mental_rotation.py
├── Parameter configuration (angles, response_keys, timing, n_blocks)
├── Window and monitor settings (full screen/window)
├── Stimulus preloading (ImageStim object, loaded by angle and type)
├── Conditional file reading (MentalRot.csv, including angle, left_stim, right_stim, correct_resp, condition)
├── Trial cycle:
│ ├── Fixation point (500 ms — TextStim "+")
│ ├── Stimulus pair presentation (max 3000 ms — left + right ImageStim)
│ ├── Response collection (Keyboard, keys=["s", "d", "escape"])
│ ├── Feedback (Practice only - 800 ms text feedback)
│ └── ITI (600-1000 ms random - blank screen)
├── Rest between blocks (user presses button to continue)
├── Data saving: try/finally write to CSV line by line
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| angle | int | rotation angle (degrees) |
| condition | str | `"same"` or `"different"` |
| left_stim | str | left stimulus file name |
| right_stim | str | Right stimulus file name |
| correct_resp | str | Correct response key |
| rt | float | reaction time (seconds) |
| key_resp | str | actual key |
| acc | int | Correctness (1=correct, 0=wrong) |
| block | int | Block number |
| trial | int | trial number in Block |
