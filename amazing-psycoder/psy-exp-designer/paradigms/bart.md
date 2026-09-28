# Balloon Analogue Risk Task (BART)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/bart) · reference

## When to Use

User mentions: BART, balloon task, risk-taking, balloon simulation risk task. A behavioral measure of risk-taking propensity in which participants inflate balloons to earn rewards, trading off the risk of bursting and losing earnings.

## Core Logic

On each trial, a balloon is displayed and the participant can repeatedly press a key to pump it up. Each pump increases the balloon's size and adds a small amount to a temporary reward counter. However, every pump also carries a risk: each balloon has a hidden explosion point, and if the participant exceeds it, the balloon bursts, all temporary earnings for that trial are lost, and a new balloon appears. The participant can choose to "cash out" at any point, transferring the temporary earnings to a permanent bank before the balloon would burst.

The explosion point for each balloon is drawn from a predetermined distribution. In the original Lejuez et al. (2002) paradigm, balloons burst according to a probability function; in the simplified demo, the explosion threshold (max pumps) is a random integer. Participants complete multiple balloons (typically 30). The critical question is how many pumps a participant makes on average, especially on trials where the balloon does not burst.

Key variables: number of pumps per balloon (adjusted), number of balloons burst, number of cash-outs, total earnings. The primary dependent measure is the adjusted average number of pumps (mean pumps on non-burst trials), which indexes risk-taking propensity independent of the balloon explosion threshold.

## Data Analysis

Filter out burst trials and compute mean pumps on remaining (non-burst) trials as the primary measure. Examine total earnings and number of explosions as secondary measures. Correlate adjusted pumps with self-report measures of sensation-seeking, impulsivity, and real-world risk behaviors (e.g., substance use, gambling). Variants introduce balloons with different colors/explosion profiles to examine sensitivity to risk probability.

## Must Confirm

- **Balloon count**: How many balloons? (typically 30)
- **Burst distribution**: What determines the explosion point — fixed probability per pump, random integer threshold, or fixed thresholds in conditions.xlsx?
- **Key mapping**: Which key for "pump" and which for "collect"?
- **Reward structure**: Reward per pump and what happens on burst?
- **Visual assets**: Balloon colors, background images, and burst sound?

## Trial Window Timeline

