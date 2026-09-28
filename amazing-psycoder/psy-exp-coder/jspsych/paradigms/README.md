# jsPsych Paradigms

> **L3 legacy source set**: 22 PsychoJS + 1 lab.js + 2 jsPsych 6.1.0. Code blocks are isolated historical sources and may not be copied, executed, or marked as current jsPsych runnable code.

## Paradigm index

| Paradigm | File | Type |
|------|------|------|
| Antisaccade | [antisaccade.md](antisaccade.md) | PsychoJS |
| Attention Network Task | [attention-network-task.md](attention-network-task.md) | PsychoJS |
| BART | [bart.md](bart.md) | PsychoJS |
| Bilingual Stroop | [bilingual-stroop.md](bilingual-stroop.md) | PsychoJS |
| Butterfly Simon | [butterfly-simon.md](butterfly-simon.md) | PsychoJS |
| Change Detection | [change-detection.md](change-detection.md) | PsychoJS |
| Children Flanker Task | [children-flanker-task.md](children-flanker-task.md) | PsychoJS |
| Choice Reaction Time | [choice-reaction-time.md](choice-reaction-time.md) | PsychoJS |
| Climate Reflection Task | [climate-reflection-task.md](climate-reflection-task.md) | PsychoJS |
| Continuous Performance Test | [continuous-performance-test.md](continuous-performance-test.md) | PsychoJS |
| Corsi Blocks | [corsi-blocks.md](corsi-blocks.md) | PsychoJS |
| Cyberball | [cyberball.md](cyberball.md) | PsychoJS |
| Drag and Drop | [drag-and-drop.md](drag-and-drop.md) | PsychoJS |
| EAST | [east.md](east.md) | jsPsych 6.1.0 native |
| IAT | [iat.md](iat.md) | jsPsych 6.1.0 native |
| Stroop (lab.js) | [labjs-stroop.md](labjs-stroop.md) | lab.js |
| Mental Rotation | [mental-rotation.md](mental-rotation.md) | PsychoJS |
| Multisensory Nature | [multisensory-nature.md](multisensory-nature.md) | PsychoJS |
| Multisensory Nature Climate | [multisensory-nature-climate.md](multisensory-nature-climate.md) | PsychoJS |
| Numerical Stroop | [numerical-stroop.md](numerical-stroop.md) | PsychoJS |
| Phone a Friend | [phone-a-friend.md](phone-a-friend.md) | PsychoJS |
| Psychophysics Staircase | [psychophysics-staircase.md](psychophysics-staircase.md) | PsychoJS |
| Rating to Choice Task | [rating-to-choice-task.md](rating-to-choice-task.md) | PsychoJS |
| Sternberg | [sternberg.md](sternberg.md) | PsychoJS |
| Wisconsin Card Sorting | [wisconsin-card-sorting.md](wisconsin-card-sorting.md) | PsychoJS |

## Type description

- **PsychoJS**: Standalone JavaScript runtime for PsychoPy Builder, often deployed in Pavlovia; not a jsPsych implementation or plugin set
- **lab.js**: Standalone JavaScript experiment framework (not jsPsych/PsychoJS), using HTML templates + messageHandlers
- **jsPsych 6.1.0 native**: Native implementation of the standard jsPsych 6.1.0 library (source: psychbruce/jspsych)

> **Important: Paradigm ≠ API Reference. ** Only read the design intent, window sequence, conditional fields and scoring semantics, and then reimplement using [spec](../spec/README.md) and [mapping](../mapping/README.md). Any legacy code snippets must be rejected or rewritten by the current validator.

Each file may contain a mixture of experimental logic and historical export code; the latter does not constitute evidence of runnability or correctness.
