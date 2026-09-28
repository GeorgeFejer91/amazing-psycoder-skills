# Simon Paradigm

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)

## When to Use

User mentions: Simon task, Simon effect, spatial compatibility, spatial Stroop, stimulus-response compatibility, Simon task. Measures the ability to suppress a prepotent spatial response tendency when stimulus location conflicts with the required response hand/location.

**This file covers the Simon paradigm (spatial stimulus-response compatibility). For the Stroop paradigm (color-word interference), see [stroop.md](stroop.md). For the Eriksen Flanker paradigm (center-surround distractor interference), see [eriksen-flanker.md](eriksen-flanker.md).**

## Core Logic

Participants respond to a **non-spatial stimulus feature** (e.g., color) with a **spatial response** (left/right key or click). The stimulus appears at a location that is either:
- **Congruent**: Same side as the correct response (e.g., red = left key, red circle appears on left)
- **Incongruent**: Opposite side from the correct response (e.g., red = left key, red circle appears on right)

The **Simon effect** = RT_incongruent − RT_congruent. This indexes the ability to suppress the automatic tendency to respond toward the stimulus location.

**Critical distinction from other interference paradigms**: The Simon effect is driven by **spatial stimulus-response compatibility** — the conflict is between stimulus location and response location, not between competing stimulus features (Stroop) or between central and peripheral stimuli (Flanker).

**Response mode**: Keyboard (left/right keys) or mouse (click left/right circles). The key manipulation is the same regardless: the stimulus location is task-irrelevant.

## Must Confirm

1. **Stimulus feature to respond to**: Color (red/green), shape (circle/square), or other?
2. **Response mode**: Keyboard (left/right arrow keys) or mouse (click)?
3. **Stimulus positions**: Left/right only, or additional positions (top/bottom)?
4. **Response mapping**: Which color maps to which side?
5. **Stimulus shape**: Colored circles, squares, or images?
6. **Trial count**: How many congruent vs. incongruent trials? Total trials?
7. **Practice**: Include practice block with loop-until-correct?
8. **ITI duration**: Trial interval and variation range?
9. **OS & font**: What operating system is it running on? If using Chinese, confirm the font
10. **Display**: Full screen or window? Stimulus size and screen location?
11. **Instruction text**: Instruction content? How to explain response rules to subjects?

## Do Not Assume

- Do not assume keyboard response — many Simon tasks use mouse clicks
- Do not assume 50:50 congruency — some designs include neutral (center) positions
- Do not assume adult stimuli — the butterfly variant uses child-friendly images
- Do not assume the Simon effect will be large without sufficient trials per condition

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| target_color | str | Color or feature that determines correct response |
| stimulus_position | str | Screen position: `"left"`, `"right"` (or `"center"` for neutral) |
| congruency | str | `"congruent"`, `"incongruent"`, or `"neutral"` |
| correct_response | str | Correct key name or click target name |

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Fixation                 │    │ Simon Stimulus           │    │ Feedback                 │
│ Content: + at center     │    │ Content: colored circle  │    │ Content: "Correct!" or   │
│ Duration: 500-1000 ms    │    │ at left or right position│    │ "Incorrect" (500 ms)     │
│ Response: none           │    │ Duration: until response │    │ Response: none           │
│ Data: none               │    │ Response: left/right key │    │ Data: none               │
│                          │    │   or mouse click         │    │                           │
│                          │    │ Condition: {color}/{pos} │    │                           │
│                          │    │ Data: rt, key, acc       │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Fixation | + | 500-1000 ms | none | none | none |
| Simon Stimulus | colored shape at L/R position | until key (deadline ~2000 ms) | left/right key or mouse click | {target_color}, {stimulus_position} | rt, key, acc |
| Feedback | correct/incorrect | 500 ms | none | {correct_response} | none |

## Child-Friendly Butterfly Variant

A version for pediatric populations uses colorful butterfly images (`purple_butterfly.png`, `white_butterfly.png`, `yellow_butterfly.png`) instead of abstract colored shapes, with a nature-themed background (`background-1877877_1280.jpg`). The task logic is identical: press left key for one butterfly color, right key for another, ignoring the butterfly's screen position.

**Key differences from the standard Simon**:
- Stimuli: Butterfly PNG images (`visual.ImageStim`) instead of colored `ShapeStim` circles
- Response: Keyboard (keys 'z' and 'm') instead of mouse clicks
- Background: Engaging nature image replaces neutral grey
- Two-phase design: practice block with feedback followed by main experimental block without feedback
- Separate condition files: `practice_conditions.xlsx` and `conditions.xlsx`

The Simon effect, trial structure, and congruency manipulation remain identical.

## Data Analysis

Compute Simon interference scores:
- **Simon effect (RT)**: RT_incongruent − RT_congruent
- **Simon effect (accuracy)**: Accuracy_congruent − Accuracy_incongruent

Use paired t-test or 2 (congruency: congruent vs. incongruent) repeated-measures ANOVA. The Simon effect typically ranges from 20–60 ms in healthy adults. Larger effects are associated with poorer inhibitory control and are observed in aging, ADHD, and frontal lobe dysfunction.

## Randomization Checks

- Equal number of congruent and incongruent trials
- Equal number of left-position and right-position trials within each congruency condition
- No more than 3–4 consecutive same-response trials

## References

Simon, J. R., & Rudell, A. P. (1967). Auditory S-R compatibility: The effect of an irrelevant cue on information processing. *Journal of Applied Psychology*, *51*(3), 300–304. https://doi.org/10.1037/h0020586

Simon, J. R. (1969). Reactions toward the source of stimulation. *Journal of Experimental Psychology*, *81*(1), 174–176. https://doi.org/10.1037/h0027448

## Example

### User Request

> "I want to do a Simon experiment. A red/green circle appears on the left or right side of the screen, press the F key for red (left), and press the J key for green (right). Half and half of consistent conditions (red on the left, green on the right) and inconsistent conditions (red on the right, green on the left). 20 practice trials (with feedback) + 2 formal blocks of 60 trials each. Fixation point 500ms, stimulus presentation until the key (deadline) 2000ms), feedback 500ms, ITI random 500-1000ms. "

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Simon Stimulus           │    │ Feedback                 │    │ ITI                      │
│ Content: + │ │ Content: red/green circle │ │ Content: correct/wrong │ │ Content: empty │
│ Duration: 500 ms         │    │ Duration: until key      │    │ Duration: 500 ms         │    │ Duration: 500-1000 ms    │
│ Response: none           │    │ Response: f/j            │    │ Response: none           │    │ Response: none           │
│ Condition: none          │    │ Condition: {color}/{pos} │    │ Condition: none          │    │ Condition: none          │
│ Data: none               │    │ Data: rt, key, acc       │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Color-Position Simon Task |
| Platform | PsychoPy |
| Stimulus type | Colored circles (red/green) at left/right positions |
| Response mapping | F=red/left, J=green/right |
| Congruency ratio | 50:50 congruent:incongruent |
| Conditions | 2 target_color × 2 stimulus_position = 4 conditions |
| Blocks | Practice(20) → Block1-2(60 each) |
| Data columns | target_color, stimulus_position, congruency, correct_response, rt, key, acc |
