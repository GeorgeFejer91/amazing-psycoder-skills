# Phone a Friend Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/phone_a_friend) · reference

## When to Use

User mentions: Phone a friend, hint task, cue validity, general knowledge task, ECSoP, friend help task. A general knowledge task where participants can optionally request hints ("phone a friend"), with half of the hints being correct and half incorrect. Measures trust in external information and the influence of cue validity on belief updating.

## Core Logic

Participants are presented with a series of general knowledge questions and respond by typing an answer. On each question, they may choose to "phone a friend" to receive a hint. Each participant has exactly 10 hint opportunities across the entire task, of which 5 hints are valid (correct) and 5 are invalid (incorrect), randomly interleaved. After receiving a hint, the participant may revise their answer.

The critical manipulation is the validity of the hints: participants do not know in advance whether a given hint is correct or incorrect, so they must decide when to trust external information. The task tracks whether participants are more likely to request hints for difficult questions, whether they incorporate hints into their answers, and whether they detect that some hints are systematically incorrect.

On each trial, participants see a question, an editable textbox for typing their answer, a "Phone a friend" button, and a call tracker showing remaining hints. The trial is open-ended: participants can either type an answer and press Enter to submit, or click the hint button to request a hint. If a hint is requested, the trial transitions to a hint display screen showing the question, the hint text (labeled as a friend's answer), and a new editable textbox. The participant then submits their final answer by pressing Enter.

The cue validity list is pre-shuffled at experiment start: exactly 5 valid and 5 invalid hints are randomly ordered. On each hint request, the next cue type is popped from this list (sampling without replacement), and the corresponding valid or invalid hint text from the condition file is displayed. After all 10 hints are exhausted, a warning screen ("YOU HAVE NO CALLS LEFT") is shown for 1 second, and the hint button is disabled. Key variables: number of hints used, willingness to use hints for difficult vs. easy questions, answer accuracy before and after hints, how often participants follow valid vs. invalid hints, and individual differences in hint-seeking behavior. This task was developed following discussions at ESCOP 2025.

## Must Confirm

- **Question content**: General knowledge trivia, domain-specific questions, or custom item set?
- **Total hints**: 10 hints (5 valid + 5 invalid), or different count/ratio?
- **Answer format**: Free-text entry, or multiple choice?
- **Hint presentation**: Display as "friend's answer" text, or other framing?
- **Hint timing**: Is the pre-hint answer collected before the hint is shown, or is the answer only collected after?
- **Trial count**: Total number of questions (should exceed hint count so participants must choose when to use hints)?

## Trial Window Timeline

```text
┌─────────────────────────────────┐     ┌──────────────────────────────────┐
│ Window 1: Question + Answer     │     │ Window 2: Hint + Revised Answer  │
│ (if participant submits         │     │ (if participant clicks           │
│  without hint)                  │     │  "Phone a friend" button)        │
│                                 │     │                                  │
│ Content: question text +        │     │ Content: question text +         │
│ editable answer box +           │ ──→ │ hint text + new answer box +    │
│ "Phone a friend" button +       │     │ calls remaining counter          │
│ calls remaining counter         │     │ Duration: until Enter pressed    │
│ Duration: until Enter pressed   │     │ Response: free-text entry        │
│ Response: free-text entry       │     │ Data: answer_2.text, hint_shown, │
│ Data: answer.text, key_resp     │     │ cue_type, this_hint, n_calls     │
└─────────────────────────────────┘     └──────────────────────────────────┘
                                                 │
                    ┌────────────────────────────┘
                    ↓
     ┌──────────────────────────────────┐
     │ Window 3: No Calls Left          │
     │ (when n_calls >= 10)             │
     │                                  │
     │ Content: "YOU HAVE NO CALLS      │
     │ LEFT" warning                    │
     │ Duration: 1 s                    │
     │ Response: none                   │
     └──────────────────────────────────┘
```

## Data Analysis

Analyze hint usage rate, accuracy change after hints (comparing valid vs. invalid hint trials), and whether participants show differential weighting of valid vs. invalid hints. Examine individual differences in hint-seeking (e.g., related to overconfidence, trust, or need for cognition). Compare pre-hint and post-hint accuracy.

## References

Developed based on discussions with Paulina Pietrak at ESCOP 2025. Images by Rudy Issa.

## Do Not Assume

- Do not assume hints are always valid — this paradigm has exactly 5 valid and 5 invalid hints, randomly interleaved. The 50% validity rate is part of the experimental manipulation.
- Do not assume participants know the hint validity ratio — in the standard paradigm, participants are not informed about the 50% validity rate; they must learn it implicitly through experience.
- Do not assume every trial will use a hint — participants have limited hints (10 total) and must strategically choose when to request them. Most trials typically proceed without hints.
- Do not assume the hint button is always available — the button must be disabled after all 10 hints are exhausted, and a "no calls left" warning should be shown for 1 second.
- Do not assume participants must request a hint before answering — participants can submit their answer immediately without requesting a hint. The pre-hint answer and post-hint answer are separate data points that must be tracked independently.
- Do not assume the answer format is multiple choice — the standard phone-a-friend paradigm uses free-text entry, which requires string matching or manual scoring rather than key-press accuracy.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| question_id | str | Question number, such as `Q01`, `Q02` |
| question_text | str | Question content (common sense question text) |
| valid_answer | str | Correct answer (used for string matching scoring) |
| valid_hint | str | Valid hint text (correct answer given by friend) |
| invalid_hint | str | Invalid hint text (wrong answer given by a friend) |

## Variants

- **Informed Validity**: Participants were clearly told before the experiment that only half of the cues were correct. Compared with the uninformed version, the impact of explicit beliefs on cue trust was examined. Refer to trust-game.md.
- **Multi-Source Hints**: Expand a single "friend" to multiple information sources (such as experts, AI assistants, peers), and participants can choose to ask for help from different sources. Used to examine the differential impact of information source credibility on help-seeking behavior.
- **Deterministic Feedback**: The correct answer is displayed immediately after each answer is submitted and feedback is given on whether it is accurate or not, allowing participants to track cumulative evidence of the effectiveness of the prompt. Examine the promoting effect of feedback on cue trust renewal.

---

## Example

### User Request

> "I'm going to do a 'Ask a Friend for Help' experiment. Each time a common sense question appears on the screen, and the subject enters the answer in the text box. There is a 'Ask a Friend for Help' button next to each question, and the subject can click on it to get tips at any time. There are a total of 10 opportunities for help, of which 5 prompts are correct and 5 prompts are incorrect, randomly shuffled. After receiving the prompts, you can modify the answer. When the help is used up, the button will become gray and unavailable. There are 30 questions in total, 5 practice questions first. Implemented using PsychoPy."

### Trial Window Timeline

```text
┌─────────────────────────────────┐    ┌──────────────────────────────────┐    ┌──────────────────────────────────┐
│ Window 1: Questions + answers │ │ Window 2: Tips + revised answers │ │ Window 3: Tips for running out of requests for help │
│                                 │    │                                  │    │                                  │
│ Content: question_text + │ │ Content: question_text + │ │ Content: "Your number of requests for help has been exhausted" │
│ Textbox answer box + │ │ hint_text + New Textbox answer box + │ │ │
│ "Ask friends for help" button + │ → │ Display of remaining number of help requests │ → │ Duration: 1 s │
│ The remaining number of calls for help is displayed │ │ Duration: until Enter is pressed │ │ Response: none │
│ Duration: Until Enter or │ │ Response: free-text entry │ │ Data: none │
│ Click the help button │ │ Data: answer_2.text, hint_shown, │ └───────────────────────────────────┘
│ Response: free-text entry       │    │ cue_type, this_hint, n_calls     │
│ Data: answer_1.text, rt_1       │    └──────────────────────────────────┘
└─────────────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Question+Answer | question_text, Textbox, help button, remaining times | Until Enter or click for help | free-text Entry | {question_id} | answer_1.text, rt_1, hint_requested |
| Hint + revised answer | question_text, hint_text, Textbox, number of remaining times | Until Enter | free-text Entry | {cue_type, hint_text} | answer_2.text, rt_2, hint_shown, cue_type, this_hint |
| The number of requests for help has been exhausted | "The number of requests for help has been exhausted" | 1 s | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Phone a Friend Task |
| Platform | PsychoPy |
| Task type | General knowledge Q&A + optional clues for help |
| Number of questions | 30 questions (formal) + 5 questions (practice) |
| Total number of requests for help | 10 times |
| Number of valid prompts | 5 times |
| Number of invalid prompts | 5 times |
| Prompt validity ratio | 50% |
| Answer format | Free text input |
| Stage | Instructions → Practice(5) → Formal(30) |

### Missing Information

1. The source of the question content is not specified → You will be asked (Do you provide a custom question bank CSV/Excel file? Or use the built-in default general knowledge questions?)
2. The answer scoring method is not specified → Will ask (Exact string matching? Fuzzy matching? Or does manual post-grading required?)
3. The visual style and location of the help button is not specified → Will ask (is the button below the question or to the right? Button size and color?)

### Critical Assumptions

- The help button is available before each answer (unless 10 times have been used up). Participants can decide whether to ask for help.
- The cue validity list is pre-shuffled at the start of the experiment (5 valid + 5 invalid randomly arranged, without replacement sampling) to ensure that each participant encounters valid/invalid cues in a different order
- Free text answers use string exact matching for scoring (ignoring case and leading and trailing spaces), and Chinese answers use full-width/half-width unification before matching.
- The help function is not provided during the practice phase (only used to familiarize yourself with the interface and answer process)

### Code Architecture

```
phone_a_friend.py
├── Parameter configuration (total number of requests for help, valid/invalid ratio, number of questions, text matching tolerance)
├── Window settings (full screen/window, background color, Chinese font loading)
├── Conditional file loading (CSV: question_id, question_text, valid_answer, valid_hint, invalid_hint)
├── Prompt validity list generation (5 valid + 5 invalid → shuffle → pop on each request)
├── Stimulus component pre-creation
│ ├── Question text (TextStim)
│ ├── Prompt text (TextStim)
│ ├── Answer box (TextBox)
│ ├── Help button (Rect + TextStim combination)
│ ├── Remaining times display (TextStim: "Remaining help: X times")
│ └── Warning for help exhausted (TextStim: "Your number of requests for help has been exhausted")
├── Experimental stage
│ ├── Instructions (explanation of tasks, help-seeking mechanism, button operations)
│ ├── Practice stage (5 questions, no help function)
│ └── Formal stage (30 questions)
├── Trial cycle:
│ ├── Window 1: Question presentation + answer box + help button
│ │ ├── Detect Enter key → Collect answer_1, jump to ITI
│ │ └── Detect help button click → Pop up the next prompt (valid/invalid) and enter Window 2
│ ├── Window 2: prompt presentation + new answer box (only triggered when asking for help)
│ │ ├── show hint_text
│ │ ├── Collect answer_2 (Enter to submit)
│ │ └── Update n_calls
│ ├── Window 3: Warning of running out of help (displayed for 1 second when n_calls >= 10)
│ └── ITI (500-1000 ms random)
├── Data saving: try/finally + CSV write line by line
│ ├── Try sublevel: question_id, answer_1, answer_2, hint_requested, hint_shown, cue_type, n_calls, acc_1, acc_2
│ └── Summary level: total_hints_used, validity_detection_score
└── Exit control: Escape key full detection
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| question_id | str | question number |
| answer_1 | str | Answer before asking for help (final answer if no help is given) |
| answer_2 | str | The answer after asking for help (an empty string if no help is provided) |
| hint_requested | int | Whether the help button was clicked (0/1) |
| hint_shown | str | The actual displayed prompt text (empty string if no help is required) |
| cue_type | str | Cue type: `valid` / `invalid` / `none` |
| n_calls | int | Cumulative number of calls for help (including current attempts) |
| acc_1 | int | Accuracy before asking for help (1 = correct, 0 = incorrect) |
| acc_2 | int | Accuracy rate after asking for help (1 = correct, 0 = wrong, NaN = no request for help) |
| rt_1 | float | Response time before asking for help (ms) |
| rt_2 | float | Response time after asking for help (ms, NaN if not asking for help) |
