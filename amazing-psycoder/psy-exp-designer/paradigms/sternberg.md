# Sternberg Memory Scanning Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/sternberg) · reference

## When to Use

User mentions: Sternberg task, memory scanning, short-term memory search, set size effect, Sternberg task, memory scanning. Measures the speed and nature of short-term memory retrieval by varying the number of items held in a memory set and measuring the time to determine whether a probe was present.

## Core Logic

On each trial, participants are shown a memory set of items (typically digits, e.g., "3 7 1") to memorize. After a brief retention interval, a single probe item is presented. Participants respond whether the probe was present in the memory set (yes/no judgment). The critical manipulation is the set size — the number of items in the memory set — which varies from trial to trial (e.g., 1 to 6 items).

Sternberg's (1969) classic finding is that RT increases linearly with set size at approximately 30-40 ms per additional item, and the slope is roughly equal for both positive (probe present) and negative (probe absent) responses. This parallel slope pattern supports a serial, exhaustive search model: the entire memory set is scanned on every trial, even when the probe is found early (self-terminating search would predict shallower slopes for positive trials). The intercept of the RT function estimates encoding + response time, while the slope estimates scanning rate per item.

This implementation uses a precisely timed trial sequence with all items of the memory set shown simultaneously: fixation cross for 1.0 s, memory set display for 1.5 s (digits as a space-separated string, e.g., "3 7 1"), a 2.0 s blank retention interval, then the probe digit appears. The keyboard begins listening at probe onset for frame-accurate RT. Response reminders ("LEFT if it was NOT" / "RIGHT if it WAS") appear after the probe has been on screen briefly. 

Design includes a practice block (with 1.0 s feedback showing "Correct! RT=Nms" or "Oops! That was wrong") followed by the main block (no feedback). Separate condition files (`pracTrials.xlsx`, `mainTrials.xlsx`) each have columns: `numberSet` (memory set string), `target` (probe digit string), and `corrAns` ('left' or 'right').

## Must Confirm

- **Set sizes**: Which memory set sizes to include? (typically 1-6 items)
- **Stimulus type**: Digits, letters, words, or other?
- **Memory set presentation**: Simultaneous (all items at once) or sequential (one at a time)?
- **Timing**: Fixation duration, memory set display duration, retention interval length?
- **Response mapping**: Which keys for "yes/in set" and "no/not in set"?
- **Practice**: Include a practice block with RT feedback before the main task?
- **Trial count**: How many trials per set size per response type (positive/negative)?

## Trial Window Timeline

```text
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│ Window 1             │→ │ Window 2             │→ │ Window 3             │→ │ Window 4             │→ │ Window 5             │
│ Fixation             │  │ Memory Set           │  │ Retention Interval   │  │ Probe                │  │ Feedback (practice   │
│ Content: +           │  │ Content: digits      │  │ Content: blank       │  │ Content: digit       │  │ only)                │
│ Duration: 1.0 s      │  │ (e.g., "3 7 1")      │  │ Duration: 2.0 s      │  │ Duration: ≤2.0 s     │  │ Content: correct/    │
│ Response: none       │  │ starts at t=1.2 s    │  │ Response: none       │  │ starts at t=4.7 s    │  │ incorrect + RT       │
│ Data: none           │  │ Duration: 1.5 s      │  │ Data: none           │  │ Response: left/right │  │ Duration: 1.0 s      │
│                      │  │ Response: none       │  │                      │  │ Data: rt, key, acc   │  │ Response: none       │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘  └──────────────────────┘  └──────────────────────┘
```

## Data Analysis

Plot mean RT as a function of set size, separately for positive and negative trials. Fit linear regression to estimate slope (ms/item) and intercept. Compare slopes between positive and negative responses (serial exhaustive vs. self-terminating). Test whether different populations (e.g., older adults, schizophrenia patients) show steeper slopes (slower scanning) or higher intercepts (slower encoding/response). Also analyze accuracy to ensure ceiling-level performance.

## References

Sternberg, S. (1969). Memory-scanning: Mental processes revealed by reaction-time experiments. *American Scientist, 57*(4), 421–457.

## Do Not Assume

- Do not assume that memory sets are displayed in simultaneous presentation mode. The Sternberg task can also be a sequential presentation (item-by-item presentation). The coding process and scanning strategy of these two methods may be different and need to be confirmed with the user.
- Do not assume that the probe stimulus appears in the center of the screen. Some implementations display detection items at positions other than fixed locations (such as random positions) to superimpose spatial components, and the location and size of the detection items need to be confirmed.
- Do not assume that the stimulus materials must be numbers. Letters, words, pictures, or other symbols are also commonly used in this paradigm, and the type of stimulus and whether font support is needed need to be confirmed.
- Do not assume that the ratio of positive and negative trials is 1:1. Although the number of trials in both types is equal in the standard design, the user may intentionally adjust the ratio (such as 2:1), which needs to be explicitly confirmed.
- Do not assume that the memory set size range is fixed at 1–6. Depending on the subject group and the purpose of the experiment, the range may be 1–4, 2–6 or other, and the value of the memory set size needs to be confirmed.
- Do not assume feedback must be included in the exercise block. Feedback may be in exercises only, in formals only, both, or neither, and the feedback strategy needs to be confirmed with the user.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| numberSet | str | Memory set string, each item is separated by spaces, such as `"3 7 1"` |
| target | str | Probe stimulus, such as `"7"` (present in the memory set) or `"5"` (not present) |
| corrAns | str | Correct key, `"left"` (not in memory) or `"right"` (in memory) |
| setSize | int | The number of items in the memory set (can be deduced from numberSet, but explicit recording is more convenient for analysis) |

