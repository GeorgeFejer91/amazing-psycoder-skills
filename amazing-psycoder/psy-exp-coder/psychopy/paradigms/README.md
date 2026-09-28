# PsychoPy Paradigms

> **Layer 3**: Paradigm reference files — one `.md` file per paradigm, containing experimental logic and code examples.

## Paradigm index

### Core Paradigm (14 entries, 13 files + 1 cross-reference)

| Paradigm | File | Type |
|------|------|------|
| Stroop | [stroop.md](stroop.md) | Pavlovia demo |
| Go/No-go | [go-nogo.md](go-nogo.md) | Pavlovia demo |
| Eriksen Flanker | [eriksen-flanker.md](eriksen-flanker.md) | CONFIG-DRIVEN |
| Simon | [simon.md](simon.md) | Pavlovia demo |
| N-back | [n-back.md](n-back.md) | CONFIG-DRIVEN |
| Dot-probe | [dot-probe.md](dot-probe.md) | Pavlovia demo |
| Visual search | [visual-search.md](visual-search.md) | CONFIG-DRIVEN |
| Task switching | [task-switching.md](task-switching.md) | CONFIG-DRIVEN |
| Stop-signal | [stop-signal.md](stop-signal.md) | CONFIG-DRIVEN |
| IAT | [iat.md](iat.md) | Pavlovia demo |
| Priming | [priming.md](priming.md) | Pavlovia demo |
| Rating | [rating.md](rating.md) | Pavlovia demo |
| Navon | [navon.md](navon.md) | CONFIG-DRIVEN |
| EAST | (see jspsych) | — |

### Extended paradigm (14, refer to the description)

| Paradigm | File |
|------|------|
| Antisaccade | [antisaccade.md](antisaccade.md) |
| Change Detection | [change-detection.md](change-detection.md) |
| Choice Reaction Time | [choice-reaction-time.md](choice-reaction-time.md) |
| Cyberball | [cyberball.md](cyberball.md) |
| Delay Discounting | [delay-discount.md](delay-discount.md) |
| Mental Rotation | [mental-rotation.md](mental-rotation.md) |
| Multisensory Nature | [multisensory-nature.md](multisensory-nature.md) |
| Numerical Stroop | [numerical-stroop.md](numerical-stroop.md) |
| Phone a Friend | [phone-a-friend.md](phone-a-friend.md) |
| Psychophysics Staircase | [psychophysics-staircase.md](psychophysics-staircase.md) |
| Sternberg | [sternberg.md](sternberg.md) |
| Ultimatum Game | [ultimatum-game.md](ultimatum-game.md) |
| Wisconsin Card Sorting | [wisconsin-card-sorting.md](wisconsin-card-sorting.md) |
| Writing Distraction | [writing-distraction.md](writing-distraction.md) |

> **Important: Paradigm ≠ API Reference. ** The code examples in the following files are from the Pavlovia demo (mostly PsychoPy v3.1), using legacy APIs (e.g. `event.getKeys(maxWait=)`, `exec()` conditional injection, `trialClock.getTime()`). **When generating experimental code, the API mode is based on the Canonical Code Skeleton of [spec/README.md](../spec/README.md)** (PTB keyboard, `key.rt`, `getFutureFlipTime`, `try/finally`). The paradigm file only provides experimental logic: window sequences, conditional structures, correctness rules.

Each file's **Experimental Logic** chapters are available for design patterns, window sequences, and scoring semantics. The historical code block is an isolated source and cannot be run or copied directly; it must be rewritten and verified with the config fixed version of the L1-L2 API.

Another 13 paradigms have only jsPsych/PsychoJS code (no Python implementation), see [jspsych/paradigms/README.md](../../jspsych/paradigms/README.md).
