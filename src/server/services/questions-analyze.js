import Session from '../models/session-persistent'

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

    analyze(user) {
        try {
            console.log("Done");
            Session.setFor(user._id, {questions: null });
            return Promise.resolve({status: "success", personality: {}});
        }
        catch(err) {
            console.log("Error in QuestionsnalyzerService", err);
            return Promise.reject(err);
        }
    }
}
