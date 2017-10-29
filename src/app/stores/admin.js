import Store from './store';
import SocketUtil from '../util/socket'
import MiscUtil from '../util/misc'

export default class AdminStore extends Store {

    constructor(state) {
        super(state);
    }     

    async getAlarms() { 
        if (!this.alarms && !this.gettingAlarms)  {
            try {
                this.gettingAlarms = true;
                console.log("Getting alarms");
                let yesterday = new Date();
                yesterday.setDate(yesterday.getDate() - 1);
                let result = await SocketUtil.rpc(
                    'alarms/admin::find', 
                    {
                        accessToken: this._state.auth.accessToken,
                        time: {$gt: yesterday},
                        deleted: false
                    });
                this.gettingAlarms = false;
                console.log("Alarms result", result);
                this.alarms = result;
                this.trigger("alarms_updated");
            }

            catch (e) {
                this.gettingAlarms = false;
                console.log("Error getting alarms  ", e);                    
            }
        }
    }

    setAction(action) {
        if (this.action != action) {
            this.action = action;
            this.trigger("admin_action_updated");
        }
    }

    async assignMTurk(alarm) {
        let result = await SocketUtil.rpc('alarms/admin::patch', alarm._id, {assignedTo: null, mturk: true});
        return result;
    }

};
