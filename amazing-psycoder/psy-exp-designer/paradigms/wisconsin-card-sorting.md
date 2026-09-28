# Wisconsin Card Sorting Test (WCST)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/wcst) · reference

## When to Use

User mentions: WCST, Wisconsin Card Sorting, set-shifting, cognitive flexibility, perseveration, Wisconsin Card Sorting, cognitive flexibility. The gold-standard neuropsychological test of executive function measuring the ability to form, maintain, and shift cognitive sets in response to changing reinforcement contingencies.

## Core Logic

Participants sort cards one at a time into one of four target piles. Each card varies on three dimensions: shape (e.g., triangle, star, cross, circle), color (e.g., red, green, yellow, blue), and number (1 to 4 symbols per card). The four target cards each represent a unique value on one dimension (e.g., one red triangle, two green stars, three yellow crosses, four blue circles). The participant is not told the sorting rule but receives feedback (correct/incorrect) after each sort.

The sorting rule (match by color, shape, or number) is initially set and maintained. After a criterion number of consecutive correct sorts (typically 10), the rule changes without warning. The participant must discover the new rule through trial and error using feedback alone. The core difficulty is suppressing the previously correct rule (set-shifting). Perseverative errors — continuing to sort by the old rule after it has changed — are the hallmark measure of cognitive inflexibility.

This implementation uses a nested two-loop design: an outer block loop (`chooseRule.xlsx`, 2 reps) sets the sorting rule, and an inner trial loop (`cards.xlsx`) presents cards in blocks of 7 forced trials (useRows selection). Each trial displays 4 reference cards at the top and 1 trial card below, all rendered as colored shapes at specified positions. A 1 s fixation precedes the card display, and the participant clicks on one of the 4 reference cards to indicate their sort. After each sort, feedback ("Correct!" or "Incorrect") is shown for 1 s. At the end of each block, the score is displayed for 3 s before the next block begins.

Key measures: number of categories completed (max 6), total errors, perseverative errors (continuing the old rule after a shift), failure to maintain set (losing the rule mid-category, i.e., 5+ correct followed by an error), and trials to complete the first category (initial conceptualization). The test continues until all 6 categories are completed or all 128 cards are used.

## Must Confirm

- **Stimulus dimensions**: Shape, color, and number — all three or a subset?
- **Number of dimensions and values**: 3 dimensions with 4 values each (shapes: triangle/star/cross/circle, colors: red/green/yellow/blue, numbers: 1/2/3/4)?
- **Trial cards**: How are trial cards generated — from a fixed deck (128 cards), or dynamically?
- **Trials per block**: Fixed number (e.g., 7 forced trials from chooseRule.xlsx) per rule, or continue until criterion (e.g., 10 consecutive correct)?
- **Response mode**: Mouse click on reference cards, or keyboard selection?
- **Feedback**: 1 s feedback after each trial, or no feedback?
- **Rule change**: How many rule shifts, and in what order?

## Trial Window Timeline

```text
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│ Window 1             │→ │ Window 2             │→ │ Window 3             │→ │ Window 4             │
│ Fixation             │  │ Card Sort            │  │ Feedback              │  │ Block End (every     │
│ Content: + at center │  │ Content: 4 reference │  │ Content: "Correct!"   │  │ 7 trials)            │
│ Duration: 1.0 s      │  │ cards (top) + 1      │  │ or "Incorrect"        │  │ Content: score       │
│ Response: none       │  │ trial card (bottom)  │  │ Duration: 1.0 s       │  │ Duration: 3.0 s      │
│ Data: none           │  │ Duration: until click│  │ Response: none        │  │ Response: none       │
│                      │  │ Response: click on   │  │ Data: none            │  │ Data: none           │
│                      │  │ a reference card     │  │                       │  │                      │
│                      │  │ Data: clicked_name,  │  │                       │  │                      │
│                      │  │ rt, acc              │  │                       │  │                      │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘  └──────────────────────┘
```

