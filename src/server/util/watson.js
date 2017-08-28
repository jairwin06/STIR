import PersonalityInsights from 'watson-developer-cloud/personality-insights/v3'

const PERSONALITY_INSIGHTS_USER = "01eb874e-0db5-4031-8258-7d85b4e00791";
const PERSONALITY_INSIGHTS_PASSWORD = "WNiGtOpqUAqN";

class WatsonUtil {
    constructor() {
        this.personalityInsights = new PersonalityInsights({
            username: PERSONALITY_INSIGHTS_USER,
            password: PERSONALITY_INSIGHTS_PASSWORD,
            version_date: '2016-10-19',
            url: "https://gateway-fra.watsonplatform.net/personality-insights/api"
        });
    }
    profile(text) {
        return new Promise((resolve, reject) => {
            console.log("Running profile");
            this.personalityInsights.profile({
              text: text,
              consumption_preferences: true
              },
              (err, response) => {
                  if (err) {
                    reject(new Error(err));
                  }
                  else {
                    console.log("Result", response);
                    resolve(response);
                  }
            });
        });
    }
};

// Singleton
let instance = new WatsonUtil();
export default instance;
