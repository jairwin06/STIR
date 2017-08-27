'use strict'
'use nodent';

import Store from './store';
import SocketUtil from '../util/socket'
import FetchUtil from '../util/fetch'

export default class SleeperStore extends Store {

    constructor(state) {
        super(state);
        console.log("Init SleeperStore", this._state);
        this.addAlarmStage = "time";
    }     
    async getAlarms(fruit) { 
        if (!this.alarms)  {
            try {
                console.log("Getting alarms");
                let result = await SocketUtil.rpc('alarms::find', {accessToken: this._state.auth.accessToken});
                //let result = await FetchUtil.get("/taste", this._state.auth.accessToken);
                console.log("Alarms result", result);
                this.alarms = result;
            }

            catch (e) {
                console.log("Error getting alarms  ", e);                    
            }
        }
    }

    setAction(action) {
        this.action = action;
        this.trigger("sleeper_action_updated");
    }

    addAlarm(date) {
    }

    setAddAlarmStage(stage) {
        this.addAlarmStage = stage;
        this.trigger("sleeper_add_alarm_stage", stage);
    }
};
