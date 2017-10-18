import Session from '../models/session-persistent'

const QuestionIDToBig5 = {
    1: {
        trait_id: "big5_agreeableness"
    },
    2: {
        trait_id: "big5_conscientiousness"
    },
    3: {
        trait_id: "big5_extraversion"
    },
    4: {
        trait_id: "big5_neuroticism"
    },
    5: {
        trait_id: "big5_openness"
    }
}

export default class QuestionsAnalyzeService {
    setup(app) {
        this.app = app;
    }
    create(data, params) {
        console.log("Questions Analyze service! params: ", data);
        Session.setFor(params.user._id, {questions: data.questions });

        return this.app.service("users").patch(params.user._id, data)
        .then(() => {
            return {status: "success", userName: data.name};
        })
        .catch((err) => {
            return Promise.reject(err);
        });
    }

    analyze(user,questions) {
        console.log("Question analysis!");
        Session.setFor(user._id, {questions: null });
        let result = questions.map(q => QuestionIDToBig5[q]);
        
        return Promise.resolve({status: "success", personality: result});
    }
}
