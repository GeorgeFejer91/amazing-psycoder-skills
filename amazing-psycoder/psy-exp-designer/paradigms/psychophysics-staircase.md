# Psychophysics Staircase (Adaptive Threshold Estimation)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/staircase_demo) · PsychoJS

## When to Use

User mentions: Staircase, psychophysics, adaptive threshold, orientation discrimination, just noticeable difference, psychophysical staircase method, adaptive threshold. An adaptive psychophysical procedure that efficiently estimates sensory thresholds by adjusting stimulus intensity based on the participant's recent performance.

## Core Logic

The staircase procedure adaptively changes the difficulty of a perceptual discrimination task to converge on a participant's threshold. This implementation is a custom staircase (no built-in `MultiStairHandler`) that measures the minimal orientation difference at which a participant can distinguish between two tilted gratings.

**Task**: On each trial, two grating images are presented — one on the left and one on the right. One grating is tilted slightly clockwise, the other counterclockwise. The participant must indicate which side has the clockwise-tilted grating by pressing the left or right arrow key (2AFC — two-alternative forced choice).

**Staircase parameters** (all configurable in code):
- **Starting value**: 70 degrees (large initial orientation difference, easy to discriminate)
- **Step sizes**: [10, 5, 2, 1, 0.5] degrees — progressively finer steps across successive reversals for precise threshold estimation
- **Up/Down rule**: 1-up 1-down (converges to 50% threshold). Each correct response decreases the difference (makes it harder); each incorrect response increases the difference (makes it easier).
- **Number of reversals**: 5 — the staircase stops after 5 direction changes
- **Bounds**: min 0 degrees, max 90 degrees
- **Direction tracking**: Starts in "down" direction (decreasing orientation difference after correct responses)

**Reversals and threshold**: A "reversal" occurs when the staircase changes direction (from decreasing to increasing, or vice versa). The threshold is calculated as the average of the stimulus levels (orientation differences) at all reversal points. The first few reversals are sometimes excluded to allow the staircase to settle.

**Common staircase rules**:
- 1-up 1-down → converges to 50% threshold
- 2-up 1-down → converges to ~70.7% threshold (most common for detection tasks)
- 3-up 1-down → converges to ~79.4% threshold

**Safety limits**: A maximum number of trials (e.g., 100) serves as a safety net if the required number of reversals is not met.

## Must Confirm

- **Perceptual dimension**: Orientation discrimination (grating tilt), contrast detection, motion coherence, auditory frequency, or other?
- **Up/Down rule**: 1-up 1-down (50% threshold), 2-up 1-down (~70.7%), or 3-up 1-down (~79.4%)?
- **Starting value**: Large initial difference (easy) or near-threshold (faster convergence)?
- **Step sizes**: What step size sequence? Single fixed step or decreasing sequence?
- **Number of reversals**: How many reversals before stopping? (5-8 typical)
- **Maximum trials**: Safety limit on total trials?
- **Threshold calculation**: Average of all reversal values, or exclude first N reversals?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Grating Pair             │    │ Feedback (optional)      │    │ ITI                      │
│ Content: + at center     │    │ Content: 2 tilted        │    │ Content: correct/incorrect│   │ Content: blank           │
│ Duration: 500 ms         │    │   gratings (L and R)     │    │ Duration: 300 ms         │    │ Duration: 500 ms         │
│ Response: none           │    │ Duration: until key      │    │ Response: none           │    │ Response: none           │
│ Condition: none          │    │ Response: left/right key │    │ Condition: none          │    │ Condition: none          │
│ Data: none               │    │ Condition: {level}       │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    │   (orientation difference)│    └──────────────────────────┘    └──────────────────────────┘
                                │ Data: rt, key, acc,      │
                                │   level, direction       │
                                └──────────────────────────┘