## Variants

- **Sequential Presentation variant (Sequential Presentation)**: The items in the memory set are presented one by one in sequence (such as 500 ms for each item), rather than displayed simultaneously. This variant is used to study encoding strategies and scanning processes under time pressure. Related reference: [n-back](../paradigms/n-back.md).
- **Visual Search Comparison**: After completing a Sternberg task, the subject then completed the corresponding visual search task (stimuli were presented at the same time but no memory was required), and the difference between working memory scanning and perceptual search was revealed by comparing the slope of memory scanning and the slope of visual search.
- **Dual-task variant (Dual-task)**: perform a second task (such as articulatory suppression, key distraction, etc.) while performing memory scanning, used to examine the role of the central executive in the working memory scanning process. Related reference: complex-span (complex span task, which can be used to measure individual differences in working memory capacity).

---

## Example

### User request

> "I want to do a Sternberg memory scanning experiment. The fixation point 500 appears in the center of the screen first ms, and then display 2 to 5 random numbers as a memory set for 1.5 seconds. After the screen remains blank for 2 seconds, a detection number appears. If the detection number is not in the memory set, press the left arrow key. First do 12 practice trials with feedback, and then do 4 formal blocks of 24 ms. "

### Trial window timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │ →  │ Window 5                 │
│ Fixation point │ │ Memory set │ │ Hold interval │ │ Probe item │ │ Feedback (practice only) │
│ Content: + │ │ Content: "3 7 1 9" │ │ Content: blank │ │ Content: "7" │ │ Content: "Correct! RT=452ms"│
│ Duration: 500 ms         │    │ Duration: 1500 ms        │    │ Duration: 2000 ms        │    │ Duration: ≤2000 ms       │    │ Duration: 1000 ms        │
│ Response: none           │    │ Response: none           │    │ Response: none           │    │ Response: left/right     │    │ Response: none           │
│ Data: none               │    │ Data: none               │    │ Data: none               │    │ Data: rt, key, acc       │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

### Analyzed experimental specifications

| Field | Value |
|------|-----|
| Experiment Name | Digital Sternberg Memory Scan Task |
| Platform | jsPsych |
| Task Type | Sternberg Memory Scan |
| Stimulus | Number (0-9) |
| Memory set size | 2, 3, 4, 5 |
| Memory set presentation method | Simultaneous presentation |
| Memory set presentation time | 1500 ms |
| Fixation point duration | 500 ms |
| Hold interval | 2000 ms |
| Maximum presentation time of detection items | 2000 ms |
| Reaction mapping | Right arrow = in memory, left arrow = not in memory |
| Stage | Instructions → Practice (12 trials) → Block1-4 (24 trials each) |
| ITI | 800-1200 ms random |

### Missing information

1. **Font and Chinese Support**: Users use numbers as stimuli, no Chinese fonts are required. However, if you need to present Chinese instructions, you need to confirm the font loading path.
2. **Feedback method**: The user only mentioned that there is feedback for the exercise, but did not specify the specific format of the feedback (only text or including sounds/colors), which needs to be confirmed.
3. **Break between blocks**: The user has not mentioned the rest time between blocks. You need to confirm whether a rest page is needed and the duration of the rest.

### Key assumptions

- The default ratio of positive and negative trials is 1:1 (half of the probability of the detection item is in the memory set)
- Practice phase feedback shows "Correct/Incorrect" with RT (standard Sternberg practice settings)
- Numbers in the memory set are not repeated within the same trial (sampling without replacement)
- Expected RT threshold: 200 ms (below this is considered a premature response)
- Run in full screen, default white background and black text

### Code structure

```
sternberg.html (or sternberg.js)
├── Parameter configuration (setSizes, timing, key mapping)
├── Trial condition generation (cross setSize and positive and negative types)
├── jsPsych initialization + plug-in loading
├── Timeline construction:
│ ├── Instructions page
│ ├── Practice block (12 trials + feedback)
│ ├── Transition page
│ └── Formal experiment (4 blocks × 24 trials):
│ ├── block start prompt
│ ├── Trial cycle:
│ │ ├── fixation point (500 ms)
│ │ ├── Memory Set (1500 ms)
│ │ ├── Hold interval (2000 ms)
│ │ ├── Detection item (≤2000 ms, left/right arrow response)
│ │ └── ITI (800-1200 ms random)
│ └── End of block (if you need to rest)
└── Data saving (jsPsych data + CSV export)
```

### Expected data column

| Column | Type | Description |
|--------|------|-------------|
| numberSet | str | The memory set string for this trial |
| target | str | detection number |
| corrAns | str | Correct key (`"left"` or `"right"`) |
| setSize | int | memory set size |
| probeInSet | int | Whether the probe item is in memory (1=yes, 0=not) |
| rt | float | reaction time (ms) |
| acc | int | correctness (1=correct, 0=wrong) |
| keyPressed | str | The actual key pressed |
| block | int | block number (0=practice, 1-4=formal) |
| trialType | str | `"positive"` or `"negative"` |
