# Children Flanker Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/children_flanker_task) · PsychoJS

## When to Use

User mentions: Children flanker, child flanker, fish flanker, kids attention task, children flanker task, children attention task. A child-friendly adaptation of the Eriksen flanker paradigm using fish images instead of abstract arrows, designed for developmental populations and pediatric research.

## Core Logic

This is a flanker task adapted for children. Instead of arrows or letters, participants see a row of five fish. The central fish is the target; the four flanking fish (two on each side) point either in the same direction (congruent) or opposite direction (incongruent). The child presses the left or right arrow key to indicate the direction of the middle fish only, ignoring the flanking fish.

**Child-friendly design features**:
- Fish images (`leftFish.png`, `rightFish.png`) replace abstract arrow stimuli, making the task intuitive for young children
- A colorful, engaging background replaces neutral grey/black
- A progress counter (e.g., "Fish 12 / 48") is displayed throughout to maintain motivation
- Transparent spacer images (`transparent.png`) maintain consistent horizontal spacing even when fish are not present

**Trial structure**: fixation → five-fish display (center target + four flankers) → keypress response (left/right arrow) → ITI. The condition file (`conditions.csv`) defines each trial's target direction, flanker direction, and correct answer (`corrAns`).

**Two-phase design**:
1. **Practice block**: Trials with trial-level feedback (correct/incorrect text shown after each response). An instruction screen precedes practice.
2. **Main experimental block**: Trials without feedback. A gap/routine screen separates practice from the main phase.

**The Flanker effect**: Incongruent trials (target left, flankers right, or vice versa) yield slower and less accurate responses than congruent trials (all fish pointing the same direction). The flanker interference effect (incongruent RT – congruent RT) indexes selective attention and inhibitory control in children.

## Must Confirm

- **Age range**: What ages? (influences instruction wording, trial count, and response deadline)
- **Stimuli**: Fish images, animal images, or other child-friendly stimuli?
- **Trial count**: How many practice trials? How many experimental trials? (fewer for younger children)
- **Congruency ratio**: 50:50 congruent:incongruent, or include neutral condition?
- **Response deadline**: Child-friendly deadline (e.g., 3000 ms) or no deadline?
- **Feedback**: Practice-only feedback, or feedback throughout? Verbal encouragement between blocks?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Fish Stimuli             │    │ Feedback (practice only) │    │ ITI                      │
│ Content: + at center     │    │ Content: 5 fish in row   │    │ Content: correct/incorrect│   │ Content: blank           │
│ Duration: 500 ms         │    │ ←←←←← or ←←→←←           │    │ + progress counter       │    │ Duration: 500-1000 ms    │
│ Response: none           │    │ Duration: until key      │    │ Duration: 500 ms         │    │ Response: none           │
│ Condition: none          │    │ (deadline ~3000 ms)      │    │ Response: none           │    │ Condition: none          │
│ Data: none               │    │ Response: left/right key │    │ Condition: none          │    │ Data: none               │
└──────────────────────────┘    │ Condition: {congruency}  │    │ Data: none               │    └──────────────────────────┘
                                │ Data: rt, key, acc       │    └──────────────────────────┘
                                │   trial_counter          │
                                └──────────────────────────┘
