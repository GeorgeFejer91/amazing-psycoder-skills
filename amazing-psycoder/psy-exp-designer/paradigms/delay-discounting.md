# Delay Discounting Task (Temporal Discounting)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/delay-discounting) · reference

## When to Use

User mentions: Delay discounting, temporal discounting, intertemporal choice, impulsivity, delay discounting, temporal discounting. Measures the tendency to devalue rewards as a function of the delay until their receipt — the preference for smaller-sooner rewards over larger-later ones.

## Core Logic

Participants make a series of binary choices between a smaller reward available immediately (e.g., "$20 today") and a larger reward available after a delay (e.g., "$50 in 30 days"). The immediate amount, the delayed amount, and the delay length are systematically varied across trials. The key dependent variable is the indifference point at each delay — the immediate amount at which the participant is equally likely to choose either option (i.e., the subjective value of the delayed reward).

Delay periods typically range from days to years (e.g., 1 day, 1 week, 1 month, 6 months, 1 year, 5 years). By plotting subjective value against delay, the discounting rate (k) is estimated using a hyperbolic discounting function: V = A / (1 + kD), where V is subjective value, A is the delayed amount, D is delay, and k is the discounting rate. Higher k values indicate steeper discounting (greater impulsivity).

The task can be administered as a titration procedure (adjusting the immediate amount based on previous responses to converge on the indifference point) or as a full factorial design (all combinations of amounts and delays). This implementation uses a fixed choice set: each trial displays two options as labeled buttons (ButtonStim) side by side — e.g., "£5 now" vs. "£7 in 3 days". The condition file (`conditions.xlsx`) specifies the text labels in `amount1` and `amount2` columns. Participants click the button corresponding to their preferred option. No accuracy feedback is given, as there are no correct or incorrect answers — this is a preference measure. Trials are presented once in random order (`nReps=1.0`, `method='random'`).

## Must Confirm

- **Reward amounts**: What range of amounts? (e.g., $10-$100, or hypothetical larger sums?)
- **Delay values**: Which delay durations? (e.g., 1 day, 1 week, 1 month, 6 months, 1 year, 5 years)
- **Choice format**: Fixed choice pairs from a condition file, or adaptive titration?
- **Reward type**: Money, food, drugs, or other commodity?
- **Response mode**: Mouse click on labeled buttons, or keyboard selection?
- **Hypothetical vs. real**: Hypothetical choices, or one randomly selected trial is paid out for real?
- **No feedback**: Correct — no correct/incorrect answers in this paradigm.

## Trial Window Timeline

```text
┌──────────────────────────────────────────────────────────────────────┐
│ Single Trial                                                          │
│                                                                       │
│ Content: two options as labeled buttons                              │
│   Left button: amount1 label (e.g., "£5 now")                        │
│   Right button: amount2 label (e.g., "£7 in 3 days")                 │
│ Duration: until click                                                 │
│ Response: mouse click on chosen button                               │
│ Condition: {amount1, amount2} from conditions.xlsx                   │
│ Data: chosen_button, RT                                               │
│                                                                       │
│ Note: no fixation, no feedback, no ITI — immediate advance to        │
│ next trial on response. Pure preference measure.                      │
└──────────────────────────────────────────────────────────────────────┘
```

## Data Analysis

Fit the hyperbolic discounting model to estimate k for each participant (or compute area under the curve, AUC, as a model-free alternative). Log-transform k due to positive skew. Compare k between clinical groups (substance use disorders, ADHD, gambling disorder, obesity) and controls. Steeper discounting is consistently associated with addictive and impulsive behaviors. Also examine whether discounting rate varies by reward type (money, food, drugs) in relevant populations.

## References

Mazur, J. E. (1987). An adjusting procedure for studying delayed reinforcement. In M. L. Commons, J. E. Mazur, J. A. Nevin, & H. Rachlin (Eds.), *Quantitative analyses of behavior, Vol. 5. The effect of delay and of intervening events on reinforcement value* (pp. 55–73). Lawrence Erlbaum.

Kirby, K. N., Petry, N. M., & Bickel, W. K. (1999). Heroin addicts have higher discount rates for delayed rewards than non-drug-using controls. *Journal of Experimental Psychology: General, 128*(1), 78–87. https://doi.org/10.1037/0096-3445.128.1.78

