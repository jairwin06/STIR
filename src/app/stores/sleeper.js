import Store from './store';
import SocketUtil from '../util/socket'
import MiscUtil from '../util/misc'

export default class SleeperStore extends Store {

    constructor(state) {
        super(state);
        this.currentAlarm = {};
    }     

    async getAlarms() { 
        if (!this.alarms && !this.gettingAlarms)  {
            try {
                this.gettingAlarms = true;
                console.log("Getting alarms");
                let result = await SocketUtil.rpc(
                    'alarms/sleeper::find', 
                    {
                        accessToken: this._state.auth.accessToken,
                        delivered: false,
                        deleted: false,
                        failed: false
                    });
                this.gettingAlarms = false;
                console.log("Alarms result", result);
                this.alarms = result;
                this.trigger("alarms_updated");
            }

            catch (e) {
                this.gettingAlarms = false;
                if (e.code == 401) {
                    this.alarms = [];
                    this.trigger('alarms_updated');
                } else {
                    console.log("Error getting alarms  ", e);                    
                }
            }
        }
    }

    setAction(action) {
        if (this.action != action) {
            this.action = action;
            if (action == "add-alarm") {
                this.currentAlarm = {};
            }
            this.trigger("sleeper_action_updated");
        }
    }

    invalidateAlarms() {
        this.alarms = null;
    }

    async addAlarm() {
        console.log("Create the alarm!", this.currentAlarm);
        let result = await SocketUtil.rpc('alarms/sleeper::create', this.currentAlarm);
        console.log("Alarm create result", result);
        this.alarms.push(result);
        this.currentAlarm = null;
        this.addAlarmStage = null;
        this.trigger('alarm_created');
    }

    async saveAlarmTime(newTime, timezone) {
        console.log("Saving alarm", this.currentAlarm, newTime, timezone);
        let result = await SocketUtil.rpc('alarms/sleeper::patch', this.currentAlarm._id, {time: newTime, timezone: timezone});
        this.currentAlarm.time = newTime.toString();
        return result;
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

    async getAlarm(id) {
        console.log("Sleeper gets alarm ", id);
        this.currentAlarm = await SocketUtil.rpc('alarms/sleeper::get', id,{
            accessToken: this._state.auth.accessToken,
        });
        console.log("Current sleeper alarm", this.currentAlarm);
    }

    async deleteAlarm() {
        if (this.currentAlarm) {
            console.log("Deleting alarm");
            let result = await SocketUtil.rpc('alarms/sleeper::patch', this.currentAlarm._id, {deleted: true});
            this.alarms.splice(MiscUtil.findIndexById(this.alarms, this.currentAlarm._id), 1);
            this.currentAlarm = null;
            return {status: "success"};
        }
    }
    async saveProgress() {
        let result = this._state.auth.setSession({newAlarm: this.currentAlarm});
        return result;
    }

    async restoreProgress() {
        let result = await this._state.auth.getSession();
        if (result.newAlarm) {
            console.log("Restring sleeper progress", result);
            this.currentAlarm = result.newAlarm;
        }
        if (result.pendingTwitter) {
            console.log("Pending twitter!");
            this.pendingTwitter = true;
        } else {
            this.pendingTwitter = false;
        }
        if (result.pendingFacebook) {
            console.log("Pending facebook!");
            this.pendingFacebook = true;
        } else {
            this.pendingFacebook = false;
        }
        return result;
    }

    async analyzeFacebook() {
        console.log("Analyzing FB");
        let result = await SocketUtil.rpc('fbanalyze::find', {
            accessToken: this._state.auth.accessToken
        });
        console.log("FB Result", result);
        return result;
    }
    async twitterAnalyze() {
        console.log("Analyzing Twitter");
        let result = await SocketUtil.rpc('twitter-analyze::find', {
            accessToken: this._state.auth.accessToken
        });
        console.log("Twitter result", result);
        this.pendingTwitter = false;
        return result;
    }
    async questionsAnalyze(data) {
        console.log("Analyzing Questions");
        let result = await SocketUtil.rpc('questions-analyze::create',data);
        console.log("Questions result", result);
        return result;
    }
    calculateSteps() {
        this.steps = 2;
        if (!this._state.auth.user.status.phoneValidated) {
            this.steps += 3;
        } 
        if (!this._state.auth.user.pronoun) {
            this.steps += 1;
        }
        console.log("Calculated steps", this.steps);
    }
    getSteps() {
        if (!this.steps) {
            this.calculateSteps();
        }
        return this.steps;
    }
    
};
