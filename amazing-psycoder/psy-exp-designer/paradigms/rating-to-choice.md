# Rating-to-Choice Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/rating_to_choice_task) · PsychoJS

## When to Use

User mentions: Rating to choice, two-phase preference, painting rating, adaptive choice, rating-to-choice task. A two-phase decision-making paradigm where participants first rate individual stimuli and then make pairwise choices between stimuli selected based on their own ratings, demonstrating dynamic stimulus selection driven by participant responses.

## Core Logic

The task comprises two sequential phases linked by the participant's own rating data:

**Phase 1 — Rating Phase**: Participants view a set of stimuli (e.g., paintings — European art and nature scenes from Unsplash and museum collections) one at a time and rate each on a 3-point scale. They press keys 1, 2, or 3 to assign a rating. Each rating-keypress is stored alongside the image filename. The rating data from this phase serves as input to Phase 2.

**Phase 2 — Choice Phase**: A comparison file (`conditions_choice_phase.xlsx`) specifies which rating-level comparisons to make: "1 vs 2", "2 vs 3", and "1 vs 3". The code dynamically selects one painting with each specified rating from the participant's Phase 1 data. Two paintings are displayed side by side: one that the participant rated at one level and one rated at another level. The participant presses '1' to choose the left image or '2' to choose the right image.

**Adaptive stimulus selection** is the key innovation: Phase 2 trials are not pre-determined but are constructed in real time from Phase 1 responses. If a participant gave no painting a particular rating (e.g., no painting was rated 3), a default placeholder image is used for that comparison instead, ensuring all comparison types can always be presented.

**Data collected**: For each Phase 2 trial — the images displayed (left and right), the participant's choice, the comparison type (1v2, 2v3, 1v3), and the ratings that triggered the pairing. This reveals whether participants show systematic preferences between stimuli they rated identically, or inconsistencies between stated ratings and revealed choices.

## Must Confirm

- **Stimuli**: Paintings (what style/domain?), product images, faces, or other? How many items in the stimulus set?
- **Rating scale**: 1-3 (3-point), 1-5 (5-point), 1-7, or continuous slider?
- **Comparison types**: Which rating differences to compare? (1v2, 2v3, 1v3, or all pairwise?)
- **Placeholder handling**: What to show when no stimulus was given a required rating? Default image or skip that comparison?
- **Phase sequencing**: Always rating-then-choice, or counterbalanced order?
- **Trial counts**: How many stimuli to rate? How many comparison trials?

## Trial Window Timeline

