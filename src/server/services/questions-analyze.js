export default class QuestionsAnalyzeService {
    setup(app) {
        this.app = app;
    }
    find(params) {
        console.log("Questions Analyze service! params: ", params);

        return this.app.service("users").patch(params.user._id, {name: params.query.name})
        .then(() => {
            return {status: "success", userName: params.user.name};
        })
        .catch((err) => {
            return Promise.reject(err);
        });
    }

    async analyze(user) {
        try {
            console.log("Done");
            return Promise.resolve({status: "success", personality: {}});
        }
        catch(err) {
            console.log("Error in QuestionsnalyzerService", err);
            return Promise.reject(err);
        }
    }
}
