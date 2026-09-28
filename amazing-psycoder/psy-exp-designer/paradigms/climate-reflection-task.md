# Climate Reflection Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/climate_reflection_task) · PsychoJS

## When to Use

User mentions: Climate reflection, environmental attitudes, climate change engagement, climate beliefs, climate reflection task, environmental attitudes. A two-phase questionnaire paradigm designed to explore how exposure to climate information influences participants' engagement with and attitudes toward climate change issues.

## Core Logic

This is a reflection-and-reassessment paradigm, not a reaction-time task. It consists of three sequential phases:

**Phase 1 — Free Response**: Participants are presented with a series of open-ended questions about climate change from a spreadsheet (`climate_change_questions.xlsx`). Each question appears individually, and participants type their answer using a text input box (Enter to submit). All typed answers are stored as `answer.text`.

**Phase 2 — Information Exposure**: Participants read an informational passage about climate change, presented as a static text screen. This serves as the experimental manipulation — the content can be varied (e.g., scientific consensus information, personal impact narratives, solutions-focused messages) to test different intervention framings.

**Phase 3 — Reflection**: An introduction screen explains that participants will now review their previous answers. The second loop (`response_loop`) re-presents each original question alongside the participant's own Phase 1 answer. A slider component allows participants to rate how much they agree with their previous response on a continuous scale. This measures whether exposure to the informational passage shifted their attitudes toward their prior beliefs.

**Cross-phase data linkage**: The participant's typed answer from Phase 1 is stored and re-displayed during Phase 2/3. This requires tracking which answer corresponds to which question across experimental phases — a design pattern for any reflection/reassessment paradigm regardless of topic.

**Key measures**:
- Agreement ratings (do participants still stand by their original answers?)
- Pre-post shift in agreement (reflection ratings as a function of information exposure)
- Answer content analysis (qualitative coding of Phase 1 free responses)
- Individual differences in receptivity to climate information

## Must Confirm

- **Questions**: What climate change questions to ask? (e.g., beliefs about causes, personal concern, policy support, behavioral intentions)
- **Informational passage**: What content to present between phases? Scientific consensus text, narrative stories, statistical data, or multiple conditions?
- **Number of questions**: How many? (typically 5–10 for reasonable task duration)
- **Rating scale**: Continuous slider (0–100) or Likert scale (e.g., 1–7)?
- **Topic flexibility**: Climate change topic only, or adaptable to other attitude domains (vaccine beliefs, political attitudes, etc.)?
- **Control condition**: Include a no-information control group, or within-subjects pre-post only?

## Trial Window Timeline

