# jsPsych Implementation Guide

> **Status**: Layer 1 — API specification, anti-pattern table, enforcement patterns. The current build target is jsPsych 8.x; projects must pin and document the exact core/plugin versions.
> **Last updated**: 2026-07-25 — 17-rule quality template applied (9-section jsPsych adaptation)

## Critical Rules (Read First — errors here invalidate data)

| Rule | Why Critical |
|------|-------------|
| **`on_data_update` for durable per-trial checkpoint** | `localSave` at end only = browser close/crash loses all data |
| **`addEventListener(..., true)` — capture phase required** | Missing `true` = jsPsych plugins capture Escape first, abort handler never fires |
| **`Number(jsPsych.pluginAPI.compareKeys(...))` for accuracy** | `true`/`false` in data breaks CSV analysis. Must output 0/1 int |
| **`timeline_variables` precomputed at script load** | jsPsych cannot dynamically generate conditions at runtime |
| **`type: jsPsychHtmlKeyboardResponse` (class, not string)** | `type: 'html-keyboard-response'` = legacy, broken in jsPsych 8.x |
| **`initJsPsych()` + `jsPsych.run()`, never `jsPsych.init()`** | `jsPsych.init()` = legacy API, removed in current versions |

Full anti-patterns table: [§5](#5-anti-patterns-quick-reference). Full 17-rule template: [§0](#0-code-structure-requirements-17-rule-quality-template-jspsych-adaptation).

## Version Assumption

The canonical CDN example is pinned to **jsPsych 8.2.3** and official plugin packages 2.1.0. Before generation, confirm the project's target version and consult its official migration guide; never silently mix core and plugin major versions. `jsPsych.init()` is legacy — use `initJsPsych()` + `jsPsych.run()`.

**Key current-vs-legacy distinctions:**

| Legacy | jsPsych 8.x target |
|--------|--------------------|
| `jsPsych.init({timeline: [...], ...})` | `var jsPsych = initJsPsych({...}); jsPsych.run([...])` |
| `type: 'html-keyboard-response'` (string) | `type: jsPsychHtmlKeyboardResponse` (class) |
| `jsPsych.NO_KEYS` / `jsPsych.ALL_KEYS` | `"NO_KEYS"` / `"ALL_KEYS"` (string) |
| `jsPsych.currentTimelineNodeID` | `jsPsych.getCurrentTimelineNodeID()` |
| `jsPsych.progress` | `jsPsych.getProgress()` |
| `jsPsych.timelineVariable('x', true)` inside a function (v7 pattern) | `jsPsych.evaluateTimelineVariable('x')` inside a function |

## 0. Code Structure Requirements (17-Rule Quality Template — jsPsych Adaptation)

Every generated jsPsych experiment must follow these rules. The template is identical to the PsychoPy version except where jsPsych/JavaScript API differences require adaptation (marked **[jsPsych]**).

### 0.1 File-Level Structure (Rules 1–2 — jsPsych: HTML comments)

```html
<!-- {filename}.html -->
<!--
  Integrated process:
    {stage_1} → {stage_2} → {stage_3}

  Data output:
    on_finish → sub-{id}_{task}_{date}.csv
    on_data_update → localStorage durable checkpoint

  Design summary:
    Each block: {n} trial
    Formal stage: {m} block × {t} = {total} trial

  Key modifications of the current version:
    1) {change_1}
    2) {change_2}
-->
```

**[jsPsych]** jsPsych is an HTML file. File headers are commented with HTML `<!-- -->` instead of Python `#`. The CDN version number must be written explicitly in the file header.

### 0.2 Section Order (Rules 1, 3, 5 — jsPsych: 9 sections)

```
Section 1: HTML header (CDN version number + CSS font/style + <body> container) ← Rule 3
Section 2: Experimental constants (subject/session/task version/seed material)
Section 3: Text constants (all instruction/feedback/prompt HTML strings are centrally defined) ← Rule 5
Section 4: Exit the safety net (AUTOSAVE_KEY + handleEmergencyAbort + persistTrialCheckpoint)
Section 5: jsPsych initialization (initJsPsych + on_data_update + on_finish + on_close)
Section 6: Conditional definition (inline array/factorial/precomputed generation) ← Rule 9
Section 7: Trial definition (fixation point/stimulus/feedback/ITI — one object per trial) ← Rule 12
Section 8: Block definition (timeline_variables + repetitions + randomize_order)
Section 9: Timeline assembly + startup (preload → instruction → blocks → debrief → run)
```

**[jsPsych]** jsPsych is declarative - trials are defined as objects, not functions. `jsPsych.run(timeline)` replaces the imperative main loop.

### 0.3 Variable Naming (Rule 4 — jsPsych: camelCase)

```
<prefix><Category><Meaning>

prefix = kp | nv | prac | main | (customized according to the experimental stage)
Category = Txt (text) | Key (key name) | Ms (millisecond timing)
         | MaxConsec (constraint) | n (count)

Positive example: pracFeedbackMs, mainItiMinMs, nvMaxConsecSame
Counterexample: feedback_timeout, iti, max_ellipse
```

**[jsPsych]** JavaScript convention uses camelCase. Cross-platform constants (`SUBJECT_ID`, `RUN_ID`, `AUTOSAVE_KEY`) retain UPPER_SNAKE because they are runtime identifiers.

### 0.4 Pseudorandom Constraints (Rule 6 — jsPsych: timeline_variables + randomize_order)

```js
// ---------- Pseudo-random constraint ----------
const MAX_CONSEC_SAME_CONDITION = 3;
const MAX_PSEUDORAND_TRIES = 5000;

function canAppendTrial(seq, candidate) {
    let count = 0;
    for (let i = seq.length - 1; i >= 0; i--) {
        if (seq[i].condition === candidate.condition) count++;
        else break;
    }
    return count < MAX_CONSEC_SAME_CONDITION;
}

function pseudorandomize(rawTrials) {
    for (let attempt = 0; attempt < MAX_PSEUDORAND_TRIES; attempt++) {
        const remaining = jsPsych.randomization.shuffle([...rawTrials]);
        const seq = [];
        while (remaining.length > 0) {
            const validIdx = [];
            for (let i = 0; i < remaining.length; i++) {
                if (canAppendTrial(seq, remaining[i])) validIdx.push(i);
            }
            if (validIdx.length === 0) break;
            const pick = validIdx[
              jsPsych.randomization.randomInt(0, validIdx.length - 1)
            ];
            seq.push(remaining.splice(pick, 1)[0]);
        }
        if (seq.length === rawTrials.length) return seq;
    }
    throw new Error('Unable to generate a trial sequence that satisfies the constraints.');  // Failure must exit
}
```

**[jsPsych]** jsPsych's `randomize_order: true` only supports simple randomization - it cannot express constraints such as "no more than N consecutive identical conditions". Constrained pseudo-random **must be precomputed** when the script is loaded: call `jsPsych.randomization.setSeed()` first, then call `pseudorandomize()` before `jsPsych.run()`, and assign the complete result directly to `timeline_variables`. The caller must catch `throw new Error()`, save the failed checkpoint, and explicitly call `jsPsych.abortExperiment()`; throwing the error itself will not automatically trigger jsPsych's abort process.

### 0.5 Exit Safety (Rule 7 — jsPsych: abortExperiment + localStorage checkpoint)

```js
let abortRequested = false;
function handleEmergencyAbort(event) {
  if (event.key !== 'Escape' || abortRequested) return;
  event.preventDefault();
  abortRequested = true;
  localStorage.setItem(`${AUTOSAVE_KEY}:aborted_at`, new Date().toISOString());
  jsPsych.abortExperiment(
    'The experiment has been safely terminated and the most recent checkpoint has been retained.',
    { abort_reason: 'escape' }
  );
}
document.addEventListener('keydown', handleEmergencyAbort, true);
```

**[jsPsych]** jsPsych has no full-screen exit issue - the browser's own Escape behavior does not lock the screen. `jsPsych.abortExperiment()` terminates execution and triggers `on_finish` (with `localSave`). Key: The third argument to `addEventListener` must be `true` (capture phase) to ensure capture before any jsPsych event handlers.

### 0.6 Condition Validation (Rule 9 — jsPsych: precomputed arrays)

```js
// Conditions must be precomputed at script load time - jsPsych does not support dynamic generation of timeline_variables at runtime
const validStimuli = ['RED', 'GREEN', 'BLUE'];
const validColors  = ['red', 'green', 'blue'];
const validKeys    = ['f', 'j'];

const conditions = [];
for (const word of validStimuli) {
  for (const color of validColors) {
    if (word === color) continue;  // Exclude consistent conditions? (depends on experimental design)
    conditions.push({
      word: word,
      color: color,
      corr_ans: color === 'red' ? 'f' : 'j',
      congruent: word === color
    });
  }
}
if (conditions.length === 0) {
  throw new Error('The condition table is empty.');
}
```

### 0.7 Trial Definition Contract (Rule 12 — jsPsych: five steps distributed across timeline)

**[jsPsych]** jsPsych does not have "one function does five steps" - the framework is declarative, and each trial object only manages one screen. The five steps are spread across multiple trial objects + block timeline:

```
① render = stimulus parameter (HTML string or function returning HTML)
② Collection = jsPsych automatically (data.response, data.rt — integer ms, no manual timing required)
③ feedback = separate feedback trial object (inserted after trial through block timeline)
④ ITI = post_trial_gap parameter (simple fixed length) or separate ITI trial object (random duration)
⑤ Write data = on_finish callback (calculate accuracy, response_status and other derived fields)
```

```js
// ①+② Stimulus + response (single trial object)
const trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    const word = jsPsych.evaluateTimelineVariable('word');
    const color = jsPsych.evaluateTimelineVariable('color');
    return `<p style="color:${color}; font-size:96px;">${word}</p>`;
  },
  choices: ['f', 'j'],
  trial_duration: 2000,
  data: function() {
    return {
      task: 'stroop',
      word: jsPsych.evaluateTimelineVariable('word'),
      color: jsPsych.evaluateTimelineVariable('color'),
      corr_ans: jsPsych.evaluateTimelineVariable('corr_ans')
    };
  },
  on_load: function() {
    onsetTimestamp = new Date().toISOString();            // Rule 16: Runtime value
  },
  on_finish: function(data) {
    data.accuracy = data.response === null                // Rule 15: 0/1 int
      ? 0
      : Number(jsPsych.pluginAPI.compareKeys(data.response, data.corr_ans));
    data.response_status = data.response === null ? 'timeout' : 'responded';
    data.timestamp = onsetTimestamp;
    data.block = blockIndex;
    data.trial = data.trial_index + 1;                    // 1-based
  }
};

// ③ Feedback (separate trial object)
const feedbackTrial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    const last = jsPsych.data.get().last(1).values()[0];
    if (last.accuracy === 1) return '<p style="color:green">Correct</p>';
    return '<p style="color:red">Error</p>';
  },
  choices: "NO_KEYS",
  trial_duration: FEEDBACK_MS,
  data: { task: 'feedback' }
};

// ④ ITI (jsPsych: random duration through post_trial_gap)
// post_trial_gap is automatically executed after on_finish and before the next trial.
// is placed on the last trial in the block to ensure that the interval is inserted after response/feedback.
const feedbackWithIti = Object.assign({}, feedbackTrial, {
  post_trial_gap: function() {
    return jsPsych.randomization.randomInt(ITI_MIN_MS, ITI_MAX_MS);
  }
});

// Five-step assembly in block timeline
const trialBlock = {
  timeline: [trial, feedbackWithIti],                   // ①② → ③ → ④
  timeline_variables: conditions,
  randomize_order: true
};
```

**Rule**: Naked numbers are not allowed inside the trial object - `trial_duration` all reference configuration constants. `on_finish` is the only place where data can be safely modified. `Number()` converts a boolean value to 0/1 int. `data.trial_index` is 0-based, converted to 1-based and saved.

### 0.8 Per-Trial Data Write (Rules 10, 14–16 — jsPsych: on_data_update checkpoint)

```js
function persistTrialCheckpoint(data) {
  try {
    localStorage.setItem(
      `${AUTOSAVE_KEY}:trial:${data.trial_index}`,
      JSON.stringify(data)
    );
    localStorage.setItem(`${AUTOSAVE_KEY}:last_trial`, String(data.trial_index));
  } catch (error) {
    jsPsych.abortExperiment(`Data save failed: ${error.name === 'QuotaExceededError' ? 'Storage is full' : 'Storage unavailable'}.`);
    throw error;
  }
}

const jsPsych = initJsPsych({
  on_data_update: persistTrialCheckpoint,  // Rule 10: Automatically triggered after each trial
  on_close: function() {
    localStorage.setItem(`${AUTOSAVE_KEY}:closed_at`, new Date().toISOString());
  },
  on_finish: function() {
    document.removeEventListener('keydown', handleEmergencyAbort, true);
    jsPsych.data.get().filter({task: 'stroop'}).localSave(       // Rule 11: Stage save
      'csv',
      `sub-${SUBJECT_ID}_${EXP_NAME}_${new Date().toISOString().slice(0,10)}.csv`
    );
  }
});
```

**[jsPsych]** `on_data_update` is automatically triggered after data is written for each trial - equivalent to PsychoPy's `nextEntry()`. `localSave('csv')` called in `on_finish` - equivalent to `saveAsWideText`. The localStorage checkpoint is a durable backup of each trial - if the browser crashes, it can be restored the next time it is loaded.

### 0.9 Main Flow (Rule 8 — jsPsych: declarative timeline, no try/catch)

```js
// jsPsych is a declarative framework — no imperative try/except/finally main loop.
// jsPsych.run(timeline) is executed in the order of timeline array.
// on_finish is always triggered (normal end, abort, Escape are triggered).
// Escape is handled in the capture phase through addEventListener('keydown', handler, true).
//
// The execution sequence is equivalent to:
//   preload → fullscreen → instruction → practice blocks → main blocks → debrief → on_finish

const timeline = [
  preload,                                         // Rule 13: First, all media is preloaded
  { type: jsPsychFullscreen, fullscreen_mode: true },
  instruction,
  practiceBlock,                                   // timeline_variables + repetitions + feedback
  mainBlock,                                       // timeline_variables + repetitions (no feedback)
  debrief
];
jsPsych.run(timeline);
```

**[jsPsych]** After `jsPsych.abortExperiment()` terminates execution, jsPsych automatically triggers `on_finish` - so `localSave` and cleanup can also be executed in the abort case. This is the jsPsych equivalent of `finally`. Key: The third parameter of `addEventListener` of `handleEmergencyAbort` must be `true`** (capture phase), otherwise the event handler of the jsPsych plug-in will capture the Escape key first, causing the abort handler not to trigger.

Block mode - control which trials appear through the timeline array:
```js
const practiceBlock = {
  timeline: [fixation, trial, feedback, iti],       // Exercise: with feedback
  timeline_variables: practiceConditions,
  randomize_order: true,
  repetitions: 1
};

const mainBlock = {
  timeline: [fixation, trial, iti],                 // Official: No feedback
  timeline_variables: mainConditions,
  randomize_order: true,
  repetitions: 4
};
```

### 0.10 Comment Rules (Rule 17)

```js
// Positive example — explaining intent
const AUTOSAVE_KEY = `psycoder-${SUBJECT_ID}-${EXP_NAME}`;  // localStorage recovery flag

// No feedback during the formal phase - only displayed during the practice phase correct/incorrect ← Explain design decisions

// data.accuracy uses Number() to ensure output of 0/1 instead of true/false ← Explain non-standard practice

// Counterexample - Don't do it
const jsPsych = initJsPsych({...});  // Initialize jsPsych ← The code is self-explanatory
choices: ['f', 'j']                  // Set allowed keys ← Nonsense
```

## 1. Minimal Keyboard-Task Scaffolding

This scaffolding shows pinned core/plugin loading for a keyboard task. Select only the plugins required by config; mouse, survey, audio, video, and custom-event tasks need their own verified nodes while preserving the shared persistence/abort/data contracts.

```html
<!DOCTYPE html>
<html>
<head>
  <title>Experiment</title>
  <script src="https://unpkg.com/jspsych@8.2.3"></script>
  <script src="https://unpkg.com/@jspsych/plugin-html-keyboard-response@2.1.0"></script>
  <script src="https://unpkg.com/@jspsych/plugin-image-keyboard-response@2.1.0"></script>
  <script src="https://unpkg.com/@jspsych/plugin-preload@2.1.0"></script>
  <link href="https://unpkg.com/jspsych@8.2.3/css/jspsych.css" rel="stylesheet" type="text/css" />
</head>
<body><div id="jspsych-target"></div></body>
<script>
  // 1. Initialize jsPsych
  const SUBJECT_ID = 'test';
  const SESSION_ID = 'session-1';
  const TASK_VERSION = '1.0.0';
  const RUN_ID = globalThis.crypto?.randomUUID?.();
  if (!RUN_ID) throw new Error('Target browser must provide crypto.randomUUID(); verify the pinned browser/runtime contract.');
  const AUTOSAVE_KEY = `amazing-psycoder-${SUBJECT_ID}-${SESSION_ID}-${RUN_ID}-autosave`;
  function persistTrialCheckpoint(data) {
    try {
      localStorage.setItem(`${AUTOSAVE_KEY}:trial:${data.trial_index}`, JSON.stringify(data));
      localStorage.setItem(`${AUTOSAVE_KEY}:last_trial`, String(data.trial_index));
    } catch (error) {
      const reason = error.name === 'QuotaExceededError'
        ? 'localStorage is full, please clear browser storage'
        : 'localStorage is unavailable (may be private mode), please use normal browsing mode';
      jsPsych.abortExperiment(`Data saving failed: ${reason}.`, { abort_reason: 'storage_unavailable' });
      throw error;
    }
  }
  let abortRequested = false;
  function handleEmergencyAbort(event) {
    if (event.key !== 'Escape' || abortRequested) return;
    event.preventDefault();
    abortRequested = true;
    localStorage.setItem(`${AUTOSAVE_KEY}:aborted_at`, new Date().toISOString());
    jsPsych.abortExperiment(
      'The experiment ended safely; the latest checkpoint was preserved.',
      { abort_reason: 'escape' }
    );
  }
  const jsPsych = initJsPsych({
    display_element: 'jspsych-target',
    on_data_update: persistTrialCheckpoint,
    on_close: function() {
      localStorage.setItem(`${AUTOSAVE_KEY}:closed_at`, new Date().toISOString());
    },
    on_finish: function() {
      document.removeEventListener('keydown', handleEmergencyAbort, true);
      jsPsych.data.get().localSave(
        'csv',
        `sub-${SUBJECT_ID}_ses-${SESSION_ID}_run-${RUN_ID}_experiment_data.csv`
      );
      localStorage.setItem(`${AUTOSAVE_KEY}:completed_at`, new Date().toISOString());
    }
  });
  const RNG_SEED = `${TASK_VERSION}|${SUBJECT_ID}|${SESSION_ID}`; // config seed_scope determines the material
  jsPsych.randomization.setSeed(RNG_SEED);
  jsPsych.data.addProperties({
    subject_id: SUBJECT_ID,
    session_id: SESSION_ID,
    run_id: RUN_ID,
    task_version: TASK_VERSION,
    rng_seed: RNG_SEED
  });
  document.addEventListener('keydown', handleEmergencyAbort, true);
  // 2. Preload media
  const preload = {
    type: jsPsychPreload,
    auto_preload: true
  };

  // 3. Define timeline
  const timeline = [preload, /* ...trials... */];

  // 4. Run experiment
  jsPsych.run(timeline);
</script>
</html>
```

This compact example uses synchronous per-trial `localStorage` records. A generated deployment must first assess expected payload/quota, privacy, browser lifecycle, and recovery/export requirements; use a tested server or IndexedDB path for larger or centrally managed studies. Never call a device-local checkpoint a remote backup.

## 2. Core API specification

### 2.1 initJsPsych() — Experimental configuration

```js
const jsPsych = initJsPsych({
  // Display
  display_element: 'jspsych-target',  // Target HTML element ID, default <body>
  experiment_width: 800,              // px, default 100%

  // Timing
  default_iti: 0,                     // Default interval between trials (ms)
  minimum_valid_rt: 0,                // Lowest effective RT (ms)

  // Data & Callbacks
  on_finish: function(data) { },      // Triggered at the end of the experiment to receive all data
  on_trial_start: function(trial) { },// Triggered at the beginning of each trial, the trial object can be modified
  on_trial_finish: function(data) { },// Triggered at the end of each trial
  on_data_update: function(data) { }, // Triggered when new data is written
  on_close: function() { },           // Triggered before the page is closed

  // Progress bar
  show_progress_bar: false,
  auto_update_progress_bar: true,

  // Audio
  use_webaudio: true,                 // true=WebAudio API, false=HTML5 Audio

  // Extensions
  extensions: [
    // { type: jsPsychExtensionMouseTracking, params: {} }
  ]
});
```

### 2.2 Timeline — Declarative experiment structure

jsPsych uses declarative timeline — Experimental = Nested Arrays. Each node can be a one-to-one trial or a block containing child nodes:

```js
const timeline = [
  welcome_trial,              // Simple trial object
  instruction_block,          // Nested timeline block
  practice_block,             // block containing timeline_variables
  main_block,                 // Main experiment block
  debrief_trial               // End screen
];
jsPsych.run(timeline);
```

**Core parameters — common to all timeline nodes:**

| Parameters | Type | Description |
|------|------|------|
| `type` | Plugin class | **Must be a class reference, not a string**. Such as `jsPsychHtmlKeyboardResponse` |
| `stimulus` | string/function | HTML content or image path |
| `choices` | array \| `"NO_KEYS"` \| `"ALL_KEYS"` | Allowed keys |
| `trial_duration` | number/function | Maximum duration (ms), null = infinite |
| `response_ends_trial` | boolean | Whether to press the key to end the trial, default true |
| `post_trial_gap` | number/function | Pause after trial (ms), default `default_iti` |
| `data` | object/function | Metadata attached to this trial |
| `on_start` | function | Triggered when trial just starts |
| `on_finish` | function(data) | Triggered when trial ends, data can be modified |
| `on_load` | function | Triggered when DOM loading is completed |

**Block-level parameters (nested timeline):**

| Parameters | Description |
|------|------|
| `timeline` | sub trial array |
| `timeline_variables` | Conditional array, each element is an object, key=variable name, value=variable value |
| `randomize_order` | Whether to randomize the trial order, default false |
| `repetitions` | Number of repetitions, default 1 |
| `loop_function` | Repeat this block if true is returned (loop until false is returned) |
| `conditional_function` | Return false to skip this block |

### 2.3 Timeline Variables — condition driven

**Correct mode** — `jsPsych.timelineVariable()` as static parameter:

```js
const stimuli = [
  { word: 'RED',   color: 'red',   corr_ans: 'left' },
  { word: 'GREEN', color: 'green', corr_ans: 'down' },
  { word: 'BLUE',  color: 'blue',  corr_ans: 'right' },
];

const trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    return `<p style="color:${jsPsych.evaluateTimelineVariable('color')}">${jsPsych.evaluateTimelineVariable('word')}</p>`;
  },
  choices: ['left', 'down', 'right'],
  data: jsPsych.timelineVariable('data')
};

const stroop_block = {
  timeline: [fixation, trial],
  timeline_variables: stimuli,
  randomize_order: true,
  repetitions: 5
};
```

**Key Rules**:
- **Static parameter placeholder**: `stimulus: jsPsych.timelineVariable('name')`
- **Immediate value within the function**: `jsPsych.evaluateTimelineVariable('name')`
- **Conditional precalculation**: The `timeline_variables` array is evaluated when the script is loaded and does not support dynamic generation at runtime
- If you need dynamic conditions at runtime, modify the trial parameter in `on_trial_start`

### 2.4 Key response collection

**Correct Mode** — Use the `choices` parameter to limit the allowed keystrokes:

```js
const trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: 'Press F or J',
  choices: ['f', 'j'],
  trial_duration: 2000,           // 2s deadline
  response_ends_trial: true       // Press key to end
};
// Automatic recording: data.response (key name), data.rt (ms, starting from stimulus appearance)
```

**Fixed duration (no response)**:
```js
const fixation = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '+',
  choices: "NO_KEYS",             // No keystrokes accepted
  trial_duration: 500,            // Fixed 500ms
  response_ends_trial: false      // It won’t end until time is up
};
```

**Forced Correction (practice)**:
```js
// Use the categorize-html plugin
const practiceTrial = {
  type: jsPsychCategorizeHtml,
  stimulus: jsPsych.timelineVariable('stim'),
  choices: ['f', 'j'],
  key_answer: 'f',                    // keyCode of the correct answer
  correct_text: '<span style="color:green">√</span>',
  incorrect_text: '<span style="color:red">X</span>',
  feedback_duration: 500,
  force_correct_button_press: true    // The correct key must be pressed to continue
};
```

### 2.5 RT timing

jsPsych automatically records RT — the time (ms) from the start of the trial to the key press. **No need to manually manage the clock. **

```js
// RT is automatically recorded in data.rt
// Source: performance.now(), rounded to nearest ms
jsPsych.data.get().filter({task: 'response'}).select('rt').mean();

// Verify minimum valid RT
const jsPsych = initJsPsych({
  minimum_valid_rt: 200  // ms, exclude too fast guessing reaction
});
```

**Anti-Pattern** — Disable manual timing:
- Don't log `Date.now()` in `on_start` and subtract in `on_finish`
- Do not use `setTimeout` to implement trial_duration — use the `trial_duration` parameter

### 2.6 Accuracy Judgment

**Mode 1 — `on_finish` callback (recommended)**:

```js
const test = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: jsPsych.timelineVariable('word'),
  choices: ['f', 'j'],
  data: jsPsych.timelineVariable('data'),
  on_finish: function(data) {
    data.correct = jsPsych.pluginAPI.compareKeys(
      data.response, data.correct_response
    );
  }
};
```

**Mode 2 — `categorize-html` plug-in built-in**:

```js
key_answer: 'f',  // or dynamic function: key_answer: function() { return keyCode(correctKey) }
// The plug-in automatically records data.correct = true/false
```

**Mode 3 — correctness_field parameter (supported by some plug-ins)**:

```js
const trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: jsPsych.timelineVariable('stim'),
  choices: ['f', 'j'],
  data: { corr_ans: 'f' },
  correctness_field: 'corr_ans'  // Plug-in automatic comparison response == corr_ans
};
```

### 2.7 Conditional file loading

jsPsych does not support direct loading of xlsx/csv files. Conditions must be defined as JavaScript arrays:

```js
// Method 1: Inline array
const conditions = [
  { stimulus: 'img/a.png', correct: 'f', category: 'target' },
  { stimulus: 'img/b.png', correct: 'j', category: 'foil' },
];

// Method 2: jsPsych.randomization.factorial (factorial design)
const factors = {
  cue_validity: ['valid', 'invalid'],
  target_location: ['left', 'right']
};
const conditions = jsPsych.randomization.factorial(factors);
// generates: [{cue_validity:'valid', target_location:'left'}, ...] 4 items in total

// Method 3: Dynamic generation (precalculated when script is loaded)
const csStimuli = ['cs1.jpg', 'cs2.jpg'];
const usStimuli = ['us1.jpg'];
const conditions = [];
csStimuli.forEach(function(cs) {
  usStimuli.forEach(function(us) {
    conditions.push({cs: cs, us: us, cs_type: 'CS', us_type: 'US'});
  });
});
```

### 2.8 Data Saving

**Force mode** — Create a durable checkpoint after each trial and export the final CSV at the normal end. `on_data_update` is triggered every time the plug-in writes data, and cannot only rely on memory and `localSave` at the end:

```js
const AUTOSAVE_KEY = `amazing-psycoder-${subjectID}-${expName}`;
const jsPsych = initJsPsych({
  on_data_update: function() {
    localStorage.setItem(AUTOSAVE_KEY, jsPsych.data.get().json());
  },
  on_close: function() {
    localStorage.setItem(AUTOSAVE_KEY, jsPsych.data.get().json());
  },
  on_finish: function() {
    jsPsych.data.get()
      .filter({task: 'response'})
      .localSave('csv', `sub-${subjectID}_${expName}.csv`);
  }
});
```

Acquisition export retains original response, RT, status and design fields. Do not apply universal RT thresholds or remove provenance on the browser acquisition side; confirmed exclusion rules are executed by the analysis script and sample flow is logged.

**DataCollection method quick check:**

| Method | Description |
|------|------|
| `jsPsych.data.get()` | Get all data |
| `.filter({key: value})` | Conditional filtering (AND) |
| `.filter([{a:1},{b:2}])` | Conditional filtering (OR) |
| `.filterCustom(fn)` | Custom filter function |
| `.ignore(['col1','col2'])` | Exclude specified columns |
| `.addToLast({key: val})` | Add attributes to the last piece of data |
| `.localSave('csv', filename)` | Local download CSV/JSON |
| `.csv()` | Export CSV string |
| `.json()` | Export JSON string |
| `.values()` | Return the original object array |
| `.count()` | Return trial quantity |
| `.select('col')` | Returns an array of specified column values |
| `jsPsych.data.addProperties({key:val})` | Globally add properties to all data |

## 3. Stimulus preloading (mandatory rules)

**Correct mode** — Insert `preload` trial at the front of timeline:

```js
// Automatic detection (recommended - covers most scenarios)
const preload = {
  type: jsPsychPreload,
  auto_preload: true      // Automatically scan the paths of all files in the timeline
};

// Manually specified (dynamic stimulus or file referenced within function)
const preload = {
  type: jsPsychPreload,
  images: ['img/blue.png', 'img/orange.png'],
  audio: ['audio/beep.mp3'],
  video: ['video/instruction.mp4'],
  show_progress_bar: true,
  message: 'Loading stimuli...'
};

const timeline = [preload, /* ...all other tests... */];
jsPsych.run(timeline);
```

**Anti-Pattern — Forbidden**:
- Do not place preload trial at the beginning of the timeline → When the image is presented for the first time, timing errors will be caused by network request delays.

## 4. CJK font configuration

```html
<!-- Method 1: Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC&display=swap" rel="stylesheet">

<!-- Option 2: System font fallback -->
<style>
  body {
    font-family: "PingFang SC", "Microsoft YaHei", "Noto Sans SC", sans-serif;
  }
  .jspsych-display-element {
    font-family: "PingFang SC", "Microsoft YaHei", "Noto Sans SC", sans-serif;
  }
</style>
```

```js
// Method 3: Inline in stimulus HTML
const instruction = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: `
    <div style="font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; font-size: 24px;">
      Hello! Welcome to this experiment. <br/>
      Please press the space bar to continue.
    </div>`,
  choices: [' ']
};
```

**Key Rule**: jsPsych renders everything as HTML — all styling is controlled via CSS. Chinese fonts use `PingFang SC` on macOS and `Microsoft YaHei` on Windows.

## 5. Anti-Pattern Cheat Sheet

| Forbidden API/Mode | Reason | Alternatives |
|-------------------|------|---------|
| `jsPsych.init()` | legacy initialization | `initJsPsych()` + `jsPsych.run()` |
| `type: 'html-keyboard-response'` (String) | current plugins use class references | `type: jsPsychHtmlKeyboardResponse` |
| `jsPsych.NO_KEYS` / `jsPsych.ALL_KEYS` | legacy constants | `"NO_KEYS"` / `"ALL_KEYS"` (strings) |
| `jsPsych.timelineVariable('x', true)` inside a function | v7 immediate-evaluation pattern, not current API | `jsPsych.evaluateTimelineVariable('x')` |
| `timeline_variables` as function | Runtime generation not supported | Precompute all conditions when script loads |
| `setTimeout` / `setInterval` implements timing | Inaccurate, breaks jsPsych event loop | `trial_duration` parameter |
| `Date.now()` Manual timing | jsPsych automatically records RT | Use `data.rt` |
| The media task is not preloaded before the first use | Runtime loading will pollute the rendering | The media task puts `preload` before the first media trial; pure HTML/text tasks do not need an empty preload node |
| `XMLHttpRequest` / `fetch` loads xlsx within trial | Network latency breaks timing | Precomputed as JavaScript array |
| Hardcoded `keyCode` number | Unreliable across browsers | `jsPsych.pluginAPI.convertKeyCharacterToKeyCode('f')` or use `'f'` directly |
| Do not return after modifying data in `on_finish` | The modification will not be reflected in the saved data | Directly modify the passed in `data` object (it is a reference) |
| Not handling the Escape key, or mixing Escape into scoring `choices` | Unable to exit safely, or mistaking the abort key as a task response | Use a cross-stage centralized `keydown` handler; write abort checkpoint first, then call `jsPsych.abortExperiment()`, and remove the listener in `on_finish` |
| Only `localSave` at the end of the experiment | Shut down/crash will lose the entire data | `on_data_update` is persisted to server/IndexedDB/localStorage, and then `localSave` at the end |

## 6. Trial life cycle

```
1. on_load() ← DOM loading completed
2. on_trial_start() ← trial is about to start (global callback)
3. on_start() ← When trial starts (trial level callback)
4. stimulus rendering ← display stimulus and start timing
5. [response collection] ← key / timeout
6. on_finish(data) ← When the trial ends (trial level), data can be modified
7. on_trial_finish(data) ← trial end (global callback)
8. post_trial_gap ← Clear the screen, wait for the interval
9. next trial / finish← Enter the next trial or the end of the experiment
```

**Key:** `data.rt` was measured between steps 4-5. `on_finish` is the best place to modify data (such as calculating accuracy).

## 7. Plug-in type quick check

### The most frequently used plug-in

| Requirements | Plug-in type | Key parameters |
|------|---------|---------|
| HTML + Keyboard | `jsPsychHtmlKeyboardResponse` | `stimulus`, `choices`, `trial_duration` |
| Picture + button | `jsPsychImageKeyboardResponse` | `stimulus`(picture path), `choices` |
| Audio + Keyboard | `jsPsychAudioKeyboardResponse` | `stimulus`(audio path), `choices` |
| HTML + button | `jsPsychHtmlButtonResponse` | `stimulus`, `choices`(button label array) |
| Category + Feedback | `jsPsychCategorizeHtml` | `key_answer`, `correct_text`, `incorrect_text`, `force_correct_button_press` |
| Instructions (multiple pages) | `jsPsychInstructions` | `pages` (text array), `key_forward`, `allow_backward` |
| Questionnaire (general) | `jsPsychSurvey` | `pages` (including questions array) |
| Likert scale | `jsPsychSurveyLikert` | `questions`, `labels`(7-point/5-point labels) |
| Multiple choice | `jsPsychSurveyMultiChoice` | `questions`, `options` |
| Text input | `jsPsychSurveyText` | `questions`, `rows` |
| Call function | `jsPsychCallFunction` | `func` |
| Full screen switch | `jsPsychFullscreen` | `fullscreen_mode`, `message` |
| Preloading | `jsPsychPreload` | `auto_preload`, `images`, `audio` |
| IAT | `jsPsychIatHtml` | `stimulus`(words array), `labels`(left and right labels) |

## 8. Canonical Code Skeleton — Keyboard Task

The following is the pinned keyboard reference skeleton, showing version, seed, persistence, exit and semantic data fields. It is not a universal implementation for all paradigms; generators must select plugins and event models per config, and document justification and testing for any contract deviations.

```html
<!-- {filename}.html -->
<!--
  Integrated process:
    Instructions → Practice → Formal Experiment → End

  Data output:
    on_finish → sub-{id}_{task}_{date}.csv
    on_data_update → localStorage durable checkpoint

  Design summary:
    Each block: {n} trial
    Formal stage: {m} block × {t} = {total} trial

  Key modifications of the current version:
    1) {change_1}
    2) {change_2}
-->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>{experiment_name}</title>
  <!-- ============================================================
  1. CDN version + CSS
  ============================================================ -->
  <script src="https://unpkg.com/jspsych@8.2.3"></script>
  <script src="https://unpkg.com/@jspsych/plugin-html-keyboard-response@2.1.0"></script>
  <script src="https://unpkg.com/@jspsych/plugin-preload@2.1.0"></script>
  <script src="https://unpkg.com/@jspsych/plugin-fullscreen@2.1.0"></script>
  <link href="https://unpkg.com/jspsych@8.2.3/css/jspsych.css" rel="stylesheet" type="text/css" />
  <style>
    body {
      font-family: "PingFang SC", "Microsoft YaHei", "Noto Sans SC", sans-serif;
    }
  </style>
</head>
<body></body>
<script>
  // ============================================================
  // 2. Experimental constants
  // ============================================================
  const SUBJECT_ID   = 'test';
  const SESSION_ID   = 'session-1';
  const TASK_VERSION = '1.0.0';
  const EXP_NAME     = '{experiment_name}';
  const BASE_DATA_COLUMNS = [
    'subject_id', 'block', 'trial', 'condition', 'stimulus',
    'correct_response', 'response', 'rt', 'accuracy', 'timestamp'
  ];
  const RUN_ID = globalThis.crypto?.randomUUID?.();
  if (!RUN_ID) throw new Error('Target browser must provide crypto.randomUUID().');

  // ============================================================
  // 3. Text constants (all instructions/feedback HTML are concentrated here)
  // ============================================================
  const txtWelcome = '<p>Welcome to participate in the experiment. </p><p>Press the space bar to start. </p>';
  const txtEnd = '<p>The experiment is over, thank you for participating! </p><p>Press any key to exit. </p>';

  // ---------- Timing (ms) ----------
  const FIXATION_MS    = 500;
  const STIMULUS_MS    = 1000;
  const FEEDBACK_MS    = 500;
  const RESP_DEADLINE_MS = 2000;
  const ITI_MIN_MS     = 600;
  const ITI_MAX_MS     = 900;

  // ---------- Key ----------
  const RESP_KEYS = ['f', 'j'];

  // ---------- Constraints ----------
  const MAX_PSEUDORAND_TRIES = 5000;

  // ============================================================
  // 4. Exit safety net + durable checkpoint
  // ============================================================
  const AUTOSAVE_KEY = `psycoder-${SUBJECT_ID}-${EXP_NAME}-${RUN_ID}`;
  function persistTrialCheckpoint(data) {
    try {
      localStorage.setItem(
        `${AUTOSAVE_KEY}:trial:${data.trial_index}`,
        JSON.stringify(data)
      );
      localStorage.setItem(`${AUTOSAVE_KEY}:last_trial`, String(data.trial_index));
    } catch (error) {
      jsPsych.abortExperiment('Checkpoint persistence failed.');
      throw error;
    }
  }
  let abortRequested = false;
  function handleEmergencyAbort(event) {
    if (event.key !== 'Escape' || abortRequested) return;
    event.preventDefault();
    abortRequested = true;
    localStorage.setItem(`${AUTOSAVE_KEY}:aborted_at`, new Date().toISOString());
    jsPsych.abortExperiment('The experiment has been safely terminated.', { abort_reason: 'escape' });
  }
  // ⚠️ Do not register handleEmergencyAbort here — jsPsych has not been created yet.
  // addEventListener must be registered after initJsPsych.

  // ============================================================
  // 5. jsPsych initialization
  // ============================================================
  let onsetTimestamp = '';
  let blockIndex = 0;
  const jsPsych = initJsPsych({
    on_data_update: persistTrialCheckpoint,
    on_close: function() {
      localStorage.setItem(`${AUTOSAVE_KEY}:closed_at`, new Date().toISOString());
    },
    on_finish: function() {
      document.removeEventListener('keydown', handleEmergencyAbort, true);
      jsPsych.data.get().filter({task: 'main'}).localSave(
        'csv',
        `sub-${SUBJECT_ID}_${EXP_NAME}_${new Date().toISOString().slice(0,10)}.csv`
      );
      localStorage.setItem(`${AUTOSAVE_KEY}:completed_at`, new Date().toISOString());
    }
  });
  // The Escape listener must be registered after jsPsych is created (when jsPsych already exists)
  document.addEventListener('keydown', handleEmergencyAbort, true);

  const RNG_SEED = `${TASK_VERSION}|${SUBJECT_ID}|${SESSION_ID}`;
  jsPsych.randomization.setSeed(RNG_SEED);
  jsPsych.data.addProperties({
    subject_id: SUBJECT_ID,
    session_id: SESSION_ID,
    run_id: RUN_ID,
    task_version: TASK_VERSION,
    rng_seed: RNG_SEED
  });

  // ============================================================
  // 6. Condition definition (precalculation)
  // ============================================================
  const stimuli = [
    { word: 'RED',  color: 'red',   corr_ans: 'f' },
    { word: 'GREEN', color: 'green', corr_ans: 'j' },
  ];
  const fullConditions = [];
  stimuli.forEach(function(row) {
    stimuli.forEach(function(col) {
      fullConditions.push({
        word: row.word,
        color: col.color,
        corr_ans: col.corr_ans,
        congruent: row.word === col.word
      });
    });
  });

  // ============================================================
  // 7. Trial definition (declarative object)
  // ============================================================

  // --- Gaze point ---
  const fixation = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: '<div style="font-size:60px;">+</div>',
    choices: "NO_KEYS",
    trial_duration: FIXATION_MS,                        // Rule 13: Reference constants
    data: { task: 'fixation' }
  };

  // --- stimulus + response ---
  const trial = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function() {
      const word = jsPsych.evaluateTimelineVariable('word');
      const color = jsPsych.evaluateTimelineVariable('color');
      return `<p style="color:${color}; font-size:96px;">${word}</p>`;
    },
    choices: RESP_KEYS,
    trial_duration: RESP_DEADLINE_MS,
    data: function() {
      return {
        task: 'main',
        word: jsPsych.evaluateTimelineVariable('word'),
        color: jsPsych.evaluateTimelineVariable('color'),
        corr_ans: jsPsych.evaluateTimelineVariable('corr_ans'),
        congruent: jsPsych.evaluateTimelineVariable('congruent')
      };
    },
    on_load: function() {
      onsetTimestamp = new Date().toISOString();        // Rule 16: Runtime value
    },
    on_finish: function(data) {
      data.block = blockIndex;
      data.trial = data.trial_index + 1;                // 1-based
      data.condition = data.congruent ? 'congruent' : 'incongruent';
      data.stimulus = `${data.word}|${data.color}`;
      data.correct_response = data.corr_ans;
      data.response_status = data.response === null ? 'timeout' : 'responded';
      data.rt = data.rt === null ? null : Math.round(data.rt);
      data.accuracy = data.response === null            // Rule 15: 0/1 int
        ? 0
        : Number(jsPsych.pluginAPI.compareKeys(data.response, data.corr_ans));
      data.timestamp = onsetTimestamp;
    }
  };

  // --- Feedback (Practice phase only) ---
  const feedback = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function() {
      const accuracy = jsPsych.data.get().last(1).values()[0].accuracy;
      if (accuracy === 1) return '<p style="color:green; font-size:48px;">Correct</p>';
      return '<p style="color:red; font-size:48px;">Error</p>';
    },
    choices: "NO_KEYS",
    trial_duration: FEEDBACK_MS,
    post_trial_gap: function() {                           // Random ITI after feedback
      return jsPsych.randomization.randomInt(ITI_MIN_MS, ITI_MAX_MS);
    },
    data: { task: 'feedback' }
  };

  // --- Formal trial (comes with random ITI) ---
  // jsPsych: post_trial_gap is automatically executed after on_finish and before the next trial.
  // is placed on the last trial in the block to ensure response/feedback before inserting the ITI.
  const mainTrial = Object.assign({}, trial, {
    post_trial_gap: function() {
      return jsPsych.randomization.randomInt(ITI_MIN_MS, ITI_MAX_MS);
    }
  });

  // ============================================================
  // 8. Block definition
  // ============================================================
  // Each block's timeline applies to each row in timeline_variables.
  // practiceBlock: Each condition executes fixation → trial → feedback (feedback followed by ITI)
  // mainBlock: Each condition executes fixation → mainTrial (trial followed by ITI, no feedback)
  const practiceBlock = {
    timeline: [fixation, trial, feedback],
    timeline_variables: fullConditions,
    randomize_order: true,
    repetitions: 1
  };

  const mainBlock = {
    timeline: [fixation, mainTrial],
    timeline_variables: fullConditions,
    randomize_order: true,
    repetitions: 4
  };

  // ============================================================
  // 9. Timeline assembly + startup
  // ============================================================
  const preload = {
    type: jsPsychPreload,
    auto_preload: true
  };

  const welcome = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: txtWelcome,
    choices: [' ']
  };

  const endScreen = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: txtEnd,
    choices: "ALL_KEYS"
  };

  const timeline = [
    preload,                                              // Rule 13: Preload first
    { type: jsPsychFullscreen, fullscreen_mode: true },
    welcome,
    practiceBlock,
    mainBlock,
    endScreen
  ];
  jsPsych.run(timeline);
</script>
</html>
```

## 9. API reference index

| Functions to be implemented | Core API/plug-in |
|---------------|----------------|
| Create experiment, configure callback | `initJsPsych({on_finish, on_trial_start, ...})` |
| Start experiment | `jsPsych.run(timelineArray)` |
| Display HTML text + keystrokes | `jsPsychHtmlKeyboardResponse` |
| Display image + key | `jsPsychImageKeyboardResponse` |
| Play audio + key | `jsPsychAudioKeyboardResponse` |
| Classification task + feedback | `jsPsychCategorizeHtml` / `jsPsychCategorizeImage` |
| Multi-page instructions | `jsPsychInstructions` |
| Likert scale | `jsPsychSurveyLikert` |
| Multiple choice questionnaire | `jsPsychSurveyMultiChoice` |
| IAT task | `jsPsychIatHtml` / `jsPsychIatImage` |
| Switch to full screen | `jsPsychFullscreen` |
| Preload media | `jsPsychPreload` |
| Execute arbitrary JS | `jsPsychCallFunction` |
| Conditional array driven trial | `timeline_variables` + `jsPsych.timelineVariable()` |
| Factorial design | `jsPsych.randomization.factorial(factors)` |
| Randomization | `jsPsych.randomization.shuffle(arr)` / `randomize_order: true` |
| Key comparison | `jsPsych.pluginAPI.compareKeys(response, expected)` |
| Data filtering | `jsPsych.data.get().filter({...}).filterCustom(fn)` |
| Data save | `on_data_update` durable checkpoint + final `.localSave('csv', filename)` |
| Data display (debugging) | `jsPsych.data.displayData()` |
| Mouse tracking | `extension-mouse-tracking` |
| Eye tracking | `extension-webgazer` |
