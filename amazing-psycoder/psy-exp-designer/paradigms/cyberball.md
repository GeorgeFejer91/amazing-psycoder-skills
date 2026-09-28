# Cyberball (Social Exclusion Paradigm)

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/cyberball) · reference

## When to Use

User mentions: Cyberball, ostracism, social exclusion, social rejection, cyberball, social rejection. A virtual ball-tossing game used to experimentally induce feelings of social inclusion or exclusion (ostracism).

## Core Logic

Participants are told they are playing an online ball-tossing game with two or three other participants (actually computer-controlled confederates). The game appears as a simple interface showing player icons. When a participant receives the ball, they click on one of the other players to throw the ball to them. Unbeknownst to the participant, the computer players follow a predetermined script dictating how often they toss the ball to the participant.

In the inclusion condition, the participant receives the ball roughly one-third of the time (equal participation). In the exclusion (ostracism) condition, the participant initially receives the ball a few times but is then excluded from play — the computer players toss the ball only among themselves. The paradigm is powerful: even brief (2-5 minute) exclusion reliably induces feelings of distress, lowered belonging, reduced self-esteem, reduced sense of meaningful existence, and reduced perceived control.

Typical design: 30-60 total throws, with the participant receiving 2-4 initial throws in the exclusion condition then none thereafter. Post-experiment, participants complete the Need-Threat Scale (assessing belonging, self-esteem, meaningful existence, and control) and a mood questionnaire. The Cyberball effect is remarkably robust — participants report distress even when told the other players are computer-controlled or from a despised outgroup.

## Must Confirm

- **Condition**: Inclusion, exclusion, or both? What percentage of throws does the participant receive in each condition?
- **Number of players**: 2 virtual players (total 3 including participant) or 3 virtual players?
- **Total throws**: How many total ball tosses? (typically 30-60)
- **Participant throw mechanism**: Mouse click on player icons, or keyboard selection?
- **Ball animation**: Animated ball movement between players, or instantaneous teleport?
- **Cover story**: Is the participant told they are playing with real people over the internet, or with a computer program?
- **Post-game measures**: Which questionnaires follow the game (Need-Threat Scale, mood, manipulation check)?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────────────────┐
│ Participant's Turn        │    │ Other Player's Turn (passive)        │
│ (ball_to == "choose")     │    │ (ball_to != "choose")                │
│                           │    │                                      │
│ Content: 3 player icons   │    │ Content: 3 player icons + ball at   │
│ + ball at participant     │    │ thrower position                     │
│ Duration: until click     │    │ Duration: 1 s (observation)          │
│ Response: click target    │    │ Response: none                       │
│ Data: chosen_player, RT   │    │ Data: ball_from, ball_to             │
├───────────────────────────┤    ├──────────────────────────────────────┤
│            ↓              │    │            ↓                         │
└───────────────────────────┘    └──────────────────────────────────────┘
                 ↓                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ Ball Animation (both trial types)                                     │