```text
Phase 1 — Free Response:
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Question                 │    │ Text Response            │
│ Content: question text   │    │ Content: text input box  │
│ Duration: until Enter    │    │ Duration: until Enter    │
│ Response: none           │    │ Response: free text      │
│ Data: this_question      │    │ Data: answer.text        │
└──────────────────────────┘    └──────────────────────────┘

Phase 2 — Information:
┌──────────────────────────┐
│ Information Passage      │
│ Content: climate text    │
│ Duration: self-paced     │
│   (press key to continue)│
│ Response: any key        │
│ Data: reading_time       │
└──────────────────────────┘

Phase 3 — Reflection:
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Question + Prior Answer  │    │ Agreement Rating         │
│ Content: question +      │    │ Content: slider          │
│   "You answered: {text}" │    │   (0 = completely disagree│
│ Duration: self-paced     │    │    100 = completely agree)│
│ Response: none           │    │ Duration: until response │
│ Data: this_question,     │    │ Response: slider drag    │
│   previous_answer        │    │ Data: slider.response    │
└──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

Primary analysis compares agreement ratings across questions. Examine whether agreement shifts systematically after information exposure. Analyze free-text responses (Phase 1) using qualitative content analysis or NLP topic modeling. Test individual difference moderators (political orientation, environmental values, science literacy) on agreement change. Compare different information conditions (if multiple passages are used between subjects).

## References

Developed as part of climate change engagement research using the PsychoJS platform. Adaptable to any domain requiring reflection on prior beliefs after information exposure.

## Do Not Assume

- Do not assume the informational passage is the same for all participants — between-subjects manipulation with different passage types (e.g., scientific consensus, personal narrative, solution-oriented) is the core experimental design; a single-passage within-subjects design weakens causal inference.
- Do not assume participants will fully read the informational passage — reading time must be recorded (`reading_time`) as a manipulation check; participants who skim or skip the passage dilute the experimental manipulation.
- Do not assume the reflection rating uses a 0–100 continuous slider — some implementations use Likert scales (e.g., 1–7) or bipolar scales (−3 to +3); the scale type affects whether parametric or non-parametric analyses are appropriate.
- Do not assume all Phase 1 questions must reappear in Phase 3 — some designs include filler questions that are asked but not reflected upon, or randomly sample a subset for reflection to reduce demand characteristics.
- Do not assume the topic is climate change — the paradigm structure (free answer → information exposure → reflection and re-evaluation) is domain-general and equally applicable to vaccine attitudes, political beliefs, AI risk perception, or any attitude object.
- Do not assume Phase 2 always precedes Phase 3 — some control-group designs place the informational passage after reflection (Phase 2 and Phase 3 swapped) to establish a no-exposure baseline.

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| question_id | str | Question unique identifier, used for cross-stage data linking (such as `"Q01"`, `"Q02"`) |
| question_text | str | Question text presented in Phase 1 and Phase 3 |
| question_category | str | Question category (such as `"belief"`, `"concern"`, `"policy"`, `"behavior"`), used for dimensional analysis |

## Variants

### Multi-information condition variant

Randomly assign subjects to different information text conditions (such as scientific consensus group vs. personal narrative group vs. neutral control group), and Phase 2 presents different content according to the group. The core issue is the differential impact of different message frames on attitude change. Condition assignment needs to be determined before the experiment by randomization or Latin square.

### General Attitude Reflection Task

Replace climate issues with other attitude objects (vaccine attitude, political attitude, AI risk perception, etc.), maintaining the same three-stage structure of "free answer → information exposure → reflection and re-evaluation". The content of question sets and information essays changes with the topic, but the code structure is completely reused. Refer to [rating.md](rating.md) for paradigm differences in single attitude ratings.

### Simplified two-stage variant

The free-response session in Phase 1 is omitted, and subjects are directly asked to rate Likert attitudes after reading the information text (that is, only the scoring part of Phase 2 + Phase 3 is retained). Suitable for scenarios where only the direction of attitude change is measured rather than the depth of reflection. The code is simpler, but the data dimension of text analysis is lost.

## Example

### User Request

> "I want to do a climate reflection experiment. The subjects first answer 5 questions about climate change (for example, do you believe climate change is happening? Are you willing to change your living habits? etc.). Each question is displayed separately. Use the text box to enter the answer and press Enter to submit. Then all subjects read a A short scientific consensus article (introducing that 97% of climate scientists agree that human activities cause global warming). Each question is then re-presented, and the subject's previous answer is displayed, allowing the subject to rate how much they agree with the previous answer using a 0-100 slider (0=completely disagree, 100=completely agree). 5 questions presented in random order. Participants were college students, running on macOS.

### Trial Window Timeline

```text
Phase 1 — Free Response (loop 5 questions):
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Problem presentation │ │ Text input │
│ Content: {question_text} │ │ Content: text box │
│ Duration: self-paced     │    │ Duration: until Enter     │
│ Response: none           │    │ Response: free text       │
│ File: none               │    │ File: none               │
│ Condition: {question_id} │    │ Condition: {question_id} │
│ Data: question_id        │    │ Data: answer.text        │
└──────────────────────────┘    └──────────────────────────┘

Phase 2 — Information (unified for all subjects):
┌──────────────────────────┐
│ Message text │
│ Content: Short scientific consensus article │
│ Duration: self-paced     │
│ (Press any key to continue) │
│ Response: any key        │
│ Data: reading_time       │
└──────────────────────────┘

