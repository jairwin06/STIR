import graph from 'fbgraph'
import WastonUtil from '../util/watson'
import Session from '../models/session-persistent'

const FB_APP_ID = '679489015579803';
const FB_APP_SECRET = 'e820e06015e5dbf80982c72400433dde';
const FB_APP_TOKEN = FB_APP_ID + '|' + FB_APP_SECRET;


export default class FBAnalyzeService {
    setup(app) {
        this.app = app;
        graph.setVersion("2.8");
    }
    find(params) {
        console.log("FB Analyze service! params: ", params);

        return this.verifyToken(params.query.fbaccessToken)
        .then(() => {
            return this.getName(params.query.fbaccessToken);
        })
        .then((name) => {
            params.user.name = name;
            return this.getPosts(params.query.fbaccessToken);
        })
        .then((posts) => {
            console.log("Analyzing")
            let oneLine = posts.join(" ");
            return WastonUtil.profile(oneLine);
        })
        .then((personality) => {
            // Save the personality in the session
            console.log("Done");
            Session.setFor(params.user._id, {name: params.user.name, personality : personality});
            return Promise.resolve({status: "success", userName: params.user.name});
        })
        .catch((err) => {
            console.log("Error in FBAnalyzerService", err);
            return Promise.reject(err);
        });
    }

    verifyToken(accessToken) {
        return new Promise((resolve, reject) => {
            console.log("Verifying " + accessToken);
            graph.get('/debug_token?input_token=' + accessToken + '&access_token=' + FB_APP_TOKEN, (err, res) => {
                console.log(res);
                if (res && res.data.is_valid) {
                    resolve();
                } else {
                    reject(err);
                }
            });
        });
    }

    getPosts(accessToken) {
        return new Promise((resolve, reject) => {
            console.log("Getting posts");
            graph.get('me/posts', {limit: 1000, access_token: accessToken}, function(err, res) {
                // TODO: Paging
                let posts = [];
                res.data.forEach((post) => {
                    if (post.message) {
                        posts.push(post.message);
                    }
                    resolve(posts);
                })
            });
        });
    }
    getName(accessToken) {
        return new Promise((resolve, reject) => {
            console.log("Getting first name");
            graph.get('me?fields=first_name', {access_token: accessToken}, function(err, res) {
                console.log("First name data: ",  res);
                resolve(res.first_name);
            });
        });
    }
}