## Data Analysis

Primary outcome: number of perseverative errors (the most sensitive index of frontal lobe dysfunction). Also analyze categories completed, total errors, failure to maintain set, and learning-to-learn (improvement across categories). The WCST is highly sensitive to prefrontal cortex damage, particularly dorsolateral prefrontal cortex. Perseverative errors are elevated in schizophrenia, Parkinson's disease, ADHD, and traumatic brain injury.

## References

Grant, D. A., & Berg, E. A. (1948). A behavioral analysis of degree of reinforcement and ease of shifting to new responses in a Weigl-type card-sorting problem. *Journal of Experimental Psychology, 38*(4), 404–411. https://doi.org/10.1037/h0059831

Heaton, R. K., Chelune, G. J., Talley, J. L., Kay, G. G., & Curtiss, G. (1993). *Wisconsin Card Sorting Test manual: Revised and expanded*. Psychological Assessment Resources.

## Do Not Assume

- Do not assume 10 consecutive correct ones to complete the classification. Some versions use 6 or 8 consecutive corrects as the classification completion criterion to confirm the number of criteria.
- Do not assume that the sequence of rules is fixed. Color → Shape → Quantity is a common order, but the order of rules may be randomized or determined by experimental design.
- Do not assume all three dimensions are used. A simplified version might use only 2 dimensions (e.g. only color and shape), confirm the number of dimensions.
- Do not assume that all 128 cards are always used. Some versions terminated early after completing 6 categories, or used only 64 cards (WCST-64).
- Do not assume feedback is text only. Confirm feedback form: text ("correct"/"wrong"), voice, or both.
- Do not assume that the subject knows the three dimensions. Some experiments clearly inform the dimensions in the instructions, while some do not inform them at all. The content of the instructions needs to be confirmed.

## Condition File Columns

drives xlsx/csv file columns for each trial:

| Column | Type | Description |
|--------|------|-------------|
| rule | str | Current classification rule: `"color"`, `"shape"` or `"number"` |
| card_id | int | card number (1-128) |
| correct_target | str | Correct target card identification (such as `"red_triangle"`) |
| block | int | Block number (1-6, corresponding to 6 categories) |

## Variants

1. **Standard WCST (128 cards)**: Original version, using 128 paper cards, 4 values in each of 3 dimensions, and up to 6 classifications completed. The order of the rules is fixed (color → shape → quantity → color → shape → quantity). See [config-schema](../references/config-schema.md).

2. **Simplified version of MCST (Modified Card Sorting Test)**: Use only 48 cards, excluding those ambiguous cards that share multiple attributes with the target card (such as cards that match both color and quantity with the correct target). Reduces confusion and is more suitable for clinical populations, especially elderly or cognitively impaired patients. See [go-nogo.md](go-nogo.md) for feedback processing logic.

3. **Computerized WCST-64**: Uses only 64 cards (one deck per rule), reducing test time while maintaining psychometric properties. Suitable for screening scenarios with limited time.

---

## Example

### User Request

> "I want to do a Wisconsin card sorting test. 4 target cards (1 red triangle, 2 green stars, 3 yellow crosses, 4 blue circles) are displayed at the top of the screen, and 1 test card is displayed at the bottom. The subject clicks on the target card to sort. Each click "Correct" or "wrong" feedback is displayed for 1 second. The rules are automatically switched after 10 consecutive correct ones. A total of 6 categories are to be completed, and the subjects are not reminded to do 10 practice trials before the test. The subjects are native Chinese speakers.

### Trial Window Timeline

