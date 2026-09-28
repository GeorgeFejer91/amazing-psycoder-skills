# PTB installation and environment configuration

> Source: Teacher Jiang Ting Zhihu PTB tutorial
> Category: `demo/_raw/getting-started/` — L4 Getting Started Reference
> Reference level: L4 demo (only refer to the installation process, the API mode is subject to spec/README.md)

## Environmental requirements

| Environment type | Recommended version | Components must be enabled |
|---------|---------|------------|
| MATLAB | R2018a - R2023b | OpenGL, Java Runtime |
| GNU Octave | ≥6.4 | Graphics Toolkit: gnuplot or qt |
| Windows | 10+ | Graphics card driver loads normally |
| macOS | 10.14+ | Xcode CLI Tools |
| Linux | Kernel ≥5.4 | build-essential, libx11-dev, libgl1-mesa-dev |

## Installation steps

### 1. Clone the warehouse

```matlab
targetDir = '~/Documents/Psychtoolbox';
mkdir(targetDir);
system(['git clone https://github.com/Psychtoolbox-3/Psychtoolbox-3.git ' targetDir]);
addpath(genpath(fullfile(targetDir)));
```

### 2. Configure the MEX compiler

```matlab
mex -setup C++
% Select compiler: MinGW-w64 (Windows) / Xcode CLI (macOS) / gcc/g++ (Linux)
```

### 3. Run first initialization

```matlab
PsychtoolboxSetup;
```

### 4. Verify installation

```matlab
ver('psychtoolbox')          % should show version number and build date
[win, rect] = Screen('OpenWindow', 0, [0 0 0]);
wait(1);
Screen('CloseAll');
```

## Common installation errors

| Error | Cause | Solution |
|------|------|------|
| `Undefined function 'PsychtoolboxSetup'` | The path is not added | `addpath(genpath('~/Documents/Psychtoolbox'))` |
| `Invalid MEX-file` | MEX not configured | `mex -setup C++` |
| MEX compilation failed (Linux) | Missing development library | `sudo apt-get install build-essential libx11-dev libgl1-mesa-dev` |
| Insufficient permissions | Unable to write to system path | Install to user's home directory + `setenv('PSYCHTOOLBOX_ROOT', '~/Documents/Psychtoolbox')` |

## System-level performance optimization

| Interference source | Impact mechanism | Recommended countermeasures |
|-------|---------|----------|
| Screensaver | Trigger monitor to sleep | Disable before experiment |
| Background update | Sudden increase in CPU usage | Turn off automatic updates |
| Animation Effects | Graphics Pipeline Blocking | Switch to Classic Theme (Windows: Tuned for Best Performance) |
| Laptop power saving mode | Reduce GPU frequency | Plug in and set to high performance |
| macOS notifications | Preempt threads | Close notification center |
| DWM Desktop Compositing (Windows) | Flip cannot sync VBLANK accurately | Control Panel > Adjust for best performance |

## Dual graphics card system GPU binding

On laptops with both integrated and discrete graphics, MATLAB needs to be forced to use a high-performance GPU:

- **Windows**: NVIDIA Control Panel → Set MATLAB to "High Performance NVIDIA Processors"
- **macOS**: Use `gpuDevice()` to check the currently active GPU
- **Linux**: `export __NV_PRIME_RENDER_OFFLOAD=1 && matlab -nodesktop`

```matlab
% Check current GPU at runtime
info = Screen('GetWindowInfo', win);
if contains(info.Renderer, 'Intel')
    warning('Running on integrated GPU. Consider switching to discrete.');
end
```

## Clock accuracy verification

```matlab
t0 = GetSecs;
for i = 1:100
    t(i) = GetSecs;
end
dt = diff(t);
fprintf('Min interval: %.6f s | Max: %.6f s | Jitter: %.6f s\n', min(dt), max(dt), std(dt));
```

Ideally the time difference between consecutive calls to `GetSecs` should be on the microsecond level (< 100 μs) with a very small standard deviation. If the jitter exceeds 1 ms, there may be an interrupt storm or scheduling delay issue.
