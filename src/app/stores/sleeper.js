import Store from './store';
import SocketUtil from '../util/socket'
import MiscUtil from '../util/misc'

export default class SleeperStore extends Store {

    constructor(state) {
        super(state);
        this.addAlarmStage = "time";
        this.currentAlarm = {};
    }     
    async getAlarms(fruit) { 
        if (!this.alarms)  {
            try {
                console.log("Getting alarms");
                let result = await SocketUtil.rpc(
                    'sleeper/alarms::find', 
                    {
                        accessToken: this._state.auth.accessToken,
                        delivered: false
                    });
                console.log("Alarms result", result);
                this.alarms = result;
                this.trigger("alarms_updated");
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
                this.currentAlarm = {};
            }
            this.trigger("sleeper_action_updated");
        }
    }

    async addAlarm() {
        try {
            console.log("Create the alarm!", this.currentAlarm);
            let result = await SocketUtil.rpc('sleeper/alarms::create', this.currentAlarm);
            console.log("Alarm create result", result);
            this.alarms.push(result);
            this.trigger('alarm_created');
        }

        catch (e) {
            console.log("Error creating alarm  ", e);                    
        }
    }

    async saveAlarm() {
        console.log("Saving alarm", this.currentAlarm);
        return await SocketUtil.rpc('sleeper/alarms::patch', this.currentAlarm._id, {time: this.currentAlarm.time});
    }

    setAddAlarmStage(stage) {
        this.addAlarmStage = stage;
        this.trigger("sleeper_add_alarm_stage", stage);
    }

    chooseAlarm(id) {
        console.log("Sleeper chooses alarm ", id);
        this.currentAlarm = MiscUtil.findById(this.alarms,id);
        console.log("Current sleeper alarm", this.currentAlarm);
    }
};
