import Store from './store';
import SocketUtil from '../util/socket'
import MiscUtil from '../util/misc'

export default class RouserStore extends Store {

    constructor(state) {
        super(state);
        this.status = null;
        this.action = null;
        this.alarms = null;
        this.currentAlarm = null;

        SocketUtil.socket.on('recordings ready', (data) => {
            this.recording = data;
            this.trigger('recording_ready', data);
        })
    }

    async getAlarms(contact) {
        try {
            if (!this.alarms && !this.gettingAlarms) {
                this.gettingAlarms = true;
                console.log("Get rouser alarms");
                this.alarms = await SocketUtil.rpc('rouser/alarms::find', {accessToken: this._state.auth.accessToken});
                this.gettingAlarms = false;
                this.trigger('queue_updated')
            }
        }
        catch (e) {
            console.log("Error getting alarm queue", e);                    
            this.gettingAlarms = false;
        }
    }

    setAction(action) {
        if (this.action != action) {
            this.action = action;
            this.trigger('action_updated', action);
        }
    }

    setRecordStage(stage) {
        console.log("Set record stage", stage);
        this.recordStage = stage;
        this.trigger('record_stage_updated');
    }

    chooseAlarm(id) {
        console.log("Rouser chooses alarm ", id);
        this.currentAlarm = MiscUtil.findById(this.alarms,id);
        console.log("Current alarm", this.currentAlarm);
    }

    async requestCall() {
        console.log("Requesting a call for alarm", this.currentAlarm);
        let result = await SocketUtil.rpc("recordings::create",{alarmId: this.currentAlarm._id});
        return result;
    }

    async finalizeAlarm() {
        console.log("Finalizing alarm");
        let result = await SocketUtil.rpc(
            "recordings::patch",
            this.currentAlarm._id, 
            {'recording.finalized': true}
        );
        return result;
    }
};
