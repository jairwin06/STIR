import MSTranslator from 'mstranslator'

class MSTranslateUtil {
    constructor() {
        this.client = new MSTranslator({
            api_key : process.env.MS_ACCESS_KEY
        },true)
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
};

// Singleton
let instance = new MSTranslateUtil();
export default instance;
