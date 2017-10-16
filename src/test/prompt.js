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
            for (highLowParagaph of highLowBig5Obj.paragraphs) {
                for (facet in big5Obj.facets) {
                    let facetObj = big5Obj.facets[facet];
                    for (facetParagrah of facetObj.paragraphs) {
                        for (need in big5Obj.needs) {
                            let needObj = big5Obj.needs[need];
                            for (needParagrah of needObj.paragraphs)  {
                                for (typeParagraph of PromptLogic.person_types[big5Obj.person_type].paragraphs) {

                                    // Now I can generate the prompt!
                                    let promptParagraphs = []
                                    promptParagraphs.push(highLowParagaph[PRONOUN]);
                                    promptParagraphs.push(facetParagrah[PRONOUN]);
                                    promptParagraphs.push(needParagrah[PRONOUN]);
                                    promptParagraphs.push(typeParagraph[PRONOUN]);

                                    promptParagraphs.push(highLowBig5Obj.instruction[PRONOUN]);
                                    promptParagraphs.push(facetObj.instruction[PRONOUN]);
                                    promptParagraphs.push(needObj.instruction[PRONOUN]);
                                    promptParagraphs.push(PromptLogic.person_types[big5Obj.person_type].instruction[PRONOUN]);

                                    let flattenedPargraphs = [];
                                    for (promptParagraph of promptParagraphs) {
                                        promptSyntax.sentence[0] = promptParagraph;
                                        let grammar = tracery.createGrammar(promptSyntax);
                                        flattenedPargraphs.push(grammar.flatten('#sentence#'));
                                    }
                                    console.log(flattenedPargraphs.join("\n"));
                                    console.log("-------------------------------");
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
