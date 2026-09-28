# Writing Distraction Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: Custom paradigm · PsychoPy

## When to Use

User mentions: Writing distraction, dual-task writing, distractor interference, writing under distraction, writing interference. A dual-task paradigm that measures the effect of visual distractors on ongoing text production, combining continuous typing performance with intermittent distractor exposure.

## Core Logic

Participants type a word or phrase while intermittently being shown distracting images. The paradigm measures how distraction disrupts the continuity, speed, and accuracy of ongoing text production. This task bridges motor production, working memory maintenance, and distractor suppression, making it relevant for studying real-world interference effects (e.g., writing while notifications appear).

**Trial structure** -- each trial has four sequential phases:

1. **Word display phase** (2 s minimum + typing): A target word is shown on screen. The participant must type at least a specified number of letters (`n_distract`) from the word. Once they type enough characters, the phase advances. If they haven't typed enough letters within 2 seconds, the phase continues until they do.

2. **Distractor phase** (1 s): A distractor image is displayed for exactly 1 second. The participant's typing is interrupted by this visual distractor. The text they had typed so far is preserved.

3. **Continue writing phase** (5 s maximum): The original text typed so far is restored, and the participant continues typing from where they left off. They have up to 5 seconds to complete the word. The phase ends when they finish typing or when the 5-second timeout expires.

4. **Question phase** (until Y/N response): A yes/no question about the trial is displayed (e.g., "Did you notice the distractor?"). The participant responds with Y or N key.

**Cross-phase state**: The typed text is carried across phases via experiment-level variables. During the distractor phase, the text input is hidden; it is then restored for the continue-writing phase. The final text string (from word display + continue writing) is the primary performance measure.

**Condition file** (`conditions.xlsx`): Each row specifies `this_word` (the target word), `n_distract` (number of letters to type before the distractor appears), the distractor image filename, and the post-trial question. No per-trial feedback is given.

## Must Confirm

- **Word stimuli**: What words to use? Word length, frequency, language?
- **Distractor images**: What type of distractors? (emotional, neutral, task-relevant, or varied IAPS images)
- **n_distract**: How many letters must be typed before the distractor appears? Fixed or variable?
- **Phase timing**: Duration of distractor display (1 s), continue-writing timeout (5 s), and minimum word display time (2 s)?
- **Question content**: What yes/no question follows each trial?
- **Response collection**: Keyboard for typing + keyboard for Y/N, or mouse for Y/N?
- **Trial count**: How many trials? From a fixed CSV or procedurally generated?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Phase 1                  │ →  │ Phase 2                  │ →  │ Phase 3                  │ →  │ Phase 4                  │
│ Show Word + Type         │    │ Show Distractor          │    │ Continue Writing         │    │ Question Response        │
│ Content: target word +   │    │ Content: distractor      │    │ Content: existing text + │    │ Content: question text   │
│ textbox with typed chars │    │ image                    │    │ editable textbox         │    │ Duration: until Y/N key  │
│ Duration: min 2 s, then  │    │ Duration: 1 s            │    │ Duration: max 5 s        │    │ Response: 'y' or 'n' key │
│ until n_distract chars   │    │ Response: none (typing   │    │ (advances on completion) │    │ Data: key_resp.keys      │
│ typed                    │    │ suppressed)               │    │ Response: keyboard typing│    │                           │
│ Response: keyboard       │    │ Data: none               │    │ Data: full typed text    │    │                           │
│ Data: initial typed text │    │                           │    │                           │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

Primary measures: typing speed (characters per second) in the continue-writing phase vs. word-display phase, error rate (deviations from target word), and completion rate (whether the word was fully typed). Compare performance on trials with distractors vs. baseline (if included). Analyze whether certain distractor types (emotional vs. neutral) differentially impair writing continuity. Y/N question responses provide a secondary measure of distractor awareness. Individual differences in working memory capacity or attentional control may moderate distraction effects.

## References

No canonical reference yet -- this is a custom paradigm. Adapt analyses from dual-task interference literature (e.g., Pashler, 1994) and writing process research.

## Do Not Assume

- Do not assume that the interference presentation time is fixed at 1 second. Some variations require the interference to continue until the subject resumes input, or use staircase to adjust the duration of the interference. Be sure to confirm the exact duration of the interference phase and whether it is variable.
- Do not assume the input language is English. If the target word is Chinese, input method (IME) compatibility needs to be addressed (the candidate word window may block the stimulus, and the input key combination may be misjudged as a reaction key), and explicitly use `keyboard.Keyboard` to collect characters instead of `event.getKeys`.
- Do not assume that the interference type is only pictures. Distractors may be flashing text, sounds, video clips or pop-up notifications. It is necessary to confirm the modality and file format of the interfering stimulus.
- Do not assume that a problem phase must appear after each trial. Some variations ask questions after only a subset of trials (e.g., 25% randomly selected), or omit questions entirely to shorten the experiment length. Be sure to confirm the frequency and logic of the problem.
- Do not assume `n_distract` is a secondary variable. It may be used as a global fixed parameter (the same for all trials), in which case there is no need to specify it line by line in the conditions file.
- Do not assume that the input box during the writing phase is always visible. During the distraction phase, input boxes may be hidden, disabled, or overwritten. It is necessary to clarify the visibility and editable status of the input box at each stage to ensure that the cross-stage text status is transferred correctly.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| this_word | str | target word, the word that the subject needs to input |
| n_distract | int | The minimum number of characters that need to be entered before interference occurs |
| distractor | str | Disturbance image file name (including extension) |
| question | str | Yes/no question text presented after trial |

## Variants

