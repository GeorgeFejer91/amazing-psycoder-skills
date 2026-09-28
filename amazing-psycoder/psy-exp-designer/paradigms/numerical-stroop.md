# Numerical Stroop Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/numerical_stroop) · reference

## When to Use

User mentions: Numerical Stroop, number Stroop, physical vs. semantic comparison, Henik task, numerical Stroop. A variant of the Stroop task using numerical magnitude comparison, measuring interference between the physical size and semantic value of digits.

## Core Logic

Participants compare two numbers and indicate which is "greater" under two different task conditions. In semantic trials, participants must choose the numerically larger number while ignoring the physical size of the digits (e.g., the digit "3" printed in large font vs. "5" in small font — the correct answer is "5" based on value, ignoring size). In physical trials, participants must choose the physically larger number while ignoring its numerical value (e.g., large "3" vs. small "5" — the correct answer is "3" based on size, ignoring value).

Congruent trials are those where physical size and numerical value align (e.g., large "5" vs. small "3" — "5" is both physically and numerically larger). Incongruent trials create conflict between the two dimensions (e.g., large "3" vs. small "5"). The key prediction is that incongruent trials produce longer RTs than congruent trials, with larger interference effects in the semantic task (reflecting the automatic, difficult-to-suppress processing of numerical magnitude).

This is a close replication of Henik & Tzelgov (1982). The task is organized into blocks, each driven by a row in `blockDefinitions.xlsx` specifying the instruction text, practice condition file, and main condition file. This allows easy switching between semantic and physical comparison blocks within a single experiment.

Each trial follows a precisely timed sequence: fixation cross ("+") at center for 100 ms, then at 200 ms two number stimuli appear simultaneously at positions (-0.075, 0) and (0.075, 0) in height units. The key manipulation is that each trial condition provides four parameters: `number1`/`number2` (the digit strings) and `size1`/`size2` (the physical font heights). In congruent trials the physically larger digit is also numerically larger; in incongruent trials the physically larger digit is numerically smaller, creating response conflict. Participants respond with 'a' (left) or 'k' (right). Practice trials show 1s feedback ("Correct!" or "Oops! That was wrong"); main trials proceed without feedback.

## Must Confirm

- **Task conditions**: Both semantic ("which is numerically larger?") and physical ("which is physically larger?") conditions, or just one?
- **Blocking**: Conditions blocked (one instruction per block) or interleaved?
- **Stimulus pairs**: Which digit pairs to use? (e.g., 1-9 with varying physical sizes)
- **Response keys**: 'a'/'k' (left/right), arrow keys, or other mapping?
- **Size manipulation**: How many physical size levels per digit? (e.g., two sizes creating congruent/incongruent/neutral)
- **Practice**: Include practice trials with feedback before each block?
- **Trial count**: How many trials per congruency condition per block?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Fixation                 │    │ Number Stimuli           │    │ Feedback (practice only)  │
│ Content: + at center     │    │ Content: two digits      │    │ Content: "Correct!" or    │
│ Duration: 100 ms         │    │ at different font sizes  │    │ "Oops! That was wrong"    │
│ Response: none           │    │ positions: ±0.075        │    │ Duration: 1 s              │
│ Data: none               │    │ starts at t=200 ms       │    │ Response: none            │
│                          │    │ Duration: until response │    │ Data: none                │
│                          │    │ Response: 'a' or 'k' key│    │                           │
│                          │    │ Data: rt, key, acc       │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

Compare mean RT for congruent vs. incongruent trials within each task condition (semantic, physical). Expect larger interference in semantic comparison. Use a 2 (task: semantic vs. physical) x 2 (congruency: congruent vs. incongruent) repeated-measures ANOVA. Analyze the interaction to determine the locus of the numerical Stroop effect.

## References

Henik, A., & Tzelgov, J. (1982). Is three greater than five: The relation between physical and semantic size in comparison tasks. *Memory & Cognition, 10*(4), 389–395. https://doi.org/10.3758/BF03202431

Stroop, J. R. (1935). Studies of interference in serial verbal reactions. *Journal of Experimental Psychology, 18*(6), 643–662. https://doi.org/10.1037/h0054651

## Do Not Assume

