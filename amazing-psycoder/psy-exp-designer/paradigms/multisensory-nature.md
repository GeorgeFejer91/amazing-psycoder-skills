# Multisensory Nature Experience Task

> **Parent**: [psy-exp-designer](../SKILL.md)
> **Config reference**: [config-schema](../references/config-schema.md)
> **Source**: [Pavlovia demos](https://gitlab.pavlovia.org/demos/multisensory_nature) · PsychoJS

## When to Use

User mentions: Multisensory nature, nature exposure, audiovisual wellbeing, restorative environments, multisensory nature experience. Measures the interactive effects of visual and auditory nature exposure on self-reported affect (positive and negative) in response to natural vs. urban audiovisual scenes.

## Core Logic

Participants view a series of 15 audiovisual recordings that vary in the proportion of natural vs. urban visual scenes and natural vs. anthropogenic (human-made) soundscapes. Each clip is 60 seconds long. After each clip, participants rate their current positive and negative affect using slider components.

**Design**: The stimuli form a factorial combination of visual nature level (high/medium/low natural content) and sound type (natural sounds, anthropogenic noise, or mixed). Video files use naming conventions indicating scene type: N (nature), T (town/urban), and R (rural/mixed). The condition file (`vids.xlsx`) specifies which video file to play per trial along with its visual nature level and sound type labels.

**Trial structure**: video playback (60 seconds, full audiovisual) → affect rating sliders (positive and negative affect) → next trial. Videos play using `visual.MovieStim` with synchronized audio.

**Pre-task questionnaire**: Before the video trials, participants complete the I-PANAS-SF (International Positive and Negative Affect Schedule — Short Form), a validated brief affect measure, to establish baseline mood. This is loaded from an Excel file (`IPANAS-SF.xlsx`).

**Key prediction**: High visual nature paired with low anthropogenic noise should produce the highest positive affect and lowest negative affect. High visual nature paired with high anthropogenic noise may paradoxically increase negative affect due to sensory conflict. Individual difference moderators (nature connectedness, state anxiety) can be collected.

### Climate Variant

A climate-focused variant (`multisensory_nature_climate`) uses the identical experimental structure, video resources, and condition file, but is framed within climate change research contexts — potentially with adapted instruction text, different questionnaires, or climate-themed debriefing. This variant was developed as part of the 1 in 5 Climate Change Project and can be used to study how multisensory nature experiences influence climate engagement and wellbeing.

## Must Confirm

- **Video content**: Which 15 videos to use? The original N/T/R set or custom recordings? File format (MP4) and resolution?
- **Rating scales**: Positive and negative affect only, or additional dimensions (arousal, perceived restorativeness, aesthetic preference)?
- **Pre-task measures**: I-PANAS-SF only, or additional individual difference measures (nature connectedness/NRS, state anxiety/STAI, environmental attitudes)?
- **Clip duration**: Standard 60 seconds, or shorter/longer per clip?
- **Trial count**: 15 clips, or custom number?
- **Between- or within-subjects**: Single session with all participants viewing all clips, or between-subjects assignment to condition subsets?

## Trial Window Timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1                 │ →  │ Window 2                 │ →  │ Window 3                 │
│ Video Playback           │    │ Positive Affect Rating   │    │ Negative Affect Rating   │
│ Content: nature/urban    │    │ Content: slider          │    │ Content: slider          │
│   video (60s)            │    │ Duration: until response │    │ Duration: until response │
│ Duration: 60000 ms       │    │ Response: slider drag    │    │ Response: slider drag    │
│ Response: none           │    │ Condition: {video_id}    │    │ Condition: {video_id}    │
│ Condition: {video_type}  │    │ Data: PA rating          │    │ Data: NA rating          │
│ Data: video_filename     │    └──────────────────────────┘    └──────────────────────────┘
└──────────────────────────┘
```

## Data Analysis

Analyze positive and negative affect ratings as a function of visual nature level, auditory nature level, and their interaction using mixed-effects models or repeated-measures ANOVA. Test individual difference moderators: nature connectedness, state anxiety. Expect a significant visual x auditory interaction; the restorative benefit of visual nature is attenuated or reversed under high anthropogenic noise. Control for baseline mood using I-PANAS-SF pre-task scores.

## References

Aldoh, A., Ungureanu, R., Popescu, S., Eldridge, A., Sandom, C. J., & Rae, C. (2023). How does a multi-sensory experience of nature interact with wellbeing? Effects of visual and auditory nature presence on affect. Part of the 1in5 Climate Change Project initiative. https://www.1in5project.info/

## Do Not Assume

- Do not assume all 15 videos are available without verification — Are the video files complete, original N/T/R video set or custom footage? Do the file format (MP4) and resolution match presentation needs?
- Do not assume audio and video tracks are inherently synchronized — MovieStim’s audio and video synchronization relies on hardware decoding performance, and the delay needs to be confirmed by actual measurement on the target device
- Do not assume the rating scale is self-explanatory to participants — Confirm slider anchor labels (e.g. 1=very slightly, 9=very strongly), scale ranges, and whether the same scale is used for PA and NA
- Do not assume clip presentation order should be fully randomized — Confirm whether the same visual level or sound type is allowed to appear continuously and whether Latin square balance is required
- Do not assume I-PANAS-SF is the only pre-task measure needed — Confirm whether the Nature Related Scale (NR-6/NRS), State Anxiety Inventory (STAI), or other individual difference measures are also needed
- Do not assume the 60-second clip duration is fixed for all trials — some variants may use shorter (30s) or longer (120s) clips, need to be explicitly confirmed

## Condition File Columns

| Column | Type | Description |
|--------|------|-------------|
| video_file | str | Video file name, including extension (such as `N01.mp4`) |
| visual_level | str | Visual naturalness level: `high` (high), `medium` (medium), `low` (low) |
| sound_type | str | Sound type: `natural` (natural sound), `anthropogenic` (artificial noise), `mixed` (mixed) |

## Variants

**Climate Variant** — `multisensory_nature_climate`: Uses the same 2x3 factor experimental structure and video resources, but uses climate change research as a framework and includes climate-related instructions, a climate anxiety questionnaire, or a pro-environmental behavioral intention measure. Suitable for studying how multisensory nature experiences influence climate engagement. See the [Climate Variant](#climate-variant) section of this document for details.

**Unimodal Control Variant**: Separate the visual and auditory channels, presenting only the visual (silent video) or only the auditory (black screen + natural sound), used to quantify the independent contribution of each sensory channel to the emotional impact. Additional silent video or audio-only stimulation files are required. Can be cross-referenced to `audiovisual-stimuli.md`.

**Extended Exposure Variant**: Extend each segment to 3-5 minutes and reduce the number of trials to 5-6, which is suitable for examining the cumulative recovery effect of long-term natural exposure. Longer video footage needs to be prepared and fatigue effects and attention checks need to be taken into account.

## Example

### User request

> "I am going to do a multi-sensory natural experience experiment. Use 15 video clips, each of 60 seconds. There are three types of videos: high naturalness (all forests and beaches), medium naturalness (country fields), and low naturalness (city street scenes). The sounds include natural sounds (birds, water sounds), human sounds There are three types of noise (traffic, construction) and mixed sounds. After each video, the subjects were asked to rate their current positive emotions and negative emotions using a slider from 1 to 9. Before the experiment started, the video files were randomly presented. stimuli/videos/ folder using PsychoPy 2024.

### Trial window timeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Window 1 │ → │ Window 2 │ → │ Window 3 │
│ Gaze │ │ Video playback │ │ Emotion score │
│ Content: + │ │ Content: Nature/Urban Scene Video │ │ Content: PA + NA Slider │
│ Duration: 500 ms │ │ Duration: 60000 ms │ │ Duration: Until reaction │
│ Response: None │ │ Response: None │ │ Response: Drag the slider with the mouse │
│ Conditions: None │ │ Conditions: {video_file} │ │ Conditions: {visual_level}, │
│ Data: None │ │ Data: video_filename │ │ {sound_type} │
└─────────────────────────┘ └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ │ Data: PA_rating, NA_rating│
                                                                └──────────────────────────┘
```

| Window | Content | Duration | Response | File | Condition | Data |
|------|------|----------|------|------|------|------|
| fixation point | + | 500 ms | none | none | none | none |
| Video playback | Natural/urban scene video | 60000 ms | None | stimuli/videos/{video_file} | {video_file} | video_filename |
| Sentiment Rating | PA + NA Slider | Until Reaction | Mouse Drag | None | {visual_level}, {sound_type} | PA_rating, NA_rating |

### Analyzed experimental specifications

| Field | Value |
|------|-----|
| Experiment name | Multi-sensory nature experience task |
| Platform | PsychoPy 2024 |
| Task type | Multisensory emotion assessment (within-subjects design) |
| Visual factors | 3 levels: high naturalness / medium naturalness / low naturalness |
| Hearing factors | 3 levels: natural sounds / artificial noises / mixed sounds |
| Number of trials | 15 (3x3 factorial design, some combinations may be repeated or blank) |
| Duration per trial | 60 seconds video + rating (no time limit) |
| Pre-experiment questionnaire | I-PANAS-SF (positive and negative emotion scale short version) |
| Scoring method | Slider 1-9 (positive emotions + negative emotions are rated separately) |
| Trial order | Completely random |
| Video source | stimuli/videos/ folder |

### Information to be confirmed

1. **Scale anchor tag**: What text descriptions do sliders 1 and 9 correspond to? (e.g. "hardly" to "very strongly") Do the PA and NA scales use the same anchor labels?
2. **Practice trials**: Are practice trials (such as 2-3 sample videos) needed to familiarize subjects with the scoring process? Is the practice data saved?
3. **Guidance Language**: Is the instruction language in Chinese/English/bilingual? Is debriefing required after the experiment?

### Key assumptions

-Video file naming follows the N/T/R convention (for example, N01.mp4 is high naturalness), and the visual_level and sound_type tags are already included in the condition file
- Positive and negative sentiment scores are displayed in two separate interfaces (first PA and then NA) instead of the same screen
- The I-PANAS-SF questionnaire uses the standard 10-question version, loaded as an Excel file, 5-point Likert scale
- There is no ITI between trials, and you will enter the scoring interface directly after the video ends.

### Code structure

```
multisensory_nature.py
├── Parameter configuration (video duration, rating range, file path)
├── Window settings (full screen/window, resolution)
├── I-PANAS-SF pre-experiment questionnaire loading (xlsx)
├── Conditional file loading (vids.xlsx → trial list)
├── Video Stim Preload Check (MovieStim3)
├── Guidance interface
├── Trial cycle:
│ ├── Fixation point (500 ms)
│ ├── Video playback (60000 ms, MovieStim3 + audio sync)
│ ├── Positive sentiment score (slider 1-9)
│ ├── Negative sentiment score (slider 1-9)
│ └── Data record
├── Data saving: try/finally CSV incremental writing
└── Later explanation
```

### Expected data column

| column name | type | description |
|------|------|------|
| participant | str | participant number |
| trial_index | int | trial number (0-14) |
| video_file | str | video file name |
| visual_level | str | Visual naturalness level |
| sound_type | str | sound type |
| PA_rating | int | Positive sentiment rating (1-9) |
| NA_rating | int | Negative sentiment rating (1-9) |
| PA_RT | float | Positive emotion score reaction time (seconds) |
| NA_RT | float | Negative emotion score reaction time (seconds) |
| ipanas_PA_baseline | float | I-PANAS-SF Positive emotion baseline score |
| ipanas_NA_baseline | float | I-PANAS-SF negative emotion baseline score |
