# Choice Reaction Time Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/choice_reaction_time) · PsychoJS

## When to Use

User mentions: Choice reaction time, CRT, choice RT, Hick's law, Choice reaction time. Measures the speed of decision-making when participants must discriminate among multiple stimuli and select the corresponding response — unlike simple RT (one stimulus, one response), choice RT requires both stimulus discrimination and response selection.

## Core Logic

Participants respond to visual targets that appear at one of several possible screen positions. The target can be one of multiple stimulus types (e.g., cross, square, plus), each mapped to a different response. The task requires both stimulus identification (which shape?) and response selection (which key/position?), making it a measure of decision complexity beyond simple detection.

**This implementation** uses 3 target shapes (cross, square, plus) that appear at 4 possible positions arranged around the screen. Each shape is associated with a specific keyboard response: C, V, or B keys. Additionally, mouse clicks on the target position are accepted as a valid response. This dual-modality design allows measuring both stimulus-identity-driven (keyboard) and location-driven (mouse) response selection.

**Position cueing**: Before the target appears, outline placeholder tiles are shown at all 4 possible positions for 500 ms, cuing the participant to the possible target locations. The target then appears at one position for a brief 200 ms display window, requiring rapid encoding.

**Variable onset timing**: The target onset time (`onsetTime`) varies per trial as specified in the condition file, introducing temporal uncertainty and preventing anticipatory responses. Reaction time is calculated relative to this onset (`RT = keyResp.rt - onsetTime`).

**Two-block design**: Practice block (1 repetition of conditions) with detailed feedback showing RT, response type, and accuracy after each trial, followed by the experimental block (2 repetitions) with the same feedback. The practice and main blocks share the same trial structure and condition logic.

**Multi-alternative choice design**: 3 possible stimulus shapes, each mapped to a specific key. This is the key difference from simple RT (one stimulus, one key) -- the participant must recognize which shape appeared and select the correct response from multiple options. Hick's Law predicts that RT increases logarithmically with the number of response alternatives.

## Must Confirm

- **Stimulus shapes**: How many shapes, and which ones? (cross, square, plus -- or custom)
- **Stimulus positions**: How many locations on screen, and where?
- **Response modality**: Keyboard only, mouse only, or both? Which keys map to which shapes?
- **Target duration**: Brief flash (200 ms) or response-terminated display?
- **Onset timing**: Fixed SOA, variable from condition file, or immediate?
- **Position cueing**: Show position tiles before target (500 ms), or no pre-cue?
- **Trial count**: How many practice repetitions? How many experimental repetitions?
- **Feedback content**: RT, accuracy, response type -- or accuracy only?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Position Cues            │    │ Target Display           │    │ Feedback                 │
│ Content: 4 outline tiles │    │ Content: shape (cross/   │    │ Content: RT, response    │
│ at target positions      │    │ square/plus) at one      │    │ type, accuracy           │
│ Duration: 500 ms         │    │ position                  │    │ Duration: ~1 s            │
│ Response: none           │    │ Duration: 200 ms         │    │ Response: none           │
│ Data: none               │    │ Response: key (C/V/B) or │    │ Data: none               │
│                          │    │ mouse click on position  │    │                           │
│                          │    │ Data: rt (from onsetTime)│    │                           │
│                          │    │ key, acc, response_type  │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

Primary analyses should follow the confirmed estimand. A common choice is RT as a function of the number of response alternatives, motivated by Hick's Law (`RT = a + b * log2(N)`), with accuracy analyzed separately or jointly as specified in the analysis plan. Shape, response modality, temporal uncertainty, and individual-difference effects are optional hypotheses rather than assumed findings. Do not impose universal accuracy or RT-difference thresholds: define exclusion and quality rules from the protocol, task parameters, measurement evidence, and cited literature before seeing condition effects.

## References

Hick, W. E. (1952). On the rate of gain of information. *Quarterly Journal of Experimental Psychology, 4*(1), 11-26. https://doi.org/10.1080/17470215208416600

## Do Not Assume

- Do not assume 3 shapes with 4 positions — The number of shapes and positions can be configured arbitrarily, 2-8 options are often used in classic Hick's law experiments
- Do not assume keyboard-only response — The mouse click position can also be used as a valid response. The dual-modal design (keyboard + mouse) is a feature of this implementation.
- Do not assume fixed onset stimulus — onsetTime changes from trial to trial according to the condition file, introducing time uncertainty, and you need to ask about the variable time interval range
- Do not assume response-terminated stimulus display — In this implementation, the target only flashes briefly for 200 ms, and the subject must continue to respond after the target disappears
- Do not assume position cues are always present — 500 ms position cues (outline tiles) are the default setting for this implementation, but some experimental designs may omit this stage
- Do not assume RT is calculated from stimulus onset — RT is calculated based on the onsetTime field in the conditions file (`RT = keyResp.rt - onsetTime`), rather than simply using the stimulus plot moment

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| shape | str | Target shape: `"cross"`, `"square"`, `"plus"` |
| position | str | Target position: such as `"left"`, `"right"`, `"top"`, `"bottom"` or coordinate value |
| correct_key | str | Correct keys corresponding to this shape: `"c"`, `"v"`, `"b"` |
| onsetTime | float/number | target onset time (seconds relative to the start of the trial), used for variable interval control |

