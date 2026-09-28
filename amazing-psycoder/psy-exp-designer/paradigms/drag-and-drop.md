# Drag and Drop Puzzle Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/drag_and_drop) · PsychoJS

## When to Use

User mentions: Drag and drop, puzzle task, pattern matching, spatial arrangement, drag-and-drop task, puzzle task. A pattern-matching puzzle task using drag-and-drop interaction, demonstrating mouse-based stimulus manipulation for spatial reasoning, problem-solving, or visuospatial ability assessment.

## Core Logic

Participants view a target pattern (e.g., a black-and-white design) displayed above an empty grid. Draggable puzzle pieces (black and white squares) are positioned around the grid. Participants must click and drag each piece from its starting position into the correct grid cell to recreate the target pattern.

**Trial structure**: target design image displayed above grid → participant drags black/white pieces into grid cells → when satisfied, clicks "Continue" button → feedback (correct/incorrect + completion time) → next trial. The condition file (`conditions.xlsx`) defines the target design image and the correct arrangement (which cells should be black vs. white).

**Drag-and-drop mechanics**: PsychoJS `visual.ImageStim` components are created with `setDraggable(true)`. Piece positions are tracked via each stimulus's `.pos` property. The grid is defined using pixel coordinates (`units: 'pix'` for precise positioning). Each trial has 9 grid cells (3x3 arrangement), each requiring either a black or white piece.

**Accuracy verification**: When the participant clicks "Continue", the code compares the final dragged positions of black and white pieces against the target pattern cells defined in the condition file columns (`a1` through `a9`, or equivalent grid labels). The trial is marked correct only if all pieces are in their correct positions.

**Completion time**: A trial timer runs from trial onset until the "Continue" button is clicked. Time taken and accuracy are displayed as feedback.

## Must Confirm

- **Grid layout**: 3x3 grid (9 cells), or different size? Rectangular or irregular?
- **Puzzle complexity**: Black/white binary pieces, color pieces, or more complex pattern pieces?
- **Target designs**: Pre-made design images or programmatically generated patterns?
- **Trial count**: How many puzzles to solve?
- **Interaction mode**: Mouse drag-and-drop, touchscreen, or both?
- **Feedback**: Full accuracy feedback (all-or-nothing) or partial credit (number of pieces correct)?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Puzzle Assembly          │    │ Feedback                 │    │ ITI                      │
│ Content: target design   │    │ Content: correct/incorrect│   │ Content: blank           │
│   above grid + draggable │    │   + completion time      │    │ Duration: 1000 ms        │
│   black/white pieces     │    │ Duration: 2000 ms        │    │ Response: none           │
│ Duration: self-paced     │    │ Response: none           │    │ Condition: none          │
│   (click Continue to end)│    │ Condition: none          │    │ Data: none               │
│ Response: mouse drag     │    │ Data: none               │    └──────────────────────────┘
│ Condition: {design_id}   │    └──────────────────────────┘
│ Data: piece_positions,   │
│   completion_time        │
└──────────────────────────┘
```

## Data Analysis

Primary measures: completion time (time to solve each puzzle), accuracy (proportion of correctly solved puzzles), and error patterns (which grid cells had incorrect pieces). Analyze learning effects across trials (faster completion on later puzzles). Individual differences in visuospatial ability can be inferred from accuracy and speed. Mouse trajectories (piece drag paths) provide process-tracing data on solution strategies.

## References

This paradigm demonstrates drag-and-drop interaction capabilities in PsychoJS/PsychoPy. Adaptable to visuospatial ability testing, puzzle-solving research, and any paradigm requiring spatial manipulation of on-screen elements.

---

## Do Not Assume

- Do not assume the grid is always 3x3 — the grid size (e.g., 2x2, 4x4, irregular shapes) should be explicitly confirmed with the user before generation
- Do not assume binary black/white pieces — some variants use colored pieces, patterned pieces, or pieces with varying shapes; the piece type directly affects stimulus creation and condition file structure
- Do not assume pieces return to their original position after an incorrect drop — some implementations allow pieces to snap into the nearest grid cell, while others reject invalid placements
- Do not assume the "Continue" button is always present — some paradigms auto-advance after all pieces are placed, while others require explicit confirmation; this affects the trial termination logic
- Do not assume target designs come from image files — some experiments generate target patterns programmatically (e.g., random placement of colored squares), which eliminates the need for external image assets
- Do not assume mouse-only interaction — touchscreen compatibility may be required, which affects event handling and stimulus sizing (larger touch targets needed)

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| design_id | str | The identifier of the target pattern, corresponding to the image file name or programmatic generation parameters |
| grid_rows | int | Number of grid rows |
| grid_cols | int | Number of grid columns |
| solution | str | Correct answer encoding, such as `"B,W,B;W,B,W;B,W,B"` represents the color of each grid (B=black, W=white), arranged in rows |

## Variants

- **Standard Drag-and-Drop Puzzle**: Participants drag graphics blocks from the alternative area to the grid to complete the reproduction of the target pattern. Commonly seen in spatial cognition and problem solving research. See the main body description of this document for details.
- **Free-Sorting Drag-and-Drop**: Participants drag items scattered on the screen into any grouping area, with no fixed correct position. Commonly used in classification tasks and concept formation studies. Please refer to free-sorting.md.
- **Timed Drag-and-Drop**: Adds time pressure to the standard drag-and-drop puzzle. Participants must complete the drag-and-drop operation within a limited time, and the current state will be automatically submitted when it times out. Ideal for studying decision-making speed and spatial reasoning under stress.

---

## Example

### User Request

> "I want to do a drag puzzle experiment. A 3x3 black and white target pattern is displayed on the screen, and below the pattern is a 3x3 blank grid. There are 5 black squares and 4 white squares next to it that can be dragged. Participants drag the squares to the correct position and click the 'Submit' button. There are 10 trials in total, and the target pattern is different each time. Use PsychoPy."

### Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Puzzle Assembly          │    │ Feedback                 │    │ ITI                      │
│ Content: Target pattern (top) │ │ Content: Correct/wrong │ │ Content: Blank │
│ + 3×3 blank grid (middle) │ │ + completion time │ │ Duration: 800 ms │
│ + 5 black and 4 white draggable blocks (side) │ │ Duration: 2000 ms │ │ Response: none │
│ Duration: Customized pace │ │ Response: none │ │ Condition: none │
│ (Click the submit button to end) │ │ Condition: none │ │ Data: none │
│ Response: Mouse drag │ │ Data: none │ └───────────────────────────┘
│ Condition: {design_id}   │    └──────────────────────────┘
│ Data: The final status of each grid, │
│Completion time, number of moves before submission│
└──────────────────────────┘
```

