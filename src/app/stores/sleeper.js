import Store from './store';
import SocketUtil from '../util/socket'

export default class SleeperStore extends Store {

    constructor(state) {
        super(state);
        this.addAlarmStage = "time";
        this.newAlarm = {};
    }     
    async getAlarms(fruit) { 
        if (!this.alarms)  {
            try {
                console.log("Getting alarms");
                let result = await SocketUtil.rpc(
                    'sleeper/alarms::find', 
                    {
                        accessToken: this._state.auth.accessToken
                    });
                console.log("Alarms result", result);
                this.alarms = result;
            }

            catch (e) {
                console.log("Error getting alarms  ", e);                    
            }
        }
    }

    setAction(action) {
        if (this.action != action) {
            this.action = action;
            if (action == "add") {
                this.newAlarm = {};
            }
            this.trigger("sleeper_action_updated");
        }
    }

    async addAlarm() {
        try {
            console.log("Create the alarm!", this.newAlarm);
            let result = await SocketUtil.rpc('sleeper/alarms::create', this.newAlarm);
            console.log("Alarm create result", result);
            this.alarms.push(result);
            this.trigger('alarm_created');
        }

        catch (e) {
            console.log("Error creating alarm  ", e);                    
        }
    }

    setAddAlarmStage(stage) {
        this.addAlarmStage = stage;
        this.trigger("sleeper_add_alarm_stage", stage);
    }
};
