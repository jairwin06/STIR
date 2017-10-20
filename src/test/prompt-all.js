import tracery from 'tracery-grammar'
import PromptLogic from '../server/models/prompt-logic'

const promptSyntax = {
  "sentence": [
    ""
  ],
  "name": "Avner"
};

console.log("Generating all cases");

const PRONOUN = 'he';

for (big5 in PromptLogic.big5s) {
    let big5Obj = PromptLogic.big5s[big5];
    let highsLows = {highs: big5Obj.highs, lows: big5Obj.lows};
    for (highLow in highsLows) {
        let highLowObj = highsLows[highLow];
        for (highLowBig5 in highLowObj) {
            let highLowBig5Obj = highLowObj[highLowBig5];
            for (facet in big5Obj.facets) {
                let facetObj = big5Obj.facets[facet];
                for (need in big5Obj.needs) {
                    let needObj = big5Obj.needs[need];
                    // Now I can generate the prompt!
                    let promptParagraphs = []
                    let promptInstructions = [];
                    promptParagraphs.push(highLowBig5Obj.paragraph[PRONOUN]);
                    promptParagraphs.push(facetObj.paragraph[PRONOUN]);

                    promptInstructions.push(highLowBig5Obj.instruction[PRONOUN]);
                    promptInstructions.push(facetObj.instructions[0][PRONOUN]);
                    promptInstructions.push(facetObj.instructions[1][PRONOUN]);
                    promptInstructions.push(needObj.instruction[PRONOUN]);

                    let flattenedPargraphs = [];
                    let flattenedInstructions = [];
                    for (promptParagraph of promptParagraphs) {
                        promptSyntax.sentence[0] = promptParagraph;
                        let grammar = tracery.createGrammar(promptSyntax);
                        flattenedPargraphs.push(grammar.flatten('#sentence#'));
                    }

                    for (promptInstruction of promptInstructions) {
                        promptSyntax.sentence[0] = promptInstruction;
                        let grammar = tracery.createGrammar(promptSyntax);
                        flattenedInstructions.push(grammar.flatten('#sentence#'));
                    }

                    console.log("-----------------------------------------------------------------------------");
                    console.log(big5 + "---> " + highLow + " " + highLowBig5 + "," + facet + "," + need);
                    console.log("-----------------------------------------------------------------------------");
                    console.log(flattenedPargraphs.join("\n"));
                    console.log("\n");
                    console.log(flattenedInstructions.join("\n"));
                    console.log("\n");
                }
            }
        }
    }
    
}
