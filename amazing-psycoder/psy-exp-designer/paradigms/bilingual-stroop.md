# Bilingual (Blocked) Stroop Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/bilingual_stroop) · PsychoJS

## When to Use

User mentions: Bilingual Stroop, blocked Stroop, cross-language Stroop, bilingual Stroop. A variant of the classic Stroop task using blocked language conditions to compare the magnitude of Stroop interference across a participant's native and non-native languages.

## Core Logic

Participants report the display color of words while ignoring their semantic meaning, which may be congruent or incongruent with the ink color. The bilingual blocked version presents two language blocks — one in each language (e.g., English and Maori). The key prediction is that the Stroop effect (incongruent RT – congruent RT) will be larger in the more fluent language, because word reading is more automatic in that language, producing greater interference with color naming.

**Counterbalancing**: Participants are assigned to Group A or Group B at experiment start. Group A sees Language 1 first, then Language 2; Group B sees the reverse order. This controls for order effects.

**Block structure**: For each language, a block-level instruction screen explains the task in that language. Then a trial loop presents the stimuli. Two separate condition files (`english.xlsx` and `maori.xlsx`, or equivalent for your languages) define the stimuli for each language block.

**Trial structure**: fixation → color-word stimulus (the word in its ink color) → keypress response → ITI. Participants press one of three keys to indicate the ink color (e.g., 'r' for red, 'g' for green, 'b' for blue). The same three-key mapping is used across both language blocks; only the word language changes.

**Stimuli**: Color words (e.g., RED, GREEN, BLUE) presented in colored ink. Each trial is classified by: language (L1 vs L2), word meaning (color name), ink color, and congruency (congruent: word = ink; incongruent: word != ink).

## Must Confirm

- **Language pair**: Which two languages? (e.g., English/Maori, Chinese/English, French/German)
- **Color set**: Which ink colors? How many? (typically 3: red, green, blue)
- **Response keys**: Which keys map to which colors? (e.g., r/g/b for red/green/blue)
- **Counterbalancing**: Between-subjects (Group A/B) or within-subjects (all participants do both orders)?
- **Trial count per block**: How many trials per language? Congruency ratio? (50:50 or with neutral trials?)
- **Practice**: Practice before each language block, or one combined practice at the start?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Stroop Stimulus          │    │ Feedback (optional)      │    │ ITI                      │
│ Content: +               │    │ Content: color word       │    │ Content: correct/incorrect│   │ Content: blank           │
│ Duration: 500-1000 ms    │    │ Duration: until key      │    │ Duration: 500 ms         │    │ Duration: 500-1000 ms    │
│ Response: none           │    │ Response: r/g/b keys     │    │ Response: none           │    │ Response: none           │
│ Condition: none          │    │ Condition: {lang, word,  │    │ Condition: none          │    │ Condition: none          │
│ Data: none               │    │  ink_color, congruency}  │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    │ Data: rt, key, acc       │    └──────────────────────────┘    └──────────────────────────┘
                                └──────────────────────────┘
