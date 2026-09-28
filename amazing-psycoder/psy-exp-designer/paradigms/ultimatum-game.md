# Ultimatum Game

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/ultimatum) · reference

## When to Use

User mentions: Ultimatum game, UG, fairness, social decision-making, economic game, ultimatum game, fair game. A two-player economic game that measures fairness preferences and the willingness to incur personal costs to punish unfair treatment.

## Core Logic

The participant (Responder) is told they are paired with another player (Proposer), who has been given a sum of money to split. The Proposer makes an offer specifying how much the Responder receives (e.g., "Proposer gets $7, you get $3"). The Responder can either accept the offer (both players receive the proposed amounts) or reject it (neither player receives anything). The rational self-interest prediction is that Responders should accept any non-zero offer. In reality, low offers (typically below 20-30% of the total) are rejected at high rates, demonstrating fairness-driven punishment.

Key manipulations: the stake size (total amount to split), the identity of the Proposer (human vs. computer), the context (e.g., earned vs. windfall endowment), and whether the game is one-shot or repeated. Offers are typically presented as pre-determined splits (e.g., $5:$5 fair, $8:$2 unfair, $9:$1 very unfair), though some versions involve real-time human proposers.

This implementation frames the participant as the Responder. A simulated "connection" sequence (6 s total: 4 s "connecting to other player..." + 2 s "Connected!") enhances the cover story. On each trial, the proposed split is displayed (amount out of 10 pounds total), and the participant clicks an "Accept" or "Reject" button (mouse-based ButtonStim). After the choice, the outcome is displayed: both players' earnings if accepted, or "You rejected the offer. Nobody gets anything." if rejected. A fairness check (`offer >= amount/2`) is used to categorize offers as fair or unfair.

Typical design: offers range from 0 to the full stake, with standard offers being 5:5 (fair), 7:3/8:2 (unfair), and 9:1/10:0 (very unfair). Earnings accumulate across trials. The key behavioral measure is the rejection rate at each offer level.

## Must Confirm

- **Stake amount**: How much money to split? (typically 10 units, e.g., $10 or 10 pounds)
- **Offer set**: Which specific offer splits to present? (e.g., 5:5, 7:3, 8:2, 9:1)
- **Player role**: Participant always as Responder, or does the role alternate?
- **Cover story**: "Connected to another player" simulation, or transparent about pre-programmed offers?
- **Proposer identity**: Human (with photo/name), computer algorithm, or anonymous?
- **Response mode**: Mouse click on Accept/Reject buttons, or keyboard response?
- **Outcome display**: Show earnings after each trial, or only at the end?
- **Post-trial ratings**: Collect fairness judgments or emotion ratings after each offer?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Connection Simulation    │    │ Offer + Decision         │    │ Outcome Display          │
│ Content: "Connecting to  │    │ Content: proposed split  │    │ Content: earnings or     │
│ other player..." (4 s)   │    │ (e.g., "Proposer: £7     │    │ "Nobody gets anything"   │
│ then "Connected!" (2 s)  │    │ You: £3") + Accept/      │    │ Duration: ~2 s            │
│ Duration: 6 s total      │    │ Reject buttons           │    │ Response: none            │
│ Response: none           │    │ Duration: until click    │    │ Data: none                │
│ Data: none               │    │ Response: mouse click    │    │                           │
│                          │    │ Data: choice, RT, offer  │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

## Data Analysis

The primary dependent variable is the acceptance rate as a function of offer amount. Plot acceptance rate against offer size (or fairness level). Typically, acceptance rates increase with offer size, with a sharp drop-off below 30-40%. Compare acceptance rates between conditions (e.g., human vs. computer proposer — higher rejection of unfair human offers indexes social preferences). Individual differences (e.g., trait agreeableness, psychopathy, autism) correlate with rejection rates. Rejection rates are also used to index negative reciprocity and anger-driven punishment.

## References

Guth, W., Schmittberger, R., & Schwarze, B. (1982). An experimental analysis of ultimatum bargaining. *Journal of Economic Behavior & Organization, 3*(4), 367–388. https://doi.org/10.1016/0167-2681(82)90011-7

Camerer, C. F. (2003). *Behavioral game theory: Experiments in strategic interaction*. Princeton University Press.

## Do Not Assume

- Do not assume that the participant is always the Responder role - some variants alternate roles or let the participant act as the Proposer, and the role allocation method needs to be clearly confirmed
- Do not assume the proposer is a human — computers/algorithms acting as proposers are a common practice used to distinguish social preferences from risk preferences. The identity of the proposer needs to be confirmed (real photo/name, anonymous, or computer algorithm)
- Do not assume assignments are pre-programmed — some implementations involve real-time human proposers, require online matchmaking, or use virtual player logic
- Do not assume acceptance/rejection is the only dependent variable - some designs collect fairness ratings or emotion ratings after each trial, need to confirm whether post-trial ratings are required
- Do not assume that the total amount is fixed at 10 units - different studies use different denominations (such as $10, £10, 100 yuan, 100 points), and the bet amount and currency unit need to be clearly confirmed
- Do not assume that the connection simulation session is required — some experiments explicitly inform participants that the allocation plan is predetermined, and skip the connection animation to shorten the experiment time

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| proposer_amount | int/float | Amount received by the proposer |
| responder_amount | int/float | The amount received by the participant (Responder) |
| total_stake | int/float | Total allocation amount of this round |
| fairness | str | fairness classification (`"fair"`, `"unfair"`, `"very_unfair"`) |
| proposer_id | str | Proposer identity tag (`"human"` or `"computer"`) |

