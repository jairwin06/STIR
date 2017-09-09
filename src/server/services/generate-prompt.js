import Session from '../models/session-persistent'
import tracery from 'tracery-grammar'
import WatsonUtil from '../util/watson'

export default function (hook) {
    console.log("Generate prompt!");

    let promptSyntax = {
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
      "name": hook.data.name,
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

    let sessionData = Session.getFor(hook.data.userId); 
    if (sessionData) {
        if (sessionData.location) {
            addLocation(promptSyntax, sessionData.location);
        }

        if (sessionData.personality) {
            addPersonality(promptSyntax, sessionData.personality);

            // Debug
            hook.data.debug = {
                watson: JSON.stringify(sessionData.personality)
            }
        }
    }

    console.log("Final prompt syntax", promptSyntax);
    let grammar = tracery.createGrammar(promptSyntax);
    hook.data.prompt = grammar.flatten('#sentences#')
    console.log("Final prompt", hook.data.prompt);
}

function addLocation(promptSyntax) {
   promptSyntax.sentences[0] += " #location_sentence#";
    
}

function addPersonality(promptSyntax, data) {
    console.log("Adding personality data");
    promptSyntax.sentences[0] += " #personality_sentence# #prompt_sentence#";
    Object.assign(promptSyntax, WatsonUtil.getDataForPrompt(data));
}

