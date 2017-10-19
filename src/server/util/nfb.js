import FetchUtil from '../../app/util/fetch'

class NFBUtil {
    constructor() {

    }

    async getSettings(url,ip) {
        return FetchUtil.postJSON(
            url,
            {
                language: "", 
                folder:"", 
                ip:ip,
                settings: "http://veryveryshort-dev.nfb.ca/common/sample_settings.json"
            }
        )
    }
};

// Singleton
let instance = new NFBUtil();
export default instance;