## Variants

- **Classic Ultimatum Game**: A single anonymous game in which the participants are fixed as Responders and make acceptance or rejection decisions for a series of preset allocation plans. Distribution plans typically include gradient levels such as fair (5:5), unfair (7:3, 8:2), and very unfair (9:1, 10:0). This is the most common implementation, and this document mainly describes this variant.
- **Dictator Game**: The Proposer unilaterally decides on the allocation plan. The Responder has no right to refuse and can only passively accept it. Used to measure purely altruistic preferences and fairness motives, excluding strategic considerations and punishment motives. Cross-reference dictator-game.md if it exists.
- **Multi-round Repeated Ultimatum Game**: The same pair of participants conduct multiple rounds of the game, with roles fixed or alternately rotated. Used to examine reputation building, reciprocity strategies, and learning effects. It may be necessary to display cumulative gains after each trial. Can be cross-referenced to trust-game.md if it exists.

---

## Example

### User Request

> "I want to use PsychoPy to do an ultimatum game experiment. Participants, as responders, see the distribution plan every time: how much the proposer gets, how much they get, and the total amount is 100 yuan. The distribution plans include: proposer 50 yuan/self 50 yuan (fair), proposer 70 yuan/self 30 yuan (unfair), proposer 90 yuan/self 10 yuan (very unfair). Each The plan appears 10 times, with a total of 30 trials, in a random order. Before the trial starts, the allocation plan is presented. There are two buttons 'Accept' and 'Reject' at the bottom of the screen. If accepted, the benefits of both parties are displayed. The results are presented for 2 seconds. There are no practice trials. "

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │ →  │ Window 4                 │
│ Connection Simulation │ │ Allocation Plan + Decision │ │ Result Presentation │ │ ITI │
│ Content: "Connecting │ │ Content: "The proposer gets: │ │ Content: Benefits of both parties (accepted) │ │ Content: Blank │
│ Other players..." │ │ ¥70, you get: ¥30" │ │ or "Both sides gain 0 yuan" │ │ Duration: 500-800 ms │
│ Duration: 3 s │ │ + Accept/Reject button │ │ (Reject) │ │ Response: none │
│ Response: none            │    │ Duration: until click     │    │ Duration: 2 s             │    │ Data: none               │
│ Data: none │ │ Response: Mouse click │ │ Response: none │ │ │
│                           │    │ Data: choice, RT, offer   │    │ Data: none                │    │                           │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

| Window | Content | Duration | Response | File/Folder | Condition | Data |
|--------|---------|----------|----------|-------------|-----------|------|
| Connection simulation | "Connecting to other players..." | 3 s | none | none | none | none |
| Allocation plan + decision | Allocation amount + accept/reject button | until mouse click | mouse click | none | {proposer_amount, responder_amount} | choice, rt, offer |
| Result presentation | Benefits of both parties or "Both parties' profits are 0 yuan" | 2 s | none | none | none | none |
| ITI | blank | 500-800 ms random | none | none | none | none |

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Ultimatum game task |
| Platform | PsychoPy |
| Mission Type | Ultimatum Game (Ultimatum Game) |
| Participant role | Responder |
| Total amount | 100 yuan |
| Allocation plan | 50:50 (fair), 70:30 (unfair), 90:10 (very unfair) |
| Number of attempts per plan | 10 times |
| Total number of attempts | 30 |
| Trial order | Random |
| Response method | Click the mouse to accept/reject button |
| Connection simulation | 3 seconds |
| Result presentation | 2 seconds |
| ITI | 500-800ms random |

### Missing Information

1. The identity of the proposer is not clear → It needs to be confirmed whether it is an "anonymous human player" or a "computer algorithm" (affects the cover story text and the presentation method after connecting to the simulation)
2. Whether it is necessary to display the cumulative total income after the experiment → affects the design of the results summary interface
3. The content of the guidance language is not provided → It is necessary to confirm the text of the guidance language and whether it is clearly informed that the allocation plan is preset

### Critical Assumptions

- The proposer is an anonymous human player, and the connection simulation is used to enhance the credibility of the cover story (default design assumption)
- After the experiment is over, the cumulative total revenue will not be displayed, only the acknowledgment page will be displayed.
- Instructions use the standard Ultimatum Game instruction template, including role descriptions and rule explanations
- No post-trial fairness ratings or mood ratings

### Code Architecture

```
ultimatum_game.py
├── Parameter settings (total_stake=100, offers, n_repeats, timing)
├── Window initialization (full screen/window)
├── Stimulus preloading (TextStim for assign text, ButtonStim for accept/reject)
├── Condition table generation (3 options × 10 times = 30 trials, randomly arranged)
├── Connection simulation (3 seconds, TextStim)
├── Trial cycle:
│ ├── Allocation plan presentation + accept/reject button
│ ├── Mouse click response (record choice, rt)
│ ├── Result presentation (2 seconds, revenue will be displayed based on selection)
│ └── ITI (500-800ms random)
├── Acknowledgments page
└── Data saving: try/finally CSV incremental writing
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| trial_index | int | trial number (0-based) |
| proposer_amount | float | Amount obtained by the proposer |
| responder_amount | float | Amount received by the participant |
| total_stake | float | Total amount of this round |
| fairness | str | fairness classification (`"fair"`, `"unfair"`, `"very_unfair"`) |
| choice | str | participant's choice (`"accept"` or `"reject"`) |
| rt | float | reaction time (seconds) |
| outcome_self | float | Actual income of participants in this round |
| outcome_proposer | float | The proposer's actual income in this round |
