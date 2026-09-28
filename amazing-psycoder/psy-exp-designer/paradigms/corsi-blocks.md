# Corsi Block-Tapping Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/corsi_blocks) · PsychoJS

## When to Use

User mentions: Corsi blocks, Corsi span, spatial working memory, visuospatial span, Corsi blocks, spatial working memory. Measures visuospatial short-term/working memory span by requiring participants to reproduce a sequence of spatial locations.

## Core Logic

Nine blocks are arranged in an irregular spatial pattern on screen (the classic Corsi board layout, avoiding a regular grid to prevent verbal encoding). On each trial, a subset of blocks is highlighted (flashed) one at a time in a random sequence. The participant must reproduce the sequence by clicking the blocks in the same order (forward span).

**Two-phase within-trial structure**:
1. **Presentation phase**: Blocks flash in sequence with a fixed stimulus onset asynchrony. Each block briefly changes color (e.g., from dark to light) to indicate selection.
2. **Recall phase**: The participant clicks blocks with the mouse to reproduce the sequence. Mouse position is tracked via `eventManager.getMousePos()` to detect clicks on block locations.

**Adaptive sequencing**: The task is self-contained in a single routine that programmatically generates sequences. Sequence length starts at 2 and increases with successful reproduction (span increases) or decreases with failure (span decreases). The task continues until a stopping criterion is met (e.g., failure on both attempts at a given span length).

**Span scoring**: The traditional method gives two attempts at each sequence length. The span score is the longest sequence length for which at least one trial was correctly reproduced. An alternative is the total correct trials score (sum of all correctly reproduced sequences). Typical forward spans are 5–7 items for healthy young adults; backward spans (reverse order recall) are typically 1–2 items shorter and tap the central executive.

**No condition files**: Unlike most PsychoJS experiments, the Corsi task does not use a condition spreadsheet. All sequence generation, presentation timing, and response collection logic is implemented programmatically in code components.

## Must Confirm

- **Direction**: Forward span (same order) or backward span (reverse order), or both?
- **Block count**: Classic 9-block Corsi board or custom arrangement?
- **Scoring method**: Strict span (longest length with at least 1 correct) or total correct?
- **Stopping rule**: Two attempts per span, or different rule?
- **Starting length**: Sequence length 2, or custom?
- **Recall modality**: Mouse click on screen, or touchscreen tap (different hit detection)?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Presentation Phase       │    │ Recall Phase             │
│ Content: blocks flash    │    │ Content: 9 blocks static │
│   in sequence            │    │ Duration: until click    │
│ Duration: N * SOA        │    │   (self-paced)           │
│   (SOA ~750-1000 ms)     │    │ Response: mouse clicks   │
│ Response: none           │    │   on blocks              │
│ Condition: {seq_length}  │    │ Condition: none          │
│ Data: sequence presented │    │ Data: sequence clicked,  │
└──────────────────────────┘    │   accuracy               │
                                └──────────────────────────┘
