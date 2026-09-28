# Visual recognition experiment - mouse spatial response + multi-block adaptive learning

> Source: [Matt Jones, University of Colorado](http://matt.colorado.edu/teaching/exptworkshop/example/main.m)
> Reference level: L4 demo (only refer to the experimental logic - mouse response, adaptive blocking, feedback display)

## Experimental logic

- **Task**: When you see a picture of a lizard, use your mouse to click on one of the 9 circular response areas to indicate where it lives.
- **stimuli**: 9 species of lizard pictures (`stimuli/lizard1.jpg` ~ `lizard9.jpg`)
- **Response**: 9 circular areas evenly arranged around the stimulus, mouse click
- **Block**: 36 trials/block, the experiment ends if there are ≤ 2 errors (adaptive learning standard)
- **Feedback**: Correct = Green, Wrong = Red → Display the correct answer
- **Data**: Save `.mat` independently by subject + merge into the total data file `dataMaster_*.mat`

## Original code (main.m, line 241)

```matlab
function main
%Matt Jones, Dec 20
%Visual identification experiment with spatial (mouse) response
%Some older parts of this code were inherited from Todd Maddox

clear global
rng('shuffle')

global data blockLength errorThreshold window screenRect
global W H stimWidth responseSize stimrect respRadius respBox respX respY
global white brown green red bground
global instrSize respSize
global wrongTime demoIti iti FBtime postInstrTime
global stimuli

%parameters for experiment duration
blockLength = 36;
errorThreshold = 2;

%Timing parameters
iti = .25;
FBtime = .4;
wrongDelay = .05;
wrongTime = .2;
demoIti = .4;
postInstrTime = .5;

%Set up data structure
data = struct('version', '12/9/13');
data.computer = machineID;
if setup == -1
    disp 'Experiment Canceled'
    return
end

%Load stimulus image files
stimuli = cell(9,1);
for i=1:9
    imfile = ['stimuli/lizard' num2str(i) '.jpg'];
    stimuli{i} = imread(imfile);
end

%Set up psychtoolbox and graphics
[window, screenRect] = Screen('OpenWindow',0);
W = screenRect(3);
H = screenRect(4);
Screen('TextFont', window, 'Verdana');

%Graphical parameters
stimWidth = W/15;
respSize = stimWidth/2;
respRadius = respSize*5;
responseSize = 30;
instrSize = 18;

%Colors
white = [250 250 250];
brown = [50 30 10];
red = [150 25 25];
green = [25 150 25];
bground = [0 0 0];

%Compute stimulus and response locations
ratio = size(stimuli{1},1)/size(stimuli{1},2);
stimrect = [W/2-floor(stimWidth/2), H/2-floor(stimWidth*ratio/2), W/2+ceil(stimWidth/2), H/2+ceil(stimWidth*ratio/2)];
respX = W/2 + respRadius*sin(2*pi*(0:8)/9);
respY = H/2 - respRadius*cos(2*pi*(0:8)/9);
respBox = [respX'-respSize,respY'-respSize,respX'+respSize,respY'+respSize];

%Text for display
Screen('TextSize',window,responseSize);
prompt = 'Where does this lizard live?';
[promptWidth,~] = Screen('DrawText',window,prompt,0,0);
wrong = 'Wrong';
[wrongWidth,~] = Screen('DrawText',window,wrong,0,0);
right = 'Correct';
[rightWidth,~] = Screen('DrawText',window,right,0,0);

HideCursor

if instruct(1) == -1
    abort
    return
end

if demo == -1;
    abort
    return
end

if instruct(2) == -1
    abort
    return
end

%Main task
passed = 0;
while(~passed)
    blockStim = mod(randperm(blockLength)',9)+1;
    data.stim = [data.stim;blockStim];
    blockResp = zeros(blockLength,1);
    blockRT = zeros(blockLength,1);
    Screen(window,'TextSize',responseSize);
    
    for trial = 1:blockLength
        %ITI with response regions visible
        Screen('FillRect',window,bground);
        for r = 1:9
            Screen('FillOval',window,brown,respBox(r,:));
        end
        Screen('Flip',window);
        WaitSecs(iti);
        
        %Stimulus presentation
        Screen('FillRect',window,bground);
        Screen('DrawText',window,prompt,W/2-promptWidth/2,responseSize*1.5,white);
        Screen('PutImage', window, stimuli{blockStim(trial)}, stimrect);
        for r = 1:9
            Screen('FillOval',window,brown,respBox(r,:));
        end
        SetMouse(W/2,H/2,window);
        Screen('Flip',window);
        
        %Get response
        ShowCursor;
        x = getResp;
        if x(1) == -1
            data.aborted = 1;
            passed = 1;
            break
        end
        blockResp(trial) = x(1);
        blockRT(trial) = x(2);
        
        %Feedback
        HideCursor
        Screen('FillRect',window,bground);
        Screen('DrawText',window,prompt,W/2-promptWidth/2,responseSize*1.5,white);
        Screen('PutImage', window, stimuli{blockStim(trial)}, stimrect);
        for r = 1:9
            Screen('FillOval',window,brown,respBox(r,:));
        end
        if blockResp(trial)==data.map(blockStim(trial))
            Screen('FillOval',window,green,respBox(blockResp(trial),:));
            Screen('DrawText',window,right,W/2-rightWidth/2,H-responseSize*2,green);
            Screen('Flip',window);
            WaitSecs(FBtime);
        else
            Screen('FillOval',window,red,respBox(blockResp(trial),:));
            Screen('DrawText',window,wrong,W/2-wrongWidth/2,H-responseSize*2,red);
            Screen('Flip',window);
            WaitSecs(wrongDelay);
            Screen('FillRect',window,bground);
            Screen('DrawText',window,prompt,W/2-promptWidth/2,responseSize*1.5,white);
            Screen('PutImage', window, stimuli{blockStim(trial)}, stimrect);
            for r = 1:9
                Screen('FillOval',window,brown,respBox(r,:));
            end
            Screen('FillOval',window,red,respBox(blockResp(trial),:));
            Screen('DrawText',window,wrong,W/2-wrongWidth/2,H-responseSize*2,red);
            Screen('FillOval',window,green,respBox(data.map(blockStim(trial)),:));
            Screen('Flip',window);
            WaitSecs(FBtime-wrongDelay);
        end
    end
    
    data.resp = [data.resp;blockResp];
    data.RT = [data.RT;blockRT];
    
    if data.aborted==0
        errors = sum(blockResp~=data.map(blockStim));
        if errors <= errorThreshold
            passed=1;
        else
            if instruct(3,errors) == -1
                data.aborted=1;
                passed=1;
            end
        end
    end
end

data.elapsedTime = (clock-data.dateTime)*[0;0;1440;60;1;1/60];

%Write data
if ~isdir('data')
    mkdir('data');
end
indFile = ['data',num2str(data.sub),'_',machineID];
a = what('data');
foundMaster = 0;
foundInd = 0;
for i=1:length(a.mat)
    if isequal(a.mat{i},['dataMaster_',machineID,'.mat'])
        foundMaster=1;
    end
    if isequal(a.mat{i},[indFile,'.mat'])
        foundInd=1;
    end
end
if foundInd
    suffix = num2str(rand);
    save(['data/',indFile,'-',suffix(3:6)],'data');
else save(['data/',indFile],'data');
end
if foundMaster
    load(['data/dataMaster_',machineID]);
    eval(['dataMaster_',machineID,' = [dataMaster_',machineID,' data];']);
else eval(['dataMaster_',machineID,' = data;']);
end
save(['data/dataMaster_',machineID],['dataMaster_',machineID]);
disp('Data have been saved.');
disp(' ');

if data.aborted==0
    instruct(4,errors);
    getPasswd(300)
end
ShowCursor;
Screen('CloseAll');
home
end

function abort
ShowCursor;
Screen('CloseAll');
disp('Experiment aborted by escape sequence')
end
```

## Anti-pattern annotation

| Issues | Locations | Canonical Overrides |
|------|------|---------|
| Global variable `global` | Top of file | Structure parameters or nested function closure |
| `WaitSecs` multiple places | ITI, feedback | Frame loop timing |
| `Screen('PutImage')` instead of `MakeTexture` preload | trial loop | `Screen('MakeTexture')` preprocess all textures before loop |
| Depends on external files `setup.m`, `instruct.m`, `demo.m`, `getResp.m` | Multiple places | Self-contained single file |
| `Screen('CloseAll')` | Cleanup | `sca` |
| None `try-catch` | Global | Must wrap |
| `save()` Save after end of block | Data saving | Incremental write per trial |
| Mouse RT source is opaque | `getResp` function | Need to confirm whether RT is based on `GetSecs` or `VBLTimestamp` |

## Experimental logic points (can be used for programming layer paradigm design)

- **stimulus-response mapping**: 9 lizard images → 9 spatial locations (circular arrangement, `2π/9` radians intervals)
- **Adaptive Block**: 36 trials per block, pass if error ≤ 2
- **Feedback Design**: Correct = green highlight + text, wrong = red highlight → short delay → display the correct answer
- **Error feedback is divided into two stages**: first flash red for 50ms → switch to green for correct answer
- **Data merge**: independent file + double write of the combined file to prevent duplicate subject numbers (add random suffix)