- Do not assume the task order (semantic first, then physical) is fixed — the Henik & Tzelgov (1982) original design uses blocked conditions with a fixed order, but some replications counterbalance the order across participants. Confirm whether the user wants counterbalanced blocks or a fixed sequence.
- Do not assume the same size-level mapping applies to all digits — in the standard design, each digit pair uses two physical sizes (large/small) that create congruent and incongruent pairings. If the user wants more than two size levels (e.g., small/medium/large to create neutral trials), the condition file structure and analysis must be adjusted accordingly.
- Do not assume digit pairs use single-digit numbers only — the standard Numerical Stroop uses digits 1–9, but some variants use two-digit numbers (e.g., 12 vs. 24) to investigate numerical distance effects. Confirm the digit range before generating the condition file.
- Do not assume "a" and "k" are the default response keys — the Pavlovia demo uses 'a'/'k' for left/right responses, but the user may prefer arrow keys, 'f'/'j', or another mapping. Always confirm the response key layout.
- Do not assume practice trials use the same condition file as formal trials — in the Pavlovia demo, practice and main blocks have separate condition files (`numstroop_practice_sem.xlsx` vs. `numstroop_main_sem.xlsx`). Confirm whether the user has prepared separate practice condition files or expects them to be automatically generated.
- Do not assume the interference effect is symmetric — the semantic interference effect (physical size interfering with numerical judgment) is typically larger than the reverse (numerical value interfering with physical size judgment). The analysis code should handle both within-task and between-task comparisons without assuming the direction of asymmetry.

## Condition File Columns

Columns in the xlsx/csv file that drives each trial (one file per task condition):

| Column | Type | Description |
|--------|------|-------------|
| number1 | int/str | The number presented on the left (such as `3`, `5`) |
| number2 | int/str | The number presented on the right (such as `5`, `3`) |
| size1 | float | The physical font size height of the left number (such as `0.1`, `0.08`) |
| size2 | float | The physical font size height of the number on the right (such as `0.08`, `0.1`) |
| congruency | str | `"congruent"` (the physical size is consistent with the numerical size) or `"incongruent"` (the physical size conflicts with the numerical size) |

## Variants

- **Classic Numerical Stroop**: Based on the original design of Henik & Tzelgov (1982), participants completed two block tasks: semantic comparison (judging which number is larger in numerical value) and physical comparison (judging which number is larger in physical size). Each block contained congruent and incongruent trials. See this document for details.
- **Size Congruity Task**: A generalized version of numerical Stroop, using other quantifiable dimensions (such as area, brightness, quantity) instead of physical font size to examine the consistency effect between different dimensions. Stimulus parameters (size, brightness, etc.) need to be defined as additional columns in the condition file, and the code needs to be adapted to multi-dimensional stimulus presentation. Consider the way stimulus dimensions are defined in Eriksen Flanker's task.
- **Developmental Numerical Stroop**: A simplified version for children or special populations (e.g., developmental dyscalculia) that typically uses fewer number pairs (e.g., 1–5 instead of 1–9), greater physical size differences, and adds neutral trials (two numbers with the same physical size but different numerical values) to reduce task difficulty. Additional confirmation of applicable age groups and numerical ranges is required.

## Example

### User Request

> "I am going to do a numerical Stroop experiment. A number is presented on the left and right sides of the screen, and the two numbers are different in physical size. In the semantic task, the subjects judge which number has a larger numerical value, ignoring the physical size; in the physical task, the subject judges which number has a larger physical size, ignoring the numerical value. The numbers use pairs of numbers between 1-9 (identical numbers are excluded Word matching), the font size is divided into large (0.12) and small (0.06). Each task block contains 40 trials for consistency and inconsistency. There are 16 practice trials before each block.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Fixation point │ │ Digital stimulus pair │ │ Feedback (practice phase only) │
│ Content: + │ │ Content: two numbers │ │ Content: "Correct!" or │
│ Duration: 100 ms │ │ Presented in different font sizes │ │ "Oh, wrong answer!" │
│ Response: None │ │ Position: Left (-0.075,0) │ │ Duration: 1000 ms │
│ Condition: None │ │ Right(0.075,0) │ │ Response: None │
│ Data: None │ │ Duration: Until key │ │ Condition: None │
│ │ │ Response: left/right key │ │ Data: None │
│                          │    │ Condition: {number1,     │    │                          │
│                          │    │  number2, size1, size2,  │    │                          │
│                          │    │  congruency}             │    │                          │
│                          │    │ Data: rt, key, acc       │    │                          │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|------|----------|------|------|------|
| fixation point | + | 100 ms | none | none | none |
| Number stimulus | Two numbers (different font sizes), presented side by side | Until key (no deadline) | Left arrow key / Right arrow key | {number1, number2, size1, size2, congruency, task_type} | rt, key, acc |
| Feedback | "Correct!" / "Oh, wrong answer!" (Practice only) | 1000 ms | None | None | None |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment Name | Numerical Stroop Task |
| Platform | PsychoPy |
| Task type | Numerical Stroop (Numerical Stroop / Size Congruity Task) |
| Task conditions | Semantic comparison (larger value) + physical comparison (larger size), chunked presentation |
| Number range | 1–9 (excluding same number pairs) |
| Physical size | Large font size (0.12), small font size (0.06) |
| Response keys | Left arrow key (←), right arrow key (→) |
| Number of trials per block | 80 (40 congruent + 40 incongruent) |
| Task order | Fixed: semantics first, physics later |
| Practice trials | First 16 per block |
| Stage | Instructions → Practice (Semantics, 16) → Semantics Block(80) → Rest → Practice (Physics, 16) → Physics Block(80) → End |

