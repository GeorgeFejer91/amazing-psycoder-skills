# Psychtoolbox (MATLAB)

> **Status**: The generation process is consistent with PsychoPy (unified Generation Pipeline). L1 spec + L2 mapping + 5 paradigms + 100 demo.

## Code generation process (unified with PsychoPy, see mapping/ for platform-specific mapping)

```
config.yaml
    │
    ▼
1. Copy [Canonical Code Skeleton](spec/README.md#11-canonical-code-skeleton)
    │
    ▼
2. Parameter area: fill in the display / timing / font / audio of config
    │
    ▼
3. Stimulus preloading: pre-create from config.windows[].content → Screen('MakeTexture') before loop
    │
    ▼
4. Trial loop: Press config.windows[] to select frame loop mode
    → Mode 1: Single frame Flip (fixed duration static stimulation)
    → Mode 2: for loop Flip (frame accurate control)
    → Mode 3: KbQueue response loop (recommended for production)
    → For details, see [mapping/README.md §Three frame loop modes] (mapping/README.md#Window event-ptb-frame loop mode)
    │
    ▼
5. Response collection: config.windows[].response → KbQueueCheck + VBLTimestamp RT
    │
    ▼
6. Correctness judgment: config.response_rules.correct → strcmp(response, corrAns)
    │
    ▼
7. Data saving: config.output → fopen/fprintf/fclose incremental writing
    │
    ▼
8. Run Quality Gate (10 items) → Repair → Deliver
```

Key: For the config field mapping corresponding to each step, see [mapping/README.md](mapping/README.md).

## File structure

```
psychtoolbox/
├── README.md ← this file
├── spec/ ← L1: API specification + Canonical Skeleton
│ └── README.md ← KbQueue lifecycle, Flip timing, PsychPortAudio, 18 anti-patterns
├── mapping/ ← L2: Config → MATLAB code mapping
│ └── README.md ← 12-step template + 3 types of frame loops + audio/conditional mapping
├── paradigms/ ← L3: Paradigm reference (experimental logic, non-API reference)
│ ├── README.md ← Paradigm Index + API Alert
│ └── *.md ← 5 paradigm files
└── demo/ ← L4: Original code example (100 .md, classified by function)
    └── _raw/ ← Only refer to the experimental logic, the API is subject to L1 spec
        ├── getting-started/ ← 11 — Installation configuration + minimum window + precise timing + keyboard queue
        ├── drawing-shapes/    ← 15 — dots, rectangles, fixation
        ├── animated-shapes/   ← 17 — motion, keyboard/mouse
        ├── textures/          ← 23 — images, Gabors, gratings
        ├── text/              ←  6 — text rendering
        ├── 3d-vr/             ← 19 — OpenGL, stereoscopic
        └── other/ ← 9 — Full experiment + gamma correction + multi-screen + audio, etc.
```

## Level filling status

| Level | Content |
|------|------|
| L1 `spec/` | Canonical Skeleton + API specification (KbQueue lifecycle, Screen Flip half-IFI rule, PsychPortAudio, try/catch/sca) + 18 anti-patterns |
| L2 `mapping/` | 12-step template PTB implementation + 3 frame loop modes + Config→Code complete mapping + audio mapping |
| L3 `paradigms/` | 5 paradigms (Stroop, Posner Cuing, Orientation Threshold, Likert Scale, Slider). **API mode is based on spec and does not follow KbCheck in the paradigm code** |
| L4 `demo/_raw/` | 100 original examples (`_raw/` = only refer to experimental logic, API is subject to L1 spec) — classified by function, consult on demand during code generation |

## Mandatory API rules

All generated PTB code conforms to (full specification in [spec/README.md](spec/README.md)):

| Category | Required | Use prohibited |
|------|---------|---------|
| Keyboard input | `KbQueueCreate` + `KbQueueStart` + `KbQueueCheck` | `KbCheck` / `KbWait` (for RT) |
| RT starting point | `VBLTimestamp` (`Screen('Flip')` return value) | `GetSecs` |
| RT calculation | `(min(firstPress) - stimOnset) * 1000` | `secs - tStimFlip` |
| Frame Timing | `vbl + (waitframes - 0.5) * ifi` | Block with `WaitSecs()` in stages where flip/input/trigger/abort is still required |
| Clear the queue every trial | `KbQueueFlush([], 2)` | Clear the queue resulting in the remaining keystrokes in the previous trial |
| Error handling | `try/catch/sca/Priority(0)/ShowCursor` | naked `sca` |
| Stimulus preloading | `Screen('MakeTexture')` before loop | `imread` inside trial |
| Foveation point | Select by config and verify on target monitor; `Screen('DrawLines')` avoids font dependency | No validation of size, position, color or font rendering |
| Data saving | Recoverable append/flush/close, `writetable`/`matfile` or equivalent atomic strategies for each trial | Only keep the matrix in the workspace (crash = all lost) |
| SyncTests | `SkipSyncTests, 0` | Skip SyncTests |

## PTB vs PsychoPy (concept correspondence)

Used for users switching from PsychoPy to quickly locate the PTB equivalent API:

| Concepts | Psychtoolbox | PsychoPy |
|------|-------------|----------|
| Window creation | `PsychImaging('OpenWindow', ...)` | `visual.Window(...)` |
| Page flip | `Screen('Flip', window, when)` | `win.flip()` |
| Frame interval | `Screen('GetFlipInterval')` → `ifi` | `win.getFutureFlipTime()` |
| RT Keyboard | `KbQueueCreate`/`KbQueueCheck` | `keyboard.Keyboard(backend='ptb')` |
| RT Get | `firstPress - VBLTimestamp` | `key.rt` |
| Text rendering | `DrawFormattedText` / `Screen('DrawText')` | `TextBox2` / `TextStim` |
| Image | `imread` + `Screen('MakeTexture')` | `visual.ImageStim()` |
| Audio | `PsychPortAudio` (supports low-latency scheduling/timestamps; tested on target hardware) | PsychoPy sound backend (also required tested) |
| Data saving | `fopen`/`fprintf`/`fclose` | `csv.DictWriter` + `flush` |
| Error handling | `try/catch/sca` | `try/finally/win.close()` |
| Gabor | `CreateProceduralGabor`（GPU shader） | `visual.GratingStim` |

## Quick check on paradigm differences

Key points for implementing different paradigms on PTB:

| Paradigm | Frame cycle mode | Response mode | Special logic |
|------|----------|---------|---------|
| Stroop | Mode 3 (KbQueue) | Arrow keys → Color mapping | `DrawFormattedText` dynamic color |
| Posner Cuing | Mode 2 (for Flip) | KbQueue polling | `CreateProceduralGabor` + cue validity |
| Orientation Threshold | Mode 2 | 2AFC left/right button | Constant stimulation method + psychometric function |
| Likert Scale | Mode 2 | Mouse interaction | Hover to zoom + click to select |
| Slider | Mode 2 | Mouse drag | Continuous drag + real-time percentage |

For detailed code template, see [mapping/README.md §Window event frame loop mode] (mapping/README.md#Window event-ptb-frame loop mode).