**Phase 1 — Rating:**
```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Stimulus                 │    │ Rating Prompt            │    │ ITI                      │
│ Content: painting image  │    │ Content: rating scale    │    │ Content: blank           │
│ Duration: until key      │    │   (1-3) with labels      │    │ Duration: 500 ms         │
│ Response: none           │    │ Duration: until key      │    │ Response: none           │
│ Condition: {image_file}  │    │ Response: 1, 2, or 3     │    │ Condition: none          │
│ Data: image_filename     │    │ Data: rating_value       │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

**Phase 2 — Choice:**
```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Stimulus Pair            │    │ Response                 │    │ ITI                      │
│ Content: 2 paintings     │    │ Content: selection prompt │    │ Content: blank           │
│   (left: rated X,        │    │ Duration: until key      │    │ Duration: 500 ms         │
│    right: rated Y)       │    │ Response: 1=left, 2=right│    │ Response: none           │
│ Duration: until key      │    │ Condition: {comparison}  │    │ Condition: none          │
│ Condition: {comparison}  │    │ Data: choice, rt          │    │ Data: none               │
│ Data: left_img, right_img│    └──────────────────────────┘    └──────────────────────────┘
└──────────────────────────┘
```

## Data Analysis

Analyze rating distributions (histogram of Phase 1 ratings). In Phase 2, examine reaction time and choice proportions for each comparison type. Test for preference consistency: does choice in Phase 2 align with rating differences from Phase 1? Analyze cases where rated-equal items produce systematic choices (revealed preference diverging from stated preference). Compare different comparison types (1v2, 2v3, 1v3) for choice difficulty (RT, decision confidence).

## References

No specific publication — this is a methodology demo illustrating dynamic stimulus selection based on participant responses. Adaptable to preference testing, decision-making, and value-based choice studies.

## Do Not Assume

- Do not assume that all stimuli received full rating levels during the rating phase - participants may have used only some of the rating levels (e.g., only 1 and 2, never 3), and how to structure trials in the selection phase when missing levels need to be dealt with
- Do not assume that the comparison type in the selection phase is pre-fixed - the comparison type (e.g. 1v2, 2v3, 1v3) is defined by the conditions file, but the actual available image pairs depend on the participant's rating distribution and need to be matched dynamically in the code
- Do not assume that placeholder stimuli can be used arbitrarily without affecting data quality - when a placeholder image is used without a corresponding stimulus for a certain rating level, the behavioral data of this trial may not be comparable and need to be marked in the data analysis
- Do not assume that left and right position does not affect choice preference - the left and right position of the stimulus needs to be randomized within trials or balanced across trials, and the actual presentation position is recorded in the data
- Do not assume that the rating phase and the selection phase use the same timing parameters - stimulus presentation times, response windows and ITI may require different settings for the two phases

## Condition File Columns

Select the columns of the stage condition file (the rating stage usually does not require a condition file and directly traverses the picture list):

| Column | Type | Description |
|--------|------|-------------|
| comparison_type | str | Comparison type tag, such as "1v2", "2v3", "1v3" |
| left_rating | int | The target rating level that the left stimulus should have |
| right_rating | int | The target rating level that the right stimulus should have |
| num_trials | int | The number of repetitions for each position permutation of this comparison type |

## Variants

- **Standard Two-Phase Rating-to-Choice**: Participants first complete the ratings of all stimuli, and then make pairing choices based on the rating results. The scoring phase and the selection phase are completely separated in time. This is the core paradigm described in this paper.
- **Trial-by-Trial Rating-to-Choice**: In each trial, participants first rate a new stimulus, and then choose among the currently rated stimuli. Rating and selection alternate. Suitable for studying immediate preference consistency and learning effects. Please refer to the adaptive-choice paradigm.
- **Multi-Round Rating-to-Choice**: Participants perform multiple rounds of "rating-choice" cycles, and the selection results of each round are fed back to the stimulus set or rating reference of the next round. It is suitable for studying the dynamic evolution of preferences and choice-induced preference change.

---

## Example

### User Request

> "I want to do a rating-to-choice experiment. In the first stage, subjects are asked to rate their preference for 30 abstract paintings on a scale of 1 to 5. In the second stage, based on the rating results, pairs of pictures with a rating difference of at least 2 are displayed (for example, rating 1 vs. rating 3, rating 2 vs. Rating 4, etc.), let the subject press the button to select the preferred picture. Do 8 trials for each comparison type. If there is no corresponding picture for a certain rating level, use PsychoPy, full screen mode.

### Trial Window Timeline

```text
Phase 1 — Rating（30 trials）:
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Picture stimulation │ │ Scoring interface │ │ ITI │
│ Content: Abstract painting pictures │ │ Content: 1-5 point scale │ │ Content: blank │
│ Duration: until key │ │ (1=dislike very much, │ │ Duration: 500 ms │
│ Response: none │ │ 5=like it very much) │ │ Response: none │
│ Condition: {image_file}  │    │ Duration: until key      │    │ Condition: none          │
│ Data: image, onset       │    │ Response: 1,2,3,4,5      │    │ Data: none               │
└──────────────────────────┘    │ Data: rating, rt          │    └──────────────────────────┘
                                └──────────────────────────┘

Phase 2 — Choice (contrast type × 8 trials, balanced left and right positions):
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Picture pair │ │ Selection interface │ │ ITI │
│ Content: Two abstract paintings on the left and right │ │ Content: "Press 1 to select left │ │ Content: blank │
│ Left: rated X │ │ Press 2 to select right" │ │ Duration: 500 ms │
│ Right: rated Y │ │ Duration: until key │ │ Response: none │
│ Duration: until key │ │ Response: 1=left, 2=right │ │ Condition: none │
│ Response: none           │    │ Condition: {comparison}  │    │ Data: none               │
│ Condition: {comparison}  │    │ Data: choice, rt          │    └──────────────────────────┘
│ Data: left_img, right_img│    └──────────────────────────┘
└──────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Score to selection task |
| Platform | PsychoPy |
| Stimulus type | Abstract painting picture |
| Number of stimuli | 30 pictures |
| Rating scale | 1-5 points (likeability) |
| Rating label | 1=dislike very much, 5=like very much |
| Comparison rules | Rating difference ≥ 2 |
| Number of trials for each comparison type | 8 (half for left and right positions) |
| Missing grade handling | Skip all comparison types that contain this grade |
| Display mode | Full screen |