## Do Not Assume

- Don't assume the reward type must be monetary. Rewards in delayed discounting tasks can be food, cigarettes, alcohol, drugs, or other goods. There may be systematic differences in discount rates across reward types (e.g., substance users discount drugs at significantly higher rates than money). The specific type of reward must be confirmed before generating a code.
- Do not assume that the selection format must be a fixed selection set. While most implementations use a predefined condition file listing all amount-delay combinations (full factorial design), there are also studies using an adaptive titration procedure - the instant amount is dynamically adjusted based on the previous selection to approach the indifference point. Be sure to confirm which format the user expects.
- Do not assume that all trials are hypothetical choices. In some designs, a trial is randomly drawn after the experiment to actually cash out (real payout) the participant's choice, which may yield a different discount rate than a purely hypothetical choice. Confirm whether real payment trials are included.
- Don't assume that the immediate option is always on the left. The left and right positions of the immediate and delayed options should be counterbalancing across trials to control for position preference bias. Verify that the conditions file already contains position-balanced trials, or if you need code to randomize left and right positions at runtime.
- Do not assume there is no reaction time limit. Although preference measurement tasks typically do not have a response deadline, some implementations set a maximum response window (e.g., 4000 ms) and flag or reject responses that are too fast below the expected threshold (e.g., RT < 200 ms). Confirm whether response time limits are required.
- Do not assume that all delays use the same time unit. Delays may be measured in days, weeks, months or years. Column naming in the conditions file and subsequent data analysis (such as the dimensions of the k values) must be consistent with the actual units used. The time unit to confirm the delay.
The columns in the

## Condition File Columns

condition file (xlsx/csv) that define the choice pairs for each trial:

| Column | Type | Description |
|--------|------|-------------|
| amount1 | str | The text label of the left button (such as "¥20 now" or "¥20 today") |
| amount2 | str | Text label of the button on the right (such as "¥50 in 30 days" or "¥50 in 30 days") |
| delay_days | int | Number of delay days (waiting time for the delay option, if the unit is not days, adjust the column name accordingly) |
| immediate_amount | float | The amount value of the immediate option (used for subsequent k-value fitting) |
| delayed_amount | float | The amount value of the delayed option (used for subsequent k-value fitting) |

## Variants

- **Fixed-Choice Delay Discounting**: The most commonly used implementation. All combinations of immediate amounts, delayed amounts, and delayed times are prespecified in the condition file and presented in random order. Each trial is an independent binary choice without adaptive adjustment. Data analysis estimated k values ​​by fitting a hyperbolic discount model V = A / (1 + kD), or calculated the area under the curve (AUC) as a model-free surrogate. This document mainly describes this variant.
- **Titrating/Adjusting Delay Discounting**: The instant reward amount is dynamically adjusted based on the participant's previous choices under the same delay condition to approach the indifference point. For example, if a participant chooses a delayed reward, the immediate amount will be increased next time; if a participant chooses an immediate reward, the immediate amount will be reduced. Reference is made to Mazur (1987) for the adjustment procedure. This variation reduces the total number of trials but requires more complex inter-trial logic. May be cross-referenced to staircase.md.
- **Cross-Commodity Delay Discounting**: The same participant completes delay discounting tasks for different reward types (such as money, food, cigarettes, alcohol). Each item is presented in a separate block, or the item type is used as a trial condition variable. Domain specificity used to examine discount rates. Can be cross-referenced to concurrent-schedule.md.

---

## Example

### User Request

