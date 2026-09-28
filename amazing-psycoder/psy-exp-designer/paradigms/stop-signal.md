# Stop-Signal Paradigm

> **Structure ref**: [spec-template.md](../references/spec-template.md)
> **Standards**: [timing](../references/timing.md) · [data recording](../references/data-recording.md) · [randomization](../references/randomization.md) · [missing info](../references/missing-information.md) · [condition file](../references/condition-file.md)

## When to Use

User mentions: Stop-signal, stop signal, SST, stop-signal task, SSRT, stop-signal reaction time.

## Core Logic

Participants respond to a "go" stimulus, but on a subset of trials a "stop" signal appears after a delay, instructing them to withhold the response. Measures the latency of the inhibitory process (SSRT).

Typical: 70–75% go trials, 25–30% stop trials. SSD (stop-signal delay) adapts based on performance — increases after successful stops, decreases after failed stops — to converge on ~50% stopping probability.

## Must Confirm

Before generating stop-signal code, confirm ALL of these:

1. **Go stimulus**: what is the go signal?
2. **Stop signal**: what is the stop signal? (tone, visual cue, color change?)
3. **Response mapping**: single key or choice RT? If choice, what are the go stimuli?
4. **SSD algorithm**: adaptive staircase? If so, step size (typically 50 ms)?
5. **Initial SSD**: starting delay (typically 250 ms)?
6. **SSD bounds**: minimum and maximum allowed SSD (typically 50 ms–800 ms)?
7. **Stop probability**: what fraction of trials have a stop signal? (typically 25–30%)
8. **Go trial deadline**: response deadline for go trials? (typically 1000–1500 ms)
9. **Feedback**: is inhibition performance feedback shown?
10. **ITI duration**: Trial interval time and variation range?
11. **OS & font**: What operating system is it running on? If using Chinese, confirm the font
12. **Display**: Full screen or window? Stimulus size and screen location?
13. **Instruction text**: Instruction content? How to explain the stop signal to subjects?

## Do Not Assume

- Do not assume single go key — choice RT stop-signal uses two keys
- Do not assume fixed SSD — adaptive tracking is the standard method
- Do not assume a step size — confirm (50 ms is typical but varies)
- Do not assume SSDs are independent per subject — they should be tracked separately
- Do not assume feedback is shown — many SST designs omit it to avoid slowing
- Do not assume SSRT is calculated online — it's typically computed offline using the integration method

## SSRT Calculation (for reference)

SSRT is estimated from the go RT distribution and the SSD:
- Integration method: find the nth percentile of go RTs where n = p(respond|stop) × 100, subtract mean SSD
- This is an offline calculation. The experiment code should save sufficient data for it.

## Condition File Columns

Columns in the xlsx/csv file that drives each trial:

| Column | Type | Description |
|--------|------|-------------|
| stop_trial | int | 1 if stop signal present, 0 if not |
| ssd | float | Stop-signal delay (ms). Pre-filled for fixed SSD; `"adaptive"` for staircase |

## Data Output Columns

| Column | Type | Description |
|--------|------|-------------|
| trial_type | str | `"go"` or `"stop"` |
| ssd | float | Stop-signal delay (ms). `None` for go trials |
| stop_response | int | 1 if responded on stop trial, 0 if successfully inhibited |
| go_rt | float | RT on go trials (for SSRT calculation) |
| go_omission | int | 1 if no response on go trial |

## Randomization Checks

- Stop-signal trials must not cluster — distribute evenly within block
- Verify stop probability matches target (25–30%)

## Common Failure Modes

- Not implementing adaptive SSD tracking correctly (wrong step direction)
- Not recording SSD per trial (required for SSRT calculation)
- Using a fixed deadline that masks go RT distribution (go deadline should be generous enough to capture the full RT distribution)
- Not clearing keyboard buffer before each trial
- Confusing stop-signal with go/no-go — SST has an initial go response that must be cancelled

## References

Logan, G. D., & Cowan, W. B. (1984). On the ability to inhibit thought and action: A theory of an act of control. *Psychological Review*, *91*(3), 295–327. https://doi.org/10.1037/0033-295X.91.3.295

Logan, G. D., Schachar, R. J., & Tannock, R. (1997). Impulsivity and inhibitory control. *Psychological Science*, *8*(1), 60–64. https://doi.org/10.1111/j.1467-9280.1997.tb00545.x