### Missing Information

1. The specific list of comparison types is not clear - score difference ≥ 2 may include "1v3, 1v4, 1v5, 2v4, 2v5, 3v5", etc. You need to confirm whether all of them are included or only some are selected.
2. The order of picture presentation during the rating phase is not specified—random order or fixed order? Did all subjects use the same order?
3. In the selection stage, if the number of available picture pairs for a certain comparison type is less than 8, should they be reused or reduced? Can the same image pair appear multiple times when reused?

### Critical Assumptions

- Assume that contrast types with a rating difference ≥ 2 include all possible combinations by default (1v3, 1v4, 1v5, 2v4, 2v5, 3v5) instead of just combinations with adjacent rating differences of 2
- Assume there is no feedback during the rating phase and no inter-trial feedback during the selection phase (only selection data is recorded)
- Assume that each contrast type in the selection phase has a fixed number of 8 trials, and the left and right positions are randomized within trials (50% each) instead of being pre-specified with a condition file

### Code Architecture

```
rating_to_choice.py
├── Experiment initialization (window full screen, clock, color, font)
├── Parameter configuration (n_images=30, rating_scale=1-5, min_rating_diff=2, n_trials_per_comparison=8)
├── Load stimulus picture list (read file name from specified folder or condition file)
├── Phase 1: Scoring phase
│ ├── Randomize the order of picture presentation
│ ├── Trial-by-trial loop (30 trials)
│ │ ├── Window 1: Present image (until keypress skip → Window 2)
│ │ ├── Window 2: Present rating scale + record keystrokes (1-5) and RT
│   │   ├── Window 3: ITI（500 ms）
│ │ └── Save {image, rating, rt} into the rating_data list
│ └── Construct rating distribution: count the picture list for each level
├── Phase 2: Selection phase
│ ├── Build comparison type list: generate all valid comparisons based on rating_data and min_rating_diff
│ ├── Filter: Skip comparison types without pictures at any level
│ ├── Dynamically construct trial list (each comparison × n_trials_per_comparison)
│ │ ├── Randomly select 1 picture of the corresponding level in each trial
│ │ ├── Randomize left and right positions (50% probability exchange)
│ │ └── If there are insufficient available pairs for a certain comparison type, trials will be generated based on the maximum number of available pairs.
│ ├── Randomize trial order
│ └── Trial-by-trial loop
│ ├── Window 1: Present left and right image pairs (until keypress → Window 2)
│ ├── Window 2: Present selection prompt + record keystrokes (1/2) and RT
│       ├── Window 3: ITI（500 ms）
│ └── Save {left_img, right_img, left_rating, right_rating, comparison_type, choice, rt} into the choice_data list
├── Data saving (.csv)
│   ├── rating_data.csv（phase, trial, image, rating, rt）
│   └── choice_data.csv（phase, trial, left_img, right_img, left_rating, right_rating, comparison_type, choice, rt）
└── Escape exit check (checked in each window)
```

### Expected Data Columns

Phase 1 — Scoring phase:

| Column | Type | Description |
|--------|------|-------------|
| participant_id | str | participant number |
| phase | str | "rating" |
| trial_index | int | Trial number in the scoring stage (1-30) |
| image | str | image file name |
| rating | int | Rating value (1-5) |
| rt | float | Scoring reaction time (milliseconds) |

Phase 2 — Selection phase:

| Column | Type | Description |
|--------|------|-------------|
| participant_id | str | participant number |
| phase | str | "choice" |
| trial_index | int | Selection phase trial number |
| left_image | str | Left image file name |
| right_image | str | Right image file name |
| left_rating | int | The evaluation value of the left image in the rating stage |
| right_rating | int | The evaluation value of the image on the right in the rating stage |
| comparison_type | str | comparison type (such as "1v3", "2v4") |
| rating_diff | int | Absolute value of rating difference |
| choice | int | Choice result (1=left, 2=right) |
| rt | float | Select reaction time (milliseconds) |
