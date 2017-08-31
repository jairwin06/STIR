import Store from './store';
import SocketUtil from '../util/socket'

export default class RouserStore extends Store {

    constructor(state) {
        super(state);
        console.log("Init RouserStore", this._state);
        this.status = null;
        this.signUpStage = "contact";
    }
    async getStatus() { 
        if (!this.status)  {
            try {
                let result = await SocketUtil.rpc('user/status::find', {accessToken: this._state.auth.accessToken});
                console.log("Router status", result);
                this.status = result;
                this.trigger("status_updated");
            }

            catch (e) {
                console.log("Error getting rouser status  ", e);                    
            }
        }
    }
};
