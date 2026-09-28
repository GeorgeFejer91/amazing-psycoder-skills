# EAST (Extrinsic Affective Simon Task) — jsPsych

> **Parent**: [psy-exp-coder](../../SKILL.md)
> **Config reference**: [east](../../../psy-exp-designer/paradigms/east.md)
> **Source**: [psychbruce/jspsych](https://github.com/psychbruce/jspsych) (Bao, 2020) · jsPsych 6.1.0

> ⚠️ **LANGUAGE WARNING**: The code example below is a Chinese-language reference implementation. When generating code for non-Chinese users, ALL participant-facing text (instructions, stimuli, feedback, button labels, debrief text) MUST be translated to the user's language. See [Language Consistency (Red) Line)](../../SKILL.md#language-consistency-red-line). The stimulus words (`health, happiness...`), instruction paragraphs, category labels, and debrief messages in this example are Chinese-specific — replace them entirely for other languages.

## Experiment Logic

The Extrinsic Affective Simon Task (EAST) is an indirect measure of implicit attitudes that assesses associations between target concepts and evaluative attributes by varying the color-category pairing. Unlike the IAT, which compares response latencies across two combined category blocks, the EAST interleaves attribute trials (positive/negative words in white) and target trials (colored nouns) within a single test block. The core logic is that participants classify words by either their evaluative meaning (positive vs. negative, using F/J keys) for attribute stimuli, or by their ink color (blue vs. green, using F/J keys) for target stimuli. The EAST effect emerges when reaction times for a given target category (e.g., "flowers") differ depending on whether the category's assigned ink color shares the same response key as positive or negative attribute words.

The experiment consists of three phases: two single-category practice blocks followed by a combined test block. In Practice 1, participants classify white attribute words as positive (F key) or negative (J key), with error feedback (green check / red X) after each trial and forced correction. In Practice 2, participants classify colored target nouns by their ink color -- blue words (F key) or green words (J key) -- again with error feedback and forced correction. The test block then randomly interleaves both stimulus types: white attribute words (classified by meaning) and colored target words (classified by ink color), presented on a black background with no error feedback and a randomized 1-2 second inter-trial interval.

Each trial within a block follows a nested timeline structure: a 500ms fixation cross (no-response) followed by the stimulus classification screen. Category label tags are displayed absolute-positioned to the left and right of the screen, with the left tag always mapping to the F key and the right tag to the J key. The `key_answer` is resolved dynamically via a function that inspects the current `timelineVariable` to determine the correct response. At the conclusion, the `debrief2` block computes real-time EAST scores for each target category pair (category `a`, `b`, `c`) by calculating the RT difference between green-minus-blue trials for correct formal-test responses, producing an implicit-attitude score where positive values indicate a pro-category attitude and negative values indicate an anti-category attitude.

## Key Design Patterns

- `categorize-html` plugin for forced-choice classification with built-in feedback (correct/incorrect text displayed post-response)
- `key_answer` as a dynamic function that resolves the correct key code at runtime based on the current `timelineVariable`'s `stim_type`
- Nested timeline per trial: 500ms fixation (`html-keyboard-response` with `jsPsych.NO_KEYS` and `trial_duration`) followed by stimulus classification (`categorize-html`)
- `repetitions` and `randomize_order` at the block level control how many times each stimulus is repeated and whether the order is shuffled
- Style switching between practice (white background via `set_html_style`) and test (black background, cursor hidden, larger font via `set_html_style_EAST`)
- `force_correct_button_press: true` in practice blocks (participant must press the correct key to advance) vs. `false` in the test block
- Legacy source used an unseeded randomized ITI. Generated jsPsych 8.x code must instead use `jsPsych.randomization.randomInt(1000, 2000)` after `setSeed()` and save the resolved ITI.
- Category label tags (`tag_LR1`, `tag_LR2`, `tag_LR3`) positioned absolute-left and absolute-right via inline style, dynamically showing the current key-to-category mapping
- Real-time EAST score computation in `debrief2` using `jsPsych.data.get().filter()` to compute mean RTs per color-per-category combination, with the EAST effect = RT(green) minus RT(blue) for each target category

## Code Example

```javascript
/**
 * EAST (Extrinsic Affective Simon Task)
 * Source: psychbruce/jspsych (Bao, 2020)
 * jsPsych 6.1.0
 */


/* Custom JS Functions */

function keyCode(character) {
    return jsPsych.pluginAPI.convertKeyCharacterToKeyCode(character)
}

function timer() {
    var second = document.getElementById('timer')
    var button = document.getElementsByClassName('jspsych-btn')[0]
    if (second != null) {
        if (second.innerHTML > 1) {
            second.innerHTML = second.innerHTML - 1
        } else {
            button.innerHTML = 'Continue'
            button.disabled = false
        }
    }
}


/* Global Variables */

const btn_html_timer =
    `<style onload="tid=setInterval(timer, 1000)"></style>
     <button onclick="clearInterval(tid)" class="jspsych-btn" disabled=true>%choice%</button>`

const feedback_right = `<span style="position: absolute; top: 55%; left: 0; right: 0; color: green"> √ </span>`

const feedback_wrong = `<span style="position: absolute; top: 55%; left: 0; right: 0; color: red"> X </span>`

const subID = jsPsych.randomization.randomID(8)


/* Blocks: HTML DOM Settings */

var set_html_style = {
    type: 'call-function',
    func: function() {
        document.body.style.backgroundColor = 'rgb(250, 250, 250)' // background color
        document.body.style.color = 'black' // font color
        document.body.style.fontSize = '20pt'
        document.body.style.fontFamily = 'Microsoft Yahei'
        document.body.style.fontWeight = 'bold' // 'normal', 'bold'
        document.body.style.lineHeight = '1.6em' // line space
        document.body.style.cursor = 'default' // 'default', 'none', 'wait', ...
        document.body.onselectstart = function() { return false }
        document.body.oncontextmenu = function() { return false }
        document.onkeydown = function() {
            if ((event.keyCode in { 27: 'Esc', 116: 'F5', 123: 'F12' }) ||
                (event.ctrlKey && event.keyCode in { 85: 'U' })
            ) { return false }
        }
    },
}

var set_html_style_EAST = {
    type: 'call-function',
    func: function() {
        document.body.style.backgroundColor = 'black'
        document.body.style.color = 'white'
        document.body.style.fontSize = '32pt'
        document.body.style.fontFamily = 'Microsoft Yahei'
        document.body.style.fontWeight = 'normal'
        document.body.style.lineHeight = '1.2em'
        document.body.style.cursor = 'none'
    },
}


/* Blocks: EAST Experiment */

// Stimuli

var EAST_attrib_words = [
    { data: { stim_type: 'pos' }, s: 'Health' },
    { data: { stim_type: 'pos' }, s: 'Happy' },
    { data: { stim_type: 'pos' }, s: 'Beautiful' },
    { data: { stim_type: 'neg' }, s: 'Evil' },
    { data: { stim_type: 'neg' }, s: 'Stingy' },
    { data: { stim_type: 'neg' }, s: 'Despicable' },
]

var a1 = 'Rose'
var a2 = 'Peony'
var b1 = 'Air'
var b2 = 'Land'
var c1 = 'Cockroach'
var c2 = 'Mosquito'
var blu = 'rgb(0, 125, 150)'
var grn = 'rgb(0, 150, 125)'
var EAST_target_words = [
    { data: { stim_type: blu, x: 'a' }, s: a1 },
    { data: { stim_type: blu, x: 'a' }, s: a2 },
    { data: { stim_type: blu, x: 'b' }, s: b1 },
    { data: { stim_type: blu, x: 'b' }, s: b2 },
    { data: { stim_type: blu, x: 'c' }, s: c1 },
    { data: { stim_type: blu, x: 'c' }, s: c2 },
    { data: { stim_type: grn, x: 'a' }, s: a1 },
    { data: { stim_type: grn, x: 'a' }, s: a2 },
    { data: { stim_type: grn, x: 'b' }, s: b1 },
    { data: { stim_type: grn, x: 'b' }, s: b2 },
    { data: { stim_type: grn, x: 'c' }, s: c1 },
    { data: { stim_type: grn, x: 'c' }, s: c2 },
]

// Category label tags (positioned absolute left/right)

var tag_LR1 = `<div class="tag-left">Press F:<br/>Positive words</div>
               <div class="tag-right">Press J:<br/>Negative words</div>`

var tag_LR2 = `<div class="tag-left">Press F:<br/><span style="color:${blu}">Blue</span></div>
               <div class="tag-right">Press J:<br/><span style="color:${grn}">Green</span></div>`

var tag_LR3 = `<div class="tag-left">Press F:<br/>Positive words<br/>or<br/><span style="color:${blu}">blue</span></div>
               <div class="tag-right">Press J:<br/>Negative words<br/>or<br/><span style="color:${grn}">green</span></div>`

// Instructions

var EAST_prac1_instr = {
    type: 'html-keyboard-response',
    stimulus: `
    <p style="text-align: left; font-size: 20pt">
    Practice task 1:<br/><br/>
    Below is an "Adjective Classification" task. <br/>
    Adjectives with <span style="color:#FFD866">positive</span> or <span style="color:#FFD866">negative</span> meaning will appear one at a time.<br/>
    Before each adjective is presented, a fixation point "+" will appear on the screen to remind you to pay attention. <br/>
    After each adjective appears, <span style="color:#FFD866">respond as accurately and quickly as possible</span>.<br/>
    - For <span style="color:#FFD866">positive</span> adjectives, press <span style="color:#FFD866">F</span>.<br/>
    - For <span style="color:#FFD866">negative</span> adjectives, press <span style="color:#FFD866">J</span>.<br/>
    Each judgment will have correct ("√") or wrong ("X") feedback. <br/><br/>
    Now, please place your index fingers on the "F" key and the "J" key respectively, and ensure that your hands do not leave the keyboard during the experiment. <br/>
    If you have carefully read and fully understood the above requirements, please press the space bar to get started. </p>`,
    choices: [' ']
}

var EAST_prac2_instr = {
    type: 'html-keyboard-response',
    stimulus: `
    <p style="text-align: left; font-size: 20pt">
    Practice task 2:<br/><br/>
    The following is a "noun classification" task. <br/>
    Nouns shown in <span style="color:${blu}">blue</span> or <span style="color:${grn}">green</span> will appear one at a time.<br/>
    Before each noun is presented, a fixation point "+" will appear on the screen to remind you to pay attention. <br/>
    After each noun appears, <span style="color:#FFD866">respond as accurately and quickly as possible</span>.<br/>
    - For a <span style="color:${blu}">blue</span> noun, press <span style="color:#FFD866">F</span>.<br/>
    - For a <span style="color:${grn}">green</span> noun, press <span style="color:#FFD866">J</span>.<br/>
    Each judgment will have correct (“√”) or incorrect (“X”) feedback. <br/><br/>
    Now, please place your index fingers on the "F" key and the "J" key respectively, and ensure that your hands do not leave the keyboard during the experiment. <br/>
    If you have carefully read and fully understood the above requirements, please press the space bar to get started. </p>`,
    choices: [' ']
}

var EAST_test_instr = {
    type: 'html-keyboard-response',
    stimulus: `
    <p style="text-align: left; font-size: 20pt">
    Formal mission:<br/><br/>
    Next came the formal task, where the white adjectives and colored nouns from the two previous practice tasks were randomly alternated. <br/>
    Continue to <span style="color:#FFD866">respond as accurately and quickly as possible</span>:<br/>
    - For <span style="color:#FFD866">positive</span> adjectives or <span style="color:${blu}">blue</span> nouns, press <span style="color:#FFD866">F</span>.<br/>
    - For <span style="color:#FFD866">negative</span> adjectives or <span style="color:${grn}">green</span> nouns, press <span style="color:#FFD866">J</span>.<br/>
    No feedback on what is correct or incorrect will be presented this time. <br/><br/>
    Now, please place your index fingers on the "F" key and the "J" key respectively, and ensure that your hands do not leave the keyboard during the experiment. <br/>
    If you have carefully read and fully understood the above requirements, please press the space bar to get started. </p>`,
    choices: [' ']
}

// Exp. Blocks

var EAST_prac1 = {
    // stimulus items
    timeline_variables: EAST_attrib_words,
    // single trial
    timeline: [{
            // fixation
            type: 'html-keyboard-response',
            stimulus: '+',
            choices: jsPsych.NO_KEYS,
            prompt: tag_LR1,
            trial_duration: 500,
            post_trial_gap: 0,
            response_ends_trial: false
        },
        {
            // word stimulus
            type: 'categorize-html',
            data: jsPsych.timelineVariable('data'),
            stimulus: jsPsych.timelineVariable('s'),
            choices: ['f', 'j'],
            key_answer: function() {
                switch (jsPsych.timelineVariable('data', true).stim_type) {
                    case 'pos':
                        return keyCode('f')
                    case 'neg':
                        return keyCode('j')
                }
            },
            prompt: tag_LR1,
            correct_text: tag_LR1 + feedback_right,
            incorrect_text: tag_LR1 + feedback_wrong,
            feedback_duration: 500,
            force_correct_button_press: true
        },
    ],
    // trial presentation
    repetitions: 2,
    randomize_order: true
}

var EAST_prac2 = {
    // stimulus items
    timeline_variables: EAST_target_words,
    // single trial
    timeline: [{
            // fixation
            type: 'html-keyboard-response',
            stimulus: '+',
            choices: jsPsych.NO_KEYS,
            prompt: tag_LR2,
            trial_duration: 500,
            post_trial_gap: 0,
            response_ends_trial: false
        },
        {
            // word stimulus
            type: 'categorize-html',
            data: jsPsych.timelineVariable('data'),
            stimulus: function() {
                return `<p style="color:${jsPsych.timelineVariable('data', true).stim_type}">${jsPsych.timelineVariable('s', true)}</p>`
            },
            choices: ['f', 'j'],
            key_answer: function() {
                switch (jsPsych.timelineVariable('data', true).stim_type) {
                    case blu:
                        return keyCode('f')
                    case grn:
                        return keyCode('j')
                }
            },
            prompt: tag_LR2,
            correct_text: tag_LR2 + feedback_right,
            incorrect_text: tag_LR2 + feedback_wrong,
            feedback_duration: 500,
            force_correct_button_press: true
        },
    ],
    // trial presentation
    repetitions: 1,
    randomize_order: true
}

var EAST_test_warmup = {
    type: 'html-keyboard-response',
    stimulus: '',
    choices: jsPsych.NO_KEYS,
    prompt: tag_LR3,
    trial_duration: 2000,
    response_ends_trial: false
}

var EAST_test = {
    // stimulus items (attrib words duplicated to balance frequency with target words)
    timeline_variables: [].concat(EAST_attrib_words, EAST_attrib_words, EAST_target_words),
    // single trial
    timeline: [{
            // fixation
            type: 'html-keyboard-response',
            stimulus: '+',
            choices: jsPsych.NO_KEYS,
            prompt: tag_LR3,
            trial_duration: 500,
            post_trial_gap: 0,
            response_ends_trial: false
        },
        {
            // word stimulus
            type: 'categorize-html',
            data: jsPsych.timelineVariable('data'),
            stimulus: function() {
                var stim_type = jsPsych.timelineVariable('data', true).stim_type
                var stimulus = jsPsych.timelineVariable('s', true)
                switch (stim_type) {
                    case 'pos':
                    case 'neg':
                        return stimulus
                    case blu:
                    case grn:
                        return `<p style="color:${stim_type}">${stimulus}</p>`
                }
            },
            choices: ['f', 'j'],
            key_answer: function() {
                switch (jsPsych.timelineVariable('data', true).stim_type) {
                    case 'pos':
                    case blu:
                        return keyCode('f')
                    case 'neg':
                    case grn:
                        return keyCode('j')
                }
            },
            prompt: tag_LR3,
            correct_text: tag_LR3,
            incorrect_text: tag_LR3,
            // Legacy evidence only: generated v8 code must replace this with
            // seeded jsPsych.randomization.randomInt(1000, 2000).
            feedback_duration: function() { return Math.random() * 1000 + 1000 }, // legacy 6.1 source
            show_stim_with_feedback: false,
            force_correct_button_press: false,
            on_finish: function(data) { data.formal = true }
        },
    ],
    // trial presentation
    repetitions: 2,
    randomize_order: true
}


/* Blocks: Feedbacks */

var debrief2 = {
    type: 'html-keyboard-response',
    stimulus: function() {
        var data = jsPsych.data.get()
        var east_a_grn = data.filter({ formal: true, correct: true, stim_type: grn, x: 'a' }).select('rt').mean()
        var east_a_blu = data.filter({ formal: true, correct: true, stim_type: blu, x: 'a' }).select('rt').mean()
        var east_b_grn = data.filter({ formal: true, correct: true, stim_type: grn, x: 'b' }).select('rt').mean()
        var east_b_blu = data.filter({ formal: true, correct: true, stim_type: blu, x: 'b' }).select('rt').mean()
        var east_c_grn = data.filter({ formal: true, correct: true, stim_type: grn, x: 'c' }).select('rt').mean()
        var east_c_blu = data.filter({ formal: true, correct: true, stim_type: blu, x: 'c' }).select('rt').mean()
        var east_a = east_a_grn - east_a_blu
        var east_b = east_b_grn - east_b_blu
        var east_c = east_c_grn - east_c_blu
        return `
        <p style="text-align: left">
        Result feedback (experimental part):<br/><br/>
        Your implicit attitude towards roses and peonies: ${east_a.toFixed(2)}<br/>
        Your implicit attitude towards air and land: ${east_b.toFixed(2)}<br/>
        Your implicit attitude towards cockroaches and mosquitoes: ${east_c.toFixed(2)}<br/>
        (less than 0 = negative, 0 = neutral, greater than 0 = positive)<br/><br/>
        (Press any key to continue)</p>`
    }
}


/* Combine Timelines */

var EAST = {
    timeline: [
        set_html_style_EAST,
        EAST_prac1_instr, EAST_prac1,
        EAST_prac2_instr, EAST_prac2,
        EAST_test_instr, EAST_test_warmup, EAST_test,
        set_html_style,
        debrief2,
    ]
}

var main_timeline = [
    set_html_style,
    EAST,
]


/* Launch jsPsych */

jsPsych.init({
    timeline: main_timeline,
    on_finish: function() {
        jsPsych.data.get().localSave('csv', `data_east_${subID}.csv`) // download from browser
        document.getElementById('jspsych-content').innerHTML += 'The experiment is over, thank you for your participation!'
    }
})
```