```

## Data Analysis

Compare the Stroop interference effect (incongruent RT – congruent RT) between language conditions. Use a 2 (language: fluent vs. less fluent) x 2 (congruency: congruent vs. incongruent) repeated-measures ANOVA. The interaction term tests whether the Stroop effect differs by language. Follow up with simple effects tests. Also report accuracy (error rate) as a secondary measure.

## References

Stroop, J. R. (1935). Studies of interference in serial verbal reactions. *Journal of Experimental Psychology, 18*(6), 643–662. https://doi.org/10.1037/h0054651

## Do Not Assume

- Do not assume the two languages use the same color words — verify the exact word set for each language (e.g., English: RED/GREEN/BLUE; Mandarin: the corresponding Mandarin color words). Different languages may use different numbers of words or different translation conventions.
- Do not assume a single condition file drives both language blocks — the bilingual blocked design typically uses two separate condition files (one per language). Confirm whether the user has prepared both files before generating code.
- Do not assume counterbalancing is done via random assignment — the Pavlovia demo uses explicit Group A/B assignment at runtime. Confirm whether between-subjects counterbalancing (group assignment) or within-subjects (all participants see both orders) is preferred.
- Do not assume the response key mapping is identical across languages — while the standard design uses the same three-key mapping for both blocks, some designs may use different key mappings per language (e.g., first-letter mapping in each language). Confirm explicitly.
- Do not assume neutral trials exist — the standard bilingual Stroop uses only congruent and incongruent trials (50:50). If the user wants neutral trials (e.g., colored squares or non-color words), the condition file and analysis must be adjusted.
- Do not assume the Stroop effect direction — in the less fluent language, the interference effect may be reduced or even reversed. The analysis should handle both possibilities rather than assuming a fixed direction.

## Condition File Columns

Columns in the xlsx/csv file that drives each trial (one file per language):

| Column | Type | Description |
|--------|------|-------------|
| word | str | color word text in the language being tested (for example, `RED`) |
| ink_color | str | Ink color name (such as `red`, `red`) |
| congruency | str | `"congruent"` or `"incongruent"` |

## Variants

- **Classic Bilingual Blocked Stroop**: Each of the two languages is an independent block, and the block contains consistent and inconsistent trials. Participants completed two language blocks in a fixed or inter-subjects counterbalanced order. See this document for details.
- **Mixed Bilingual Stroop**: Trials of two languages ​​are randomly mixed and presented within the same block. Compared with the block design, the mixed design can examine the moderating effect of language switching costs on the Stroop effect. When generating code, a `language` column needs to be added to the condition file to mark the language of each trial.
- **Emotional Bilingual Stroop (Emotional Bilingual Stroop)**: Replace Stroop stimuli with emotional words (positive/negative/neutral) to examine bilinguals' attention bias toward emotional words and their cross-language differences. Additional confirmation of the emotion word vocabulary and valence scores is required. Please refer to the emotional Stroop related paradigm documents.

## Example

### User Request

> "I want to do a bilingual Stroop experiment. The two languages are Chinese and English, Chinese as the mother tongue and English as the second language. There are three colors: red, green and blue, and the buttons use r/g/b to correspond to the color. Each language block There are 60 trials, 30 trials each for consistency and inconsistency. The subjects are balanced, with half doing Chinese first and half the other way around. There is a unified practice block (12 trials) before the experiment.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation point │ │ Stroop stimulus │ │ Feedback (only practice phase) │ │ Trial interval │
│ Content: + │ │ Content: color word │ │ Content: correct/wrong │ │ Content: blank │
│ Duration: 500 ms │ │ Duration: until the key is pressed │ │ Duration: 500 ms │ │ Duration: 500-800 ms │
│ Response: None │ │ Response: r/g/b key │ │ Response: None │ │ Response: None │
│ Condition: None │ │ Condition: {word, │ │ Condition: None │ │ Condition: None │
│ Data: None │ │ ink_color, congruency, │ │ Data: None │ │ Data: None │
│                          │    │  language}               │    │                          │    │                          │
│                          │    │ Data: rt, key, acc       │    │                          │    │                          │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|------|----------|------|------|------|
| fixation point | + | 500 ms | none | none | none |
| Stroop stimulus | color word (RED/GREEN/BLUE or RED/GREEN/BLUE) | until key pressed (no deadline) | r/g/b key | {word, ink_color, congruency, language} | rt, key, acc |
| Feedback | True/False (Practice only) | 500 ms | None | None | None |
| ITI | Blank | 500-800 ms Random | None | None | None |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Chinese-English bilingual Stroop task |
| Platform | PsychoPy |
| Task Type | Bilingual Blocked Stroop (Bilingual Blocked Stroop) |
| Language 1 (Native) | Chinese (Red, Green, Blue) |
| Language 2 (Second Language) | English (RED, GREEN, BLUE) |
| Color set | red, green, blue (red, green, blue) |
| Response button | r→red/red, g→green/green, b→blue/blue |
|Number of trials per language | 60 (30 congruent + 30 incongruent) |
| Balanced method | Between subjects: Group A speaks Chinese first and then English, Group B speaks English first and then Chinese |
| Practice trials | 12 (unified practice) |
| Stage | Instructions → Exercise(12) → Block1(60) → Block2(60) → End |

### Missing Information

1. The content of the instruction is not specified → It is necessary to confirm the specific content of the instruction before the Chinese and English blocks (is the instruction presented in the corresponding language?)
2. The feedback stage is not mentioned → It is assumed that there is feedback only in the practice stage and no feedback in the formal stage (standard Stroop practice)
3. The trial composition of the practice phase is not specified → Need to confirm whether the practice is bilingual or only in one language? Consistent/incongruent ratio?

### Critical Assumptions

- Practice block uses bilingual mixed trials (half Chinese and half English) to help participants familiarize themselves with the key mappings in both languages
- Official block has no trial secondary feedback, only short rest prompts between blocks.
-The key mapping is consistent in the two language blocks (r/g/b corresponds to three colors) and does not change with the language
- Stimuli are presented in random order, with no more than 3 consecutive trials of the same consistency
- No response deadline (response-terminated), the participant will immediately enter the next window after pressing the button

### Code Architecture

```
bilingual_stroop.py
├── Parameter definition (language sequence, color mapping, keys, number of trials, time parameters)
├── Window settings (full screen/window, background color, unit)
├── Stimulus preloading (TextStim × 2: Chinese and English color words; Polygon fixation point)
├── Conditional file loading (chinese.xlsx, english.xlsx)
├── Subject grouping (odd and even number → Group A/B)
├── Experimental phase:
│ ├── Instructions (general + language specific)
│ ├── Practice block (12 trials, with feedback)
│ │ ├── Fixation point (500 ms)
│ │ ├── Stroop stimulation (until the key is pressed)
│ │ ├── Feedback (500 ms)
│ │ └── ITI (500-800 ms random)
│ ├── Block 1 (first language in grouping order, 60 trials)
│ │ ├── Block instructions
│ │ └── Trial cycle (fixation point → stimulus → ITI)
│ └── Block 2 (second language in grouping order, 60 trials)
│ ├── Block instructions
│ └── Trial cycle (fixation point → stimulus → ITI)
├── Data saving: try/finally + write to CSV line by line
└── End screen
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| participant | str | participant number |
| group | str | group (A or B) |
| language | str | Trial language (`"chinese"` or `"english"`) |
| block_type | str | stage type (`"practice"` or `"formal"`) |
| block_num | int | Block number (1 or 2, 0 for practice) |
| trial_num | int | Block trial number |
| word | str | rendered color word text |
| ink_color | str | ink color name |
| congruency | str | consistency (`"congruent"` or `"incongruent"`) |
| correct_key | str | Correct key (`"r"` / `"g"` / `"b"`) |
| key_pressed | str | Actual key pressed by the participant |
| rt | float | reaction time (ms) |
| acc | int | Accuracy rate (1 = correct, 0 = incorrect) |
