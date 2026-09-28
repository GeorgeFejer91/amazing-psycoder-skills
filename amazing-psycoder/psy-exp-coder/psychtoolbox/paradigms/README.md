# Psychtoolbox Paradigms

> **Layer 3 legacy source set**: 5 teaching paradigms/components that retain design intent with legacy MATLAB examples; not current build templates or run-proofs.

## Paradigm index

| Paradigm | File | Description |
|------|------|------|
| Stroop | [stroop.md](stroop.md) | Color-Word Stroop task. Word (Red/Green/Blue) × Ink color independent control, direction key response, RT + accuracy record |
| Posner Cuing | [posner-cuing-experiment.md](posner-cuing-experiment.md) | Spatial cueing task. Gabor target, cue validity manipulation (contingent/non-contingent), data saved to tab-delimited file |
| Orientation Threshold | [orientation-threshold.md](orientation-threshold.md) | 2AFC Orientation discrimination threshold measurement. Constant stimulus method, programmed Gabor, psychometric function fitting |
| Likert Scale | [likert-scale.md](likert-scale.md) | 7-point Likert scale. Mouseover to enlarge + click to select, color gradient feedback (blue → red), response collection component |
| Slider | [coolness-slider.md](coolness-slider.md) | Continuous slider rating. Click-and-drag interaction, 0-100% real-time percentage display, dynamic color change |

## Type description

- **Historical complete example** (Stroop, Posner Cuing, Orientation Threshold): trial/condition/scoring intent can be extracted, but the code must be rewritten according to the current config and spec
- **Response Collection Component** (Likert Scale, Slider): Interactive UI component that can be embedded as a sub-component into a larger experiment

## File structure

> **Important: Paradigm ≠ API Reference. ** The MATLAB code examples embedded in the following files are from Peter Scarfe's PTB tutorials, using tutorial-level APIs such as `KbCheck`. **When generating experimental code, the API mode is based on the Canonical Code Skeleton of [spec/README.md](../spec/README.md)** (`KbQueueCheck` replaces `KbCheck`, `VBLTimestamp` replaces `GetSecs`, `try/catch/sca` replaces bare `sca`). The paradigm file only provides experimental logic: window sequences, conditional structures, correctness rules.

Each paradigm file `.md` may contain:
- Experiment description and design logic
- window/screen sequence
- History Teaching MATLAB code (may not be directly copied, executed, or claimed to be currently runnable)