```

## Data Analysis

The primary output is the threshold estimate (mean of reversal values). Plot the staircase trajectory (stimulus level vs. trial number) to visualize convergence. The threshold represents the just-noticeable difference (JND) for the perceptual dimension tested. Compare thresholds between conditions or groups. Check that the staircase converged (stable oscillation around threshold by final reversals) and that the number of trials was sufficient.

## References

Cornsweet, T. N. (1962). The staircase-method in psychophysics. *The American Journal of Psychology, 75*(3), 485–491. https://doi.org/10.2307/1419876

Levitt, H. (1971). Transformed up-down methods in psychoacoustics. *The Journal of the Acoustical Society of America, 49*(2B), 467–477. https://doi.org/10.1121/1.1912375

---

## Do Not Assume

- Do not assume the ladder method uses the 1-up 1-down rule. Although this is the default implementation of the custom ladder method, different upper and lower rules converge to different threshold levels. 1-up 1-down converges to the 50% accuracy threshold, 2-up 1-down converges to about 70.7%, and 3-up 1-down converges to about 79.4%. Specific rules must be confirmed before generating code, otherwise systematic biases in threshold estimates will be uncontrollable.
- Do not assume that the starting value is always large (easily identifiable). This implementation starts at 70 degrees (directional discrimination varies widely), but the starting value should be adjusted according to the specific perceptual dimension and subject population. A starting value that is too large will result in slow convergence of the ladder (more trials are needed to approach the threshold), and a starting value that is too small will result in incorrect responses in early trials and subject frustration. You need to confirm the task difficulty corresponding to the starting value.
- Do not assume that the step sequence is fixed. This implementation uses a sequence of decreasing steps of [10, 5, 2, 1, 0.5] degrees, but the choice of steps depends on the stimulus dimensions (contrast, spatial frequency, motion consistency, etc.) and the threshold desired accuracy. Fixed step sizes (e.g. 2 dB always) and decreasing sequences each have advantages and disadvantages, and the step size strategy needs to be confirmed.
- Do not assume that the threshold calculation uses the average of all reversals. Some ladder implementations will exclude the first 1-3 reversals (allowing the ladder to converge near the threshold before starting formal recording), and only use the last few reversals to calculate the threshold. You need to confirm whether to exclude the initial reversal and how the threshold is calculated (mean or median).
- Do not assume that the ladder method does not require a condition file. While the stimulation level of the traditional staircase method is completely determined by the subject's performance on the first few trials (adaptive), many modern implementations still require condition files to specify: starting values ​​for multiple cross-stairs, staircase IDs for each condition, or block-level parameter settings. Especially in staggered ladder designs, condition documentation is required.
- Do not assume that the perceptual dimension is always toward the grating tilt. This reference implementation uses orientation discrimination, but the ladder method is widely used in various psychophysical tasks such as contrast detection, motion coherence, auditory frequency discrimination, and tactile thresholds. Stimulus creation and staircase update logic differ substantially across perceptual dimensions.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| staircase_id | int | Staircase number, used to distinguish different staircases in staggered staircase design (such as different starting values ​​or different stimulation conditions). Single step design can be omitted |
| start_level | float | The starting stimulus level value of the staircase (such as the starting direction difference degree, starting contrast value, etc.), used to initialize the current level of the staircase |
| condition_label | str | The experimental condition label corresponding to this staircase (such as `"high_contrast_adapt"` or `"low_contrast_adapt"`), used for group analysis and data filtering |

## Variants

- **Transformed Up-Down Staircase**: Change the up-down rules to converge on different psychometric function points. Common variations include 2-up 1-down (converging to ~70.7% threshold), 3-up 1-down (converging to ~79.4% threshold), and weighted up-down methods (such as 1-up 2-down converging to ~29.3%). Suitable for detection and discrimination tasks that require estimating a specific threshold of accuracy (rather than the 50% point). Reference: Levitt (1971).
- **Interleaved Staircase**: Run 2-4 independent staircases at the same time, and the trials of each staircase are randomly interleaved. Different staircases can correspond to different stimulation conditions (such as different spatial frequencies, different adaptation states) or different starting values. The staggered design makes it impossible for subjects to predict which staircase the current trial belongs to, thereby reducing the interference of expectation bias and response strategies. Suitable for condition comparison experiments that require simultaneous measurement of multiple thresholds. Related paradigm: dual-task (shared logic of interleaved trials design).
- **Bayesian Adaptive Staircase (e.g., QUEST/Psi)**: Uses Bayesian inference to update the psychometric function posterior on a trial-by-trial basis and select the next stimulus level according to stated utility/information rules. It may increase the sampling efficiency of specific parameters, but the number of trials required depends on the prior, stimulus grid, guess/miss rate, true parameters, and target accuracy; it must be determined with parameter recovery or simulation, and cannot apply a fixed "20–40 vs. 60–100" commitment.

---

## Example

### User Request

> "I want to do a psychophysical ladder experiment with contrast detection. A fixation point is first presented in the center of the screen for 500 ms, and then a Gabor grating (sinusoidal grating, spatial frequency 2 cpd, Gaussian envelope sigma=2°) is presented in the center of the screen for 200 ms. The subject's task is to judge whether the grating is seen - press the 'z' key if they see it (yes), press '/' if they do not see it Key (No). Use 2-up 1-down ladder method, starting with 50% contrast (Michelson contrast), with an initial step size of 0.05 log units after the second reversal. Stop after a total of 8 reversals, with a maximum of 120 trials. Implemented with PsychoPy.

### Trial Window Timeline

```text
┌──────────────────────────────┐    ┌──────────────────────────────┐    ┌──────────────────────────────┐    ┌──────────────────────────────┐
│ Window 1                     │ →  │ Window 2                     │ →  │ Window 3                     │ →  │ Window 4                     │
│ Fixation point │ │ Stimulus presentation │ │ Response window │ │ ITI │
│ Content: + in the center of the screen │ │ Content: Gabor raster │ │ Content: blank screen │ │ Content: blank │
│ Duration: 500 ms │ │ (target contrast, 2 cpd) │ │ Duration: until key press or 3000ms │ │ Duration: 400-800 ms │
│ Response: None │ │ Duration: 200 ms │ │ Response: z(see)/ │ │ Response: None │
│ Condition: None │ │ Response: None │ │ /(not seen) │ │ Condition: None │
│ Data: None │ │ Condition: {contrast_level} │ │ Condition: {correct_resp} │ │ Data: None │
│                               │    │ Data: stimulus_onset_time   │    │ Data: rt, key, acc,         │    │                               │
│                               │    │                              │    │   contrast_level,           │    │                               │
│                               │    │                              │    │   reversal_count            │    │                               │
└──────────────────────────────┘    └──────────────────────────────┘    └──────────────────────────────┘    └──────────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Contrast detection ladder experiment |
| Platform | PsychoPy |
| Task Type | Psychophysical Ladder Method (Contrast Detection, 2AFC Yes/No) |
| Perceptual dimension | Contrast Detection |
| Stimulus type | Gabor grating (sinusoidal grating, spatial frequency 2 cpd, Gaussian envelope sigma=2°) |
| Up and down rules | 2-up 1-down (converging to ~70.7% threshold) |
| Starting Contrast | 50% Michelson Contrast |
| Step sequence | Initial 0.1 log unit, reduced to 0.05 log unit after the second reversal |
| Stop condition | 8 reversals / maximum 120 trials (safety limit) |
| Threshold calculation | Average of the last 6 reversals (excluding the first 2 reversals) |
| Stimulation duration | 200 ms |
| Fixation duration | 500 ms |
| Response deadline | 3000 ms |
| Response button | z (seen/yes), / (not seen/no) |

