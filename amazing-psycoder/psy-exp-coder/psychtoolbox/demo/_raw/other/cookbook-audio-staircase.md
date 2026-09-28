# Auditory staircase experiment — KbQueue + PsychPortAudio synchronization

> Source: [PTB Cookbook: Simple Experiment 4](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/Cookbook:-simple-experiment-4)
> Author: Aaron Seitz (2012)
> Reference level: L4 demo (only reference audio synchronization + staircase algorithm + KbQueue RT mode)

## Experimental logic

40-trial auditory detection staircase experiment:
- Stimulus: Cow noise (intensity controlled by stairs)
-Task: Press the button when you hear the sound
- Staircase rule: 3-down rule, correct 3 times in a row → sound intensity decreases
- Data: Save the current stair threshold for each trial

## Original code

```matlab
% SampleExperiment.m
%
% shows a simple experiment, press a key whenever you see or hear a
% cow...instructions to the subject are an excercise to the user ;-).
% runs a staircase
%
% written for Psychtoolbox 3  by Aaron Seitz 1/2012

%% Example Experiment
% Gets subject Info sets up experiment
prompt = {'Enter subject number:'};
defaults = {''};
answer = inputdlg(prompt, 'Subject Number',1.2,defaults);
SUBJECT = answer{1,:};

c = clock;
baseName=[SUBJECT '_DemoExp_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
rand('seed',GetSecs);

% Opens Sets up Psychtoolbox
[window, rect]=Screen('OpenWindow',0);
FlipInt=Screen('GetFlipInterval',window);
ListenChar(-1);
HideCursor();
KbName('UnifyKeyNames');
KbQueueCreate;
KbQueueStart;

[wavedata freq] = wavread('./cow.wav');
TheSnd=[wavedata wavedata];
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], [], 2, freq, 2, 0);

vbl=Screen('Flip',window);

%staircase parameters
numdown=3;
stepsize=-.01;
thresh=.3;
CorCounter=0;

for trial=1:40
    starttime=vbl +round((3*rand + 1)/FlipInt)*FlipInt

    PsychPortAudio('FillBuffer', pahandle, thresh*TheSnd');
    PsychPortAudio('Start', pahandle,1,inf);
    PsychPortAudio('RescheduleStart', pahandle, starttime, 0)
    vbl=Screen('Flip',window,starttime-FlipInt/2);
    KbQueueFlush;
    Waitsecs(.5);
    if KbQueueCheck
        CorCounter = CorCounter+1;
    else
        CorCounter=0;
    end
    threshhist(trial)=thresh;
    if CorCounter>=numdown
        thresh=thresh+stepsize;
    else
        thresh=thresh-stepsize;
    end
    thresh=max(thresh,0);
    thresh=min(thresh,1);
    save(baseName)
end
ListenChar(0);
ShowCursor();
Screen('CloseAll');
Priority(0);
KbQueueRelease;
ListenChar(0);
PsychPortAudio('Close');
```

## Anti-pattern annotation

| Issues | Locations | Canonical Overrides |
|------|------|---------|
| `Waitsecs(.5)` Wait for response | Response window | Frame loop + `GetSecs` Timeout detection |
| `KbQueueCheck` not reading `firstPress` timestamp | reaction collection | `[pressed, firstPress]=KbQueueCheck` → extract RT |
| `save(baseName)` Save the entire amount for each trial | Data saving | Append writing (`fprintf` + `fclose`) |
| `Screen('CloseAll')` | Cleanup | `sca` |
| None `try-catch` | Global | Must wrap |
| `wavread` Deprecated | Audio loading | `audioread` (R2015b+) |

## Key API mode (part that conforms to the spec specification)

```matlab
% PsychPortAudio precise scheduling: FillBuffer + Start(inf) → then RescheduleStart to align Flip
PsychPortAudio('FillBuffer', pahandle, audioData);
PsychPortAudio('Start', pahandle, 1, inf);          % Infinite loop waiting for scheduling
PsychPortAudio('RescheduleStart', pahandle, targetTime, 0);  % Align to Flip moment

% stimulus onset half frame advance Flip
vbl = Screen('Flip', window, starttime - FlipInt/2);
KbQueueFlush;  % Clear the key buffer before Flip
```

## Staircase algorithm logic (can be used for paradigm design)

```
3-down rule:
  if consecutive correct >= 3:
      Threshold lowered (difficulty increased)
  else:
      Threshold increased (difficulty decreased)

Constraint: threshold ∈ [0, 1]
```
