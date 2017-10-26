import graph from 'fbgraph'
import WastonUtil from '../util/watson'
import Session from '../models/session-persistent'
import translate from 'node-google-translate-skidz';
import MSTranslateUtil from '../util/mstranslate'

const FB_APP_ID = process.env['FB_APP_ID'];
const FB_APP_SECRET = process.env['FB_APP_SECRET'];

const FB_APP_TOKEN = FB_APP_ID + '|' + FB_APP_SECRET;

const MAX_POSTS = 500;
const MAX_POSTS_PER_FETCH = 200;


const toTranslatedContentItem = async (post) => {
  return {
    id: post.id,
    language: 'en', //tweet.lang,
    contenttype: 'text/plain',
    content: await toEnglish(post),
    created: Date.parse(post.created_time),
    reply: false
  };
};

const toEnglish = async (post) => {
    try {
        /*
        let result = await translate({source: 'auto', text: post.message, target: 'en'});
        return result.translation || "";*/
        let result = await MSTranslateUtil.translate(post.message,'en');
        return result || "";
    } catch(e) {
        console.log("Translation Error!", e);
        return "";
    }
};

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
            return this.app.service("users").patch(params.user._id, {name: name})
        })
        .then(() => {
            console.log("Setting sesstion");
            Session.setFor(params.user._id, {state: {pendingFacebook: false}});
            return {status: "success", userName: params.user.name};
        })
        .catch((err) => {
            console.log("Error duing FBAnalyzerService::find!", err);
            Session.setFor(params.user._id, {state: {pendingFacebook: false}});
            return Promise.reject(err);
        });
    }

    async analyze(user) {
        try {
            let posts = [];

            let newPosts = await this.getPosts(user.facebook.accessToken);
            posts = posts.concat(newPosts.data.filter((post) => post.message));

            while(newPosts.data.length > 1 && posts.length < MAX_POSTS) {
                console.log("Received " + newPosts.data.length + " posts");
                console.log("After filtering posts are now ", posts.length);
                newPosts = await this.nextPage(newPosts.paging.next);
                posts = posts.concat(newPosts.data.filter((post) => post.message));
            }

            let contentItems = posts.map(toTranslatedContentItem);
            return Promise.all(contentItems)
            .then((translatedItems) => {
                console.log("TRANSLATED ITEMS");
                console.log(translatedItems);
                return WastonUtil.profileItems(translatedItems)
            })
            .then((result) => {
                // Save the personality in the session
                console.log("Done");
                return {status: "success", personality: result};
            })
            .catch((err) => {
                console.log("Error in FBAnalyzerService", err);
                return Promise.reject(err);
            });
        }
        catch(err) {
            console.log("Error in FBAnalyzerService", err);
            return Promise.reject(err);
        }
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
            graph.get('me/posts', {limit: MAX_POSTS_PER_FETCH, access_token: accessToken}, function(err, res) {
                if (err) {
                    console.log("Error getting feed!", err);
                    reject(new Error(err));
                } else {
                    resolve({data: res.data, paging: res.paging});
                }
            });
        });
    }
    nextPage(pageUrl) {
        return new Promise((resolve, reject) => {
            graph.get(pageUrl, function(err, res) {
                if (err) {
                    console.log("Error getting feed!", err);
                    reject(new Error(err));
                } else {
                    resolve({data: res.data, paging: res.paging});
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