### Missing Information

1. The ITI duration is not clearly stated → Assuming 400–800 ms randomly distributed, the specific range needs to be confirmed with the user
2. Is it necessary to present a blank trial (catch trial, contrast = 0) at the beginning of the experiment to estimate the false alarm rate → The user has not mentioned it and needs to be confirmed. If a catch trial is included, its proportion and how the staircase responds to false alarms need to be defined.
3. Is it necessary to try secondary feedback → Feedback is usually not provided in psychophysical experiments to avoid response bias, but some designs use feedback during the practice phase or throughout the experiment. Need to confirm feedback strategy

### Critical Assumptions

- Contrast changes in steps of log10 units, with the ladder adding or subtracting steps to the current contrast level. The lower bound for contrast is 0.001 (0.1%) and the upper bound is 1.0 (100%). When the calculated contrast exceeds the boundary, it is clamped to the boundary value
- Fixation duration fixed at 500 ms (non-random), ITI random range 400–800 ms, pre-sampled at condition generation to ensure reproducibility
- The implementation logic of the 2-up 1-down rule: the contrast decreases (the difficulty increases) after 2 consecutive correct responses, and the contrast increases (the difficulty decreases) after 1 incorrect response. Reversal is defined as the point at which the direction of the ladder changes (from descending to ascending or vice versa). Threshold calculation excludes first 2 reversals

