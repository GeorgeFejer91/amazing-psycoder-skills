# Multi-screen and multi-GPU environment adaptation

> Source: Teacher Jiang Ting Zhihu PTB Tutorial §2.4
> Classification: `demo/_raw/other/` — L4 reference
> Recommended level: Not involved in code generation, only used as experimental configuration reference

## Enumeration display

```matlab
nScreens = Screen('NumDisplays');
for i = 0:nScreens-1
    bounds = Screen('Rect', i);
    fprintf('Screen %d: %d x %d @ (%d,%d)\n', i, ...
        bounds(3), bounds(4), bounds(1), bounds(2));
end
```

The number starts from 0, and 0 is usually the main screen. Specify the screen index when creating the window:

```matlab
win1 = Screen('OpenWindow', 0, [0 0 0]);        % Home screen (viewed by the subject)
win2 = Screen('OpenWindow', 1, [255 255 255]);  % Secondary screen (main test monitoring)
```

**Note**: Cross-screen windows cannot share OpenGL texture resources and need to be managed separately.

## Dual graphics card system GPU binding

On a laptop with both integrated graphics (Intel) and discrete graphics (NVIDIA):

```matlab
% Check current active GPU
info = Screen('GetWindowInfo', win);
if contains(info.Renderer, 'Intel')
    warning('Running on integrated GPU. Switch to discrete.');
end
```

- **Windows**: NVIDIA Control Panel > Set MATLAB to "High Performance NVIDIA Processors"
- **Linux**: `export __NV_PRIME_RENDER_OFFLOAD=1 && matlab -nodesktop`

## Risk of out-of-synchronization of multi-screen refresh rates

The refresh rates between multiple screens may be out of sync, resulting in time deviations in cross-screen experiments. Solution:
- Make sure the main and secondary screens are set to the same refresh rate
- Experimental data collection only uses the Flip timestamp of the subject's screen

## Secondary screen composite special effects interference

Some integrated graphics cards cannot turn off composite effects (such as macOS Mission Control animation) on the secondary screen. recommend:
- The secondary screen is only used for monitoring, not for stimulus presentation
- If you need dual screens to present stimulation, use the same model for both screens and unify the graphics card driver