```
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Balloon Display          │    │ Pump Feedback             │    │ Outcome                  │
│ Content: balloon image   │    │ Content: balloon grows   │    │ Content: burst (sound)   │
│ + score + pump count     │    │ + score increments       │    │ OR collect confirmation  │
│ Duration: until key      │    │ Duration: 500 ms         │    │ Duration: 1000 ms        │
│ Response: pump/collect   │    │ Response: none           │    │ Response: none           │
│ Data: pump_count, score  │    │ Data: none               │    │ Data: burst (bool)       │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

Nested loop: outer loop over balloons, inner loop over pumps within each balloon. Balloon size increases with each pump via `balloon.setSize()`.

## Do Not Assume

- Do not assume the burst rule is a fixed probability per pump. In the original Lejuez BART, each pump has a probability of bursting; in simplified implementations, a pre-determined integer threshold (max pumps) is drawn per balloon. Confirm which burst distribution the user wants.
- Do not assume the pump key is always the space bar. In some setups, the pump key may be different from the collect key. Confirm both key mappings.
- Do not assume 30 balloons is the default for every experiment — the count may vary by study design or age group (e.g., 10 balloons for children, 90 for pharmacological studies).
- Do not assume all balloons share the same explosion profile. Some variants assign different burst probabilities or max-pump distributions to different balloon colors/conditions. Confirm if balloons are homogeneous or heterogeneous.
- Do not assume the reward per pump is a fixed amount. It may vary across conditions or increment non-linearly. Confirm the monetary or point reward structure, including what happens on burst (partial loss, total loss of trial earnings).
- Do not assume there is no practice phase. Some designs include 2–5 practice balloons to familiarize participants with the pump/collect mechanics before the formal task.

## Condition File Columns

Columns in the xlsx/csv file that define each balloon's hidden parameters:

| Column | Type | Description |
|--------|------|-------------|
| balloon_id | int | Balloon/round number (1..n_balloons) |
| max_pumps | int | Hidden explosion threshold for this balloon |
| reward_per_pump | float | Points or monetary increment per pump |
| balloon_color | str | Balloon color (if color-condition variant) |

## Variants

- **Standard BART (Standard BART)**: Original Lejuez et al. (2002) version, each balloon has a fixed explosion probability (such as 1/128), and whether to explode is determined based on this probability after each inflation. The explosion point is a hidden variable that cannot be directly observed by participants.
- **Multi-color BART (Multi-color BART)**: Balloons of different colors correspond to different explosion probability distributions. For example, red balloons have a lower average explosion point (high risk), while blue balloons have a higher average explosion point (low risk). Used to examine participants' sensitivity to risk probabilities and learning effects. Can be cross-referenced to risk-task.md.
- **Automatic-pump BART**: Balloons automatically inflate at regular intervals, and participants only need to decide when to stop and cash out. The confounding variable of keystroke frequency is removed, providing a more pure measure of the temporal dynamics of risky decisions. Can be cross-referenced to [stop-signal.md](stop-signal.md).

## References

Lejuez, C. W., Read, J. P., Kahler, C. W., Richards, J. B., Ramsey, S. E., Stuart, G. L., Strong, D. R., & Brown, R. A. (2002). Evaluation of a behavioral measure of risk taking: The Balloon Analogue Risk Task (BART). *Journal of Experimental Psychology: Applied, 8*(2), 75–84. https://doi.org/10.1037/1076-898X.8.2.75

---

## Example

### User Request

> "I want to use PsychoPy to do a BART experiment. A red balloon appears in the center of the screen. Press the space bar to inflate the balloon. Each time the balloon is inflated, it becomes a little larger and adds 0.5 points. Each balloon has a hidden explosion upper limit (a random integer between 1 and 128). If the number of inflation exceeds this limit, the balloon explodes and the score for the round is cleared. The participant can press Enter at any time to transfer the current score to the permanent account. There are 3 practice balloons with a feedback of 100 before the official experiment. ms. The result is displayed for 2000 ms after exploding or collecting money. The explosion sound effect is played when the balloon explodes.

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Balloon Display          │    │ Pump Feedback            │    │ Outcome                  │    │ ITI                      │
│ Content: Balloon image │ │ Content: Balloon getting bigger │ │ Content: Explosion animation/sound effect │ │ Content: Blank │
│ + Current score + Number of inflations │ │ + Score increase animation │ │ or "Money collected" prompt │ │ Duration: 500 ms │
│ Duration: until key pressed │ │ Duration: 100 ms │ │ Duration: 2000 ms │ │ Response: none │
│ Response: space (inflated) │ │ Response: none │ │ Response: none │ │ File: none │
│ or Enter (receive money) │ │ File: none │ │ File: burst_sound.wav │ │ Condition: none │
│ File: balloon.png        │    │ Condition: none          │    │ Condition: none          │    │ Data: none               │
│ Condition: {balloon_id}  │    │ Data: none               │    │ Data: burst (bool),      │    │                          │
│ Data: pump_count, acc    │    │                          │    │ trial_earnings           │    │                          │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Balloon Display | Balloon image + current score + number of inflation | Until button | Space (inflate) / Enter (collect money) | balloon.png | {balloon_id} | pump_count, accumulated_score |
| Pump Feedback | Balloon gets bigger + score increases animation | 100 ms | none | none | none | none |
| Outcome | Explosion animation/sound effect or "Money received" prompt | 2000 ms | none | burst_sound.wav | none | burst (bool), trial_earnings |
| ITI | Blank | 500 ms | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Balloon Analogue Risk Task |
| Platform | PsychoPy |
| Task type | BART (risk-taking) |
| Balloon count | 30 formal + 3 practice |
| Burst rule | Random integer threshold (1–128) per balloon |
| Pump key | Space (space bar) |
| Collect key | Enter (Enter key) |
| Reward per pump | 0.5 points |
| Burst consequence | Clear the current round score to zero |
| Pump feedback duration | 100 ms |
| Outcome duration | 2000 ms |
| ITI | 500 ms |
| Phases | Instruction → Practice(3) → Formal(30) |

### Missing Information

1. The path and specifications of the balloon image file are not specified → You need to confirm the size, color, and background requirements of balloon.png
2. The specific file and format of the explosion sound effect are not provided → You need to confirm the burst_sound.wav path or use the default sound effect
3. Whether it is necessary to display feedback on the number of inflations before the balloon explodes → It is necessary to confirm whether the cumulative number of inflations is displayed between trials

### Assumptions

- The explosion threshold is a uniformly distributed random integer (1–128), not based on a probability function, as specified in the request
- The balloon image is automatically reset to its initial size after each round, without smooth transition animation
- After the explosion, the score will be 0 instead of partial deduction; after collecting the money, the score will be transferred to the permanent account in full
- Practice balloon data is not included in the final analysis, but is stored for review

### Expected Code Architecture

```
bart.py
├── Parameters (n_balloons=30, n_practice=3, max_pumps_range=128, reward_per_pump=0.5)
├── Window setup (full screen or window)
├── Stimulus preloading (balloon.png, burst_sound.wav)
├── Generate condition file (balloon_id, max_pumps, reward_per_pump)
├── Practice loop (3 balloons)
├── Formal trial loop (30 balloons):
│ ├── Balloon display (until button: Space to inflate / Enter to collect money)
│ ├── Pump feedback (100 ms: balloon gets bigger + score increases)
│ ├── Outcome (2000 ms: explosion/money collection result)
│ │ └── If the number of inflations > max_pumps → burst=True, trial_earnings=0, play the sound effect
│ │ └── If press Enter → burst=False, trial_earnings transfer to permanent account
│   └── ITI (500 ms)
├── Data: try/finally CSV with incremental writes
```

### Expected Data Columns

Base columns + balloon_id, trial_type, pump_count, burst, trial_earnings, total_earnings

| Column | Type | Description |
|--------|------|-------------|
| balloon_id | int | Balloon number (1–30) |
| trial_type | str | `"practice"` or `"formal"` |
| pump_count | int | The total number of times the balloon has been inflated |
| burst | int | 1=explosion, 0=actively collect money |
| trial_earnings | float | Actual score of the round (explosion is 0) |
| total_earnings | float | Cumulative permanent account score |
| adjusted_pumps | float | Average number of pumps for non-explosive trials (calculated during analysis) |
| max_pumps | int | The hidden explosion threshold of the balloon (for experimental records) |