### Code Architecture

```
staircase_contrast.py
├── Parameter settings
│ ├── Ladder parameters: starting contrast (0.5), step sequence ([0.1, 0.05]),
│ │ Up and down rules (2-up 1-down), maximum reversal (8), maximum trials (120)
│ ├── Time parameters: fixation point (500 ms), stimulus (200 ms), response cutoff (3000 ms), ITI (400-800 ms)
│ └── Stimulation parameters: spatial frequency (2 cpd), Gaussian sigma (2°), Gabor size and phase
├── Window initialization (full screen or window, background set to gray to match average brightness)
├── Stimulus preloading
│ ├── TextStim: fixation point "+"
│ ├── GratingStim: Gabor grating (sinusoidal grating + Gaussian envelope, contrast is dynamically updated in trials)
│ └── TextStim: Instruction ("Press z if you see it, press / if you don't see it")
├── Ladder state initialization
│   ├── current_level ← start_level（0.5）
│ ├── step_index ← 0 (use the first step size of 0.1)
│   ├── reversal_count ← 0
│ ├── direction ← "down" (the initial direction is downward, and the contrast is reduced after continuous correctness)
│ ├── consecutive_correct ← 0 (tracks the number of consecutive corrects, used for 2-up rules)
│ └── reversal_values ← [] (record the contrast value of each reversal point)
├── Trial cycle:
│ ├── Fixation window (500 ms)
│ ├── Stimulus window (200 ms, Gabor grating presented at current_level contrast)
│   │   └── GratingStim.contrast ← current_level
│ ├── Response window (deadline 3000 ms, monitor z and / keys)
│ │ ├── record rt, key_resp
│ │ ├── Correct judgment: stimulus contrast > 0 and button z → acc = 1
│ │ │ or stimulus contrast == 0 (catch trial) and key / → acc = 1
│ │ └── Update staircase status (see staircase update logic below)
│ ├── ITI (400–800 ms random)
│ └── Check stop condition (reversal_count >= 8 or trial_count >= 120)
├── Ladder update logic (after each trial):
│ ├── If acc == 1:
│   │   ├── consecutive_correct += 1
│ │ └── If consecutive_correct >= 2 (2-up condition is met):
│ │ ├── If direction == "up" → reversal occurs, record reversal_values
│   │       ├── direction ← "down"
│ │ ├── current_level -= step_sizes[step_index] (reduce contrast, become more difficult)
│   │       └── consecutive_correct ← 0
│ ├── If acc == 0:
│ │ ├── If direction == "down" → reversal occurs, record reversal_values
│   │   ├── direction ← "up"
│ │ ├── current_level += step_sizes[step_index] (increase the contrast, make it easier)
│   │   ├── consecutive_correct ← 0
│ │ └── if reversal_count >= 2 → step_index ← 1 (switch to smaller step size 0.05)
│ └── Clamp current_level to the range [0.001, 1.0]
├── Threshold calculation: take the mean of the last 6 values in reversal_values
├── Data saving: CSV format, one line for each trial, including staircase status snapshot
└── Result summary: display estimated threshold limit value, total number of trials, staircase trajectory graph
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| trial_index | int | Trial number (starting from 0) |
| contrast_level | float | Contrast level for the current trial (linear units, 0.001–1.0) |
| log10_contrast | float | The contrast of the current trial (log10 units), easy to connect with the step size |
| stimulus_onset | float | stimulus start presentation time (relative to trial start, s) |
| rt | float | reaction time (ms, from stimulus onset) |
| key_resp | str | The actual key pressed by the subject (`"z"`, `"/"` or `None` means timeout) |
| acc | int | Accuracy rate (1 = correct, 0 = error or timeout) |
| reversal_count | int | The number of reversals that have occurred as of the current trial |
| direction | str | Current ladder direction (`"up"` or `"down"`) |
| consecutive_correct | int | Current number of consecutive correct responses (used for 2-up rule judgment) |
| step_size | float | The currently used step size (log units) |
| timeout | int | Whether to time out (1 = timeout, 0 = react within the deadline) |