```text
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│ Window 1             │→ │ Window 2             │→ │ Window 3             │→ │ Window 4             │
│ Fixation point │ │ Card sorting │ │ Feedback │ │ Sorting completion prompts │
│ Content: + at center │ │ Content: 4 target cards │ │ Content: "Correct!" │ │ Content: "Classification completed! │
│ Duration: 1.0 s │ │ (top row) + 1 test card │ │ or "Error" │ │ New rules are about to start..." │
│ Response: none │ │ (lower row) │ │ Duration: 1.0 s │ │ Duration: 2.0 s │
│ Data: none           │  │ Duration: until click │  │ Response: none       │  │ Response: none       │
│                      │  │ Response: click on    │  │ Data: none           │  │ Data: none           │
│                      │  │ a target card        │  │                       │  │                      │
│                      │  │ Data: clicked_target, │  │                       │  │                      │
│                      │  │ rt, acc, rule        │  │                       │  │                      │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘  └──────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment Name | Wisconsin Card Sorting Test (WCST) |
| Platform | PsychoPy |
| Task type | Cognitive flexibility/set-shifting |
| Target card | 1 red triangle / 2 green star / 3 yellow cross / 4 blue circle (top row) |
| Test card | 1 card at a time, presented in the center below |
| Dimensions | 3 (color, shape, quantity), 4 values each |
| Reaction mode | Mouse click on the target card |
| Feedback | Text "correct"/"wrong", lasts 1 s |
| Classification completion standard | 10 consecutive correct |
| Total number of categories | 6 |
| Rule switching | Automatic, no reminder |
| Stage | Instructions → Practice (10 trials) → Formal test (up to 128 trials) |

### Missing Information

1. The duration of the fixation point is not specified → Default is 1.0 s (needs to confirm with the user)
2. The inter-trial interval (ITI) is not mentioned → Need to confirm whether there is an ITI and its duration
3. The feedback method in the practice stage is not specified → It is necessary to confirm whether the feedback in the practice stage is consistent with the feedback in the formal stage

### Critical Assumptions

- The order of the rules is Color→Shape→Quantity→Color→Shape→Quantity (standard WCST order)
- Feedback is also displayed during the practice phase and lasts 1 s
- The fixation point is black "+" and is centered
- There is no time limit for the subject's response (until click), but RT needs to be recorded
- During the practice stage, the first 10 cards are selected from the standard 128 cards without switching rules.

### Code Architecture

```
wcst.py
├── Parameters (dimensions, n_correct_to_shift=10, n_categories=6, n_practice=10)
├── Window settings (full screen/window, resolution)
├── Stimulus preloading
│ ├── 4 target cards (TextStim/ShapeStim + color fill)
│ ├── 128 test cards (generate all combinations by dimension)
│ └── Feedback text ("Correct!"/"Error")
├── Condition table generation (card_id, shape, color, number, rule, correct_target)
├── Main loop
│ ├── Rule management (current rules, continuous correct count, number of completed classifications)
│ ├── Trial cycle
│ │ ├── Fixation point (1.0 s)
│ │ ├── Display target card + test card (waiting for click)
│ │ ├── Judge correct/wrong (match the target card of the current rule)
│ │ ├── Feedback (1.0 s)
│ │ └── Check whether it reaches 10 consecutive correct → Switch rules
│ └── Termination conditions: 6 categories completed or 128 cards used up
├── Data saving: try/finally CSV, write line by line
└── Exit: Escape key monitoring
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| card_id | int | card number (1-128) |
| trial_index | int | Trial number (global) |
| block | int | Current classification number (1-6) |
| rule | str | Current classification rule (color/shape/number) |
| shape | str | Test card shape |
| color | str | Test card color |
| number | int | Number of test card symbols |
| correct_target | str | Correct target card ID |
| clicked_target | str | The target card ID clicked by the subject |
| acc | int | correct=1, error=0 |
| rt | float | reaction time (ms) |
| consecutive_correct | int | Current consecutive correct count |
| perseverative_error | int | Perseverative error = 1 (wrong with the current rule according to the old rule), otherwise = 0 |
| category_completed | int | Whether the category to which this trial belongs has been completed (1=yes) |
