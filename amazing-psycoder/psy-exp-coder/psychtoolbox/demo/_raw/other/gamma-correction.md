# Gamma correction and color space management

> Source: Teacher Jiang Ting Zhihu PTB tutorial §3.3.3
> Classification: `demo/_raw/other/` — L4 reference
> Reference level: L4 demo (generated code uses spec/README.md §2.2 color specification)

## Principle

Psychtoolbox uses the linear RGB color space by default, but most monitors have a non-linear response curve (gamma effect). Uncorrected color can cause distortion in brightness perception.

Assume that the target appears in 50% brightness grayscale:
```matlab
linear_gray = 0.5;                           % Linear value
actual_displayed = linear_gray ^ (1/2.2);    % Without correction, the actual display is darker
```

## Reverse gamma correction

```matlab
gamma = 2.2;
target_luminance = 0.5;
corrected_value = target_luminance ^ gamma;   % Precompensation
Screen('FillRect', win, corrected_value, rect);
```

## LoadNormalizedGammaTable (recommended)

After measuring the LUT with a photometer, load:

```matlab
lut_size = 256;
gamma = 2.2;
r_lut = (linspace(0, 1, lut_size)') .^ gamma;
g_lut = r_lut;
b_lut = r_lut;

Screen('LoadNormalizedGammaTable', win, [r_lut, g_lut, b_lut]);
```

Once loaded, all subsequent color values automatically go through the correction path.

## Common monitor gamma reference values

| Monitor Type | Typical Gamma Value | Remarks |
|-----------|----------|------|
| CRT | 2.2 ~ 2.5 | Close to the ideal power law |
| LCD (sRGB) | 2.2 | Standard configuration |
| OLED | 2.0 ~ 2.1 | Higher contrast ratio |
| Projector | 1.8 ~ 2.0 | Requires separate calibration |

## Anti-pattern annotation

| Questions | Canonical Overrides |
|------|---------|
| Uncorrected linear RGB values are used directly for brightness critical experiments | Load Gamma LUT before experiment or use corrected color values |
| Assume all monitors Gamma = 2.2 | Measure with a photometer or at least query the monitor specifications |
