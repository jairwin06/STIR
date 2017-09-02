import Store from './store';
import SocketUtil from '../util/socket'

export default class RouserStore extends Store {

    constructor(state) {
        super(state);
        console.log("Init RouserStore", this._state);
        this.status = null;
        this.signUpStage = "contact";
        this.action = null;
        this.alarms = null;
    }
    async getStatus() { 
        if (!this.status)  {
            try {
                let result = await SocketUtil.rpc('user/contact::find', {accessToken: this._state.auth.accessToken});
                console.log("Rouser contact status", result);
                this.status = result;
                this.trigger("status_updated");
            }

            catch (e) {
                console.log("Error getting rouser status  ", e);                    
            }
        }
    }

    async setContact(contact) {
        try {
            console.log("Set contact", contact);
            let result = await SocketUtil.rpc('user/contact::create',contact);
            console.log("Rouser contact status", result);
        }
        catch (e) {
            console.log("Error setting contact details", e);                    
        }
    }

    async getAlarms(contact) {
        try {
            if (!this.alarms) {
                console.log("Get rouser alarms");
                this.alarms = await SocketUtil.rpc('rouser/alarms::find', {accessToken: this._state.auth.accessToken});
                console.log("Rouser alarms queue", this.alarms);
            }
        }
        catch (e) {
            console.log("Error getting alarm queue", e);                    
        }
    }

    setAction(action) {
        this.action = action;
        this.trigger('action_updated', action);
    }
};
