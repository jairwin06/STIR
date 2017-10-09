import WastonUtil from '../util/watson'
import Session from '../models/session-persistent'
import Twitter from 'twitter'
import translate from 'node-google-translate-skidz';

const MAX_TWEETS = 1000;
const MAX_TWEETS_PER_FETCH = 200;

const parentId = function(tweet) {
    if (tweet.in_reply_to_screen_name != null) {
        return tweet.in_reply_to_user_id;
    } else if (tweet.retweeted && (tweet.current_user_retweet != null)) {
        return tweet.current_user_retweet.id_str;
    }
};

const toContentItem = (tweet) => {
  return {
    id: tweet.id_str,
    language: 'en', //tweet.lang,
    contenttype: 'text/plain',
    content: tweet.text.replace('[^(\\x20-\\x7F)]*',''),
    created: Date.parse(tweet.created_at),
    reply: tweet.in_reply_to_screen_name != null
        //parentid: parentId(tweet)
  };
};

const toEnglish = async (tweet) => {
    try {
        let result = await translate({source: 'auto', text: tweet.text.replace('[^(\\x20-\\x7F)]*',''), target: 'en'});
        return result.translation || "";
    } catch(e) {
        return "";
    }
};

const toTranslatedContentItem = async (tweet) => {
  return {
    id: tweet.id_str,
    language: 'en', //tweet.lang,
    contenttype: 'text/plain',
    content: await toEnglish(tweet),
    created: Date.parse(tweet.created_at),
    reply: tweet.in_reply_to_screen_name != null
        //parentid: parentId(tweet)
  };
};

const toJustText = (tweet) => {
  return tweet.text.replace('[^(\\x20-\\x7F)]*','');
};


export default class TwitterAnalyzeService {
    setup(app) {
        this.app = app;
    }
    async find(params) {
        console.log("Twitter Analyze service! params: ", params);

        try {
            let firstName = params.user.twitter.profile.displayName.split(" ")[0];
            Session.setFor(params.user._id, {state: {pendingTwitter: false}});
            return this.app.service("users").patch(params.user._id, {name: firstName})
            .then(() => {
                return {status: "success", userName: firstName};
            })
            .catch((err) => {
                throw err;
            })
        }
        catch(err) {
            console.log("Twitter connect error!", err);
            Session.setFor(params.user._id, {state: {pendingTwitter: false}});
            if (Array.isArray(err)) {
                return Promise.reject(err[0]);
            } else {
                return Promise.reject(err);                
            }
        }
    }

    async analyze(user) {
        try {
            let client = new Twitter({
              consumer_key: process.env['TWITTER_API_KEY'],
              consumer_secret: process.env['TWITTER_API_SECRET'],
              access_token_key: user.twitter.accessToken,
              access_token_secret: user.twitter.refreshToken
            });


            let tweets = [];

            let newTweets = await this.fetchTweets(client);
            tweets = tweets.concat(newTweets.filter((tweet) => !tweet.retweeted));

            while(newTweets.length > 1 && tweets.length < MAX_TWEETS) {
                console.log("Received " + newTweets.length + " tweets");
                console.log("After filtering retweet tweets are now ", tweets.length);
                let maxId = newTweets[newTweets.length-1].id - 1;
                console.log("Max Id : " + maxId);
                newTweets = await this.fetchTweets(client, maxId);
                tweets = tweets.concat(newTweets.filter((tweet) => !tweet.retweeted));
            }

            let contentItems = tweets.map(toTranslatedContentItem);
            return Promise.all(contentItems)
            .then((translatedItems) => {
                return WastonUtil.profileItems(translatedItems)
            })
            .then((result) => {
                // Save the personality in the session
                console.log("Done");
                return {status: "success", personality: result};
            }) 
        }
        catch(err) {
            console.log("Twitter analyzer error!", err);
            Session.setFor(params.user._id, {state: {pendingTwitter: false}});
            if (Array.isArray(err)) {
                return Promise.reject(err[0]);
            } else {
                return Promise.reject(err);                
            }
        }
    }

    async fetchTweets(client, maxId) {
        let params= {
            count: MAX_TWEETS_PER_FETCH, 
            exclude_replies: true,
            trim_user: true
        };
        if (maxId) {
            params.max_id = maxId;
        }
        return client.get('statuses/user_timeline', params);
    }
}
