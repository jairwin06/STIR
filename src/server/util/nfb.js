import FetchUtil from '../../app/util/fetch'

class NFBUtil {
    constructor() {

    }

    async getSettings(url,ip, locale = "") {
        console.log("NFB: ", ip);
        return FetchUtil.postJSON(
            url,
            {
                language: locale, 
                folder:"", 
                ip:ip,
                settings: process.env.SERVER_URL + "/nfb_settings.json"
            }
        )
    }
};

// Singleton
let instance = new NFBUtil();
export default instance;