> "I want to do a delay discount experiment, using PsychoPy. There is a button on the left and right of the screen. The left is an immediate smaller reward (such as 'Get ¥30 now'), and the right is a delayed larger reward (such as 'Get ¥100 after 90 days'). The delayed reward amount is fixed at ¥100. The delay time includes five levels: 7 days, 30 days, 90 days, 180 days, and 365 days. At each delay level, the immediate amount starts from ¥10 to ¥95 (in steps of ¥5). All trials were presented with a 500ms fixation point '+' before the experiment started and acknowledgment was displayed after the experiment. No feedback.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Fixation                 │    │ Choice Display           │    │ ITI                      │
│ Content: + │ │ Content: left and right buttons │ │ Content: blank │
│ Duration: 500 ms │ │ Left: Instant reward text │ │ Duration: 500 ms │
│ Response: none │ │ Right: Delay reward text │ │ Response: none │
│ File: none │ │ Duration: Until click │ │ File: none │
│ Condition: none │ │ Response: Mouse click button │ │ Condition: none │
│ Data: none               │    │ File: none               │    │ Data: none               │
│                          │    │ Condition: {amount1,      │    │                          │
│                          │    │   amount2, delay_days}    │    │                          │
│                          │    │ Data: chosen_button,      │    │                          │
│                          │    │   choice_rt,              │    │                          │
│                          │    │   chose_immediate         │    │                          │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Fixation | + | 500 ms | none | none | none | none |
| Choice Display | Left and right buttons (immediate vs delayed) | Until mouse click | Mouse click left/right button | none | {amount1, amount2, delay_days, immediate_amount, delayed_amount} | chosen_button, choice_rt, chose_immediate |
| ITI | Blank | 500 ms | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Delay Discounting Task (Delay Discounting Task) |
| Platform | PsychoPy |
| Task type | Delay Discounting / Intertemporal Choice (Delay Discounting / Intertemporal Choice) |
| Reward type | Money (¥) |
| Delayed amount | Fixed ¥100 |
| Delay levels | 7, 30, 90, 180, 365 days (5 levels) |
| Immediate amounts | ¥10–¥95 (step size ¥5, 18 levels in total) |
| Total trials | ~90 (5 delays × 18 immediate amounts; the combination of immediate amounts exceeding delayed amounts is reserved) |
| Choice format | fixed choice set (fixed choice set), randomly presented |
| Fixation duration | 500 ms |
| ITI duration | 500 ms |
| Response mode | Mouse click button (ButtonStim) |
| Phases | Instruction → Formal trials → End thanks |

### Missing Information

1. Do the left and right positions of the button need to be counterbalancing - does the same pair of amount and delay need to appear once in the left and right positions? The current description is not clear and requires confirmation.
2. The specific content of the instruction is not provided - it is necessary to confirm the text of the instruction, whether it contains sample trials, and the wording of the transition prompt.
3. Do responses that are too fast (such as RT < 200 ms) need to be marked or eliminated? The minimum reaction time threshold needs to be confirmed.

### Critical Assumptions

- The range of the instant amount is ¥10–¥95, with ¥5 as the step, a total of 18 instant amounts × 5 delays = 90 trials. Combinations in which the immediate amount exceeds the delayed amount (e.g. ¥95 now vs ¥100 in 7 days) remain in the design as this is a reasonable preference measure (the extreme case might be to select the immediate option all, reflecting extremely high discount rates).
- No practice trials, enter the formal experiment directly. This is consistent with the user description.
- There is no within-trial randomization of the left and right positions - the button text is determined directly from the amount1 (left) and amount2 (right) columns of the condition file. If left-right balancing is required, the condition file needs to include extra lines with swapped positions.
- No feedback, no extra space beyond the ITI fixation point. Advance directly between trials.
- The format of the button text label (such as "¥30 now" vs "¥100 in 90 days") is defined by the amount1/amount2 column of the condition file, and the code directly reads and displays it without additional formatting.

### Code Architecture

```
delay_discounting.py
├── Parameters (n_trials, fixation_dur=0.5, iti_dur=0.5, delayed_amount=100)
├── Window setup (full screen or window)
├── Stimulus preloading (TextStim for fixation +, ButtonStim × 2 for choice options)
├── Load condition file (conditions.xlsx: amount1, amount2, delay_days, immediate_amount, delayed_amount)
├── Instruction screen
├── Formal trial loop:
│   ├── Fixation (500 ms: +)
│ ├── Choice display (until mouse click: left button=immediate, right button=delayed)
│   ├── Record response (chosen_button, RT, chose_immediate)
│ └── ITI (500 ms: blank)
├── End thanks screen
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| amount1 | str | Left button text (such as "Now ¥30") |
| amount2 | str | Right button text (such as "¥100 after 90 days") |
| delay_days | int | Number of delay days |
| immediate_amount | float | Instant reward amount (¥) |
| delayed_amount | float | delayed reward amount (¥) |
| chosen_button | str | Clicked button label ("left" / "right") |
| choice_rt | float | Choice reaction time (seconds) |
| chose_immediate | int | 1=Choose immediate reward, 0=Choose delayed reward |
