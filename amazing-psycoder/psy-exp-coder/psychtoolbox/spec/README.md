# Psychtoolbox Implementation Guide

> **Status**: Layer 1 — API specification, anti-pattern table, enforcement patterns. Builds must be checked against config-fixed MATLAB/Octave, Psychtoolbox, and target OS/hardware versions.
> **Last updated**: 2026-07-25 — 17-rule quality template applied (8-section PTB adaptation)

## Critical Rules (Read First — errors here invalidate data)

| Rule | Why Critical |
|------|-------------|
| **RT from `VBLTimestamp`, never `GetSecs`** | Wrong RT source = all RT data invalid. `Screen('Flip')` return value is the GPU flip time |
| **`fclose` after every trial** | Missing = buffered data lost on crash. `fopen('a')` + `fprintf` + `fclose` per trial |
| **`KbQueueFlush` at start of each trial** | Missing = previous trial keypress contaminates current RT |
| **`cleanup()` in BOTH `try` AND `catch`** | MATLAB has no `finally`. One missed branch = screen locked, cursor hidden |
| **`global` declarations in both script AND functions** | MATLAB requires `global x` in main script AND each function that uses it |
| **Preload stimuli outside trial loop** | `imread`/`MakeTexture` inside loop = frame drops |

Full anti-patterns table: [§11](#11-anti-patterns-quick-reference). Full 17-rule template: [§0](#0-code-structure-requirements-17-rule-quality-template-ptb-adaptation).

## Version Assumption

Do not assume a default PTB release, host runtime, license state, or backwards-compatibility range. Confirm the exact target versions and current official installation/licensing requirements, pin them in the runtime contract, and run synchronization tests on the collection machine.

## 0. Code Structure Requirements (17-Rule Quality Template — PTB Adaptation)

Every generated PTB experiment must follow these rules. The template is identical to the PsychoPy version except where MATLAB/PTB API differences require adaptation (marked **[PTB]**).

### 0.1 File-Level Structure (Rules 1–2)

```matlab
% {filename}.m
% ---------------------------------------------------------------
% Integrated process:
%   {stage_1} → {stage_2} → {stage_3}
%
% Data output:
%   {stage} -> sub-{id}_{stage}_{date}.csv
%
% Design summary:
%   Each block: {trial_count} trial
%   Formal stage: {block_count} block × {trials_per_block} = {total} trial
%
% Key modifications of the current version:
%   1) {change_1}
%   2) {change_2}
% ---------------------------------------------------------------
```

### 0.2 Section Order (Rules 1, 3, 5 — PTB: 8 sections)

```
Section 1: Parameter configuration area (path/screen/font/timing/key/condition/random seed)
            contains text constants — all instruction/feedback text is defined here as string variables ← Rule 3+5
Section 2: Screen initialization (PsychImaging + BlendFunction + ifi + Priority)
Section 3: Stimulus preloading (MakeTexture / CreateProceduralGabor — outside the loop) ← Rule 13
Section 4: KbQueue initialization (Create + Start — previous loop) ← [PTB]
Section 5: Data file initialization (fopen + fprintf header + fclose) ← [PTB]
Section 6: Tool functions (cleanup / saveTrial / checkEscape / safeWait / pseudo-random engine)
Section 7: Main loop (try → trial loop → cleanup → catch → cleanup) ← Rule 8 [PTB]
Section 8: Local functions (cleanup / saveTrial — must be at the end of the script file) ← [PTB]
```

**[PTB]** MATLAB script files require that all local functions be defined at the end of the file. It is not allowed to insert function definitions in the middle of script.

### 0.3 Variable Naming (Rule 4 — PTB: camelCase)

```
<stagePrefix><Category><Meaning>

stagePrefix = kp | nv | prac | main | (customized by experimental stage)
Category = Txt (instruction text) | Key (key) | Sec (second-level timing)
            | Dir (folder path) | Fb (feedback) | Xlsx (condition table file name)
            | MaxConsec (pseudo-random constraint) | n (count)

Positive example: kpItiSec, nvFeedTimeout, nvMaxConsecEllipse
Counterexample: iti, feedback_timeout, max_ellipse
```

**[PTB]** PTB convention uses camelCase. Python's UPPER_SNAKE does not apply here. Cross-platform constants (`KEY_QUIT`, `BASE_DIR`) retain UPPER_SNAKE because they are runtime environment constants rather than experimental parameters.

### 0.4 Pseudorandom Constraints (Rule 6 — PTB: Shuffle + while)

```matlab
% ---------- Pseudo-random constraint ----------
nvMaxConsecEllipse    = 2;      % One constant per constraint
nvMaxConsecPrimeWidth = 3;
nvMaxPseudorandTries  = 5000;   % Hard upper limit to prevent infinite loops

function ok = canAppendTrial(seq, candidate)
    % Check whether candidate added to the end of seq violates any constraints
end

function ordered = pseudorandomize(rawTrials)
    for attempt = 1:nvMaxPseudorandTries
        remaining = rawTrials(randperm(length(rawTrials)));
        seq = {};
        while ~isempty(remaining)
            validIdx = [];
            for i = 1:length(remaining)
                if canAppendTrial(seq, remaining{i})
                    validIdx(end+1) = i;
                end
            end
            if isempty(validIdx), break; end
            pick = validIdx(randi(length(validIdx)));
            seq{end+1} = remaining{pick};
            remaining(pick) = [];
        end
        if length(seq) == length(rawTrials)
            ordered = seq; return;
        end
    end
    error('Unable to generate a trial sequence that satisfies the constraints.');  % Failure must exit
end
```

**[PTB]** MATLAB replaces Python's `random.shuffle()` with `Shuffle()` (Psychtoolbox) or `randperm()`. `error()` replaces Python's `exit_without_saving()`.

### 0.5 Exit Safety (Rule 7 — PTB: cleanup + error)

```matlab
function cleanup()
    KbQueueStop; KbQueueRelease;
    fclose('all');
    sca; Priority(0); ShowCursor;
end

% Exit point: The user presses Escape → cleanup(); error('User manually exits');s manually');
%         File missing → cleanup(); error('Missing: %s', path);
%         Verification failed → cleanup(); error('Condition table verification failed');table verification failed');
```

**[PTB]** MATLAB None `core.quit()` — `error()` will jump to the `catch` block. `sca` (= `Screen('CloseAll')`) Restore display. `cleanup()` must be called in both `try` and `catch` branches.

### 0.6 Condition Validation (Rule 9)

```matlab
validPrimeNames  = {'narrow', 'broad'};
validShapes      = {'circle', 'ellipse'};

% Verify line by line
for i = 1:length(primeRows)
    if ~ismember(lower(primeRows{i}.prime), validPrimeNames)
        error('prime table row %d illegal prime: %s', i, primeRows{i}.prime);
    end
end

% Material file pre-check
for i = 1:length(neededFiles)
    if ~isfile(neededFiles{i})
        error('Material missing: %s', neededFiles{i});
    end
end
```

### 0.7 Trial Function Contract (Rule 12 — PTB: KbQueue timing)

```matlab
function [respKey, rtMs, correct, timeout] = runOneTrial(row, trialIdx, blockIdx, phase)
    % ① Stimulus presentation (VBLTimestamp = RT starting point)
    % ② Response collection (KbQueueCheck loop + deadline + escape)
    % ③ Feedback presentation (according to phase branch)
    % ④ ITI (frame loop + escape check)
    % ⑤ Data writing (saveTrial writes to disk immediately)
end
```

**[PTB]** RT starting point must be the `VBLTimestamp` returned by `Screen('Flip')`, not `GetSecs`. RT formula: `rtMs = (firstPress - stimOnset) * 1000`.

### 0.8 Per-Trial Data Write (Rules 10, 14–16 — PTB: saveTrial)

```matlab
function saveTrial(path, subjectID, block, trial, condition, stimulus, ...
        correctResp, response, rtMs, accuracy, onsetTs, seed)
    fid = fopen(path, 'a');  % 'a' = append mode — crash-safe
    if fid < 0, error('Unable to open data file: %s', path); end
    if isnan(rtMs), rtText = ''; else, rtText = sprintf('%.0f', rtMs); end  % Rule 14: integer ms
    fprintf(fid, '%s,%d,%d,%s,%s,%s,%s,%s,%d,%s,%d\n', ...
        subjectID, block, trial, condition, stimulus, correctResp, ...
        response, rtText, accuracy, onsetTs, seed);                         % Rule 15: accuracy is 0/1 int
    fclose(fid);  % fclose every trial — Durable checkpoint Rule 10
end
```

**[PTB]** PTB has no ExperimentHandler. Use `fopen(..., 'a')` + `fprintf` + `fclose` to achieve equivalent incremental saving. `fclose` must be called after each trial to ensure crashes are recoverable.

### 0.9 Main Flow (Rule 8 — PTB: try/catch)

```matlab
try
    % --- Instructions ---
    showText(txtStart);

    % --- Conditional loading + verification ---
    rows = loadConditions(conditionXlsx);

    % --- Formal experiment ---
    for trial = 1:nTrials
        KbQueueFlush([], 2);
        runOneTrial(rows{trialOrder(trial)}, trial, 1, 'main');
    end

    % --- End ---
    showText(txtEnd);
    cleanup();
    fprintf('Data saved to: %s\\n', dataFile);

catch ME
    cleanup();
    rethrow(ME);
end
```

**[PTB]** MATLAB None `finally`. `cleanup()` is called explicitly in both branches. The effect is equivalent to Python's `try/except/finally`. `rethrow(ME)` retains the original error message.

### 0.10 Comment Rules (Rule 17)

```matlab
% Positive example — explaining intent
stimOnset = VBLTimestamp;                    % RT starting point: GPU page turning time
% Pre-blank removed, only ITI retained ← Explain design decisions
itiSec = itiMinSec + rand * (itiMaxSec - itiMinSec);  ← Avoid an obvious comment such as "% Generate random numbers".

% Counterexample - Don't do it
vbl = Screen('Flip', window);  % Perform screen flip ← The code is self-explanatory
ifi = Screen('GetFlipInterval', window); % Get frame interval ← Nonsense
```

## 1. Canonical Safety/Timing Baseline (contract overview - see §1.1 for complete runnable code)

New PTB projects should retain the sync tests, explicit seed, protected cleanup, actual flip/response timestamps, and delta save contracts from this baseline; component and loop structure is determined by config. This section presents API contract points; the complete copy-and-paste skeleton is in [§1.1] (#11-canonical-code-skeleton contract baseline for the new project).

```matlab
% 1. Settings
PsychDefaultSetup(2);                                  % Default settings + unified key name
Screen('Preference', 'SkipSyncTests', 0);              % The production environment must run synchronous tests
KbName('UnifyKeyNames');                               % Unify key names across platforms
randomSeed = resolvedSeed;                             % The deployment layer parses and records according to config.seed_scope
rng(randomSeed, 'twister');                            % Reproducible randomization

try
    % 2. Open the window
    screens = Screen('Screens');
    screenNumber = max(screens);
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    grey = white / 2;
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    ifi = Screen('GetFlipInterval', window);
    [centerX, centerY] = RectCenter(windowRect);
    HideCursor(window);
    Priority(MaxPriority(window));
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);

    % 3. Preload stimulus (before loop)
    % ... Screen('MakeTexture') / CreateProceduralGabor / PsychPortAudio('CreateBuffer') ...

    % 4. Keyboard queue initialization
    KbQueueCreate();         % Create a queue (keyList can be specified in the parameter)
    KbQueueStart();          % Start recording

    % 5. Experimental cycle
    for trial = 1:nTrials
        KbQueueFlush();      % Clear old events at the beginning of each trial

        % Draw + Flip + RT Collect
        % ...

        % Data saving: append + fclose after trial ends to ensure crash recovery
        % saveTrial(dataPath, trialData, randomSeed);
    end

    % 6. Keyboard queue release
    KbQueueStop();
    KbQueueRelease();

    % 7. Data file close
    fclose(dataFile);

    % 8. Cleanup
    sca;
    Priority(0);
    ShowCursor;

catch ME
    sca;
    Priority(0);
    ShowCursor;
    rethrow(ME);
end
```

### 1.1 Canonical Code Skeleton (contract baseline for new projects)

The following skeleton shows the supported API contracts. Adjust the structure according to the task device/event model; deviations must maintain equivalent synchronization, data and cleanup guarantees and accept target machine testing, `modify`/`debug` does not need to rewrite irrelevant architecture:

```matlab
% {filename}.m
% ---------------------------------------------------------------
% Integrated process:
%   {stage_1} → {stage_2} → {stage_3}
%
% Data output:
%   {stage} -> sub-{id}_{stage}_{date}.csv
%
% Design summary:
%   Each block: {n} trial
%   Formal stage: {m} block × {t} = {total} trial
%
% Key modifications of the current version:
%   1) {change_1}
%   2) {change_2}
% ---------------------------------------------------------------
close all; clear; sca;

% ============================================================
% 1. Parameter configuration area (all adjustable parameters + text constants are concentrated here)
% ============================================================
% Variables in MATLAB script are not automatically visible to local functions.
% Global needs to be declared in both scripts and functions.
% Do not remove these global declarations - otherwise showText/checkEscape/cleanup will read empty variables.
global window textColor fontSize escapeKey;

taskName    = '{experiment_name}';
taskVersion = '1.0.0';
subjectID   = 'test';
baseDataColumns = {'subject_id', 'block', 'trial', 'condition', 'stimulus', ...
    'correct_response', 'response', 'rt', 'accuracy', 'timestamp'};

% ---------- Screen ----------
screenNumber    = max(Screen('Screens'));
backgroundColor = [128 128 128] / 255;  % grey
textColor       = [0 0 0];
fontName        = 'PingFang SC';
fontSize        = 60;

% ---------- Timing (seconds) ----------
fixationSec    = 0.5;
stimulusSec    = 1.0;
feedbackSec    = 0.5;
respDeadlineSec = 2.0;
itiMinSec      = 0.6;
itiMaxSec      = 0.9;

% ---------- Key ----------
KbName('UnifyKeyNames');
keyLeft   = KbName('LeftArrow');
keyRight  = KbName('RightArrow');
escapeKey = KbName('ESCAPE');
responseKeys = [keyLeft, keyRight];

% ---------- Text constant ----------
txtStart = 'Welcome to participate in the experiment. \\n\\nPress any key to start.';
txtEnd   = 'The experiment is over, thank you for participating! \\n\\nPress any key to exit.';

% ---------- Conditions ----------
conditionXlsx = 'conditions.xlsx';
nReps = 10;

% ---------- Pseudo-random constraint ----------
maxConsecSameCondition = 3;
maxPseudorandTries     = 5000;

% ---------- Data ----------
dataDir = fullfile(pwd, 'data');
if ~exist(dataDir, 'dir')
    [ok, msg] = mkdir(dataDir);
    if ~ok
        error('Unable to create data folder %s: %s. Please check disk space and permissions.', dataDir, msg);
    end
end
runTs = datestr(now, 'yyyymmdd_HHMMSSFFF');
dataFile = fullfile(dataDir, sprintf('sub-%s_%s_%s.csv', subjectID, taskName, runTs));

% ============================================================
% 2. Screen initialization
% ============================================================
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 0);

% Seed (FNV-1a - Reproducible Randomization)
seedMat = unicode2native(sprintf('%s|%s', taskVersion, subjectID), 'UTF-8');
seedHash = uint32(2166136261);
for b = seedMat
    seedHash = bitxor(seedHash, uint32(b));
    seedHash = uint32(mod(uint64(seedHash) * uint64(16777619), uint64(4294967296)));
end
randomSeed = double(seedHash);
rng(randomSeed, 'twister');

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, backgroundColor, [], 32, 2);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('TextFont', window, fontName);
Screen('TextSize', window, fontSize);

ifi = Screen('GetFlipInterval', window);
waitframes = 1;
[xCenter, yCenter] = RectCenter(windowRect);

Priority(MaxPriority(window));
HideCursor;

% ============================================================
% 3. Stimulus preloading (outside the loop)
% ============================================================
fixCross = [-20 20 0 0; 0 0 -20 20];  % Fixation cross

% ============================================================
% 4. KbQueue initialization (Create + Start before loop)
% ============================================================
KbQueueCreate([], responseKeys);
KbQueueStart;

% ============================================================
% 5. Data file initialization
% ============================================================
fid = fopen(dataFile, 'w');
fprintf(fid, ['subject_id,block,trial,condition,stimulus,correct_response,' ...
              'response,response_status,rt,accuracy,timestamp,rng_seed\n']);
fclose(fid);

% ============================================================
% 6. Tool function (declared in Section 8, here is the call point comment)
%    cleanup() — KbQueue release + sca + Priority recovery
%    saveTrial() — fopen('a') + fprintf + fclose incremental write
%    showText() — Instruction/feedback text display
%    checkEscape() — escape detection per frame
% ============================================================

% ============================================================
% 7. Main loop
% ============================================================
% ⚠️ MATLAB None finally. cleanup() must be called in both try and catch branches.
% OpenWindow is placed inside try - if window creation fails, catch still performs cleanup.
try
    % --- Instructions ---
    showText(txtStart);

    % --- Conditional loading + verification ---
    rows = loadConditions(conditionXlsx);
    nTrials = size(rows, 1) * nReps;
    trialOrder = Shuffle(repelem(1:size(rows, 1), nReps));

    % --- Formal experiment ---
    vbl = Screen('Flip', window);

    for trial = 1:nTrials
        KbQueueFlush([], 2);  % Clear old events

        row = rows{trialOrder(trial)};

        % === Gaze ===
        fixationFrames = round(fixationSec / ifi);
        for f = 1:fixationFrames
            Screen('DrawLines', window, fixCross, 3, textColor, [xCenter yCenter], 2);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            checkEscape();
        end

        % === Stimulus + Response Window ===
        DrawFormattedText(window, row.stimulus, 'center', 'center', textColor);
        [vbl, ~, ~, ~] = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        stimOnset = vbl;  % Rule 14: VBLTimestamp = RT starting point
        onsetTs = char(datetime('now', 'TimeZone', 'UTC', ...
            'Format', "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"));

        gotResp = false; rtMs = NaN; resp = '';
        deadline = stimOnset + respDeadlineSec;
        while ~gotResp && GetSecs < deadline
            [pressed, firstPress] = KbQueueCheck;
            if pressed
                keyIdx = find(firstPress > 0);
                firstKey = keyIdx(1);
                rtMs = (firstPress(firstKey) - stimOnset) * 1000;  % Rule 14
                if firstKey == keyLeft
                    resp = 'left'; gotResp = true;
                elseif firstKey == keyRight
                    resp = 'right'; gotResp = true;
                end
            end
            checkEscape();
            DrawFormattedText(window, row.stimulus, 'center', 'center', textColor);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end

        % --- Accuracy rate ---
        if ~gotResp
            accuracy = double(strcmp(row.correct_key, 'none'));  % Rule 15: 0/1 int
            status = 'timeout'; resp = '';
        else
            accuracy = double(strcmp(resp, row.correct_key));
            status = 'responded';
        end

        % --- Incremental save (Rule 10: Write to disk immediately) ---
        saveTrial(dataFile, subjectID, 1, trial, row.condition, row.stimulus, ...
            row.correct_key, resp, status, rtMs, accuracy, onsetTs, randomSeed);

        % === ITI (random) ===
        itiSec = itiMinSec + rand * (itiMaxSec - itiMinSec);
        itiFrames = round(itiSec / ifi);
        for f = 1:itiFrames
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            checkEscape();
        end
    end

    % --- End ---
    showText(txtEnd);
    cleanup();
    fprintf('Data saved to: %s\\n', dataFile);

catch ME
    cleanup();
    rethrow(ME);
end

% ============================================================
% 8. Local function (MATLAB script requires the function to be defined at the end of the file)
% ============================================================

function showText(text)
    global window textColor fontSize;
    DrawFormattedText(window, double(text), 'center', 'center', textColor);
    Screen('Flip', window);
    KbStrokeWait;
end

function rows = loadConditions(xlsxPath)
    rows = table2struct(readtable(xlsxPath));
    if isempty(rows), error('Condition table is empty: %s', xlsxPath); end
end

function checkEscape()
    global escapeKey;
    [keyDown, ~, keyCode] = KbCheck;
    if keyDown && keyCode(escapeKey)
        cleanup(); error('User exits manually');
    end
end

function saveTrial(path, subjectID, block, trial, condition, stimulus, ...
        correctResp, response, status, rtMs, accuracy, onsetTs, seed)
    fid = fopen(path, 'a');
    if fid < 0, error('Unable to open data file: %s', path); end
    if isnan(rtMs), rtText = ''; else, rtText = sprintf('%.0f', rtMs); end  % Rule 14: integer ms
    fprintf(fid, '%s,%d,%d,%s,%s,%s,%s,%s,%s,%d,%s,%d\n', ...
        subjectID, block, trial, condition, stimulus, correctResp, ...
        response, status, rtText, accuracy, onsetTs, seed);                   % Rule 15: accuracy 0/1 int
    fclose(fid);  % Rule 10: durability checkpoint every trial
end

function cleanup()
    KbQueueStop; KbQueueRelease;
    fclose('all');
    sca; Priority(0); ShowCursor;
end
```

**How to use**: Copy this skeleton → Modify the parameters + text constants in Section 1 → Replace the stimulus/response/feedback logic in Section 7 → Add a multi-stage/multi-block loop. Do not change API modes (KbQueue, VBLTimestamp RT, frame-accurate Flip, try/catch, `saveTrial` incremental write).

## 2. Screen and window settings

> **Full example**: [demo/_raw/getting-started/totally-minimal.md](../demo/_raw/getting-started/totally-minimal.md) — Minimum window settings, [demo/_raw/getting-started/screen-coordinates.md](../demo/_raw/getting-started/screen-coordinates.md) — Coordinate system.

### 2.1 Window opens

```matlab
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 0);                  % Production environment must be 0
[window, windowRect] = PsychImaging('OpenWindow', ...       % Open with PsychImaging
    screenNumber, backgroundColor);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
ifi = Screen('GetFlipInterval', window);                    % Get frame interval
```

### 2.2 `Screen('Flip')` — Frame accurate timing core

**Full signature**:
```matlab
[VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = ...
    Screen('Flip', windowPtr [, when] [, dontclear] [, dontsync] [, multiflip]);
```

**`when` parameter — the most critical timing parameter**:
| value | behavior |
|----|------|
| `0` (default) | Flip on next possible vertical retrace |
| `> 0` | At the first retrace after system time reaches `when` Flip |

**Half-IFI Rule** — The core of PTB frame-accurate timing:

```matlab
vbl = Screen('Flip', window);                            % Initial flip, get vbl timestamp
for frame = 1:nFrames
    % ... draw command ...
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);  % Frame accurate
end
```

**Why subtract 0.5 * ifi**: Submitting the target moment half a frame early reduces the risk of missing the expected retrace cutoff due to scheduling/rounding. This is a common scheduling mode for PTB and is not a punctuality guarantee; you must still check for `Missed`, record the actual flip timestamp, and run synchronization and load tests on the target machine.

**Detailed explanation of return value**:
| Return value | Description |
|--------|------|
| `VBLTimestamp` | Flip Highly accurate estimate of actual time of occurrence — **All timings are subject to this** |
| `StimulusOnsetTime` | Stimulus onset time estimation, part of the backend is the same as VBLTimestamp |
| `FlipTimestamp` | The timestamp at the end of Flip execution |
| `Missed` | Negative = punctuality; positive = dropped frames. Not completely reliable (not accurate under Vulkan/VR backend) |
| `Beampos` | Beam position during measurement, -1 or 0 = not supported |

### 2.3 Fixed duration presentation

```matlab
% renders N ms (converted to frames)
durationSecs = N / 1000;
nFrames = round(durationSecs / ifi);

vbl = Screen('Flip', window);
for f = 1:nFrames
    % Redraw stimulus
    Screen('DrawTexture', window, texture);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
end
```

### 2.4 PTB Key Concepts Quick Check

| Concept | Description |
|------|------|
| `PsychImaging` | Window opening portal, supports HDR/Stereo/Retina/Floating Point Frame Buffer |
| `Screen('Flip')` return value `vbl` | VBL/flip software time reference reported by PTB; physical display onset still requires target hardware measurement |
| `ifi` | Single frame duration (seconds), obtained from `Screen('GetFlipInterval')` |
| `waitframes` | Must be an integer, `waitframes = round(seconds / ifi)` |
| `sca` | Shortcut for `Screen('CloseAll')` - Emergency Cleanup |
| `Priority(MaxPriority(window))` | Increase the MATLAB process priority and reduce frame loss |
| `Screen('DrawingFinished')` | Prompt PTB The current frame drawing is completed and rendering can be started in advance |

## 3. Keyboard response collection

> **Complete example**: [../demo/_raw/getting-started/keyboard-q.md](../demo/_raw/getting-started/keyboard-q.md) — A complete demo of KbQueue creation, polling, and release.

### 3.1 KbQueue life cycle (canonical pattern for timing-critical keyboard tasks)

For time-critical keyboard tasks, this skill's supported canonical path is `KbQueue`. That choice does not prove end-to-end accuracy: device polling, OS, display synchronization, code, and hardware still require target-machine verification. Other input devices/procedures must use their own documented contract rather than being forced into KbQueue.

```matlab
% === Before the experiment starts (once) ===
KbQueueCreate();                            % Create queue
% Optional specified keyList:
% keyList = zeros(1, 256);
% keyList(KbName({'LeftArrow', 'RightArrow', 'ESCAPE'})) = 1;
% KbQueueCreate([], keyList);
KbQueueStart();                             % Start recording

% === At the beginning of each trial ===
KbQueueFlush();                             % Clear all previous events

% === Response collection (within frame loop) ===
[pressed, firstPress] = KbQueueCheck();     % Get the keys since the last Check/Flush
if pressed
    keyCodes = find(firstPress > 0);
    rt = min(firstPress(keyCodes)) - stimOnset;  % seconds
    responseKey = KbName(find(firstPress == min(firstPress(keyCodes))));
end

% === After the experiment ===
KbQueueStop();
KbQueueRelease();
```

**Key rules:**
- `Create`/`Start` is before the trial loop**, `Stop`/`Release` is after the loop**
- **Don't** call Start/Stop inside a trial loop — the queue should run continuously
- **Every trial must be preceded by `KbQueueFlush()`** - to prevent the remaining keys from the previous trial from contaminating the current RT
- `KbQueueCheck` implicit clearing effect - cannot be called twice on the same data
- **Don't** use `KbCheck` for RT (does not provide precise timestamps)

### 3.2 Detailed explanation of KbQueueCheck return value

```matlab
[pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck();
```

| Output | Description |
|------|------|
| `pressed` | Whether any keys were pressed |
| `firstPress` | 1×256 array — First press timestamp (seconds) for each key, 0 = not pressed |
| `firstRelease` | The first release timestamp of each key |
| `lastPress` | The **last** pressed timestamp of each key |
| `lastRelease` | The last release timestamp of each key |

**RT calculation**:
```matlab
if pressed
    keyIdx = find(firstPress > 0);        % Which keys were pressed
    rtTime = min(firstPress(keyIdx));      % The earliest key press time
    responseName = KbName(find(firstPress == rtTime, 1));  % key name
    rt = (rtTime - stimOnset) * 1000;     % Convert to ms
end
```

### 3.3 Multi-key processing

Since each key only retains the first/last timestamp, recording multiple presses of the same key requires frequent calls to `KbQueueCheck`:
```matlab
% Continuous response scenario - Check and accumulate immediately after each key press
allKeys = {};
allRTs = [];
while GetSecs < stimOnset + deadline
    [pressed, firstPress] = KbQueueCheck();
    if pressed
        idx = find(firstPress > 0);
        for i = 1:length(idx)
            allKeys{end+1} = KbName(idx(i));
            allRTs(end+1) = firstPress(idx(i)) - stimOnset;
        end
    end
end
```

### 3.4 Alternative keyboard API

| API | Applicable scenarios | Restrictions |
|-----|---------|------|
| `KbQueueCheck` | This skill's primary pattern for time-critical keyboard events | Requires complete lifecycle management and target machine verification |
| `KbStrokeWait` | Command screen "Press any key to continue" | Blocking, does not return timestamp |
| `KbCheck` | Escape/status polling | Polling semantics differ from queued event timestamps; do not substitute it silently for the confirmed RT event definition |
| `KbWait` | Justified static, non-critical wait screens | Blocking; unsuitable when concurrent drawing, triggers, deadlines, or cleanup handling must continue |

## 4. RT timing specifications

> **Full example**: [../demo/_raw/getting-started/accurate-timing.md](../demo/_raw/getting-started/accurate-timing.md) — Frame accurate timing demo, [../demo/_raw/getting-started/wait-frames.md](../demo/_raw/getting-started/wait-frames.md) — waitframes usage.

```matlab
% The RT starting point must be obtained from the return value VBLTimestamp of Screen('Flip')
% VBLTimestamp is the time when the GPU actually completes page turning

Screen('DrawText', window, stimulusText, x, y, textColor);
[VBLTimestamp, ~, ~, ~] = Screen('Flip', window);
stimOnset = VBLTimestamp;                    % for RT calculations

% ... KbQueue polling ...

rt = (keypressTime - stimOnset) * 1000;     % ms
```

**Anti-Pattern — Forbidden**:
- `stimOnset = GetSecs` before or after Flip → imprecise
- `rt = GetSecs - stimOnset` using `KbCheck` → doubly inexact

## 5. Stimulus preloading

```matlab
% Pre-create all textures before looping
trialTextures = cell(1, nStimuli);
for i = 1:nStimuli
    img = imread(stimulusFiles{i});
    trialTextures{i} = Screen('MakeTexture', window, img);
end

% used directly within the loop
Screen('DrawTexture', window, trialTextures{condition(trial)});
```

| Stimulus type | Pre-loop operation | In-loop operation |
|---------|----------|----------|
| Image | `imread` + `Screen('MakeTexture')` | `Screen('DrawTexture')` |
| Gabor | `CreateProceduralGabor()` | `Screen('DrawTexture', ..., gabortex)` |
| Text | `Screen('TextFont')`, `Screen('TextSize')` | `DrawFormattedText` / `Screen('DrawText')` |
| Shape | Precomputed coordinate matrix | `Screen('FillRect')` / `Screen('DrawLines')` |

**Anti-Pattern - Forbidden**: Calling `imread` or `Screen('MakeTexture')` inside a trial loop - Disk I/O causing frame loss.

## 6. Audio / PsychPortAudio

PTB's audio system is based on **PortAudio** and supports scheduling and timestamping for low-latency experiments. Actual startup latency, jitter and synchronization depend on device, driver, buffering and system load and must be measured on the target machine.

### 6.1 Basic life cycle

```matlab
InitializePsychSound(1);                                 % 1 = low latency aggressive mode
pahandle = PsychPortAudio('Open', [], [], 2, freq, nChannels);
% Parameters: deviceID(default=[]), mode(2=standard playback), latencyClass, sampleRate, channels

% Load audio data
[audioData, sampleRate] = audioread('stimulus.wav');
audioData = audioData';                                 % Transposed to row=channel column=sampling point
PsychPortAudio('FillBuffer', pahandle, audioData);      % Fill buffer

% Play
PsychPortAudio('Start', pahandle, 1);                    % repetitions=1

% Wait for playback to complete
PsychPortAudio('Stop', pahandle, 1);                     % waitForStop=1

% Cleanup
PsychPortAudio('Close', pahandle);
```

### 6.2 Schedule-Based precise synchronization

```matlab
% Use schedule for precise audio-visual synchronization
PsychPortAudio('UseSchedule', pahandle, 1);              % Enable schedule mode

% Add buffering to schedule
bufferHandle = PsychPortAudio('CreateBuffer', [], audioData);
PsychPortAudio('AddToSchedule', pahandle, bufferHandle, 1);  % Played 1 time

% The target time comes from the confirmed SOA/offset and is pre-scheduled before the deadline
targetOnset = priorVbl + confirmedAudioVisualSOA;
PsychPortAudio('Start', pahandle, 1, targetOnset, 0);
visualVbl = Screen('Flip', window, targetOnset - 0.5 * ifi);
% Save targetOnset, visualVbl, and device measurements; scheduling request itself does not prove physical synchronization
```

### 6.3 Preloading and low latency

```matlab
% Method 1: FillBuffer (simple playback)
PsychPortAudio('FillBuffer', pahandle, audioData);

% Method 2: CreateBuffer + AddToSchedule (preload multiple audios, precise timing)
buf1 = PsychPortAudio('CreateBuffer', pahandle, audio1);
buf2 = PsychPortAudio('CreateBuffer', pahandle, audio2);
PsychPortAudio('UseSchedule', pahandle, 1, 128);         % Up to 128 slots
PsychPortAudio('AddToSchedule', pahandle, buf1, 1);
PsychPortAudio('AddToSchedule', pahandle, buf2, 1);

% Trigger playback (synchronized with visual)
PsychPortAudio('Start', pahandle, 0, nextFlipTime, 0);   % repetitions=0, when=nextFlipTime
```

### 6.4 Detailed explanation of FillBuffer parameters

```matlab
[underflow, nextSampleStartIndex, nextSampleETASecs] = ...
    PsychPortAudio('FillBuffer', pahandle, bufferdata [, streamingrefill=0][, startIndex=Append]);
```

| Parameters | Description |
|------|------|
| `streamingrefill=0` | One-time filling when playback stops |
| `streamingrefill=1` | Immediate refill during playback (replaces played data), for streaming |
| `underflow` returns | 1 = Buffer underrun (audible problem) |

**Key**: `bufferdata` must be floating point `[-1.0, +1.0]`, with one channel per row and one sample point per column.

## 7. Drawing command quick check

| Requirements | Commands | Key parameters |
|------|------|---------|
| Rectangle fill | `Screen('FillRect', w, color, rect)` | `rect = [left top right bottom]` |
| Rectangular border | `Screen('FrameRect', w, color, rect, penWidth)` | |
| Ellipse fill | `Screen('FillOval', w, color, rect)` | |
| Line connection | `Screen('DrawLines', w, xy, width, colors)` | `xy` is a 2×n matrix |
| Single pixel | `Screen('DrawDots', w, xy, size, color)` | `xy` is a 2×n matrix |
| Simple text | `Screen('DrawText', w, text, x, y, color)` | Need to set `TextFont`, `TextSize` first |
| Formatted text | `DrawFormattedText(w, text, 'center', 'center', color, wrapat)` | Supports `\n` line wrapping |
| Texture drawing | `Screen('DrawTexture', w, tex, srcRect, dstRect, angle)` | |
| Create texture | `tex = Screen('MakeTexture', w, imageMatrix)` | Need to be called before looping |
| Focus on the cross (recommended) | `Screen('DrawLines', w, crossCoords, 3, color)` | Do not use `DrawText('+')` |

## 8. CJK font configuration

```matlab
% macOS
Screen('TextFont', window, 'PingFang SC');
% Windows
Screen('TextFont', window, 'Microsoft YaHei');
% Linux
Screen('TextFont', window, 'Noto Sans CJK SC');
% Alternative (cross-platform)
Screen('TextFont', window, '-:Arial Unicode MS');

% Chinese text
Screen('TextSize', window, 60);
DrawFormattedText(window, double('Hello world'), 'center', 'center', textColor);
% double() ensures correct character encoding
```

## 9. Data saving

### 9.1 Incremental writing (forced mode)

```matlab
dataDir = fullfile(pwd, 'data');
if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end

dataFile = fopen(fullfile(dataDir, ['sub-' subjectID '_' task '.csv']), 'w');
fprintf(dataFile, 'trial,block,condition,rt,response,correct\n');

for trial = 1:nTrials
    % ... Experimental logic ...
    fprintf(dataFile, '%d,%d,%d,%.4f,%s,%d\n', ...
        trial, block, condition, rt, response, correct);
end

fclose(dataFile);
```

### 9.2 crash safe version

```matlab
% Immediately after each trial is written, fclose + reopen in append mode (safest)
for trial = 1:nTrials
    % ... Experimental logic ...
    fprintf(dataFile, '%d,%d,%d,%.4f,%s,%d\n', trial, block, condition, rt, response, correct);
    fclose(dataFile);
    dataFile = fopen(dataPath, 'a');
end
```

## 10. Escape processing

```matlab
function checkEscape()
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(KbName('ESCAPE'))
        sca;
        Priority(0);
        ShowCursor;
        error('Experiment aborted by user.');
    end
end
```

- Call `checkEscape()` on every frame of the timed loop
- Escape within the response collection loop needs to be included in the `keyList`
- `sca` is emergency cleanup - restore display, release textures, show cursor

## 11. Anti-Pattern Cheat Sheet

| Forbidden API/Mode | Reason | Alternatives |
|-------------------|------|---------|
| `WaitSecs(N)` for experimental timing | blocking, unable to Escape, imprecise | `Screen('Flip', ..., vbl + (wf-0.5)*ifi)` frame loop |
| `KbWait` | Blocked, unable to time RT, unable to Escape | `KbQueueCreate` + `KbQueueCheck` |
| `KbCheck` for RT | Does not provide precise timestamp | `firstPress` timestamp of `KbQueueCheck` |
| `input()` | Not visible in PTB full screen | PTB text + `KbQueue` |
| `imread` inside trial loop | Disk I/O causes frame loss | `Screen('MakeTexture')` preloading before loop |
| `Screen('MakeTexture')` in the trial loop | The texture creation cost is uncertain | Created before the loop, only `DrawTexture` inside the loop |
| `while` loop without Escape check | User cannot exit full screen | `KbCheck(KbName('ESCAPE'))` per frame |
| `Screen('DrawText', ..., '+')` is used for fixation point | font dependency, not centered | `Screen('DrawLines')` draws fixation cross |
| Abnormal exit without `sca` | Screen lock, cursor hidden | `try/catch` + `sca` + `Priority(0)` + `ShowCursor` |
| `GetSecs` records `stimOnset` (before and after Flip) | not the actual GPU page turning time | `VBLTimestamp` = `Screen('Flip')` return value |
| `rt = GetSecs - stimOnset` | Double inaccuracy (inaccurate starting point + inaccurate KbCheck) | `firstPress - VBLTimestamp` |
| KbQueue `Create`/`Start` in the trial loop | Performance overhead, possible loss of events | `Create`/`Start` placed before the loop, only `Flush` every trial |
| Not before each trial `KbQueueFlush()` | Residual keys from the previous trial contaminate the current RT | Before each trial starts `KbQueueFlush()` |
| `KbQueueCheck` The same data twice | The first call has cleared the data | Save the output variable |
| `Sound()` / `audioplayer()` for experimental audio | High latency, no precise timing | `PsychPortAudio` |
| `PsychPortAudio('FillBuffer')` in trial loop | Not relevant/possibly underloaded in non-streaming scenarios | `CreateBuffer` + preload before loop |
| `Screen('Flip')` without `when` parameter | The frame rate is not fixed | `vbl + (waitframes-0.5)*ifi` |
| Skip SyncTests (`SkipSyncTests, 1`) | Frame timing is unreliable | The production environment is set to 0, if it fails, change the machine |

## 12. Cross-platform considerations

| Platform | Features |
|------|------|
| **macOS ARM** | PTB 3.0.20+ natively supports M1/M2/M3/M4; frame sequential stereo does not work; `AsyncFlipBegin` does not work |
| **macOS Intel** | Requires macOS 10.13+; PTB 3.0.19 free, 3.0.20+ paid |
| **Windows** | `Priority` has a remarkable effect; PTB 3.0.20+ paid |
| **Linux** | Free forever; `PsychPortAudio` pauses PulseAudio exclusive hardware |
| **Raspberry Pi** | 32-bit permanently free |

## 13. API reference index

| Functions to be implemented | Core API | Reference |
|---------------|---------|------|
| Minimal window skeleton | `PsychDefaultSetup(2)` + `PsychImaging('OpenWindow')` | `../demo/_raw/getting-started/totally-minimal.md` |
| Frame accurate timing | `Screen('Flip', w, vbl+(wf-0.5)*ifi)` | `../demo/_raw/getting-started/accurate-timing.md` |
| Keyboard queue | `KbQueueCreate`/`Start`/`Flush`/`Check`/`Stop`/`Release` | `../demo/_raw/getting-started/keyboard-q.md` |
| Audio playback | `PsychPortAudio('Open'/'FillBuffer'/'Start')` | This document §6 |
| Accurate audio synchronization | `PsychPortAudio('UseSchedule'/'AddToSchedule')` | This document §6.2 |
| Text rendering | `DrawFormattedText` / `Screen('DrawText')` | `../demo/_raw/text/basic-text.md` |
| Image rendering | `imread` + `Screen('MakeTexture')` + `DrawTexture` | `../demo/_raw/textures/draw-image.md` |
| Fixation cross | `Screen('DrawLines', w, coords, width, color)` | `../demo/_raw/drawing-shapes/fixation-cross.md` |
| Gabor stimulus | `CreateProceduralGabor()` | `../demo/_raw/textures/gabor.md` |
| Rectangle/Ellipse | `Screen('FillRect'/'FillOval')` | `../demo/_raw/drawing-shapes/rectangle.md` |
| Data saving | `fopen`/`fprintf`/`fclose` | This document §9 |
| Escape detection | `KbCheck` + `KbName('ESCAPE')` | This document §10 |
| Conditional loading | `readtable('conditions.xlsx')` | `mapping/README.md` §blocks |
| Window query | `Screen('Screens')`, `RectCenter`, `GetFlipInterval` | `../demo/_raw/getting-started/totally-minimal-with-info.md` |