- **Text-based distraction**: The distractor is irrelevant text or vocabulary (rather than pictures) flashed on the screen, and the impact of semantic interference on the continuity of writing is examined. See the lexical interference section of [stroop.md](stroop.md) for stimulus generation logic.
- **Auditory distraction writing**: The interference stimulus is presented in the auditory channel (such as sudden noise, irrelevant speech), and the subject receives the interference through headphones while typing. Additional configuration of the audio playback component and sound file path is required, see the auditory stimulation parameters of oddball.md.
- **Emotional distraction writing**: The system manipulates the emotional valence of distractors (negative vs. neutral pictures, usually selected from the IAPS or CAPS image library) to examine the moderating effect of emotional salience on writing interruptions. The condition file needs to add a `valence` column to mark the emotional category of the interference image.

---

## Example

### User Request

> "I want to do a writing interference experiment. A two-character Chinese word is displayed at the top of the screen and an input box is shown below. The subject starts typing. When the first stroke of the second word is typed, an interference picture pops up in the center of the screen for 1 second, then the picture disappears, and the subject continues to type the word. After the trial is over, it is asked 'Did you notice the interference picture?' Press Y or N. There are 60 trials in total, and the words are randomly selected from the vocabulary list. Implemented with PsychoPy."

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Phase 1: word presentation + initial input │ → │ Phase 2: interference presentation │ → │ Phase 3: continue writing │ → │ Phase 4: question answering │
│ Content: target word + input box │ │ Content: interference picture │ │ Content: existing text + input box │ │ Content: question text │
│ Duration: at least 2 s, │ │ Duration: 1 s │ │ Duration: at most 5 s │ │ Duration: until Y/N button │
│ Until ≥2 characters are entered │ │ Response: none (input disabled) │ │ (automatically ends after completion) │ │ Response: 'y' or 'n' key │
│ Response: keyboard         │    │ Data: none                 │    │ Response: keyboard          │    │ Data: key_resp.keys        │
│ Data: Initial input text │ │ │ │ Data: Complete input text │ │ │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Stage | Content | Duration | Response | File | Condition | Data |
|------|---------|----------|----------|------|-----------|------|
| Word presentation + initial input | Target word + text input box | At least 2 s, until ≥ 2 characters are entered | keyboard | none | {this_word} | Initial input text |
| Distractor presentation | Distractor picture | 1 s | none (input disabled) | {distractor} | none | none |
| Continue writing | Existing text + input box | Up to 5 s (end after completion) | keyboard | none | none | Complete input text |
| Question answer | Question text | Until Y/N keys | 'y', 'n' | none | {question} | key_resp.keys, rt |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Chinese writing interference task |
| Platform | PsychoPy |
| Task type | Writing interference (dual task) |
| Target stimulus | Two-character Chinese word (randomly selected from the vocabulary list) |
| Interfering stimulus | Picture file |
| Interference trigger condition | Enter ≥ 2 characters (the second character and the first stroke) |
| Interference presentation duration | 1 s |
| Continue writing time limit | 5 s |
| Post-trial question | "Did you notice the distractor picture?" (Y/N) |
| Number of attempts | 60 |
| Stage structure | Word presentation → Interference → Continue writing → Question |

### Missing Information

1. **Vocabulary not provided** — No specific word list or vocabulary file path is specified. It is necessary to specify which vocabulary to use, or provide a list of terms.
2. **Interference picture not specified** — The source of the interference picture (IAPS number / custom picture folder path), and the emotion category or content type of the picture are not specified.
3. **Practice trials not mentioned** — Do they include a practice phase? The number of practice trials and whether feedback was given were not specified.

### Critical Assumptions

- Chinese input uses `keyboard.Keyboard` to collect character-level input, and `event.getKeys` cannot correctly handle Chinese input method key combinations.
- The interference picture is presented in the center of the full screen, the input box is located at the bottom of the screen, and the target word is located at the top. The layout is arranged top to bottom by default.
- 60 trials are randomly selected from the word list without replacement; if the word list is less than 60 words, the words are drawn cyclically (with replacement).

### Code Architecture

```
writing_distraction.py
├── Parameter area (character threshold, stage duration, window size)
├── Conditional file generation (randomly select 60 target words from the vocabulary list and assign interference pictures and questions)
├── Stimulus preloading (target word TextStim, question TextStim, interference picture ImageStim)
├── Input box component (PsychoPy TextBox/custom text accumulation component)
├── Trial cycle:
│ ├── Stage 1: Present target word + enable input box (minimum 2 s, until number of characters ≥ threshold)
│ ├── Stage 2: Display the interference image for 1 s (disable the input box and save the current text)
│ ├── Stage 3: Restore the input box and the entered text (up to 5 s, end with carriage return or when the number of characters reaches the limit)
│ ├── Stage 4: Present problem, wait for Y/N button
│ └── Save trial data
├── End interface (thank you)
└── Data saving: try/finally CSV incremental writing
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| this_word | str | target word |
| n_distract | int | Disturbance trigger character threshold |
| distractor | str | interference image file name |
| init_text | str | The entered text at the end of phase 1 |
| final_text | str | Complete input text at the end of phase 3 |
| correct | int | Whether the final text exactly matches the target word (1/0) |
| char_count_phase1 | int | Number of characters input in phase 1 |
| char_count_phase3 | int | Number of characters input in phase 3 |
| typing_speed_phase1 | float | Phase 1 typing speed (characters/second) |
| typing_speed_phase3 | float | Phase 3 typing speed (characters/second) |
| question_resp | str | Question answer ('y' / 'n') |
| question_rt | float | Question response time (seconds) |
