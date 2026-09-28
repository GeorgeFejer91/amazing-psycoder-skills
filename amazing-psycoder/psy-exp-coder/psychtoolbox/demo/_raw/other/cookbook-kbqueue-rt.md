# KbQueue key response + timeout processing example

> Source: [PTB Cookbook: Response Example 2](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/Cookbook%3A-response-example-2)
> Author: Aaron Seitz (2012)
> Reference level: L4 demo (only refer to KbQueueCheck + firstPress RT mode)

## Experimental logic

5 trial demonstration: random color texture → key response (0.5s timeout) → feedback RT + key name

## Original code

```matlab
% Example 2 - Shows which key was pressed and timeouts after .5 seconds
% written for Psychtoolbox 3  by Aaron Seitz 1/2012

[window, rect]=Screen('OpenWindow',0);  % open screen
ListenChar(-1); %makes it so characters typed don't show up in the command window
HideCursor(); %hides the cursor

KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming
KbQueueCreate; %creates cue using defaults
KbQueueStart;  %starts the cue

for trial=1:5 %runs 5 trials
    IM1=rand(100,100,3)*255; %creates random colored image
    tex(1) = Screen('MakeTexture', window, IM1); %makes texture
    Screen('DrawTexture', window, tex(1), []); %draws to backbuffer
    WaitSecs(rand+.5) %jitters prestim interval between .5 and 1.5 seconds

    starttime=Screen('Flip',window); %swaps backbuffer to frontbuffer
    KbQueueFlush; %Flushes Buffer so only response after stimonset are recorded
    Waitsecs(.5);  %gives .5 secs for a response

    [ pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.

    if pressed %if key was pressed do the following
        firstPress(find(firstPress==0))=NaN; %little trick to get rid of 0s
        [endtime Index]=min(firstPress); % gets the RT of the first key-press and its ID
        thekeys=KbName(Index); %converts KeyID to keyname
        RTtext=sprintf('Response Time =%1.2f secs with %s-key',endtime-starttime,thekeys); %makes feedback string
    else
        RTtext=sprintf('Sorry, too slow!'); %makes feedback string
    end
    DrawFormattedText(window,RTtext,'center'  ,'center',[255 0 255]); %shows RT
    vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    Screen('Flip',window,vbl+1); %erases feedback after 1 second
end

ListenChar(0); %makes it so characters typed do show up in the command window
ShowCursor(); %shows the cursor
Screen('CloseAll'); %Closes Screen
```

## Anti-pattern annotation

| Issues | Locations | Canonical Overrides |
|------|------|---------|
| `Waitsecs(.5)` Wait for response | Response window | Frame loop + `GetSecs` timeout detection should be used |
| `Screen('CloseAll')` | Cleanup | `sca` |
| None `try-catch` | Global | Must wrap |
| None `Priority(0)` + `KbQueueRelease` | Cleanup | Restore priority + Release keyboard queue |
| `MakeTexture` is created inside the loop | trial loop | should be preloaded outside the loop |

## Key API mode (part that conforms to the spec specification)

```matlab
% RT = time of first key press - stimulus presentation time
KbQueueFlush;                         % Clear the key buffer before stimulus presentation
starttime = Screen('Flip', window);   % stimulus presentation onset
[ pressed, firstPress] = KbQueueCheck; % Get key events
firstPress(find(firstPress==0)) = NaN;
[RT, keyIndex] = min(firstPress);     % RT = First key press time
RT = RT - starttime;                  % minus stimulus onset
```
