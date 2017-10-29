import MSTranslator from 'mstranslator'

class MSTranslateUtil {
    constructor() {
        this.client = new MSTranslator({
            api_key : process.env.MS_ACCESS_KEY
        },false) // No auto refresh, token will be initialzied and refreshed at interval

        this.initToken()
        .then((keys) => {
            console.log("M$ KEYS: ", keys);
        })
        .catch((err) => {
            console.error("Error renewing MSTranslator keys!", err);
        });
    }
    translate(text, target) {
        return new Promise((resolve, reject) => {
            let params = {
              text: text,
              to: target
            };
            this.client.translate(params, (err, data) => {
              if (err) {
                  reject(err);
              } else {
                  resolve(data);
              }
            });
        })
    }

    initToken() {
        return new Promise((resolve, reject) => {
            this.client.initialize_token((err, keys) => {
              if (err) {
                  reject(err);
              } else {
                  resolve(keys);
              }
            });
        })
    }
};

// Singleton
let instance = new MSTranslateUtil();
export default instance;
