import PersonalityInsights from 'watson-developer-cloud/personality-insights/v3'

const PERSONALITY_INSIGHTS_USER = process.env['PERSONALITY_INSIGHTS_USER'];
const PERSONALITY_INSIGHTS_PASSWORD = process.env['PERSONALITY_INSIGHTS_PASSWORD']

class WatsonUtil {
    constructor() {
        this.personalityInsights = new PersonalityInsights({
            username: PERSONALITY_INSIGHTS_USER,
            password: PERSONALITY_INSIGHTS_PASSWORD,
            version_date: '2016-10-19',
            url: "https://gateway-fra.watsonplatform.net/personality-insights/api"
        });

        this.traitDescriptions = {
          'openness': 'has a very open outlook',
          'conscientiousness': 'pays attention to details',
          'extraversion': 'enjoys going to parties and meeting new people',
          'agreeableness': 'is friendly and nice',
          'emotional range': 'has a broad emotional range',
       };

       this.traitPrompts = {
          'openness': 'Imagine you’re their close friend. Tell them something that will inspire them to try something new today.',
          'conscientiousness': 'Imagine you’re their personal assistant and you admire everything they do. Give them a list of what to do today.',
          'extraversion': 'Appeal to their social butterfly tendencies by telling them about a time you woke up early to see your friends.',
          'agreeableness': 'Think about positive messages you have heard in the past and repeat one to them.',
          'emotional range': 'They respond to softly spoken words. Imagine you are their mother waking them up.',
       }
    }
    profile(text) {
        return new Promise((resolve, reject) => {
            console.log("Running profile");
            this.personalityInsights.profile({
              text: text,
              consumption_preferences: true,
              raw_scores: true
              },
              (err, response) => {
                  if (err) {
                    reject(new Error(err));
                  }
                  else {
                    resolve(response);
                  }
            });
        });
    }
    getDataForPrompt(data){
        return  {
            personality1 : data.personality[0].name.toLowerCase(),
            personality1_child1: data.personality[0].children[0].name.toLowerCase(),
            personality1_child2: data.personality[0].children[1].name.toLowerCase(),
            description_sentence: this.traitDescriptions[data.personality[0].name.toLowerCase()],
            prompt_sentence: this.traitPrompts[data.personality[0].name.toLowerCase()]
        }
    }
};

// Singleton
let instance = new WatsonUtil();
export default instance;