## Variants

- **Simple RT)**: Only one stimulus type, one response key, mainly reducing stimulus discrimination and response selection requirements. The difference in RT between the two types of tasks depends on the stimulus, device, sample, and procedure and does not preset a fixed millisecond difference. See simple-reaction-time.md
- **Go/No-go CRT (CRT with Inhibition)**: A standard CRT that adds No-go trials that require an inhibitory response to a specific stimulus or target at a specific location. Reaction speed and inhibitory control were measured simultaneously. See [go-nogo.md](go-nogo.md)
- **Multi-dimensional CRT**: The stimulus changes in multiple dimensions (such as shape + color + location), and the subject needs to make a choice response based on one of the dimensions (task-related dimensions) while ignoring other dimensions (task-irrelevant dimensions). Can be used to study selective attention, conflict processing (such as Stroop or Flanker-like cross-dimensional interference)

---

## Example

### User Request

> "I want to do a choice reaction time experiment. There are 3 positions on the screen (left, right, bottom), and 3 types of graphics (circle, square, triangle) will appear randomly. Press the F key when you see the circle, the G key for the square, and the H key for the triangle. Each trial first presents the fixation point for 500 ms, and then the graphics appear. The graphics are displayed until the subject responds by pressing the key, with a timeout of 3000 ms is regarded as a false negative. If the key is pressed correctly, a red cross will be displayed in the center for 800 ms. The formal experiment will take 3 blocks of 40 trials each and use PsychoPy. The instructions are in Chinese.
> 
> (This request can directly generate code through the psy-exp-coder skill)

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Stimulus                 │    │ Feedback                 │    │ ITI                      │
│ Content: + │ │ Content: Circle/Square/Triangle │ │ Content: Red X (error only) │ │ Content: empty │
│ Duration: 500 ms │ │ at left/right/down position │ │ Duration: 800 ms │ │ Duration: 500-1000 ms │
│ Response: none           │    │ Duration: until key       │    │ Response: none           │    │ Response: none           │
│ Data: none │ │ Response: F/G/H keys │ │ Data: none │ │ Data: none │
│                          │    │ Timeout: 3000 ms          │    │                          │    │                           │
│                          │    │ Data: rt, key, acc        │    │                          │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Fixation | + | 500 ms | none | none | none |
| Stimulus | circle/square/triangle at left/right/bottom | until key (deadline 3000 ms) | F/G/H | {shape}, {position}, {correct_key} | rt, key, acc |
| Feedback | Red X (error trials only) | 800 ms | none | none | none |
| ITI | empty | 500-1000 ms random | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Three-figure selection reaction time experiment |
| Platform | PsychoPy |
| Task type | Choice RT (choice reaction time) |
| Stimulus shape | Circle, square, triangle |
| Stimulation position | Left, right, bottom (3) |
| Response mode | Keyboard keys: F (circle), G (square), H (triangle) |
| Fixation duration | 500 ms |
| Response timeout | 3000 ms |
| Error feedback | Red cross, 800 ms |
| Experimental phase | Instructions → Practice (20 trials) → Block1-3 (40 trials each) |
| ITI | 500-1000 ms random |

### Missing Information

1. The specific copy of the instruction is not provided → A standard Chinese instruction template will be used to explain the buttons corresponding to each graphic.
2. The operating system and font path are not provided → Assuming Chinese Windows/macOS, use the system default Chinese font (need to confirm the `Songti SC` or `SimHei` path)
3. It is not clear whether feedback will be given during the practice phase → Assuming that the practice has trial-by-trial feedback (including RT and correctness), the official block will only display a red cross when there is an error

### Critical Assumptions

- fixation duration 500 ms (explicitly mentioned by user in request)
- The stimulus disappears immediately after the subject presses the button (response-terminated display), and automatically enters the ITI after a timeout of 3000 ms.
- Each condition (shape × position) in each block is presented equally, and the order of trials is randomized.
- Correct trials do not display feedback and enter ITI directly; incorrect trials display a red cross for 800 ms and then enter ITI
- No position cuing, different from Pavlovia standard implementation

### Code Architecture

```
crt.py
├── Parameter definition (shape list, position list, key mapping, time parameter)
├── Window creation (Window)
├── Stimulus preloading (TextStim fixation points, ShapeStim graphics, TextStim feedback)
├── Condition table generation (shape × position full factor combination × number of repetitions)
├── Instructions presented
├── Trial cycle:
│ ├── Fixation point (500 ms)
│ ├── Target stimulus (key press to terminate, deadline 3000 ms)
│ ├── Error feedback (red cross 800 ms, error trials only)
│ └── ITI (500-1000 ms random)
└── Data saving (try/finally, incremental writing to CSV)
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| shape | str | stimulus shape ("circle"/"square"/"triangle") |
| position | str | Stimulation position ("left"/"right"/"bottom") |
| correct_key | str | Correct key ("f"/"g"/"h") |
| rt | float | Reaction time (ms), relative stimulus appearance moment |
| key_resp | str | The actual keys pressed by the subject |
| acc | int | Correctness (1=correct, 0=error, -1=timeout false negative) |
| timeout | int | Whether to time out (1=timeout, 0=normal response) |