### Parsed Experiment Specification

| Field | Value |
|-------|-------|
| Experiment name | 3×3 black and white drag puzzle task |
| Platform | PsychoPy |
| Mission Type | Drag-and-Drop Puzzle (Space Puzzle) |
| Grid size | 3×3 (9 grids) |
| Block type | Black block × 5, white block × 4 |
| Interaction mode | Drag the mouse to the specified position in the grid |
| Submission method | Click the "Submit" button |
| Number of trials | 10 trials |
| Target pattern | Different for each trial (need to provide 10 target pattern pictures or programmatic definition) |

### Missing Information

1. The source of the target pattern is not specified - the user is required to provide 10 pictures of the target pattern, or confirm whether the black and white arrangement is randomly generated by the program
2. Practice trials not mentioned - is a practice phase required? Number of practice trials?
3. The content of the instruction is not specified - the user is required to provide Chinese subtitles or confirm the use of the default instruction ("Please drag the box to the correct position")

### Critical Assumptions

- Blocks are considered valid placement if they are dragged and dropped into approximately the correct grid position (a certain positional tolerance is allowed, e.g. ±20 pixels), no pixel-precise alignment is required
- Feedback only shows correct/wrong and completion time, not partial score (all right or all wrong)
- The target pattern is provided as an image file (stored in the `stimuli/` directory) rather than generated programmatically

### Code Architecture

```
drag_puzzle.py
├── Experimental parameters (grid size, square color, number of trials, timing settings)
├── Window initialization (units set to pixels for precise positioning)
├── Preload stimulus materials (target pattern pictures, grid lines, draggable squares)
├── Conditional file reading (design_id → target image + correct answer code)
├── Trial cycle:
│ ├── Draw grid lines (3×3 guide lines)
│ ├── Display the target pattern (centered above the grid)
│ ├── Create draggable blocks (initial positions are randomly arranged around the grid)
│ ├── Wait for drag and drop interaction (custom pace, listen for drag events and submit buttons)
│ ├── Record the final status and completion time of each grid
│ ├── Compare the answer (compare with the solution code in condition)
│ ├── Display feedback (correct/wrong + time, lasts 2000 ms)
│ └── ITI (800 ms blank)
├── Data saving: try/finally structure, incremental writing to CSV
└── End interface
```

### Expected Data Columns

| Column | Type | Description |
|--------|------|-------------|
| design_id | str | The target pattern ID of the current trial |
| grid_state | str | The actual status code of each grid at the time of submission (such as `"B,W,B;W,B,W;B,W,B"`) |
| acc | int | Whether it is completely correct (1 = all correct, 0 = there is an error) |
| completion_time | float | Elapsed time from trial start to click submit (seconds) |
| n_moves | int | The total number of drag operations (the number of times the block has been moved) |