```

## Data Analysis

Primary measures: Corsi span (forward, backward, or both), total correct trials score. Compare to digit span for domain-specific working memory dissociations. Clinical populations (e.g., patients with right-hemisphere lesions, neglect, or ADHD) often show disproportionate Corsi deficits relative to verbal spans. Analyze error types: order errors vs. item omissions vs. intrusions.

## References

Corsi, P. M. (1972). Human memory and the medial temporal region of the brain. *Dissertation Abstracts International, 34*(2-B), 891.

Kessels, R. P. C., van Zandvoort, M. J. E., Postma, A., Kappelle, L. J., & de Haan, E. H. F. (2000). The Corsi block-tapping task: Standardization and normative data. *Applied Neuropsychology, 7*(4), 252–258. https://doi.org/10.1207/S15324826AN0704_8

## Do Not Assume

- Do not assume recall direction is forward-only without confirmation. Reverse recall (backward Corsi) is equally common and involves different cognitive processes—reverse requires the involvement of central executive functions (retention and manipulation of information), while forward primarily measures visuospatial storage. Confirm whether it is forward, reverse, or both.
- Do not assume the classic 9-block Corsi layout without confirmation. Although 9-block is the most classic configuration, some studies use simplified versions (such as 5-block for children or patients with severe cognitive impairment) or customize the spatial arrangement to accommodate special populations or screen sizes.
- Do not assume mouse click is the only valid response modality. Touch screen clicks are also common in tablet experiments and clinical bedside evaluations. The click detection logic is different from that of the mouse (direct touch screen coordinates vs. mouse cursor tracking + click events), requiring different hit detection implementations.
- Do not assume a fixed SOA across studies without confirmation. Typical SOA is 750-1000 ms, but some studies use 500 ms or 1500 ms. Faster SOA increases task difficulty, affects coding depth, and needs to be aligned with existing literature.
- Do not assume the stopping rule is always two-attempts-per-span. Some implementations use a single attempt, three attempts, or a fixed total number of attempts (such as a fixed 4 attempts per span length). Stopping rules directly affect the calculation method and statistical power of span scores.
- Do not assume condition files are used. Unlike most other PsychoJS experiments, Corsi tasks typically generate sequences, control presentation timing, and collect responses entirely through code, without using conditional spreadsheets.

## Condition File Columns

Corsi tasks typically do not use conditional files - all sequence generation, presentation timing, and response collection are implemented programmatically in code components. If you need to create a condition file for experimental design (e.g. fixing a sequence across subjects for exact replication), the simplest form is as follows:

| Column | Type | Description |
|--------|------|-------------|
| sequence | str | The block sequence of this trial, a comma-separated list of block numbers (such as `"3,7,2,5"`) |
| span_length | int | sequence length (such as 4) |
| direction | str | `"forward"` or `"backward"` |

## Variants

### Backward Corsi

Participants are required to reproduce the presented sequence in **reverse order**. Compared with forward Corsi, reverse Corsi has higher requirements on central executive function (the need to maintain and manipulate information), and the typical reverse span is 1-2 terms lower than the forward span. In clinical populations, reverse Corsi is more sensitive to deficits in frontal lobe function and is often used in conjunction with the stroop task (see [stroop.md](stroop.md)) and the n-back task (see [n-back.md](n-back.md)) to comprehensively assess executive function.

### Corsi Supraspan Learning

The same sequence is repeatedly presented at a fixed sequence length (usually set to the subject span+1 or span+2), and the number of learning times required to achieve a completely correct reproduction is measured. This variant assesses visuospatial learning ability rather than simple short-term memory span and is more sensitive to hippocampal and medial temporal lobe function.

### Touchscreen/Tablet Corsi（Touchscreen/Tablet Corsi）

An adapted version for mobile devices or tablets that uses touch events instead of mouse clicks. In addition to the differences in input methods, it is also necessary to consider the problem of finger occlusion (the finger may block the target block when touching), physical size adaptation of the block size, and coordinate calibration for different screen resolutions. The 9-tile layout can be crowded on smaller tablets, and is sometimes reduced to a 5-tile or 7-tile version.

---

## Example

### User Request

> "I am going to do a Corsi square task experiment. 9 irregular squares are presented on the screen, and each trial highlights several of the squares in sequence (starting from length 2). After the highlighting is completed, the subject needs to use the mouse to click on the highlighted squares in the same order. There are 2 attempts for each sequence length, and if both are wrong, stop. If at least 1 is correct, the sequence length + 1 continues. Forward recall. Highlight each square for 750 ms, with an interval of 500 ms. using PsychoPy.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │
│ Presentation stage │ │ Recall stage │
│ Content: 9 static blocks │ │ Content: 9 static blocks │
│ Highlight N blocks in sequence │ │ (no highlighting) │
│ Duration: N × 750 ms │ │ Duration: until click complete │
│ + (N-1) × 500 ms ISI │ │ (custom pace) │
│ Response: none │ │ Response: Mouse click on the box │
│ Condition: {span_length} │    │ Condition: none          │
│ Data: Presentation sequence │ │ Data: Click sequence, acc │
└──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | Condition | Data |
|--------|---------|----------|----------|-----------|------|
| Presentation stage | 9 squares, highlighted in sequence | N×750ms presentation + (N-1)×500ms interval | none | {span_length} | presented_sequence |
| Recall stage | 9 static squares | Self-set pace (until clicked N times) | Mouse click on the square | none | clicked_sequence, acc |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Corsi Block-Tapping Task |
| Platform | PsychoPy |
| Task type | Corsi blocks (visuospatial working memory span) |
| Block count | 9 (classic Corsi layout) |
| Recall direction | Forward (same order) |
| Starting span length | 2 |
| Attempts per span | 2 |
| Stopping rule | Stop when both attempts at a given span fail |
| Highlight duration | 750 ms per block |
| Inter-block interval | 500 ms |
| Response modality | Mouse click on blocks |
| Condition file | None (fully programmatic) |

### Missing Information

1. The specific screen position of the block is not specified → the classic Corsi 9-block irregular layout coordinates are used by default (need to confirm the screen resolution to scale the coordinates)
2. The content of the guidance is not specified → Need to ask: the wording of the guidance and whether it contains sample demonstrations
3. Whether to collect practice data is not clear → Need to confirm: Does it include a practice phase? Is the practice data saved?

### Critical Assumptions

- Uses classic 9-block Corsi irregular layout (non-grid arrangement to prevent speech coding)
- Forward recall (not reverse), mouse click input, no time limit recall stage
- No practice stage - directly enter the formal test; if the user expects to practice, additional information is required
- Span score = longest sequence length correct at least 1 time (classic scoring method)
- The same block does not appear repeatedly in the sequence (sampling without replacement)

### Expected Code Architecture

```
corsi_blocks.py
├── Parameters (n_blocks=9, start_span=2, max_attempts=2,
│               highlight_dur=0.75, isi=0.5)
├── Window setup (full screen or window)
├── Block position definition (classic Corsi 9-block layout)
│   └── List of (x, y) coordinates, scaled to window size
├── Trial generation (programmatic — no condition file):
│   ├── span_length ← 2
│   ├── while stopping criterion not met:
│   │   ├── for attempt in range(2):
│   │   │   ├── Generate random sequence of span_length blocks
│ │ │ ├── Presentation phase: Highlight each block in sequence
│   │   │   │   (highlight_dur + isi between)
│ │ │ ├── Recall phase: Wait for N mouse clicks on blocks
│   │   │   ├── Score: compare clicked vs. presented sequence
│   │   │   └── Record: span_length, attempt, sequence, acc
│   │   ├── If at least 1 correct: span_length += 1
│   │   ├── Else: stop and compute final span score
│   └── End screen with span score
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| span_length | int | Current sequence length |
| attempt | int | Number of attempts at the current length (1 or 2) |
| presented_sequence | str | presented block sequence (such as `"3,7,2,5"`) |
| clicked_sequence | str | The sequence of blocks clicked by the subject (such as `"3,7,2,5"`) |
| acc | int | 1 = completely correct (same order), 0 = wrong |
| span_score | float | Final span score (written uniformly after the task ends) |