### Missing Information

1. The content of the instructions is not specified → It is necessary to confirm the specific wording of the instructions for the semantic tasks and the physical tasks (such as "Please judge which number is larger, press the left or right key")
2. ITI (inter-trial interval) is not mentioned → It is necessary to confirm whether there is an interval between trials and the specific duration (200–500 ms random? Or go directly to the next trial?)
3. The rest between blocks is not specified → It is necessary to confirm whether there is a rest prompt after the end of the semantic block, and whether the rest duration is controlled by the subject voluntarily

### Critical Assumptions

- ITI defaults to 300 ms (before fixation), consistent with Pavlovia reference implementation
- There is a self-control rest prompt between blocks (press the space bar to continue)
-The digital stimulus is presented 200 ms after the offset from the fixation point (same as Pavlovia reference implementation: 100 ms after the fixation point → 200 ms after the blank)
- The left and right positions are consistent with the key mapping (the left stimulus corresponds to the left arrow key, the right stimulus corresponds to the right arrow key), and the stimulus positions are fixed and not randomly exchanged
- No response deadline (response-terminated), the participant will immediately enter the next window after pressing the button

### Code Architecture

```
numerical_stroop.py
├── Parameter definition (task sequence, font size mapping, keys, number of trials, time parameters)
├── Window settings (full screen/window, background color, unit=height)
├── Stimulus preloading (TextStim × 2: left digits and right digits; polygon fixation +)
├── Conditional file loading/generation (semantic_practice.xlsx, semantic_main.xlsx, physical_practice.xlsx, physical_main.xlsx)
├── Experimental phase:
│ ├── Instructions (general + semantic task specific)
│ ├── Semantic practice block (16 trials, with feedback)
│ │ ├── Fixation point (100 ms)
│ │ ├── Number stimulus pair (presented after 200 ms until key press)
│ │ ├── Feedback (1000 ms)
│   │   └── ITI（300 ms）
│ ├── Semantic formal block (80 trials, no feedback)
│ │ ├── Block instructions
│ │ └── Trial cycle (fixation point → digital stimulus → ITI)
│ ├── Rest prompt (press space to continue)
│ ├── Physics practice block (16 trials, with feedback)
│ │ └── Same structure as above
│ └── Physics formal block (80 trials, no feedback)
│ └── Same structure as above
├── Data saving: try/finally + write to CSV line by line
└── End screen
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| participant | str | participant number |
| task_type | str | Task type (`"semantic"` or `"physical"`) |
| block_type | str | stage type (`"practice"` or `"formal"`) |
| trial_num | int | Block trial number |
| number1 | int | The value of the number on the left |
| number2 | int | The value of the number on the right |
| size1 | float | The font size height of the left number |
| size2 | float | The font size height of the numbers on the right |
| congruency | str | consistency (`"congruent"` or `"incongruent"`) |
| correct_side | str | The side of the correct answer (`"left"` or `"right"`) |
| correct_key | str | Correct key (`"left"` or `"right"`) |
| key_pressed | str | Actual key pressed by the participant |
| rt | float | reaction time (ms) |
| acc | int | Accuracy rate (1 = correct, 0 = incorrect) |