Phase 3 — Reflection (Loop 5 questions):
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Question + Previous Answer │ │ Consistency Rating │
│ Content: {question_text} │ │ Content: Slider 0-100 │
│ "Your previous answer: {text}" │ │ Duration: until response │
│ Duration: self-paced     │    │ Response: slider drag    │
│ Response: key to continue│    │   + click to confirm     │
│ Condition: {question_id} │    │ Condition: {question_id} │
│ Data: question_id,       │    │ Data: agreement_rating   │
│   previous_answer        │    │                          │
└──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| P1-Question | {question_text} | self-paced (any key) | none | none | {question_id} | question_id |
| P1-Input | Text Box | until Enter | Free Text | none | {question_id} | answer.text |
| P2-Short article | Scientific consensus short article | self-paced (any key) | any key | none | none | reading_time |
| P3-Review | {question_text} + "Your previous answer: {text}" | self-paced (any key) | none | none | {question_id} | question_id, previous_answer |
| P3-Rating | Slider 0-100 | until confirm | slider drag + click | none | {question_id} | agreement_rating |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment Name | Climate Reflection Task (Scientific Consensus Condition) |
| Platform | PsychoPy |
| Task Type | Climate Reflection Task (Attitude Reflection Re-evaluation) |
| Number of questions | 5 questions (random order) |
| Question content | Climate change beliefs, personal concerns, living habits, policy support, behavioral intentions |
| Information condition | Single condition (scientific consensus essay), unified for all subjects |
| Phase 1 input method | Text box, Enter submission |
| Phase 3 scoring method | Continuous slider 0–100, drag and click to confirm |
| Subject group | College students |
| Operating system | macOS (Font: PingFang) |
| Experimental phase | Instructions → Phase 1 (5 questions) → Phase 2 (essay) → Phase 3 (5 questions) → End |

### Missing Information

1. The specific content of the informational essay is not provided - the full text (approximately 200–500 words) or confirmation of whether it was prepared by the experimenter is required
2. The confirmation method of the slider is not clear - is it recorded after dragging it or does it require clicking the "Confirm" button? It is currently assumed to be click to confirm after dragging
3. Are subjects allowed to modify their previous answers in Phase 3? It is currently assumed that only grading and original answers cannot be modified.

### Critical Assumptions

- 5 questions are presented once each in Phase 1 and Phase 3. The order of Phase 1 is randomized, and the same random order is used in Phase 3 to ensure that the subjects can correspond one to one.
- The information text is a single condition, and there is no random grouping between subjects; if multiple conditions are needed to compare, it needs to be extended to a between-subjects design
- There is no word limit for input in the text box, but it is recommended to indicate "no less than 20 words" in the instruction to ensure the quality of the answer.
- The initial position of the slider is set to 50 (neutral) to avoid the anchoring effect of the initial value on the subject's score.

### Code Architecture

```
climate_reflection.py
├── Import module (psychopy.gui, visual, event, data, core)
├── Parameter configuration (window size, font, color, question file path, short text)
├── Window initialization (full screen/window, background color)
├── Read question file (conditions.xlsx → question_id, question_text)
├── Question order randomization
├── Phase 1 — Free answer cycle:
│ ├── Show question text
│ ├── Text input box (visual.TextBox2 / custom text input)
│ ├── Listen for Enter key submission
│ └── record answer.text + question_id + rt_phase1
├── Phase 2 — Information text:
│ ├── Display short text (visual.TextStim, multiple lines)
│ ├── Monitor any key to continue
│ └── record reading_time
├── Phase 3 — Reflective Grading Cycle:
│ ├── Show question text + "Your previous answer: {answer.text}"
│ ├── Display slider (visual.Slider, 0–100, initial=50)
│ ├── Monitor slider drag + confirm click
│ └── record agreement_rating + rt_phase3
├── End interface
├── Data saving: try/finally CSV, incremental writing
│ ├── Basic columns: participant, date, expName
│ ├── Phase 1 columns: question_id, answer_text, rt_phase1
│ ├── Phase 2 column: reading_time
│ └── Phase 3 columns: agreement_rating, rt_phase3
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| participant | str | participant number |
| question_id | str | question number (cross-stage matching key) |
| question_text | str | question text |
| question_category | str | question category |
| answer_text | str | Phase 1 Free Answer Text |
| rt_phase1 | float | Phase 1 response time (ms) |
| reading_time | float | Phase 2 short article reading time (ms) |
| agreement_rating | float | Phase 3 agreement score (0–100) |
| rt_phase3 | float | Phase 3 scoring reaction time (ms) |