Verbruggen, F., & Logan, G. D. (2008). Response inhibition in the stop-signal paradigm. *Trends in Cognitive Sciences*, *12*(11), 418–424. https://doi.org/10.1016/j.tics.2008.07.005

Verbruggen, F., Aron, A. R., Band, G. P., Beste, C., Bissett, P. G., Brockett, A. T., ... & Boehler, C. N. (2019). A consensus guide to capturing the ability to inhibit actions and impulsive behaviors in the stop-signal task. *eLife*, *8*, e46323. https://doi.org/10.7554/eLife.46323

---

## Example

### User Request

> "I want to do a stop signal task. The subjects responded to the arrow direction: press F for the left arrow and press J for the right arrow. In 25% of the trials, there will be a sound signal (750Hz pure tone) after the arrow appears, indicating the need to stop the response. The stop signal delay (SSD) uses the adaptive ladder method, initial 250 ms, step size 50 ms, range 50-800 ms. There are 4 blocks of 80 trials each in the formal experiment. There are 30 practice trials before the arrow is pressed or until 1000 ms. The ITI is randomly 800-1200 ms.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Fixation                 │    │ Go Stimulus              │    │ Feedback                 │    │ ITI                      │
│ Content: + │ │ Content: ← or → │ │ Content: True/Wrong │ │ Content: empty │
│ Duration: 500 ms         │    │ Duration: until key      │    │ Duration: 500 ms         │    │ Duration: 800-1200 ms     │
│ Response: none           │    │ Response: f/j            │    │ Response: none           │    │ Response: none           │
│ File: none               │    │ File: none (text)        │    │ File: none               │    │ File: none               │
│ Condition: none          │    │ Condition: {arrow_dir}   │    │ Condition: {correct_resp}│    │ Condition: none          │
│ Data: none               │    │ Data: rt, key, acc, ssd  │    │ Data: none               │    │ Data: none               │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Fixation | + | 500 ms | none | none | none | none |
| Go Stimulus | ← or → (+ 750Hz tone if stop) | until key (deadline 1000 ms) | f=left, j=right (withhold on stop) | none (text) | {arrow_dir} | rt, key, acc, ssd, stop_trial |
| Feedback | Correct/Wrong/Too Slow | 500 ms | none | none | {correct_response} | none |
| ITI | empty | 800-1200 ms random | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Stop-Signal Task (Arrows) |
| Platform | PsychoPy |
| Task type | Stop-signal |
| Go stimulus | Left arrow (←) or Right arrow (→) |
| Stop signal | 750Hz pure tone, auditory |
| Response mapping | F=left arrow, J=right arrow |
| Stop probability | 25% of trials |
| SSD algorithm | Adaptive staircase, independent per subject |
| Initial SSD | 250 ms |
| SSD step size | 50 ms |
| SSD bounds | 50 ms–800 ms |
| Go deadline | 1000 ms |
| Phases | Instruction → Practice(30) → Block1-4(80 each) |

### Missing Information

1. Fixation not stated → assumed 500 ms (design assumption, flagged)
2. Feedback in practice only or formal too? → will ask
3. Stop-signal duration? → assumed 100 ms tone

### Assumptions

- Stop signal is auditory (750Hz tone, 100 ms duration)
- Two independent SSD staircases (one per go response direction) — standard approach
- Equal left/right arrow frequency within go and stop trials
- No feedback in formal blocks (avoids slowing responses)
- Keyboard response prioritized over tone onset for stop trials
- Anticipatory RT threshold: 100 ms

### Expected Code Architecture

```
stop_signal.py
├── Parameters (SSD params, keys, timing, stop probability)
├── Window setup + sound preloading (750Hz tone via sound.Sound)
├── SSD tracking: ssd = 250 ms initial, ±50 ms per staircase
├── Trial loop:
│   ├── Fixation (500 ms)
│   ├── Arrow onset (kb.clock reset via callOnFlip)
│   ├── [If stop trial] Schedule tone after current SSD
│   ├── Response window (deadline 1000 ms)
│   ├── Update SSD: increase 50 ms if stop success, decrease 50 ms if fail
│   ├── Feedback (if applicable, 500 ms)
│   └── ITI (800-1200 ms random)
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

Base columns + trial_type, ssd, stop_response, go_rt, go_omission
