# IAT (Implicit Association Test) — jsPsych

> **Parent**: [psy-exp-coder](../../SKILL.md)
> **Config reference**: [iat](../../../psy-exp-designer/paradigms/iat.md)
> **Source**: [psychbruce/jspsych](https://github.com/psychbruce/jspsych) (Bao, 2020) · jsPsych 6.1.0

## Experiment Logic

The Implicit Association Test (IAT) measures the strength of automatic associations between concept pairs (e.g., Self vs. Others) and attribute pairs (e.g., Good vs. Bad) by comparing response latencies across two combined categorization tasks. The standard 7-block procedure (Greenwald, Nosek, & Banaji, 2003) interleaves single-category practice blocks with combined test blocks where both attribute and target stimuli appear intermixed, with category labels displayed at the top-left and top-right of the screen. Participants classify stimuli by pressing the F or J key according to the currently displayed label mapping.

The core D-score computation follows Greenwald et al. (2003): trials with RT > 10,000 ms are excluded; error-trial RTs are replaced with the block's mean correct RT plus a 600 ms penalty; separate D-scores are computed from the practice and test combined blocks (blocks 3/6 and 4/7) as the mean RT difference (incompatible minus compatible) divided by their pooled inclusive standard deviation; and the overall D-score is the average of the practice D and test D. If more than 10% of trials have RTs under 300 ms (indicating random fast responding), the result is flagged as invalid. The standardized 7-block structure is: Block 1 -- attribute discrimination practice (20 trials), Block 2 -- target discrimination practice (20 trials), Block 3 -- combined practice (20 trials), Block 4 -- combined test (40 trials), Block 5 -- reversed target discrimination practice (20 trials), Block 6 -- reversed combined practice (20 trials), Block 7 -- reversed combined test (40 trials).

Counterbalancing is achieved via `jsPsych.randomization.factorial` which randomly assigns one of four version combinations (attribute-order x target-order). The template object `iat_temp` defines the default stimulus sets; if the factorial result swaps an attribute or target pair, the labels and items are reassigned. The compatible-first vs. incompatible-first order is then determined by whether the attribute and target version numbers match. All IAT blocks are generated programmatically using the `blockTemplateIAT()` factory function, which creates a standard nested timeline per trial (ITI fixation followed by `categorize-html` classification with forced error correction). Participant metadata (IP address, city, user agent) is collected in the opening fullscreen block, and the debrief screen displays the computed D-scores along with their interpretation.

## Key Design Patterns

- Template object `iat_temp` with `attribA/B` and `targetA/B` (each containing a `label` and `items` array) for easy stimulus customization
- `JSON.parse(JSON.stringify(iat_temp))` for deep copy so that modifications to the working copy do not affect the original template
- `jsPsych.randomization.factorial({ attrib: [1, 2], target: [1, 2] })` for automatic counterbalancing across 4 possible version combinations
- `blockTemplateIAT(block_id, tag, stimuli, stim_func, key_answer_func, iti)` factory function that generates each IAT block with a standard nested trial structure
- `generateRandomTrials(n, arr, neighbor_different)` to create trial sequences of a specified length with optional neighbor-sequence constraint via `jsPsych.randomization.shuffleNoRepeats`
- `crossArrays(arr1, arr2)` to interleave attribute and target stimuli in combined blocks, ensuring attribute/target pairs alternate
- `replaceWrongRT(df)` implementing the Greenwald et al. (2003) error penalty: wrong-trial RTs are replaced with the block's mean correct RT + 600 ms
- D-score computation using pooled inclusive SD over compatible + incompatible trials, separate practice D and test D, and a validity check flagging datasets with >10% RTs under 300 ms
- IP tracking via the `returnCitySN` JSON object (injected by an external `<script>` tag in `index.html`) in the `open_fullscreen` block's data
- CSS tag classes (`.tag-left`, `.tag-right`, `.tag-bottom`) with absolute positioning for consistent category label display across all blocks

## Code Example

```javascript
/**
 * IAT (Implicit Association Test)
 * Source: psychbruce/jspsych (Bao, 2020)
 * jsPsych 6.1.0
 */


/* Setting HTML Styles */

// CSS styles (in HTML <style> tag)
document.head.innerHTML +=
    `<style>
    body { user-select: none; -ms-user-select: none; -moz-user-select: none; -webkit-user-select: none; }
    .jspsych-btn { font-size: 16pt; font-family: Microsoft Yahei; font-weight: normal; margin: 1em 0em; }
    .tag-left { font-size: 24pt; position: absolute; top: 15%; left: 25%; }
    .tag-right { font-size: 24pt; position: absolute; top: 15%; right: 25%; }
    .tag-bottom { font-size: 20pt; position: absolute; bottom: 5%; left: 0; right: 0; }
    </style>`

// HTML DOM styles (by using JS function alone or in jsPsych 'on_start', 'on_load', 'on_finish' parameters)
function set_html_style() {
    document.body.style.backgroundColor = 'rgb(250, 250, 250)' // background color
    document.body.style.color = 'black' // font color
    document.body.style.fontSize = '20pt'
    document.body.style.fontFamily = 'Microsoft Yahei'
    document.body.style.fontWeight = 'normal' // 'normal', 'bold'
    document.body.style.lineHeight = '1.6em' // line space
    document.body.style.cursor = 'default' // 'default', 'none', 'wait', ...
    document.body.onselectstart = function() { return false }
    document.body.oncontextmenu = function() { return false }
    document.onkeydown = function() {
        // Block keyboard keys (https://www.bejson.com/othertools/keycodes/)
        if ((event.keyCode in { 27: 'Esc', 116: 'F5', 123: 'F12' }) ||
            (event.ctrlKey && event.keyCode in { 85: 'U' })
        ) { return false }
    }
}

function set_html_style_iat() {
    document.body.style.backgroundColor = 'black'
    document.body.style.color = 'white'
    document.body.style.fontSize = '32pt'
    document.body.style.fontFamily = 'Microsoft Yahei'
    document.body.style.fontWeight = 'normal'
    document.body.style.lineHeight = '1.2em'
    document.body.style.cursor = 'none'
}


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


/* Blocks: Basics */

var open_fullscreen = {
    type: 'fullscreen',
    fullscreen_mode: true,
    on_start: set_html_style,
    data: {
        // must add the following <script> in 'index.html', which will return a JSON object 'returnCitySN':
        //     <script src="https://pv.sohu.com/cityjson"></script>
        id: subID,
        ip: returnCitySN['cip'],
        ip_city: returnCitySN['cname'],
        ip_city_id: returnCitySN['cid'],
        user_agent: navigator.userAgent,
    },
    message: `
    <p style="font: 16pt Microsoft Yahei; text-align: left; line-height: 1.6em">
    <b>
    The quiz will start on a "full screen page". To ensure the best results, please:<br/>
    (1) Take the test on your computer and use a mainstream browser to open this webpage<br/>
    (Chrome, Edge, Firefox, Safari, etc., do not use IE)<br/>
    (2) Close other running programs on the computer or minimize them<br/>
    (3) Set your mobile phone to silent and minimize environmental noise interference<br/>
    (4) Do not exit full screen during the test<br/>
    (5) Be sure to answer carefully<br/><br/>
    </b>
    If you agree to participate and clearly understand the above requirements, please click Start:
    </p>`,
    button_label: 'Click here to start in full screen',
    delay_after: 100
}

var close_fullscreen = {
    type: 'fullscreen',
    fullscreen_mode: false,
    delay_after: 0
}


/* Blocks: IAT */

// Template (the ONLY thing you need to modify)

var key_L = 'f'
var key_R = 'j'
var iat_temp = {
    // Pairs A & Pairs B should be compatible
    attribA: { label: 'Okay', items: ['Smart', 'Success', 'Noble', 'Excellent', 'Happiness'] },
    attribB: { label: 'bad', items: ['Stupid', 'failed', 'Despicable', 'Bad', 'Misery'] },
    targetA: { label: 'Self', items: ['I', 'me', 'my', 'mine', 'myself'] },
    targetB: { label: 'Other', items: ['they', 'them', 'their', 'theirs', 'themselves'] },
}
var attrib_color = 'white'
var target_color = 'rgb(150, 250, 100)'

// Randomize stimuli pairs (left vs. right; compatible-blocks first vs. incompatible-blocks first)

var version = jsPsych.randomization.factorial({ attrib: [1, 2], target: [1, 2] })[0] // one of four, e.g., { attrib: 2, target: 1 }
var compatible_first = (version.attrib == version.target) ? true : false

var iat = JSON.parse(JSON.stringify(iat_temp)) // Deep copy (iat_temp is only a pointer, shallow copy will modify both simultaneously)
if (version.attrib == 2) {
    iat.attribA.label = iat_temp.attribB.label
    iat.attribA.items = iat_temp.attribB.items
    iat.attribB.label = iat_temp.attribA.label
    iat.attribB.items = iat_temp.attribA.items
}
if (version.target == 2) {
    iat.targetA.label = iat_temp.targetB.label
    iat.targetA.items = iat_temp.targetB.items
    iat.targetB.label = iat_temp.targetA.label
    iat.targetB.items = iat_temp.targetA.items
}

// Top-left and top-right tags

var tag_IAT_prac_attrib = `<div class="tag-left">Press the "${key_L.toUpperCase()}" key:<br/>
                           <span style="color:${attrib_color}">${iat.attribA.label}</span></div>
                           <div class="tag-right">Press the "${key_R.toUpperCase()}" key:<br/>
                           <span style="color:${attrib_color}">${iat.attribB.label}</span></div>`

var tag_IAT_prac_target_1 = `<div class="tag-left">Press the "${key_L.toUpperCase()}" key:<br/>
                             <span style="color:${target_color}">${iat.targetA.label}</span></div>
                             <div class="tag-right">Press the "${key_R.toUpperCase()}" key:<br/>
                             <span style="color:${target_color}">${iat.targetB.label}</span></div>`

var tag_IAT_prac_target_2 = `<div class="tag-left">Press the "${key_L.toUpperCase()}" key:<br/>
                             <span style="color:${target_color}">${iat.targetB.label}</span></div>
                             <div class="tag-right">Press the "${key_R.toUpperCase()}" key:<br/>
                             <span style="color:${target_color}">${iat.targetA.label}</span></div>`

var tag_IAT_test_1 = `<div class="tag-left">Press the "${key_L.toUpperCase()}" key:<br/>
                      <span style="color:${attrib_color}">${iat.attribA.label}</span><br/>or<br/>
                      <span style="color:${target_color}">${iat.targetA.label}</span></div>
                      <div class="tag-right">Press the "${key_R.toUpperCase()}" key:<br/>
                      <span style="color:${attrib_color}">${iat.attribB.label}</span><br/>or<br/>
                      <span style="color:${target_color}">${iat.targetB.label}</span></div>`

var tag_IAT_test_2 = `<div class="tag-left">Press the "${key_L.toUpperCase()}" key:<br/>
                      <span style="color:${attrib_color}">${iat.attribA.label}</span><br/>or<br/>
                      <span style="color:${target_color}">${iat.targetB.label}</span></div>
                      <div class="tag-right">Press the "${key_R.toUpperCase()}" key:<br/>
                      <span style="color:${attrib_color}">${iat.attribB.label}</span><br/>or<br/>
                      <span style="color:${target_color}">${iat.targetA.label}</span></div>`

// Instructions

var IAT_instr0 = {
    type: 'html-button-response',
    data: { version_attrib: version.attrib, version_target: version.target },
    stimulus: `
    <h3>Word classification task</h3>
    <p>In the next task, you will need to classify a series of words. <br/>
    Please familiarize yourself with these words first, which will help you complete the following tasks. </p>
    <table align="center" border=1 cellpadding=3 cellspacing=0>
    <tr> <th>Category</th> <th>Word</th> </tr>
    <tr> <td>&emsp;${iat_temp.attribA.label}&emsp;</td> <td>&emsp;${iat_temp.attribA.items.join('、')}&emsp;</td> </tr>
    <tr> <td>&emsp;${iat_temp.attribB.label}&emsp;</td> <td>&emsp;${iat_temp.attribB.items.join('、')}&emsp;</td> </tr>
    <tr> <td>&emsp;${iat_temp.targetA.label}&emsp;</td> <td>&emsp;${iat_temp.targetA.items.join('、')}&emsp;</td> </tr>
    <tr> <td>&emsp;${iat_temp.targetB.label}&emsp;</td> <td>&emsp;${iat_temp.targetB.items.join('、')}&emsp;</td> </tr>
    </table><br/>`,
    choices: ['<span id="timer">Continue in 10</span> seconds'],
    button_html: btn_html_timer,
    on_finish: set_html_style_iat
}

var IAT_instr1 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 1: Classify the words “${iat.attribA.label}” and “${iat.attribB.label}” ——<br/>
    Different words will appear in the center of the screen, and category labels will always be displayed at the top of the screen<br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_prac_attrib
}

var IAT_instr2 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 2: Classify the words “${iat.targetA.label}” and “${iat.targetB.label}” ——<br/>
    <span style="color:#78DCE8"><b>Note above that the category labels and words to be classified have changed</b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_prac_target_1
}

var IAT_instr3 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 3: Classify the words “${iat.attribA.label}/${iat.targetA.label}” and “${iat.attribB.label}/${iat.targetB.label}” ——<br/>
    <span style="color:#78DCE8"><b>Pay attention to the top, the previous four types of words will be mixed together and presented alternately</b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_test_1
}

var IAT_instr4 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 4: Classify the words “${iat.attribA.label}/${iat.targetA.label}” and “${iat.attribB.label}/${iat.targetB.label}” ——<br/>
    <span style="color:#78DCE8"><b>It is exactly the same as the task just now, please classify these four types of words again</b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_test_1
}

var IAT_instr5 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 5: Classify the words “${iat.targetB.label}” and “${iat.targetA.label}” ——<br/>
    <span style="color:#FF6188"><b>Attention above, there are still two category labels, but their positions have been swapped!</b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_prac_target_2
}

var IAT_instr6 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 6: Classify the words “${iat.attribA.label}/${iat.targetB.label}” and “${iat.attribB.label}/${iat.targetA.label}” ——<br/>
    <span style="color:#FF6188"><b>Attention above, the four types of words will appear alternately in new combinations! </b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_test_2
}

var IAT_instr7 = {
    type: 'html-keyboard-response',
    stimulus: `
    <div class="tag-bottom"><p>
    —— Task 7: Classify the words “${iat.attribA.label}/${iat.targetB.label}” and “${iat.attribB.label}/${iat.targetA.label}” ——<br/>
    <span style="color:#FF6188"><b>It is exactly the same as the previous task, please classify these four types of words again</b></span><br/>
    <span style="color:#FFD866"><b>Please follow the prompts on the label above and respond to the keystrokes as correctly and quickly as possible</b></span><br/>
    If you press the wrong key, <span style="color:red"> X </span> will appear. Press the other key to correct your response and continue.<br/><br/>
    Please place the index fingers of both hands on the "${key_L.toUpperCase()}" key and the "${key_R.toUpperCase()}" key respectively<br/>
    Press <Spacebar> to start
    </p></div>`,
    choices: [' '],
    prompt: tag_IAT_test_2
}

// Generate IAT stimuli and blocks

function generateRandomTrials(n_trials, arr, neighbor_different = true) {
    var repeats = Math.floor(n_trials / arr.length)
    if (repeats >= 1) {
        var array1 = jsPsych.randomization.repeat(arr, repeats)
        var array2 = jsPsych.randomization.sampleWithoutReplacement(arr, n_trials - array1.length)
        var array = array1.concat(array2)
    } else {
        var array = jsPsych.randomization.sampleWithoutReplacement(arr, n_trials)
    }
    if (neighbor_different) {
        array = jsPsych.randomization.shuffleNoRepeats(array)
    }
    return array
}

function crossArrays(arr1, arr2) {
    var arr = []
    for (var i in arr1) { arr.push(arr1[i], arr2[i]) }
    return arr
}

function toStimuli(array) {
    for (var i in array) { array[i] = { s: array[i] } }
    return array
}

function blockTemplateIAT(block_id, tag, stimuli, stim_func, key_answer_func, iti = 400) {
    var IAT = {
        timeline_variables: toStimuli(stimuli),
        timeline: [{
            type: 'html-keyboard-response',
            stimulus: '',
            choices: jsPsych.NO_KEYS,
            prompt: tag,
            trial_duration: iti, // inter-trial interval
            response_ends_trial: false
        }, {
            type: 'categorize-html',
            data: { IAT: block_id },
            stimulus: stim_func,
            choices: [key_L, key_R],
            key_answer: key_answer_func,
            prompt: tag,
            correct_text: tag,
            incorrect_text: tag + feedback_wrong,
            feedback_duration: 0,
            show_stim_with_feedback: true,
            force_correct_button_press: true,
            on_finish: function(data) { data.RT = data.rt } // for computing IAT D-score in feedback
        }]
    }
    return IAT
}

/**
 * Standard IAT procedure (adapted from Greenwald, Nosek, & Banaji, 2003, JPSP):
 *  Block   Trials      Function    Type
 *      1       20      Practice    Attribute
 *      2       20      Practice    Target
 *      3       20      Practice    Combined
 *      4       40      Test        Combined
 *      5       20      Practice    Target (reversed)
 *      6       20      Practice    Combined (reversed)
 *      7       40      Test        Combined (reversed)
 */

var IAT1 = blockTemplateIAT(
    block_id = 1,
    tag = tag_IAT_prac_attrib,
    stimuli = generateRandomTrials(20, [].concat(iat.attribA.items, iat.attribB.items)),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        return `<p style="color:${attrib_color}">${stim}</p>`
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if (iat.attribA.items.includes(stim)) { return keyCode(key_L) }
        if (iat.attribB.items.includes(stim)) { return keyCode(key_R) }
    }
)

var IAT2 = blockTemplateIAT(
    block_id = 2,
    tag = tag_IAT_prac_target_1,
    stimuli = generateRandomTrials(20, [].concat(iat.targetA.items, iat.targetB.items)),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        return `<p style="color:${target_color}">${stim}</p>`
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if (iat.targetA.items.includes(stim)) { return keyCode(key_L) }
        if (iat.targetB.items.includes(stim)) { return keyCode(key_R) }
    }
)

var IAT3 = blockTemplateIAT(
    block_id = 3,
    tag = tag_IAT_test_1,
    stimuli = crossArrays(
        generateRandomTrials(10, [].concat(iat.attribA.items, iat.attribB.items)),
        generateRandomTrials(10, [].concat(iat.targetA.items, iat.targetB.items)),
    ),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.attribB.items).includes(stim)) {
            return `<p style="color:${attrib_color}">${stim}</p>`
        }
        if ([].concat(iat.targetA.items, iat.targetB.items).includes(stim)) {
            return `<p style="color:${target_color}">${stim}</p>`
        }
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.targetA.items).includes(stim)) { return keyCode(key_L) }
        if ([].concat(iat.attribB.items, iat.targetB.items).includes(stim)) { return keyCode(key_R) }
    }
)

var IAT4 = blockTemplateIAT(
    block_id = 4,
    tag = tag_IAT_test_1,
    stimuli = crossArrays(
        generateRandomTrials(20, [].concat(iat.attribA.items, iat.attribB.items)),
        generateRandomTrials(20, [].concat(iat.targetA.items, iat.targetB.items)),
    ),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.attribB.items).includes(stim)) {
            return `<p style="color:${attrib_color}">${stim}</p>`
        }
        if ([].concat(iat.targetA.items, iat.targetB.items).includes(stim)) {
            return `<p style="color:${target_color}">${stim}</p>`
        }
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.targetA.items).includes(stim)) { return keyCode(key_L) }
        if ([].concat(iat.attribB.items, iat.targetB.items).includes(stim)) { return keyCode(key_R) }
    }
)

var IAT5 = blockTemplateIAT(
    block_id = 5,
    tag = tag_IAT_prac_target_2,
    stimuli = generateRandomTrials(20, [].concat(iat.targetB.items, iat.targetA.items)),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        return `<p style="color:${target_color}">${stim}</p>`
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if (iat.targetB.items.includes(stim)) { return keyCode(key_L) }
        if (iat.targetA.items.includes(stim)) { return keyCode(key_R) }
    }
)

var IAT6 = blockTemplateIAT(
    block_id = 6,
    tag = tag_IAT_test_2,
    stimuli = crossArrays(
        generateRandomTrials(10, [].concat(iat.attribA.items, iat.attribB.items)),
        generateRandomTrials(10, [].concat(iat.targetB.items, iat.targetA.items)),
    ),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.attribB.items).includes(stim)) {
            return `<p style="color:${attrib_color}">${stim}</p>`
        }
        if ([].concat(iat.targetB.items, iat.targetA.items).includes(stim)) {
            return `<p style="color:${target_color}">${stim}</p>`
        }
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.targetB.items).includes(stim)) { return keyCode(key_L) }
        if ([].concat(iat.attribB.items, iat.targetA.items).includes(stim)) { return keyCode(key_R) }
    }
)

var IAT7 = blockTemplateIAT(
    block_id = 7,
    tag = tag_IAT_test_2,
    stimuli = crossArrays(
        generateRandomTrials(20, [].concat(iat.attribA.items, iat.attribB.items)),
        generateRandomTrials(20, [].concat(iat.targetB.items, iat.targetA.items)),
    ),
    stim_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.attribB.items).includes(stim)) {
            return `<p style="color:${attrib_color}">${stim}</p>`
        }
        if ([].concat(iat.targetB.items, iat.targetA.items).includes(stim)) {
            return `<p style="color:${target_color}">${stim}</p>`
        }
    },
    key_answer_func = function() {
        var stim = jsPsych.timelineVariable('s', true)
        if ([].concat(iat.attribA.items, iat.targetB.items).includes(stim)) { return keyCode(key_L) }
        if ([].concat(iat.attribB.items, iat.targetA.items).includes(stim)) { return keyCode(key_R) }
    }
)


/* Blocks: Feedbacks */

function replaceWrongRT(df) {
    // Replace each wrong-trial RT with block mean + 600 ms (Greenwald et al., 2003, JPSP)
    var rt_mean = df.filter({ correct: true }).select('rt').mean()
    var wrong = df.filter({ correct: false }).values() // raw data array (modifiable)
    for (var i in wrong) {
        wrong[i]['RT'] = rt_mean + 600
    }
}

var IAT_results = { IAT_D: null, IAT_D_prac: null, IAT_D_test: null }

var debrief_IAT = {
    type: 'html-keyboard-response',
    on_start: set_html_style,
    stimulus: function() {
        // See the scoring algorithm of IAT D-score in Greenwald et al. (2003)
        if (compatible_first) {
            var block_ids = { compat: [{ IAT: 3 }, { IAT: 4 }], incomp: [{ IAT: 6 }, { IAT: 7 }] }
        } else {
            var block_ids = { compat: [{ IAT: 6 }, { IAT: 7 }], incomp: [{ IAT: 3 }, { IAT: 4 }] }
        }
        var df_iat_raw = jsPsych.data.get().filter([{ IAT: 3 }, { IAT: 4 }, { IAT: 6 }, { IAT: 7 }]) // data frame (jsPsych 'Data Collection' class)
        var df = df_iat_raw.filterCustom(function(trial) { return trial.rt < 10000 })

        var n_trials_less_than_300ms = df.filterCustom(function(trial) { return trial.rt < 300 }).count()
        var p_too_fast = n_trials_less_than_300ms / df.count()
        var validity = (p_too_fast < 0.1) ? `` :
            `<span style="color:red">Too many responses were faster than the prespecified threshold (${(100 * p_too_fast).toFixed(1)}%). This session has been flagged for review.</span><br/>`

        var iat_compat_prac = df.filter(block_ids.compat[0])
        var iat_compat_test = df.filter(block_ids.compat[1])
        var iat_incomp_prac = df.filter(block_ids.incomp[0])
        var iat_incomp_test = df.filter(block_ids.incomp[1])

        replaceWrongRT(iat_compat_prac)
        replaceWrongRT(iat_compat_test)
        replaceWrongRT(iat_incomp_prac)
        replaceWrongRT(iat_incomp_test)

        var mean_diff_prac = iat_incomp_prac.select('RT').mean() - iat_compat_prac.select('RT').mean()
        var mean_diff_test = iat_incomp_test.select('RT').mean() - iat_compat_test.select('RT').mean()
        var sd_pooled_prac = iat_compat_prac.join(iat_incomp_prac).select('rt').sd()
        var sd_pooled_test = iat_compat_test.join(iat_incomp_test).select('rt').sd()
        var IAT_D_prac = mean_diff_prac / sd_pooled_prac
        var IAT_D_test = mean_diff_test / sd_pooled_test
        var IAT_D = (IAT_D_prac + IAT_D_test) / 2

        IAT_results.IAT_D = IAT_D
        IAT_results.IAT_D_prac = IAT_D_prac
        IAT_results.IAT_D_test = IAT_D_test

        return `
        <p style="text-align: left">
        <b>Result feedback:</b><br/>
        ${validity}
        Your Implicit Association Test <em>D </em> score = <b>${IAT_D.toFixed(2)}</b><br/>
        ——Practice task<em>D </em> score = ${IAT_D_prac.toFixed(2)}<br/>
        (reaction time difference = ${mean_diff_prac.toFixed(0)}ms, pooled standard deviation = ${sd_pooled_prac.toFixed(0)}ms)<br/>
        ——Formal task<em>D </em> score = ${IAT_D_test.toFixed(2)}<br/>
        (reaction time difference = ${mean_diff_test.toFixed(0)}ms, pooled standard deviation = ${sd_pooled_test.toFixed(0)}ms)<br/>
        <br/><b><em>D </em>Explanation of scores:</b><br/>
        Greater than 0: The implicit connection between "${iat_temp.attribA.label} + ${iat_temp.targetA.label}" and "${iat_temp.attribB.label} + ${iat_temp.targetB.label}" is closer<br/>
        Less than 0: The implicit connection between "${iat_temp.attribA.label} + ${iat_temp.targetB.label}" and "${iat_temp.attribB.label} + ${iat_temp.targetA.label}" is closer<br/>
        Absolute values: 0.2 = small effect, 0.5 = medium effect, 0.8 = large effect<br/>
        <br/>(Press any key to continue)</p>`
    },
    on_finish: function(data) {
        data.varname = 'IAT_feedback'
        data.summary = JSON.stringify(IAT_results)
            // extract in R:  jsonlite::fromJSON(subset(data, varname=='IAT_feedback')$summary)
    }
}


/* Combine Timelines */

var IAT = {
    timeline: [
        IAT_instr0,
        IAT_instr1, IAT1,
        IAT_instr2, IAT2,
        IAT_instr3, IAT3,
        IAT_instr4, IAT4,
        IAT_instr5, IAT5,
        IAT_instr6, IAT6,
        IAT_instr7, IAT7,
    ]
}

var main_timeline = [
    open_fullscreen,
    IAT,
    debrief_IAT,
    close_fullscreen,
]


/* Launch jsPsych */

jsPsych.init({
    timeline: main_timeline,
    on_finish: function() {
        jsPsych.data.get().localSave('csv', `data_iat_demo_${subID}.csv`) // download from browser
        document.getElementById('jspsych-content').innerHTML += 'The experiment is over, thank you for your participation!'
        setTimeout(window.close, 10 * 1000) // not effective in Edge
    }
})
```
