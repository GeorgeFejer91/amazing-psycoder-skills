# Canvas Presentation Contract

Use this reference whenever the Designer presents a sequence timeline, phase
decision checklist, cumulative Decision Registry, or final Gate 5 review. The
saved config remains authoritative; these views make its meaning inspectable.

## Sequence-row format

- Show each sequence as an independent row separated by blank lines.
- Show sequences top-to-bottom and windows left-to-right.
- Start with `sequence: <name>` plus condition table, cycles, and order policy.
- One cycle traverses every table row once; without a table it executes the window chain once.
- Each window card shows label, content, duration, and response mode.
- Annotate the response window with its RT anchor and recorded data.
- Use `[MISSING]` for unresolved values.
- A sequence name is only a label; never infer runtime behavior from it.
- Show every sequence, including instructions, practice, rest, and end rows.

```text
Sequence: Trial
  Condition table: formal_table · cycles: 1 · order: fixed_random(seed=sub-01)

  ┌─ Fixation ─┐  ┌─ Stimulus ───┐  ┌─ Response ────┐  ┌─ ITI ──────┐
  │ "+"        │  │ "{stimulus}" │  │ "{stimulus}"  │  │ ""         │
  │ 500ms      │→ │ 500ms        │→ │ until_key     │→ │ 500-800ms  │
  │ No response │ │ No response │ │ [f, j, k] │ │ No response │
  └────────────┘  └──────────────┘  └───────────────┘  └────────────┘
                                            RT: Response onset
                                            data: rt, key, acc

Sequence: Start → Unconditional table · cycles: 1 → Welcome text
Sequence: End → Unconditional table · cycles: 1 → Thank you text
```

## Phase decision checklist

```text
## Phase N Design Decision Checklist

| # | Decision item | Confirmation value | Source |
|---|--------|--------|------|
| 1 | Fixation duration | 500ms | User confirmation |
| 2 | Response button | f/j/k | User confirmation |
| 3 | Response deadline | 2000ms | General recommendations (to be confirmed) ⚠️ |
```

Only `User confirmation` is confirmed. Values from a template, general suggestion, or
automatic inference remain proposed and visibly marked until accepted.

## Cumulative Decision Registry

```text
## Experimental design decision registration form

### Phase 1: Assess
| # | Decision item | Value | Source |
|---|--------|-----|------|
| 1 | Experimental Paradigm | Stroop | User Description |
| 2 | Platform | PsychoPy | User Confirmation |

### Phase 2: Windows & Rules
| # | Decision item | Value | Source |
|---|--------|-----|------|
| 3 | Response time definition | Actual presentation of stimulus to button press | User confirmation |
| 4 | Fixation duration | 500ms | Default (universal) ⚠️ |
```

Every non-trivial design decision must appear exactly once with its source.
Append rather than replacing prior phases. Corrected decisions retain a clear
record of the new confirmed value.

## Gate 5 final review

The final review contains:

1. Every sequence row and window, with its optional condition table, cycles, and order policy.
2. A compact window table covering content, duration, response, condition
   bindings, RT anchor, and recorded data.
3. The complete cumulative Decision Registry.
4. An explicit list of every proposed/defaulted/inferred value marked ⚠️.
5. The question: `Are all the above design decisions confirmed and can code be generated? If you need to modify it, please specify the number and new value. `

Do not route to the Coder until the user explicitly confirms the complete
review. If an item changes, update the config and registry, repeat technical
validation, and present Gate 5 again.
