# psy-exp-designer — Experimental design orchestration layer

> **Version**: v1.4.0 | **Role**: You tell it your experimental ideas, and it gradually confirms each design detail and produces a complete design decision registry and config YAML. amazing-psycoder sub-skill.

## One sentence explanation

Input experimental ideas (Chinese/English), output the complete config YAML + design decision registry, and route to code generation after final confirmation by the user.

## 5-stage workflow

```
Phase 1: Assess → Collect existing information (paradigm, platform, operating system/font)
Phase 2: Windows → Define Trial + reaction rules (the most critical - window sequence + key mapping + accuracy rules)
Phase 3: Conditions → Define trial sequence (condition table generation/verification, stimulus file)
Phase 4: Blocks → Define block structure and loop (practice/formal/rest/feedback)
Phase 5: Validate → Verification + Full Design Review → Route to Code Generation
```

At the end of each stage, the decision list must be **displayed** and the user will confirm it before proceeding.

## 5 access control

| Gate | Check content |
|------|---------|
| Gate 1 | Phase 2 completed: Window sequence without `[MISSING]`, key mapping confirmed |
| Gate 2 | After Phase 3 is completed: the condition file column name is consistent with the window `{column}` |
| Gate 3 | Phase 4 completed: config without `[MISSING]`, all sections complete |
| Gate 4 | Phase 5 technical verification: all 9 schema rules passed |
| Gate 5 | **Final Design Review**: Full decision-making registry display, users confirm item by item ⚠️ Default items |

## Core Mechanism

- **Design Decision Registry**: Track all design decisions across stages, marking sources (user confirmation/paradigm convention/automatic inference)
- **Phase Decision Checklist**: Output a decision list at each stage, and proceed after user confirmation
- **`[MISSING]` / `[ASSUMED]` flags**: Missing values are flagged as `[MISSING]`, default values are flagged as `[ASSUMED]`, both reviewed at Gate 5
- **Must-Confirm cross-stage allocation**: The Must-Confirm item of the paradigm file is assigned to the corresponding stage question

## Paradigm coverage

**38 paradigms**: 14 cores (full Must-Confirm + conditional column definition) + 24 extensions (refer to description)

Covered: Go/No-go, Navon, Priming, Stroop, Eriksen Flanker, Simon, Rating, Stop-signal, IAT, N-back, Dot-probe, Visual Search, Task Switching, EAST and more

See the [paradigms/](paradigms/) directory for details.

## Key files

| File | Purpose |
|------|------|
| [SKILL.md](SKILL.md) | Complete workflow specification (read by Claude) |
| [paradigms/](paradigms/) | 38 paradigm specification files |
| [references/config-schema.md](references/config-schema.md) | Config YAML schema + 9 validation rules |
| [references/condition-file-generation.md](references/condition-file-generation.md) | Condition file generation tool |
| [references/data-recording.md](references/data-recording.md) | Data output column definition specification |
| [references/randomization.md](references/randomization.md) | Randomization and balancing specifications |
| [references/timing.md](references/timing.md) | Timing and RT measurement specifications |

## Usage example

```
User: "I want to do a point detection experiment. Emotional faces are paired (angry-neutral). The probe appears after 500ms of presentation. Press f/j to determine the probe position."

System:
  Phase 1 → Identify paradigm (dot-probe), confirm platform (PsychoPy), confirm OS (macOS), load paradigm Must-Confirm
  Phase 2 → Build window: Fixation(500ms) → FacePair(500ms) → Probe(until key, f/j)
             Key mapping: f=left, j=right | Explicit confirmation RT=Probe actual rendering→key_down
             Accuracy: key==correct_response
             → Display the Phase 2 decision list, user confirms
  Phase 3 → Condition table: Emotion (angry/neutral) × Probe position (left/right) × Consistency (consistent/inconsistent)
             → Show Phase 3 decision list
  ... → Final Gate 5 full review → Routed to code generation
```