│ Content: 3 player icons + ball moving from start to end position      │
│ Duration: 3 s (linear interpolation per frame)                        │
│ Display: "You threw to Player X" or "Player X threw to Player Y"     │
│ Response: none                                                        │
│ Data: none                                                            │
└──────────────────────────────────────────────────────────────────────┘
```

## Data Analysis

Primary analyses compare inclusion vs. exclusion conditions on the Need-Threat Scale subscales and mood measures. Manipulation checks: perceived percentage of throws received, feelings of being ignored/excluded. Behavioral analyses (throw latency, choice of recipient) are secondary. Individual difference moderators (rejection sensitivity, social anxiety, attachment style) are often examined.

## References

Williams, K. D., Cheung, C. K. T., & Choi, W. (2000). Cyberostracism: Effects of being ignored over the Internet. *Journal of Personality and Social Psychology, 79*(5), 748–762. https://doi.org/10.1037/0022-3514.79.5.748

Williams, K. D., & Jarvis, B. (2006). Cyberball: A program for use in research on interpersonal ostracism and acceptance. *Behavior Research Methods, 38*(1), 174–180. https://doi.org/10.3758/BF03192765

## Do Not Assume

- Do not assume inclusion/exclusion conditions are distinguished only by the number of times the subject catches the ball. Confirm the specific proportion distribution: in the inclusion condition, the proportion of subjects catching the ball is about 1/3 (equal participation). In the exclusion condition, subjects only caught the ball the first few times (usually 2-4 times), and then no longer caught the ball at all.
- Do not assume that the number of virtual players is fixed at 2. Common configurations are 2 virtual players (total 3 people) or 3 virtual players (total 4 people). Different configurations will affect the rejection intensity and ecological validity.
- Do not assume the passing animation is instantaneous. Some implementations use linear interpolation animation (2-3 seconds), while others use instantaneous "flash" passes. The animation method and duration need to be clearly confirmed.
- Do not assume that the subject selected the passing target via the keyboard. The common implementation is to click the player icon with the mouse, or you may also use the keyboard numeric keys (1, 2, and 3 correspond to the player). The input method affects the data collection method during the reaction.
- Do not assume the post-experiment questionnaire can be omitted. The Need-Threat Scale (four subscales of belonging, self-esteem, meaningful existence, and sense of control) and the mood questionnaire are standard components of the Cyberball paradigm. Without them, it is difficult to evaluate the effectiveness of the exclusion manipulation.
- Do not assume the instructions say "Play against real players" is the default option. Some studies clearly informed subjects that the opponent was a computer program, but the repulsion effect was still significant; the story covering the instructions directly affected experimental ethics and the debriefing process.

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| condition | str | `"inclusion"` or `"exclusion"`, determines the proportion distribution of subjects catching the ball |
| total_throws | int | Total number of passes (usually 30-60) |
| participant_throws | int | The number of times the participant caught the ball in the entire game |
| throw_sequence | str | Predefined script for passing sequence (JSON array or comma-separated list), specifying which player passes to which player in each round |

## Variants

- **Standard Cyberball (3-player version)**: 2 virtual players + 1 subject, a total of 3 people participating. The total number of passes is usually 30-60, including both inclusion and exclusion conditions. This is the most classic version (Williams et al., 2000) and has the most stable effect sizes. Related paradigm reference: [ultimatum-game.md](ultimatum-game.md) (social decision-making paradigm).
- **Cyberball 4-player version**: 3 virtual players + 1 subject, a total of 4 people participated. Adding a virtual player to manipulate group exclusion (collective vs. partial exclusion) was used to study the interactive effects of group identification and exclusion. It is also possible to set conditions in which two virtual players exclude the subject and the other does not.
- **fMRI version of Cyberball**: Adapted to the functional magnetic resonance imaging environment, usually the inclusion block and the exclusion block are alternately presented in the block design, and the jitter time (random interval of 2-8 seconds) is increased. Used to study neural activation areas related to social rejection, specifically activity in the anterior cingulate cortex (ACC) and anterior insula (Eisenberger et al., 2003). Related paradigm reference: [dot-probe.md](dot-probe.md) (social cognitive bias paradigm).

## Example

### User Request

> "I'm going to do a Cyberball social exclusion experiment, using PsychoPy. 3 players (subject + 2 virtual players), a total of 30 passes. Under the exclusion condition, the subject only caught the ball on the 2nd and 5th pass, and then never caught the ball again. Under the inclusion condition, the subject caught the ball 10 times (evenly Distributed throughout the game). The subjects clicked on the avatars of the other two players to pass the ball. The ball needed to have a moving animation (2 seconds of animation). There were instructions before the experiment to tell the subjects that they were playing a 12-question Need-Threat game with two other online participants. Scale and 4-item mood questionnaire (7-point Likert scale).

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────────────────┐
│ Subject’s passing round │ │ Virtual player’s passing round (passive observation) │
│ (ball_to == "choose")     │    │ (ball_to != "choose")                │
│                           │    │                                      │
│ Content: 3 player icons │ │ Content: 3 player icons + ball at passer's position │
│ + The ball is at the subject's position │ │ │
│ Duration: until clicked (unlimited) │ │ Duration: 1 second (observation window) │
│ Response: Mouse click on the target player │ │ Response: None │
│ Display text: "It's your turn!" │ │ Display text: "Player X is passing the ball..." │
│ data: chosen_player, RT │ │ data: ball_from, ball_to │
├───────────────────────────┤    ├──────────────────────────────────────┤
│            ↓              │    │            ↓                         │
└───────────────────────────┘    └──────────────────────────────────────┘
                 ↓                              ↓
┌──────────────────────────────────────────────────────────────────────┐
│ Passing animation (common to both rounds) │
│ Content: 3 player icons + ball moving linearly from starting point to end point │
│ Duration: 2 seconds (60 frames per second linear interpolation) │
│ Display text: "You passed to Player X" or "Player X passed to Player Y" │
│ Response: None │
│ Data: None │
└──────────────────────────────────────────────────────────────────────┘
                 ↓
┌──────────────────────────────────────────────────────────────────────┐
│ Inter-trial interval (ITI) │
│ Content: 3 player icons (still) │
│ Duration: 500 ms │
│ Response: None │
│ Data: None │
└──────────────────────────────────────────────────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | Cyberball social exclusion experiment |
| Platform | PsychoPy |
| Paradigm Type | Cyberball (Social Exclusion/Social Acceptance) |
| Number of players | 3 (1 subject + 2 virtual players) |
| Total number of passes | 30 |
| Number of receptions under exclusion conditions | 2 times (2nd and 5th pass) |
| Number of catches under inclusion conditions | 10 times (uniformly distributed) |
| Passing method | Click the player icon with the mouse |
| Ball animation duration | 2 seconds (linear interpolation) |
| Cover Story | "Mental imagery training game with online participants" |
| Post-experiment questionnaire | Need-Threat Scale (12 questions) + Mood Questionnaire (4 questions), 7-point Likert |

### Missing Information

1. The specific text content of the instruction is not provided → The wording of the instruction needs to be confirmed (whether it prompts "mental imagination training", whether it mentions "reaction speed" and other interference task descriptions)
2. The specific questions of the mood questionnaire are not provided → The dimensions and wording of the four questions need to be confirmed (for example: happy-sad, relaxed-nervous, happy-unpleasant, excited-calm)
3. The specific style of player avatar/icon is not provided → Need to confirm: cartoon character silhouette, letter label, or photo? Icon size, color, screen position?

### Critical Assumptions

- The virtual player's passing delay is fixed at 1 second observation window + 2 seconds animation, and there is no time limit for the subject's turn.
- The covered story in the instructions will reveal the truth in the debriefing after the experiment (ethical requirement), and the debriefing text needs to be provided additionally
- The effective area for mouse clicks is within the bounding box of the player icon. Clicking on a blank area is invalid and will not be recorded.

### Code Architecture

```
cyberball.py
├── Parameter configuration (condition, total_throws, participant_throws, throw_sequence, animation_duration)
├── Window initialization (full screen/window mode, background color)
├── Stimulus preloading
│ ├── Player icon (3 circles/avatars, screen position: left-center-right or triangle arrangement)
│ ├── Ball icon (small ball graphic)
│ └── Text stimulation (status prompt text)
├── Conditional file loading
│ ├── throw_sequence predefined script (JSON format)
│ └── condition tag (inclusion / exclusion)
├── Experimental stage
│ ├── Instruction stage
│ │ ├── Overlay story text display
│ │ └── Wait for the space bar to continue
│ ├── Passing game loop (30 rounds)
│ │ ├── if ball_to == "choose" (subject's turn)
│ │ │ ├── Display the ball at the subject's position
│ │ │ ├── Display the prompt "It's your turn!"
│ │ │ ├── Wait for mouse click (record RT and chosen_player)
│ │ │ └── Entering the animation stage
│ │ └── else (virtual player turn)
│ │ ├── Shows the ball at the passer's position
│ │ ├── Display "Player X is passing the ball..." prompt
│ │ ├── Wait for 1 second observation window
│ │ └── Entering the animation stage
│ ├── Passing animation (2 seconds linear interpolation, the ball moves from the starting point to the end point)
│ ├── ITI (500 ms still image)
│ └── Data record (each round: trial_number, condition, ball_from, ball_to, chosen_player, rt, animation_start/end)
├── Post-experiment questionnaire stage
│ ├── Need-Threat Scale (12 questions, 7-point Likert, 3 questions for each of the 4 subscales)
│ └── Mood Questionnaire (4 questions, 7-point Likert)
├── Debriefing stage (revealing the true purpose of the experiment and obtaining informed consent confirmation)
└── Data saving (CSV format, incremental write + final save)
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| trial_number | int | Pass sequence number (1-30) |
| condition | str | `"inclusion"` or `"exclusion"` |
| ball_from | str | Pass initiator (`"player_1"`, `"player_2"`, `"participant"`) |
| ball_to | str | Pass target (`"player_1"`, `"player_2"`, `"choose"`) |
| is_participant_turn | int | Whether it is the subject's turn (1=subject's passing round, 0=virtual player's turn) |
| chosen_player | str | The passing target chosen by the subject (only has a value in the subject's turn, otherwise it is `NaN`) |
| rt | float | Subject's reaction time (ms), from the appearance of the ball to the mouse click (only has value in the subject's turn) |
| animation_duration | float | Actual duration of passing animation (seconds) |
| throw_text_displayed | str | The prompt text displayed in this round |
| need_threat_belonging | float | Average score of belongingness subscale (1-7) |
| need_threat_self_esteem | float | Average score of self-esteem subscale (1-7) |
| need_threat_meaningful | float | Average score of meaningful presence subscale (1-7) |
| need_threat_control | float | Average score of sense of control subscale (1-7) |
| mood_valence | float | Average mood valence (1-7) |