```

## Data Analysis

Compute flanker interference scores for RT (incongruent RT – congruent RT) and accuracy. Children typically show larger interference effects than adults, reflecting developing inhibitory control. Analyze age-related changes in the flanker effect. Error trials and post-error trials are important for understanding response monitoring development. Compare to adult flanker norms to assess developmental trajectories.

## References

Eriksen, B. A., & Eriksen, C. W. (1974). Effects of noise letters upon the identification of a target letter in a nonsearch task. *Perception & Psychophysics, 16*(1), 143–149. https://doi.org/10.3758/BF03203267

Rueda, M. R., Fan, J., McCandliss, B. D., Halparin, J. D., Gruber, D. B., Lercari, L. P., & Posner, M. I. (2004). Development of attentional networks in childhood. *Neuropsychologia, 42*(8), 1029–1040. https://doi.org/10.1016/j.neuropsychologia.2003.12.012

## Don’t assume

- Don't assume that the stimulus must be a picture of a fish - Flanker for Kids may use arrows, animals or other child-friendly stimuli, please clearly confirm the specific image material (leftFish.png / rightFish.png or other)
- Do not assume that the ratio of consistent and inconsistent trials is 50:50 - the ratio needs to be clearly confirmed. Some studies may include neutral conditions (such as fish facing up/down), which affects the logic of condition file generation
- Don't assume that the reaction keys must be the left and right keyboard arrows - for younger children (3-4 years old), maybe use the large left and right buttons, a touch screen, or a gamepad
- Don't assume there will be feedback during the practice phase - confirm the feedback strategy: only practice feedback (standard practice), full feedback, or no feedback (some studies intentionally omit it to avoid feedback interference)
- Do not assume that the children's version has a no-response cutoff time - the children's version usually sets a longer cutoff time (such as 3000 ms), but the specific value needs to be confirmed. No cutoff may lead to too long trials
- Don’t assume that the two-stage design (practice + formal) is necessarily applicable - some experiments may include multiple formal blocks, break prompts, or "gamification" transition interfaces

## Condition file column

Columns required to drive each trial in condition file (csv/xlsx):

| column name | type | description |
|------|------|------|
| congruency | str | `"congruent"` or `"incongruent"`, whether the direction of the target fish and the flanking fish are consistent |
| target_dir | str | `"left"` or `"right"`, the direction of the middle target fish |
| corrAns | str | `"left"` or `"right"`, correct key answer (same as target_dir) |

## Variations

- **Standard Arrow Flanker**: The original Eriksen paradigm using arrows (←←←←← or ←←→←←) as stimuli, suitable for adult and adolescent subjects. Short response deadline (1000-1500 ms), no child-friendly design elements. See [eriksen-flanker.md](eriksen-flanker.md)
- **Fish Flanker (Children's Edition)**: Use fish pictures instead of arrows, with a colorful background and progress counter, suitable for children aged 3-8. That is the version described in this document. Long response deadline (~3000 ms), including trial progress display to maintain children's motivation
- **Emotional Flanker**: Use emotional faces or emotional words as flanking interference stimuli to measure the interference effect of emotional information on attentional control. Commonly used in developmental psychology and clinical research to assess the interaction of emotion regulation and cognitive control

---

## Example

### User request

> "I am going to do a children's Flanker task, and the subjects are children aged 5-7. A row of 5 fish is presented in the center of the screen, and the middle one is the target fish. The child needs to judge the direction of the middle fish and press the corresponding direction key. The directions of the fish on both sides may or may not be consistent with the middle. First 2 0 practice trials with feedback, and 3 formal blocks of 40 trials each. The fixation point is 500ms, the stimulus is presented until the button is pressed (up to 3000ms), and the ITI is randomly 800-1200ms. "

### Trial window timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1 │ → │ Window 2 │ → │ Window 3 │ → │ Window 4 │
│ Fixation point │ │ Fish stimulation │ │ Feedback (only practice phase) │ │ ITI │
│ Content: + │ │ Content: 5 fish in a row │ │ Content: Correct/wrong + Progress │ │ Content: Blank │
│ Duration: 500 ms │ │ Duration: until key │ │ Duration: 500 ms │ │ Duration: 800-1200 ms │
│ Response: None │ │ (cut-off 3000 ms) │ │ Response: None │ │ Response: None │
│ Condition: None │ │ Response: Left/right key │ │ Condition: None │ │ Condition: None │
│ Data: None │ │ Condition: {congruency} │ │ Data: None │ │ Data: None │
└───────────────────────────┘ │ Data: rt, key, acc, │ └───────────────────────────┘ └───────────────────────────┘
                                │       trial_counter        │
                                └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|------|------|------|------|------|------|
| fixation point | + | 500 ms | none | none | none |
| Fish stimulus | 5 fish (←←←←← or ←←→←←) | until key pressed (cut off 3000 ms) | left/right key | {congruency} | rt, key, acc, trial_counter |
| Feedback (Practice only) | Correct/wrong text + progress count | 500 ms | None | None | None |
| ITI | Blank | 800-1200 ms Random | None | None | None |

### Experimental specifications for analysis

| Field | Value |
|------|-----|
| Experiment Name | Children's Fish Flanker Task |
| Platform | PsychoPy |
| Task type | Flanker task (selective attention/inhibitory control) |
| Stimulus type | Fish pictures (leftFish.png, rightFish.png) |
| Consistent condition | The target fish and the flanking fish are in the same direction (←←←←←) |
| Inconsistent conditions | The target fish and the flanking fish are in opposite directions (←←→←←) |
| Practice trials | 20 (with trial secondary feedback) |
| Official trial | 3 blocks × 40 trials = 120 |
| Agree/disagree ratio | 50:50 (60 formal trials each) |
| Fixation point duration | 500 ms |
| Response deadline | 3000 ms |
| ITI | 800-1200 ms random |
| Stage sequence | Instructions → Practice (20) → Rest tips → Formal Block1-3 (40 each) |

### Missing information

1. The specific ratio of consistent/inconsistent trials is not clear - assuming 50:50, need to confirm with the user
2. The source of the fish picture material is not specified - you need to confirm whether to use the default material or user-defined picture
3. The transition interface between practice and formal stages is not mentioned - it is necessary to confirm whether there are rest prompts or words of encouragement

### Key assumptions

- The ratio of consistent and inconsistent trials is 50:50, no more than 2 consecutive inconsistent trials
- Trial-level feedback (correct/wrong text + progress count) is used in the practice phase, and there is no feedback in the formal phase
- The fish pictures use the default material (leftFish.png, rightFish.png), and the background uses a colorful natural theme background

### Code structure

```
children_flanker.py
├── Parameter settings (reaction key, cut-off time, proportion, duration, trial count)
├── Window settings (full screen/window, background color/picture)
├── Stimulus preloading (leftFish.png, rightFish.png, fixation point, feedback text, progress text)
├── Generate condition table (consistent: inconsistent = 50:50, randomly arranged, each block is independent)
├── Guidance interface (child-friendly wording + icons)
├── Practice loop (20 trials):
│ ├── Fixation point (500 ms)
│ ├── Fish stimulation (5 fish, until key press or 3000 ms cutoff)
│ ├── Feedback (correct/wrong + progress count, 500 ms)
│ └── ITI (800-1200 ms random)
├── Rest/transition interface
├── Formal block loop (3 × 40 trials):
│ ├── Fixation point (500 ms)
│ ├── Fish stimulation (5 fish, until key press or 3000 ms cutoff)
│ └── ITI (800-1200 ms random)
├── Data saving: try/finally incremental write to CSV
└── End interface (thank you + completion prompt)
```

### Expected data column

| column name | type | description |
|------|------|------|
| congruency | str | `"congruent"` or `"incongruent"` |
| target_dir | str | `"left"` or `"right"`, target fish direction |
| rt | float | Reaction time (milliseconds) from stimulus presentation to key press |
| acc | int | 1 for correct, 0 for error |
| trial_counter | int | Current trial count number |
| block_type | str | `"practice"` or `"formal"` |
| block_num | int | Block number (Practice=0, Official=1/2/3) |
