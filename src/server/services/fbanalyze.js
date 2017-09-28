import graph from 'fbgraph'
import WastonUtil from '../util/watson'
import Session from '../models/session-persistent'

const FB_APP_ID = process.env['FB_APP_ID'];
const FB_APP_SECRET = process.env['FB_APP_SECRET'];

const FB_APP_TOKEN = FB_APP_ID + '|' + FB_APP_SECRET;


export default class FBAnalyzeService {
    setup(app) {
        this.app = app;
        graph.setVersion("2.8");
    }
    find(params) {
        console.log("FB Analyze service! params: ", params);

        return this.verifyToken(params.user.facebook.accessToken)
        .then(() => {
            return this.getName(params.user.facebook.accessToken);
        })
        .then((name) => {
            params.user.name = name;
            return this.getPosts(params.user.facebook.accessToken);
        })
        .then((posts) => {
            console.log("Analyzing")
            let oneLine = posts.join("\n");
            return WastonUtil.profileText(oneLine);
        })
        .then((personality) => {
            // Save the personality in the session
            console.log("Done");
            Session.setFor(params.user._id, {name: params.user.name, personality : personality});
            Session.setFor(params.user._id, {state: {pendingFacebook: false}});
            return Promise.resolve({status: "success", userName: params.user.name});
        })
        .catch((err) => {
            console.log("Error in FBAnalyzerService", err);
            Session.setFor(params.user._id, {state: {pendingFacebook: false}});
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
                    reject(new Error(res.data.error.message));
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
                if (err) {
                    console.log("Error getting feed!", err);
                    reject(new Error(err));
                } else {
                    if (res.data.length == 0) {
                        reject(new Error("Could not get any posts"));
                    } else {
                        res.data.forEach((post) => {
                            if (post.message) {
                                posts.push(post.message);
                            }
                            resolve(posts);
                        })
                    }
                }
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
