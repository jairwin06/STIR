import Session from '../models/session-persistent'
import tracery from 'tracery-grammar'
import WatsonUtil from '../util/watson'
import PromptLogic from '../models/prompt-logic'
import MiscUtil from '../../app/util/misc'

const promptSyntax = {
  "sentence": [
    ""
  ],
  "name": "Sleeper",
  "pronoun": "he"
};

export default function (hook) {
    console.log("Generate prompt!");

    Session.setFor(hook.data.userId, {newAlarm: null});
    generatePrompt(hook.app, hook.result, hook.data.analysis, hook.params.user, 1);
}


function generatePrompt(app, alarm, analysis,  user, tryNumber) {
    let promptData = Object.assign({}, promptSyntax);
    promptData.name = user.name;
    promptData.pronoun = user.pronoun;

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
            return app.service('questions-analyze').analyze(user,alarm.questions)
        }
    })
    .then((result) => {
        if (result) {
            if (result.status == "success") {
                alarmData.debug = {
                    watson: JSON.stringify(result.personality)
                }
                alarmData.prompt = runLogic(promptData, result.personality, analysis);
            } else {
                throw new Error(result.message);
            }
        }
        console.log("Final prompt", alarmData.prompt);

        return app.service('alarms/sleeper').patch(alarm._id,alarmData);
    })
    .catch((err) => {
        // TODO: Retry when twitter is not available, and any other error?
        console.log("Error generating prompt!", err);
    })
}


function runLogic(promptData, data, analysis) {
    let promptParagraphs = [];
    let promptInstructions = [];

    const PRONOUN = promptData.pronoun;
    let big5s;

    if (analysis == 'questions') {
        console.log("Analyzing by questions!", data);
        big5s = data;
    } else {
        big5s = data.personality.sort((a,b) => a.percentile < b.percentile);
    }

    // Sort the big5s by percentile
    let biggestBig5 = big5s[0];
    console.log(biggestBig5.trait_id);

    let remaining = {
        highs : big5s.slice(1,3),
        lows  : big5s.slice(3,5),
    }

    // Choose a high or a low?
    let choice = (Math.random() < 0.5) ? 'highs' : 'lows';
    console.log("Chose " + choice);

    // Choose the big5
    let chosenBig5 = MiscUtil.getRandomElement(remaining[choice]);
    console.log(chosenBig5.trait_id)

    promptParagraphs.push(PromptLogic.big5s[biggestBig5.trait_id][choice][chosenBig5.trait_id].paragraph[PRONOUN]);
    promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id][choice][chosenBig5.trait_id].instruction[PRONOUN]);

    // Choose the facet
    let topFacets;
    
    if (analysis == 'questions') {
        // All that we have
        topFacets = [];
        for (let facet in PromptLogic.big5s[biggestBig5.trait_id].facets) {
            topFacets.push({
                trait_id: facet
            });
        }
    } else {
        // Sort them, get random from top 2
        let facets = biggestBig5.children.sort((a,b) => a.percentile < b.percentile);
        topFacets = facets.slice(0,2);
    }

    let facet = MiscUtil.getRandomElement(topFacets); 
    console.log(facet.trait_id);

    promptParagraphs.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].paragraph[PRONOUN]);
    promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].instructions[0][PRONOUN]);
    promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].instructions[1][PRONOUN]);

    // Choose the need
    let topNeeds;

    if (analysis == 'questions') {
        // All that we have
        topNeeds = [];
        for (let need in PromptLogic.big5s[biggestBig5.trait_id].needs) {
            topNeeds.push({
                trait_id: need
            });
        }
    } else {
        // Sort them, get random from top 2
        let needs = data.needs.sort((a,b) => a.percentile < b.percentile);
        topNeeds = needs.slice(0,2);
    }

    let need = MiscUtil.getRandomElement(topNeeds); 
    console.log(need.trait_id);

    promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].needs[need.trait_id].instruction[PRONOUN]);

    // Result
    let resultParagraphs = [];
    let resultInstructions = [];

    for (promptParagraph of promptParagraphs) {
        promptData.sentence[0] = promptParagraph;
        let grammar = tracery.createGrammar(promptData);
        resultParagraphs.push(grammar.flatten('#sentence#'));
    }
    for (promptInstruction of promptInstructions) {
        promptData.sentence[0] = promptInstruction;
        let grammar = tracery.createGrammar(promptData);
        resultInstructions.push(grammar.flatten('#sentence#'));
    }

    return {
        paragraphs: resultParagraphs,
        instructions: resultInstructions
    }
}
