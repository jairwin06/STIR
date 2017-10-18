import tracery from 'tracery-grammar'
import PromptLogic from '../server/models/prompt-logic'
import Personality from './personality'
import MiscUtil from '../app/util/misc'

const promptSyntax = {
  "sentence": [
    ""
  ],
  "name": "Avner"
};

const PRONOUN = 'he';

let data = JSON.parse(Personality);
console.log("Generating a case");

let promptParagraphs = [];
let promptInstructions = [];

// Sory the big5s by percentile
let big5s = data.personality.sort((a,b) => a.percentile < b.percentile);

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
// Sort them, get rancom from top 2
let facets = biggestBig5.children.sort((a,b) => a.percentile < b.percentile);
let top2Facets = facets.slice(0,2);
let facet = MiscUtil.getRandomElement(top2Facets); 
console.log(facet.trait_id);

promptParagraphs.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].paragraph[PRONOUN]);
promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].instructions[0][PRONOUN]);
promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].facets[facet.trait_id].instructions[1][PRONOUN]);

// Choose the need
let needs = data.needs.sort((a,b) => a.percentile < b.percentile);
let top2Needs = needs.slice(0,2);
let need = MiscUtil.getRandomElement(top2Needs); 
console.log(need.trait_id);

promptInstructions.push(PromptLogic.big5s[biggestBig5.trait_id].needs[need.trait_id].instruction[PRONOUN]);

// Result
let resultParagraphs = [];
let resultInstructions = [];

for (promptParagraph of promptParagraphs) {
    promptSyntax.sentence[0] = promptParagraph;
    let grammar = tracery.createGrammar(promptSyntax);
    resultParagraphs.push(grammar.flatten('#sentence#'));
}
for (promptInstruction of promptInstructions) {
    promptSyntax.sentence[0] = promptInstruction;
    let grammar = tracery.createGrammar(promptSyntax);
    resultInstructions.push(grammar.flatten('#sentence#'));
}

console.log(resultParagraphs);
console.log(resultInstructions);

