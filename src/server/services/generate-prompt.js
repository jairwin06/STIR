import Session from '../models/session-persistent'
import tracery from 'tracery-grammar'
import WatsonUtil from '../util/watson'

const promptSyntax = {
  "sentences": [
    "#intro_sentence#"
  ],
  "intro_sentence": [
    "Today you’ll be waking: #name#."
  ],
  "location_sentence": [
    "#name# lives in #location#, where it's #weather#.",
    "Right now it's #weather# in #name#'s neck of the woods, #location#.",
    "In #location#, where #name# lives, it's currently #weather#.",
    "The weather in #pronoun_possessive# city, #location#, is currently #weather#."
  ],
  "personality_sentence": [
    "#name# #description_sentence#, with a strong leaning toward #personality1_child1# and #personality1_child2#.",
    "As someone who #description_sentence#, #name# has a talent for #personality1_child1# and #personality1_child2#.",
    "#name# #description_sentence#, with a strong leaning towards #personality1_child1# and #personality1_child2#."
  ],
  "pronoun": "They",
  "pronoun_possessive": "Their",
  "location": "Somewhere",
  "weather": "Unknown",
  "personality1": null,
  "personality1_child1": null,
  "personality1_child2": null,
  "description_sentence": null,
  "prompt_sentence": null
};

const DUMMY_PROMPT = "Today you’ll be waking Charlotte, from New York City. Here are some things about Charlotte that may help you create your message: Charlotte is deeply philosophical and is an appreciator of beauty, art and nature. Charlotte is supremely intellectual. She is intrigued by new ideas and loves to explore them. She needs curiosity in her life. One thing you might want to know about Charlotte too, is that she is easily rattled, easily irked. She can be uneasy and fearful about the future. For your message to Charlotte, we encourage you to share how deeply impressed you are by her intellect. Remind her to let her curiosity and quest for novel ideas guide her through this new day. And, reassure her that it’s okay to feel anxious sometimes, and that it doesn’t have to get in her way and she goes forth.";


export default function (hook) {
    console.log("Generate prompt!");

    Session.setFor(hook.data.userId, {newAlarm: null});
    generatePrompt(hook.app, hook.result._id, hook.data.analysis, hook.params.user, 1);
}


function generatePrompt(app, alarmId, analysis,  user, tryNumber) {
    let promptData = Object.assign({}, promptSyntax);
    promptData.name = user.name;

    let alarmData = {
        analyzed: true
    }

    Promise.resolve({})
    .then(() => {
        if (analysis == 'twitter') {
            return app.service('twitter-analyze').analyze(user)
        } else if (analysis == 'facebook') {
            return app.service('fbanalyze').analyze(user)
        } else {
            return null;
        }
    })
    .then((result) => {
        if (result) {
            if (result.status == "success") {
                addPersonality(promptData, result.personality)
                alarmData.debug = {
                    watson: JSON.stringify(result.personality)
                }
            } else {
                throw new Error(result.message);
            }
        }
        console.log("Final prompt syntax", promptData);
        let grammar = tracery.createGrammar(promptData);
        //alarmData.prompt = grammar.flatten('#sentences#')
        alarmData.prompt = DUMMY_PROMPT;

        console.log("Final prompt", alarmData.prompt);
        return app.service('alarms/sleeper').patch(alarmId,alarmData);
    })
    .catch((err) => {
        // TODO: Retry when twitter is not available, and any other error?
        console.log("Error generating prompt!", err);
    })
}

function addPersonality(promptData, data) {
    console.log("Adding personality data");
    promptData.sentences[0] += " #personality_sentence# #prompt_sentence#";
    Object.assign(promptData, WatsonUtil.getDataForPrompt(data));
}

