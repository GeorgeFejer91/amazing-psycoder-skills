# PsychoPy Implementation Guide

> **Parent**: [psy-exp-coder](../../SKILL.md)
> **Status**: reference — apply these rules to every generated PsychoPy experiment
> **Last updated**: 2026-07-25 — 17-rule quality template applied

## Critical Rules (Read First — errors here invalidate data)

| Rule | Why Critical |
|------|-------------|
| **RT from `key.rt`, never `clock.getTime()`** | Wrong RT source = all reaction-time data invalid |
| **`nextEntry()` after every trial** | Missing = crash loses all data. `try/finally` alone is not enough |
| **`callOnFlip(kb.clock.reset)` at stimulus onset** | Missing = RT measures from wrong origin |
| **Escape in every timed loop** | Missing = user trapped in fullscreen, must force-quit |
| **Preload stimuli outside trial loop** | `ImageStim()` inside loop = frame drops, timing jitter |
| **`event.getKeys(maxWait=...)` forbidden** | Blocks event loop, escape unresponsive |

Full anti-patterns table: [§11](#11-anti-patterns). Full 17-rule template: [§0](#0-code-structure-requirements-17-rule-quality-template).

## Version Assumption

Do not silently default a PsychoPy/Python version. Generate against the exact `runtime.framework_version` and pinned dependency strategy in config, verify every used API against that version, and record the target OS/device profile. Builder-export compatibility is required only when the user/config requests it.

## 0. Code Structure Requirements (17-Rule Quality Template)

Every generated PsychoPy experiment must follow these rules. Order matters — sections must appear in the sequence listed below.

### 0.1 File-Level Structure (Rules 1–2)

```python
# {filename}.py
# ---------------------------------------------------------------
# Integrated process:
#   {stage_1} → {stage_2} → {stage_3}
#
# Data output:
#   {stage} -> <prefix>_{stage}.csv / <prefix>_{stage}.psydat
#
# Design summary:
#   Each block: {trial_count} trial
#   Formal stage: {block_count} block × {trials_per_block} = {total} trial
#
# Key modifications of the current version:
#   1) {change_1}
#   2) {change_2}
# ---------------------------------------------------------------
```

**Rule**: First line of file = file name. The integrated process uses `→` arrows to indicate the sequence of stages. The data output format of each stage is clearly written. Use a numbered list of critical changes.

### 0.2 Section Order (Rules 1, 3, 5, 11)

```
1. Basic configuration area (path/screen/font/exit key) ← Rule 3: Configuration first 1/3
2. Text constant area (all instructions/feedback/prompt texts are centrally defined) ← Rule 5
3. Condition table/timing/constraint configuration area (data table name/path/constraint constant) ← Rule 6
4. Subject information area (gui.DlgFromDict)
5. Window + general object area (win / kb / TextStim pool / show_text function)
6. Data processor configuration area (ExperimentHandler is independent by stage) ← Rule 11
7. Tool function area (path synthesis / conditional loading / safe waiting / pseudo-random / exit safety net) ← Rule 7
8. Single trial function (presentation → collection → feedback → ITI → write data) ← Rule 12
9. Main process (try → sequential execution of each stage → except → finally cleanup) ← Rule 8
```

**Rule**: Each section starts with `# ============================================================`, and sub-configurations within the section are separated by `# ----------`. Interrupting the order of segments is not allowed.

### 0.3 Variable Naming (Rule 4)

```
<STAGE_PREFIX>_<CATEGORY>_<MEANING>

STAGE_PREFIX = KP | NV | PRAC | MAIN | (customized by experimental stage)
CATEGORY = TXT (instruction text) | KEY (key) | MS (millisecond timing)
             | DIR (folder path) | FB (feedback) | EXCEL (condition table file name)
             | MAX_CONSEC (pseudo-random constraint) | N_ (count)

Positive example: KP_ITI_MS, NV_FEED_TIMEOUT, NV_MAX_CONSEC_ELLIPSE
Counter example: iti, feedback_timeout, max_ellipse (no stage prefix, no classification information)
```

### 0.4 Pseudorandom Constraints (Rule 6)

```python
# ---------- Pseudo-random constraint ----------
NV_MAX_CONSEC_ELLIPSE     = 2       # Each constraint has a constant that can be adjusted independently
NV_MAX_CONSEC_PRIME_WIDTH = 3
NV_MAX_CONSEC_CORRECT_KEY = 3
NV_MAX_PSEUDORAND_TRIES   = 5000   # Hard upper limit to prevent infinite loops

def can_append_trial(current_seq, candidate):
    """Check whether candidate added to the end of current_seq violates any constraints"""
    # ... constraint-by-constraint check ...

def pseudorandomize(raw_trials, max_tries=NV_MAX_PSEUDORAND_TRIES):
    """Found legal sequence within max_tries times, failure = exit, no downgrade"""
    for _ in range(max_tries):
        # ... shuffle + constraint check ...
        if len(seq) == len(raw_trials):
            return seq
    exit_without_saving()  # Failure must exit
```

**Rule**: The constraint attempt fails and must exit. Downgrading to simple random is not allowed. Returning sequences that may violate constraints is not allowed.

### 0.5 Exit Safety (Rule 7)

```python
aborted_by_user = False

def cleanup_outputs():
    """Delete incomplete data files that exited midway"""
    for prefix in [filename_prefix_kp, filename_prefix_navon]:
        for path in glob.glob(prefix + ".*"):
            try:
                os.remove(path)
            except:
                pass

def exit_without_saving():
    """Escape / exception / called when condition verification fails"""
    global aborted_by_user
    aborted_by_user = True
    cleanup_outputs()
    try:
        win.close()
    except:
        pass
    core.quit()
```

**Rule**: `exit_without_saving()` must be called when: user presses Escape, file is missing, condition check fails, pseudo-random failure.

### 0.6 Condition Validation (Rule 9)

```python
# Define the legal value set first, and then verify it line by line
NV_VALID_PRIME_NAMES  = ["narrow", "broad"]
NV_VALID_SHAPES       = ["circle", "ellipse"]

# Line-by-line verification - report which fields are illegal in specific lines
prime_errors = []
for i, r in enumerate(nv_prime_rows, start=1):
    if r["prime"].lower() not in NV_VALID_PRIME_NAMES:
        prime_errors.append(f"prime table row {i} prime is illegal: {r['prime']}")

if prime_errors:
    show_text("Error:\n" + "\n".join(prime_errors[:20]), True)
    exit_without_saving()

# Material file pre-check
missing = [f for f in sorted(needed_files) if not os.path.isfile(f)]
if missing:
    show_text(f"Error: The following materials are missing:\\n\\n" + "\n".join(missing[:20]), True)
    exit_without_saving()
```

**Rule**: The verification must cover: column existence, the number of rows is non-zero, the column value is within the legal set, the material file exists on the disk, and the number of key conditions meets the standards. Error message truncation (`[:20]`) prevents screen spam.

### 0.7 Trial Function Contract (Rule 12)

```python
def {stage}_run_one_trial(
    row: dict,              # A row in the conditional table — always the first parameter, always named row
    trial_index: int,       # trial sequence number in block (1-based)
    block_index: int,       # block serial number
    phase: str,             # "practice" | "main" — Control feedback logic
    # ... additional behavior switches as boolean parameters
):
    """Single trial: Present → Collect → Feedback → ITI → Write Data"""

    # ① Stimulus presentation (including random parameters such as prime_duration_ms)
    # ② Response collection (while loop + rt_clock + timeout check)
    # ③ Feedback presentation (according to phase branch: practice all feedback / formal only timeout)
    # ④ ITI (safety waiting)
    # ⑤ Data writing (all fields addData + nextEntry at one time)
```

**Rule**: Naked numbers are not allowed inside the trial function - all reference configuration constants. RT must use `int(key.rt * 1000)`. All boolean values ​​are stored as `0/1` int. Runtime dynamic values ​​(random duration, actual ITI, onset timestamp) must be written to the data.

### 0.8 Per-Trial Data Write (Rules 10, 14–16)

```python
# ⑤ Data writing - all fields are explicit, completed at one time
for kk in SUBJECT_COLS:
    thisExp.addData(kk, info.get(kk, ""))
thisExp.addData("phase", phase)
thisExp.addData("block_index", block_index)
thisExp.addData("trial_index", trial_index)
thisExp.addData("resp_key", resp_key)
thisExp.addData("rt_ms", rt_ms)                            # Rule 14: Integer ms, from key.rt not clock.getTime()
thisExp.addData("correct", int(correct))                   # Rule 15: 0/1 int
thisExp.addData("timeout", int(timeout))
thisExp.addData("prime_duration_ms", prime_duration_ms)    # Rule 16: Runtime value
thisExp.addData("iti_ms_actual", iti_ms_actual)            # Rule 16: Runtime value
thisExp.nextEntry()                                         # Rule 10: Write disk immediately
```

### 0.9 Main Flow (Rule 8)

```python
try:
    # All experimental phases are called in sequence
    stage_1_run_and_save()
    stage_2_run_and_save()
    # ...

except SystemExit:
    exit_without_saving()

except Exception as e:
    exit_without_saving()

finally:
    try:
        thisExpKP.abort()
    except:
        pass
    try:
        thisExpNV.abort()
    except:
        pass
    try:
        win.close()
    except:
        pass
    core.quit()
```

**Rule**: Three except branches are indispensable. Each cleanup operation in finally is a separate try-except. `saveAsWideText` + `saveAsPickle` must be executed immediately after each stage, without waiting for the end of the experiment.

### 0.10 Comment Rules (Rule 17)

```python
# Positive example — explaining intent
rt_clock = core.Clock()
# fixation removed, only ITI retained ← Explain design decisions
prime_duration_ms = random.randint(400, 600)             ← Avoid an obvious comment such as "# Generate random numbers".
NV_PRIME_MIN_MS = 400 ← Configuration value comes with comments

# Counterexample - Don't do it
rt_clock = core.Clock()  # Create clock object ← Code self-explanatory
win = visual.Window(...) # Create PsychoPy window ← Nonsense
```

**Rule**: Disallows `# creating an X object`, `# setting Y to Z`. Allowed and encouraged: Explain why it was deleted, why this value was chosen, and the reason for non-standard processing.

## 1. Timing Rules

### 1.1 Frame-Accurate Timing Foundation

Visual onset/duration must be referenced to actual/predicted flips, and response timing must use the selected device backend's event timestamps. Wall-clock calls may record metadata, but must not substitute for flip- or device-referenced measurements. These are the core visual-timing APIs:

| API | Purpose | Notes |
|-----|---------|-------|
| `win.getFutureFlipTime(clock=None)` | Predicted time of next flip in **global** time | Use for component status checks: `tThisFlipGlobal > comp.tStartRefresh + duration - frameTolerance` |
| `win.getFutureFlipTime(clock=routineTimer)` | Predicted time of next flip in **routine-local** time | Reset `routineTimer` at routine start |
| `win.callOnFlip(callback, *args)` | Schedule callback at next screen refresh | Kernel of RT timing — `kb.clock.reset` must go here |
| `win.timeOnFlip(obj, 'attribute')` | Record flip time into object attribute | e.g. `win.timeOnFlip(comp, 'tStartRefresh')` |
| `frameTolerance = 0.001` | Frame comparison tolerance (1ms) | Prevents rounding errors from blocking state transitions |

```python
# Supported duration-managed visual frame-loop pattern
routineTimer = core.Clock()
frameTolerance = 0.001

while continueRoutine and routineTimer.getTime() < maxDuration:
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)

    # Component STARTED: when tThisFlip >= onset time
    if comp.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
        comp.tStartRefresh = tThisFlipGlobal
        comp.status = STARTED
        comp.setAutoDraw(True)

    # Component FINISHED: when on-screen time >= duration
    if comp.status == STARTED:
        if tThisFlipGlobal > comp.tStartRefresh + compDuration - frameTolerance:
            comp.status = FINISHED
            comp.setAutoDraw(False)

    win.flip()
```

### 1.2 Keyboard Backend Selection

`psychopy.hardware.keyboard.Keyboard` accepts a `backend` parameter. Backend availability and timing behavior depend on PsychoPy version, OS, device, and driver, so choose deliberately and verify on the target machine:

| Backend | Characteristics | Recommendation |
|---------|-----------------|----------------|
| `'ptb'` (Psychtoolbox) | Asynchronous keyboard timestamps when supported | Preferred candidate for time-critical RT tasks; verify availability and timing |
| `'iohub'` | Separate-process device handling and release-event support | Use when its device/event features are required; verify timing |
| `'event'` | Legacy/fallback event path | Use only with a documented justification and target-machine validation for timing-critical tasks |

```python
from psychopy.hardware import keyboard

# Candidate configuration for a timing-critical RT task
kb = keyboard.Keyboard(backend='ptb')
```

**Key**: Do not use the backend name itself as proof of accuracy. Document the PsychoPy/PTB/OS/device version and verify the design's required timing accuracy with a smoke test or external measurement of the target hardware.

### 1.3 Correct RT Measurement

Reset the keyboard clock on the flip used as the software onset reference. `win.callOnFlip()` aligns the clock reset with that flip callback; physical display onset still depends on the display pipeline and requires target-hardware measurement when scientifically material.

**Core pattern:**

```python
kb = keyboard.Keyboard(backend='ptb')
ALLOWED_KEYS = ['f', 'j']

# --- inside trial loop ---
stim.draw()
win.callOnFlip(kb.clock.reset)   # RT starts at the recorded flip-referenced onset
win.callOnFlip(kb.clearEvents)   # clear any pre-flip keypresses
win.flip()

# Timed response loop
response = None
rt = None
timer = core.CountdownTimer(RESPONSE_DEADLINE)
while timer.getTime() > 0:
    keys = kb.getKeys(keyList=ALLOWED_KEYS + ['escape'], waitRelease=False, clear=False)
    if keys:
        key = keys[0]
        if key.name == 'escape':
            save_and_quit()
        response = key.name
        rt = key.rt  # seconds, from kb.clock.reset on the flip
        break

if rt is not None:
    rt *= 1000  # convert to ms
```

### 1.4 key.rt vs clock.getTime() — Key differences

| Time source | Meaning | Accuracy |
|--------|------|------|
| `key.rt` | The key-down event time reported by the selected keyboard backend, relative to `kb.clock.reset()` | Usually better than the polling code time; end-to-end error depends on the device/backend/OS and needs to be measured |
| `kb.clock.getTime()` | The time when the code **executes to this line** | Affected by polling and code path delays, it cannot replace the device event timestamp |

**Always use `key.rt` for RT, never manually `clock.getTime()` to calculate RT. **

### 1.5 waitRelease parameter

| `waitRelease` | Behavior | Applicable scenarios |
|---------------|------|---------|
| `False` | Returns the key-down event, `.rt` corresponds to the moment of pressing | Used when the scored event of the protocol is key-down |
| `True` (default) | Wait for the key to be released before returning, `.duration` is available | Scenarios that require key duration |

**RT tasks that respond to key presses should set `waitRelease=False`**. `True` only returns the keys that have been released, which may delay the program from obtaining the event; only use it when studying the key duration/release moment, and make the corresponding estimand clear.

### 1.6 getKeys() vs waitKeys()

```python
# getKeys() — non-blocking, must be polled in a loop (recommended)
keys = kb.getKeys(keyList=['f', 'j'], waitRelease=False, clear=False)

# waitKeys() — blocking waiting, not suitable for scenarios that require simultaneous frame looping
keys = kb.waitKeys(maxWait=5.0, keyList=['f', 'j'])
```

Use a non-blocking `getKeys()` loop in trials that require continuous refresh, parallel triggering, animation, timeout states, or persistent Escape/window event handling. Static, single-response non-critical screens can use `waitKeys()`, but must include the escape key and ensure a cleanup path; do not misreport the blocking itself as a fixed RT deviation.

### 1.7 RT Onset Window Resolution

Check the `rt_onset` field on each response window:
- `rt_onset: self` → reset `kb.clock` at this window's own flip (merged pattern)
- `rt_onset: Target` → reset `kb.clock` at the actual flip of the window named "Target". Interpret what that interval includes from the confirmed timeline; do not attach a generic cognitive-process label.
- Missing → **ask the user before generating code**. Do not guess.

### 1.8 core.wait() — Restricted

`core.wait(duration)` blocks concurrent event handling. Do not use it for an interactive interval. A hardware protocol may require a measured blocking pulse, but that duration must come from the device contract and the design must preserve cleanup; otherwise use a timed loop:

```python
# Instead of: core.wait(0.5)
timer = core.CountdownTimer(0.5)
while timer.getTime() > 0:
    if any(key.name == 'escape' for key in kb.getKeys(keyList=['escape'], waitRelease=False)):
        save_and_quit()
    win.flip()
```

### 1.9 Canonical Code Skeleton (contract baseline for new projects)

The following skeleton shows the security, timing, data, and cleanup contracts that new projects must preserve. Press config to select the actual component/device/API; justified structural deviations must be documented and tested, `modify`/`debug` does not override irrelevant architecture.

```python
#!/usr/bin/env python3
# {filename}.py
# ---------------------------------------------------------------
# Integrated process:
#   {stage_1} → {stage_2} → {stage_3}
#
# Data output:
#   {stage} -> <prefix>_{stage}.csv / <prefix>_{stage}.psydat
#
# Design summary:
#   Each block: {n} trial
#   Formal stage: {m} block × {t} = {total} trial
#
# Key modifications of the current version:
#   1) {change_1}
#   2) {change_2}
# ---------------------------------------------------------------

import platform, os, csv, random, hashlib, glob
from datetime import datetime, timezone
from psychopy import visual, core, data, gui, event
from psychopy.hardware import keyboard

# ============================================================
# 1. Basic configuration (general)
# ============================================================
EXP_NAME = "{experiment_name}"

if "__file__" in globals():
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
else:
    BASE_DIR = os.getcwd()

SAVE_DIR = os.path.join(BASE_DIR, "data")
try:
    os.makedirs(SAVE_DIR, exist_ok=True)
except OSError:
    # Insufficient permissions/disk full/read-only file system - exit directly and don’t find out until the experiment starts
    print(f"Unable to create data folder: {SAVE_DIR}")
    print("Please check the disk space and write permissions and try again.")
    core.quit()

# ---------- Screen ----------
WIN_SIZE  = [1920, 1080]
FULLSCR   = True
BG_COLOR  = [0, 0, 0]        # black
WIN_UNITS = "height"

# ---------- Font ----------
# Explicitly record master font and target-verified fallbacks; startup checks should verify glyph coverage before formal acquisition.
FONT_CONFIG        = {"primary": "PingFang SC", "fallback": "Noto Sans CJK SC"}
TEXT_FONT          = FONT_CONFIG["primary"]
FONT_SIZE          = 0.05
FEEDBACK_FONT_SIZE = 0.07
TEXT_WRAP_WIDTH    = 2.5
TXT_COLOR          = "white"

# ---------- Exit key ----------
KEY_QUIT = "escape"

# ============================================================
# 2. Text constant area (all instructions/feedback texts are concentrated here)
# ============================================================
TXT_START = (
    "Welcome to participate in the experiment. \\n\\n"
    "Press any key to start."
)

TXT_END = (
    "The experiment is over, thank you for participating! \\n\\n"
    "Press any key to exit."
)

# ============================================================
# 3. Condition table/timing/constraint configuration
# ============================================================
CONDITION_XLSX = "conditions.xlsx"

# ---------- Timing (seconds) ----------
FIXATION_S    = 0.5
STIMULUS_S    = 1.0
FEEDBACK_S    = 0.5
RESP_MAX_S    = 2.0
ITI_MIN_S     = 0.6
ITI_MAX_S     = 0.9

# ---------- Key ----------
ALLOWED_KEYS = ["f", "j"]

# ---------- Pseudo-random constraint ----------
MAX_CONSEC_SAME_CONDITION = 3
MAX_PSEUDORAND_TRIES      = 5000

# ============================================================
# 4. Subject information
# ============================================================
fields_order = ["Participant ID", "Age", "Gender", "Handedness"]

while True:
    info = {
        "Participant ID": "",
        "Age": "",
        "Gender": ["Male", "Female"],
        "Handedness": ["Right", "Left"]
    }
    dlg = gui.DlgFromDict(info, title=EXP_NAME, order=fields_order, sortKeys=False)
    if not dlg.OK:
        core.quit()
    if info["Participant ID"].strip() != "":
        break

filename_prefix = os.path.join(
    SAVE_DIR, f"{info['Participant ID']}_{data.getDateStr()}"
)
RANDOM_SEED = int.from_bytes(
    hashlib.sha256(f"{EXP_NAME}|{info['Participant ID']}".encode("utf-8")).digest()[:8],
    "big",
)
rng = random.Random(RANDOM_SEED)

SUBJECT_COLS = ["Participant ID", "Age", "Gender", "Handedness"]
BASE_DATA_COLUMNS = [
    "subject_id", "block", "trial", "condition", "stimulus",
    "correct_response", "response", "rt", "accuracy", "timestamp",
]

# ============================================================
# 5. Window and general objects
# ============================================================
win = visual.Window(size=WIN_SIZE, fullscr=FULLSCR, color=BG_COLOR, units=WIN_UNITS)
kb  = keyboard.Keyboard(backend="ptb")
event.Mouse(visible=False, win=win)

msg = visual.TextStim(
    win, text="", color=TXT_COLOR, height=FONT_SIZE,
    wrapWidth=TEXT_WRAP_WIDTH, font=TEXT_FONT
)

def show_text(s: str, wait_key: bool = True, font_size: float = FONT_SIZE, color=None):
    """General text display - guidance/feedback/end prompts"""
    msg.text = s
    msg.height = font_size
    msg.color = color or TXT_COLOR
    msg.draw()
    win.flip()
    if wait_key:
        kb.clearEvents()
        keys = kb.waitKeys(keyList=None)
        if any(k.name == KEY_QUIT for k in keys):
            raise SystemExit

# ============================================================
# 6. Data processor (independent ExperimentHandler for each stage)
# ============================================================
thisExp = data.ExperimentHandler(
    name=EXP_NAME,
    extraInfo=info,
    savePickle=False,
    saveWideText=False,
    dataFileName=filename_prefix
)
thisExp.extraInfo = {}

# ============================================================
# 7. Tool functions
# ============================================================

# ---------- Exit the safety net ----------
aborted_by_user = False

def cleanup_outputs():
    for path in glob.glob(filename_prefix + ".*"):
        try:
            os.remove(path)
        except:
            pass

def exit_without_saving():
    global aborted_by_user
    aborted_by_user = True
    cleanup_outputs()
    try:
        win.close()
    except:
        pass
    core.quit()

# ---------- Path ----------
def stim_path(filename: str) -> str:
    return os.path.join(BASE_DIR, "stimuli", filename)

# ---------- Conditional loading + verification ----------
def load_rows_or_exit(xlsx_path: str, required_cols: list):
    full_path = os.path.join(BASE_DIR, xlsx_path)
    try:
        rows = data.importConditions(full_path)
    except Exception as e:
        show_text(f"Error loading {full_path}:\n{repr(e)}", True)
        exit_without_saving()
    if len(rows) == 0:
        show_text(f"Error: {full_path} is empty.", True)
        exit_without_saving()
    missing = [c for c in required_cols if c not in rows[0]]
    if missing:
        show_text(f"Missing columns in {xlsx_path}: {', '.join(missing)}", True)
        exit_without_saving()
    return rows

# ---------- Safe waiting (can be interrupted by escape) ----------
def safe_wait(sec: float):
    """Escape-checking wait. core.wait(0.001) here is a polling yield (~1ms), not a timing block —
    it prevents CPU spinning while keeping the escape path responsive. This is safe. """
    t0 = core.getTime()
    while core.getTime() - t0 < sec:
        if kb.getKeys(keyList=[KEY_QUIT], waitRelease=False, clear=False):
            exit_without_saving()
        core.wait(0.001)

# ---------- Pseudo random ----------
def can_append_trial(seq, candidate):
    """Check whether any continuity constraints are violated"""
    key = "condition"
    count = 0
    for row in reversed(seq):
        if row[key] == candidate[key]:
            count += 1
        else:
            break
    return count < MAX_CONSEC_SAME_CONDITION

def pseudorandomize(raw_trials):
    for _ in range(MAX_PSEUDORAND_TRIES):
        remaining = list(raw_trials)
        rng.shuffle(remaining)
        seq = []
        while remaining:
            valid = [i for i, c in enumerate(remaining) if can_append_trial(seq, c)]
            if not valid:
                break
            seq.append(remaining.pop(rng.choice(valid)))
        if len(seq) == len(raw_trials):
            return seq
    show_text("Error: Unable to generate a trial sequence that satisfies the constraints.", True)
    exit_without_saving()

# ============================================================
# 8. Single trial function (five-step rule)
# ============================================================
def run_one_trial(row: dict, trial_index: int, block_index: int, phase: str):
    """Present → Collect → Feedback → ITI → Write Data"""

    # ① Stimulus presentation
    stimText.text = row["stimulus"]
    stimText.draw()
    win.callOnFlip(kb.clock.reset)
    win.callOnFlip(kb.clearEvents)
    win.flip()
    rt_clock = core.Clock()
    onset_ts = datetime.now(timezone.utc).isoformat()

    # ② Reaction collection
    resp_key, rt_ms, correct, timeout = "", None, 0, 0
    while rt_clock.getTime() < RESP_MAX_S:
        keys = kb.getKeys(keyList=ALLOWED_KEYS + [KEY_QUIT], waitRelease=False, clear=False)
        if keys:
            k = keys[0]
            if k.name == KEY_QUIT:
                exit_without_saving()
            resp_key = k.name
            rt_ms = int(k.rt * 1000)                         # Rule 14: Integer ms
            correct = int(resp_key == row["correct_key"])    # Rule 15: 0/1 int
            break
        stimText.draw()
        win.flip()
        core.wait(0.001)

    if rt_ms is None:
        timeout = 1

    # ③ Feedback (according to phase branch)
    if phase == "practice":
        if timeout:
            t, c = "Timeout", "red"
        elif correct:
            t, c = "Correct", "green"
        else:
            t, c = "Error", "red"
        show_text(t, wait_key=False, font_size=FEEDBACK_FONT_SIZE, color=c)
        safe_wait(FEEDBACK_S)

    # ④ ITI
    iti_ms = rng.randint(int(ITI_MIN_S * 1000), int(ITI_MAX_S * 1000))
    win.flip()
    safe_wait(iti_ms / 1000.0)

    # ⑤ Data writing - all fields at one time addData + nextEntry
    for kk in SUBJECT_COLS:
        thisExp.addData(kk, info.get(kk, ""))
    thisExp.addData("subject_id", info["Participant ID"])
    thisExp.addData("phase", phase)
    thisExp.addData("block", block_index)
    thisExp.addData("trial", trial_index)
    thisExp.addData("condition", row["condition"])
    thisExp.addData("stimulus", row["stimulus"])
    thisExp.addData("correct_response", row["correct_key"])
    thisExp.addData("response", resp_key)
    thisExp.addData("rt", rt_ms)
    thisExp.addData("accuracy", correct)
    thisExp.addData("timeout", timeout)
    thisExp.addData("iti_ms_actual", iti_ms)                # Rule 16: Runtime value
    thisExp.addData("timestamp", onset_ts)
    thisExp.nextEntry()                                      # Rule 10: Write disk immediately
    thisExp.saveAsWideText(filename_prefix + ".csv", delim=",")
    with open(filename_prefix + ".csv", "ab") as checkpoint_file:
        checkpoint_file.flush()
        os.fsync(checkpoint_file.fileno())                    # Rule 10: Durable checkpoint

# ============================================================
# 9. Main process
# ============================================================
try:
    # --- Instructions ---
    show_text(TXT_START, True)

    # --- Conditional loading + verification ---
    rows = load_rows_or_exit(CONDITION_XLSX, ["stimulus", "correct_key"])

    # --- Formal experiment ---
    trials = pseudorandomize(rows)
    for i, row in enumerate(trials, start=1):
        run_one_trial(row, trial_index=i, block_index=1, phase="main")

    # --- End ---
    show_text(TXT_END, True, font_size=FEEDBACK_FONT_SIZE)

except SystemExit:
    exit_without_saving()

except Exception as e:
    show_text(f"Program exception: {repr(e)}", True)
    exit_without_saving()

finally:
    if not aborted_by_user:
        thisExp.saveAsWideText(filename_prefix + ".csv")     # Rule 11: Stage save
        thisExp.saveAsPickle(filename_prefix)
    try:
        thisExp.abort()
    except:
        pass
    try:
        win.close()
    except:
        pass
    core.quit()
```

**How ​​to use**: Copy this skeleton → Modify configuration area parameters → Replace text constants → Replace stimulus/response/feedback logic within `run_one_trial` → Add multi-stage/multi-block loop → Do not change API mode (PTB keyboard, `key.rt`, `callOnFlip`, `try/except/finally`, `nextEntry`).

## 2. Stimulus Rules

### 2.1 Preloading

Preload all stimuli before the trial loop. Disk I/O during a trial causes frame drops:

```python
stimuli = {}
for cond in conditions:
    path = os.path.join('stimuli', cond['filename'])
    if not os.path.exists(path):
        raise FileNotFoundError(f"Missing: {path}")
    stimuli[cond['filename']] = visual.ImageStim(win, image=path)
```

- **ImageStim**: Create once per unique image, use `.setImage()` to swap
- **TextStim / TextBox2**: Create once, use `.setText()` / `.text =` to update
- **Sound**: Create `sound.Sound()` objects before the trial loop

### 2.2 TextBox2 vs TextStim

| Properties | TextBox2 | TextStim |
|------|-----------------|-----------------|
| Main uses | Multi-line layout, editable text, complex alignment | Simple/traditional text stimulation |
| Fonts and non-monospaced text | Supported; target font needs to be verified | Supported; target font needs to be verified |
| Typesetting/border properties | Subject to the public API of pinned runtime | Subject to the public API of pinned runtime |
| Dynamic color/transparency | Use this version to expose properties and do visual testing | Use this version to expose properties and do visual testing; do not write to private `_need*` state |

Select components based on the config's layout, editing, and compatibility needs. Do not treat implementation details private to one version as cross-version build rules.

### 2.3 Chinese Text Rendering

Always specify a CJK-capable font — the default font may not include CJK glyphs.

**Font toggle block** (generate this at the top of the parameters section in every script that uses Chinese text):

```python
import platform, os

# ============================================================
# FONT CONFIGURATION — edit this block if Chinese text displays as □□□
# ============================================================
FONT_AUTO_DETECT = True      # True = auto-detect by OS; False = use MANUAL_FONT_PATH
MANUAL_FONT_PATH = None      # Set to your font path, e.g. '/System/Library/Fonts/PingFang.ttc'
# ============================================================

def get_cjk_font():
    """Resolve CJK font path. Returns None if no valid font found."""
    if not FONT_AUTO_DETECT and MANUAL_FONT_PATH:
        if os.path.exists(MANUAL_FONT_PATH):
            return MANUAL_FONT_PATH
        else:
            print(f"WARNING: MANUAL_FONT_PATH not found: {MANUAL_FONT_PATH}")

    _system = platform.system()
    if _system == 'Darwin':
        _FONTS = ['/System/Library/Fonts/PingFang.ttc',
                   '/System/Library/Fonts/STHeiti Light.ttc']
    elif _system == 'Windows':
        _FONTS = ['C:/Windows/Fonts/msyh.ttc', 'C:/Windows/Fonts/simhei.ttf']
    elif _system == 'Linux':
        _FONTS = ['/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
                  '/usr/share/fonts/truetype/wqy/wqy-microhei.ttc']
    else:
        _FONTS = []

    for f in _FONTS:
        if os.path.exists(f):
            return f

    print("WARNING: No CJK font found. Chinese text may display as □□□.")
    print("Set FONT_AUTO_DETECT=False and MANUAL_FONT_PATH to a valid .ttc/.ttf path.")
    return None

_CJK_FONT = get_cjk_font()

# Usage:
text_stim = visual.TextStim(win, text='Hello', font=_CJK_FONT,
                            fontFiles=[_CJK_FONT] if _CJK_FONT else None,
                            height=40, color='white', languageStyle='LTR')
```

Key pitfalls:
- Builder's default `Arial` renders Chinese on most but NOT all systems
- `languageStyle='LTR'` prevents misdetecting Chinese as RTL
- Always test Chinese rendering on the exact machine that will run subjects
- The `FONT_AUTO_DETECT` / `MANUAL_FONT_PATH` switches sit at the top of the parameters section — users edit them directly without touching logic code

## 3. Audio / Sound API

### 3.1 Backend Selection

| Backend | Scheduling capability | Evidence requirement |
|---------|-----------------------|----------------------|
| **PTB** (`backend_ptb`) | Supports scheduled playback APIs such as `play(when=)` in compatible pinned environments | Measure onset/synchrony with the actual device, driver, buffer, and load |
| **sounddevice** | Host/device dependent streaming | Verify supported API/version and measure the target setup |
| **pyo** | Host/device dependent | Verify installation compatibility and measure the target setup |
| **pygame** | Basic fallback playback; not the supported path for claim-relevant onset timing | Do not use for timing claims without independent calibration evidence |

**Current supported paths**: For experiments that require verifiable audio start times, the PTB audio backend is used and tested by default, while recording the actual device/driver/buffer settings. If other backends or external audio hardware are used, equivalent evidence of timestamps, calibration, and target measurements must be given; accuracy claims cannot be made based on the backend name alone.

### 3.2 Sound Preloading

```python
from psychopy import sound

# PTB backend — preBuffer=-1 loads entire file into memory
sound_stim = sound.Sound('stimuli/beep.wav', preBuffer=-1)

# Multiple sounds — preload all before trial loop
sounds = {
    'go': sound.Sound('stimuli/go.wav'),
    'stop': sound.Sound('stimuli/stop.wav'),
    'feedback_correct': sound.Sound('stimuli/correct.wav'),
}
```

### 3.3 Playback with Prescheduling

```python
# Sync audio with visual stimulus onset
stim.draw()
nextFlip = win.getFutureFlipTime(clock='ptb')  # PTB timebase
sound_stim.play(when=nextFlip)                 # scheduled request; validate measured onset/synchrony
win.flip()

# Or via callOnFlip
stim.draw()
win.callOnFlip(sound_stim.play)
win.flip()
```

### 3.4 Speaker / Latency Class

```python
# Only for pinned runtimes whose verified API exposes SpeakerDevice this way.
from psychopy.hardware.speaker import SpeakerDevice

speaker = SpeakerDevice(name=CONFIRMED_DEVICE, latencyClass=CONFIRMED_LATENCY_CLASS)
sound_stim = sound.Sound('stim.wav', speaker=speaker, preBuffer=-1)
```

`latencyClass` changes sharing/exclusivity and failure behavior; it is not a measured latency value. Confirm the class and device against the exact runtime documentation, keep sample-rate/resampling decisions explicit, and record device profile/dropout/timing evidence when audio onset matters. Do not assume a default across PsychoPy releases.

## 4. Response Collection

Edge cases to handle:
- **Anticipatory responses**: apply the prespecified task/device-derived rule — retain raw RT and flag it for analysis rather than silently deleting it
- **Multiple keys**: `kb.getKeys()` returns all pressed keys — `keys[0]` is the first
- **No-go trials**: `response is None` on no-go = correct rejection (accuracy=1); on go = miss (accuracy=0)
- **Key release**: Only available with `waitRelease=True` — `.duration` attribute

## 5. Data Management

### 5.1 ExperimentHandler — Top-level container

```python
from psychopy import data

exp = data.ExperimentHandler(
    name=expName,
    version='1.0',
    extraInfo={'participant': expInfo['participant'], 'session': expInfo['session']},
    runtimeInfo=None,
    dataFileName=f'data/sub-{expInfo["participant"]}_{expName}_{expInfo["date"]}',
    savePickle=True,
    saveWideText=True,
)
```

**Key Rules**:
- `addLoop(handler)` **must be called before the loop is run** — all loops cannot be added in advance at the beginning of the experiment
- `nextEntry()` marks the end of the trial - the Builder code handles this automatically, the custom script needs to be called explicitly
- The `atexit` callback will try to save existing data when the experiment crashes
- Call `exp.abort()` to prevent data saving (for debug runs)

### 5.2 TrialHandler — Conditional loop

```python
trials = data.TrialHandler(
    trialList=data.importConditions('conditions.xlsx'),
    nReps=5,
    method='random',       # 'random' | 'sequential' | 'fullRandom'
    extraInfo={'phase': 'main'},
    seed=RANDOM_SEED,      # Press config.seed_scope to parse from task version, subject and session
    name='trials'
)

exp.addLoop(trials)  # must be called before the loop

for thisTrial in trials:
    # ... present trial ...
    trials.addData('rt', rt)
    # nextEntry automatically called
```

**Randomization method**:
| Method | Behavior |
|--------|------|
| `'random'` | shuffle within each repeat, all conditions appear once |
| `'sequential'` | Presented in list order |
| `'fullRandom'` | Completely random across repeat (possibly the same condition multiple times in a row) |

### 5.3 Column Priorities

When adding data, you can set the priority to control the output column order:

```python
from psychopy.constants import priority

exp.addData('rt', rt, priority=priority.HIGH)     # in front
exp.addData('debug_var', val, priority=priority.EXCLUDE)  # ranked last
```

| Priority | Value | Usage |
|----------|-------|-------|
| CRITICAL | 30 | Routine start times (reserved) |
| HIGH | 20 | RT, accuracy — Analyze core variables |
| MEDIUM | 10 | Condition Information |
| LOW | 0 | Auxiliary information |
| EXCLUDE | -10 | Debug variable, not used for analysis |

### 5.4 Data Output Formats

| Format | Method | Notes |
|--------|--------|-------|
| CSV/TSV (wide) | `exp.saveAsWideText('data.csv', delim=',')` | One row per trial, "wide" means all variables are stored as columns |
| Pickle | `exp.saveAsPickle('data.psydat')` | Complete object, can be loaded and analyzed by Python later |

### 5.5 Incremental Save (try/finally)

```python
data_file = open(f'data/sub-{sub_id}_{task}_{date}.csv', 'w', newline='')
writer = csv.DictWriter(data_file, fieldnames=columns)
writer.writeheader()

try:
    run_experiment()
finally:
    data_file.flush()
    data_file.close()
    win.close()
```

- Per trial: `writer.writerow()` + `data_file.flush()`
- Filename convention: `data/sub-{subject_id}_{task_name}_{date}.csv`

## 6. Participant Info Dialog

```python
from psychopy import gui

expInfo = {'participant': '', 'session': '001'}
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)

if not dlg.OK:
    core.quit()  # user pressed cancel

expInfo['date'] = data.getDateStr()
expInfo['expName'] = expName
```

**Advanced usage**:
```python
# drop-down menu — value is list
expInfo = {
    'participant': '',
    'gender': ['male', 'female', 'other'],  # list = dropdown
    'age': '',
    'handedness': ['right', 'left'],
}

# fixed parameter — non-editable field
dlg = gui.DlgFromDict(
    dictionary=expInfo,
    title=expName,
    fixed=['expVersion'],   # is displayed but cannot be edited
    order=['participant', 'age', 'gender'],
    tip={'participant': 'Unique subject ID'}
)
```

## 7. Hardware Integration

### 7.1 EEG / Parallel Port Triggers

Send triggers via `callOnFlip` — **not before** `flip()`:

```python
from psychopy import parallel

port = parallel.ParallelPort(address=0x378)

TRIGGER_PULSE_SECONDS = CONFIRMED_DEVICE_PULSE_WIDTH
trigger_clock = core.Clock()
trigger_active = False

def start_trigger(code):
    global trigger_active
    port.setData(code)
    trigger_clock.reset()
    trigger_active = True

# CORRECT: trigger synchronized to stimulus onset
stim.draw()
win.callOnFlip(start_trigger, trigger_code)
win.flip()

# In the active frame/event loop; cleanup must also force port.setData(0).
if trigger_active and trigger_clock.getTime() >= TRIGGER_PULSE_SECONDS:
    port.setData(0)
    trigger_active = False

# BAD: trigger sent before flip — it can precede the measured visual onset by a display frame/phase
port.setData(trigger_code)
win.flip()
```

### 7.2 Audio-Visual Sync with Triggers

```python
# Sync sound + visual + parallel port trigger
stim.draw()
nextFlip = win.getFutureFlipTime(clock='ptb')
win.callOnFlip(start_trigger, trigger_code)
sound_stim.play(when=nextFlip)  # audio at same time as new frame
win.flip()
```

Backend scheduling is a request, not proof of physical synchrony. Measure audio, visual, and trigger onsets on the actual collection hardware and record the observed distribution.

## 8. Emergency Quit

```python
def check_quit(data_file, win):
    if 'escape' in event.getKeys():
        data_file.flush()
        data_file.close()
        win.close()
        core.quit()
```

Escape is checked inside the timed response loop AND between trials/ITIs. In the response loop, `'escape'` must be in the `keyList` passed to `kb.getKeys()`.

## 9. Debrief / Results Feedback Stage

```python
# At end of experiment, after trial loop:
debrief_text = f"""
Experimental results:
Your average reaction time: {np.mean(rts):.0f} ms
Correct rate: {np.mean(corrects)*100:.1f}%
Thank you for participating!
"""
debrief_stim = visual.TextStim(win, text=debrief_text, color='black')
debrief_stim.draw()
win.flip()
# Wait for any key press
kb = keyboard.Keyboard()
kb.waitKeys()  # Blocking and waiting here is OK (the experiment has ended)
```

## 10. Anti-Patterns

| Anti-pattern | Why it's wrong | Correct approach |
|--------------|---------------|-----------------|
| `event.getKeys(keyList=..., maxWait=...)` | Blocks event loop, Escape unresponsive | `keyboard.Keyboard(backend='ptb')` in `CountdownTimer` loop |
| `event.waitKeys(keyList=..., maxWait=...)` | Same blocking issue | `kb.getKeys()` in loop with `CountdownTimer` |
| `kb.waitKeys(maxWait=...)` during a phase that needs refresh/triggers/continuous abort handling | Prevents concurrent phase work | `kb.getKeys()` in a non-blocking loop; allow `waitKeys()` only for justified static, non-critical screens |
| `time.sleep(0.5)` | Blocks event loop | `CountdownTimer` loop or flip-based timing |
| `core.wait(duration)` in an interactive/timed phase | Blocks concurrent event handling | Timed loop with escape check; use a device-required pulse only with an explicit measured contract |
| Loading images inside trial loop | Frame drops from disk I/O | Preload at startup, `.setImage()` per trial |
| `ImageStim` per trial without preloading | Re-allocation causes jitter | Create once, `.setImage()` per trial |
| RT measured with `time.time()` or `clock.getTime()` | Not sync'd to screen refresh, ignores USB HID timestamp | `key.rt` (async USB HID timestamp) |
| `kb.clock.getTime()` for RT | Returns code-execution time, not key-press time | `key.rt` |
| `kb.getKeys(waitRelease=True)` when the scored event is key-down | Filters for released keys and can delay event delivery | `waitRelease=False`; use `True` only when release/duration is the intended event |
| Data saved only at end | Crash = zero data | Save + flush per trial, `try/finally` |
| No escape key handler | Can't quit if something goes wrong | Escape in timed loop + between-trial check |
| Default font for Chinese text | □□□ tofu characters | Explicit CJK font path via FONT_CONFIG |
| EEG trigger before `win.flip()` | Trigger can precede the measured visual onset by a display frame/phase | `win.callOnFlip(port.setData, code)` |
| `exec()` / `globals()` condition injection | Namespace mutation, unsafe column collisions, weak provenance | Explicit validated `trial["field"]` access |
| Constructing/loading sound inside a timed trial or leaving backend/device implicit for a timing claim | I/O and backend behavior are unverified | Prepare sounds before trials, pin backend/device/buffer settings, schedule where supported, and measure the target setup |
| Adding loops to ExperimentHandler at start | Loop tracking breaks | `exp.addLoop()` right before loop runs |
| Implicit keyboard backend in a timing-critical task | Timing behavior and fallback are undocumented | Choose an available backend explicitly and verify it on the target machine |
| `sound.Sound()` without explicit backend | May fall back to high-latency pygame | Use PTB backend on 64-bit Python |

## 11. Environment Safety (Anti-Cheating)

```python
# Disable text selection and right-click (if using PsychoPy in windowed mode)
# For PsychoPy fullscreen, these are typically not needed

# Block specific keys that could interrupt the experiment
from psychopy.hardware import keyboard
disallowed_keys = ['escape', 'f5', 'f12']
```

## 12. Cross-platform Notes

- **macOS**: `PingFang.ttc`. PsychoPy via standalone `.dmg` or `pip`. PTB 3.0.20+ native ARM; 3.0.19 via Rosetta.
- **Windows**: `pyglet` 1.4.x preferred. Fonts: `msyh.ttc` / `simhei.ttf`. Button boxes may need Zadig. PsychHID slightly better than ioHub.
- **Linux**: Fonts: Noto CJK. `sound.backend_ptb` for low-latency audio. May need `libusb`. PsychHID significantly better than ioHub on macOS.

## 13. API Reference Index

| Functions to be implemented | API / Class | Key parameters |
|---------------|---------|---------|
| Create window | `visual.Window()` | `size`, `fullscr`, `color`, `units`, `screen` |
| Frame timing | `win.getFutureFlipTime(clock=None/routineTimer)` | `clock` parameter determines the time base |
| Frame synchronization callback | `win.callOnFlip(callback, *args)` | callback + parameters |
| Record flip time | `win.timeOnFlip(obj, 'attr')` | Object + attribute name |
| RT timing keyboard | `keyboard.Keyboard(backend='ptb')` | `backend` select precision |
| Get keys | `kb.getKeys(keyList, waitRelease=False, clear=False)` | Non-blocking polling |
| Clear keys | `kb.clearEvents(eventType='keyboard')` | Clear before flip |
| RT timestamp | `key.rt` (`KeyPress` object property) | Counted from `kb.clock.reset()` |
| Key name | `key.name` | String, such as `'f'`, `'left'` |
| Key duration | `key.duration` | Requires `waitRelease=True` |
| Countdown | `core.CountdownTimer(seconds)` | Response deadline |
| Text display (recommended) | `visual.TextBox2()` | `text`, `font`, `letterHeight`, `color`, `alignment` |
| Text display (classic) | `visual.TextStim()` | `text`, `font`, `height`, `color` |
| Image display | `visual.ImageStim()` | `image`, `pos`, `size` |
| Audio playback | `sound.Sound()` | Pre-create before trials; PTB `play(when=)` where supported; record backend/device/buffer and measured onset |
| Conditional loop | `data.TrialHandler()` | `trialList`, `nReps`, `method`, `seed` |
| Conditional import | `data.importConditions('file.xlsx')` | Return conditions dict list |
| Data container | `data.ExperimentHandler()` | `name`, `extraInfo`, `dataFileName` |
| Add loop data | `exp.addLoop(trials)` | Call before loop |
| Add trial data | `trials.addData(name, value)` | Automatically forward to ExperimentHandler |
| Mark trial end | `exp.nextEntry()` | Custom code needs to be called explicitly |
| Save as CSV | `exp.saveAsWideText('file.csv', delim=',')` | Called at the end of the experiment |
| Save as Pickle | `exp.saveAsPickle('file.psydat')` | Complete object |
| Participant dialog | `gui.DlgFromDict(dictionary=expInfo, title=expName)` | Use list value for drop-down menu |
| Date string | `data.getDateStr()` | Format `YYYY_Mon_DD_HHMM` |
| EEG parallel port trigger | `parallel.ParallelPort(address=0x378)` | `callOnFlip(port.setData, code)` |
| Safe exit | `core.quit()` | Called during Escape processing |
