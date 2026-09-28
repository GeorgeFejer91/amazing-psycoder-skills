# Visual Choice Reaction Time Experiment — Complete PTB Experiment Template

> Source: Teacher Jiang Ting Zhihu PTB tutorial §5
> Category: `demo/_raw/other/` — L4 complete experiment reference
> Reference level: L4 demo (only refer to the experimental logic, the API mode is subject to spec/README.md Canonical Skeleton)

## Experimental logic

- **Task**: Red and green light spots appear randomly at the left/middle/right positions, press the button to determine the color
- **Trial Structure**: ITI(1s) → Stimulation (response window within 0.5s) → Feedback Sound → Data Saving
- **Conditions**: 2(color) × 3(position) = 6 species, Latin square balance
- **Output**: `.mat` structure array, including flipTime / rt / color / xpos / pressedKey

## Original code

```matlab
% Visual Choice RT Experiment
% Teacher Jiang Ting Zhihu PTB tutorial §5

close all; clear; sca;

% ============================================================
% Experimental parameters
% ============================================================
expParams.screenNum = 0;
expParams.fullscreen = 1;
expParams.monitorHz = 60;
expParams.trialsPerBlock = 40;
expParams.ITI = 1.0;                % Inter-trial interval (seconds)
expParams.stimDur = 0.5;            % Stimulation duration (seconds)
expParams.validKeys = [32, 38];     % Spacebar and Up Arrow

% Generate trial sequence (2 colors × 3 positions × repeat)
colors = [1, 2];                    % 1=red[255,0,0], 2=green[0,255,0]
positions = [-400, 0, 400];         % X coordinate (pixels), Y=0 centered
trialList = [];
for c = 1:length(colors)
    for p = 1:length(positions)
        trialList = [trialList; colors(c), positions(p)];
    end
end
trialList = repmat(trialList, expParams.trialsPerBlock / size(trialList,1), 1);
trialList = trialList(randperm(size(trialList,1)), :);  % Randomly shuffle

% ============================================================
% Window initialization
% ============================================================
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 0);

[windowPtr, windowRect] = Screen('OpenWindow', expParams.screenNum, [0 0 0], ...
    [], [], [], [], 2);  % Double buffering
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
ifi = Screen('GetFlipInterval', windowPtr);
[centerX, centerY] = RectCenter(windowRect);
HideCursor;
Priority(MaxPriority(windowPtr));

% ============================================================
% Color helper function
% ============================================================
function rgb = GetColorFromList(colorID)
    if colorID == 1
        rgb = [255, 0, 0];    % Red
    elseif colorID == 2
        rgb = [0, 255, 0];    % Green
    else
        rgb = [255, 255, 255];
    end
end

function rect = MakeRectFromCenter(cx, cy, w, h)
    rect = [cx-w/2, cy-h/2, cx+w/2, cy+h/2];
end

% ============================================================
% Main experiment loop
% ============================================================
data = struct([]);

for t = 1:expParams.trialsPerBlock
    currentColor = trialList(t, 1);
    currentX = trialList(t, 2);
    currentY = 0;

    % --- ITI ---
    vbl = Screen('Flip', windowPtr);  % Clear screen
    WaitSecs(expParams.ITI);

    % --- Draw stimulus ---
    Screen('FillOval', windowPtr, GetColorFromList(currentColor), ...
        MakeRectFromCenter(currentX, currentY, 50, 50));

    % --- Flip + timestamp record ---
    stimOnset = Screen('Flip', windowPtr);  % Returns the actual flip time

    % --- Response collection (non-blocking polling) ---
    responseDetected = false;
    responseKey = NaN;
    rt = NaN;

    deadline = stimOnset + expParams.stimDur;
    while (GetSecs < deadline) && ~responseDetected
        [keyIsDown, ~, keyCodes] = KbCheck;
        if keyIsDown
            if any(ismember(keyCodes, expParams.validKeys))
                rt = (GetSecs - stimOnset) * 1000;  % Convert to milliseconds
                responseKey = find(keyCodes, 1);
                responseDetected = true;
            end
        end
    end

    % --- Data record ---
    data(t).stimOnset = stimOnset;
    data(t).rt = rt;
    data(t).color = currentColor;
    data(t).xpos = currentX;
    data(t).responseKey = responseKey;
end

% ============================================================
% Save and clean
% ============================================================
save('ExpData_Subj01.mat', 'data');
sca;
Priority(0);
ShowCursor;

% ============================================================
% Data preprocessing example
% ============================================================
% load('ExpData_Subj01.mat');
% validRTs = [data(:).rt];
% validRTs = validRTs(~isnan(validRTs) & validRTs > 100 & validRTs < 2000);
% fprintf('Average reaction time: %.2f ms ± %.2f ms\n', mean(validRTs), std(validRTs));, std(validRTs));
```

## Anti-pattern annotation

| Issue | Location | Spec Canonical Skeleton |
|------|------|-------------------------------------|
| `WaitSecs(expParams.ITI)` blocking | ITI phase | frame loop `for f=1:nFrames; Screen('Flip',w,vbl+(wf-0.5)*ifi); end` |
| `KbCheck` polling instead of `KbQueueCheck` | Response collection | `KbQueueCreate` + `KbQueueCheck` + `firstPress - VBLTimestamp` |
| `GetSecs - stimOnset` manual calculation of RT | RT calculation | `firstPress(keyIdx) - VBLTimestamp` (KbQueue automatic timestamp) |
| `save()` One-time saving after the experiment | Data saving | `fopen`/`fprintf` Incremental writing for each trial |
| None `try-catch` | Global | Must wrap |
| Feedback sound `PlaySound` is not implemented | Feedback stage | Use `PsychPortAudio` to preload + asynchronous playback |

## Experimental logic points (can be used for programming layer paradigm design)

- 2(color) × 3(position) factorial design, Latin square balance
- Stimulation duration is fixed at 500ms, with a response window within it
- Data structure: struct array → `.mat` save
- Abnormal RT culling: < 100ms or > 2000ms
