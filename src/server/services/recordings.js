import Session from '../models/session-persistent'

export default class RecordingsService {
    constructor() {
        this.events = ['ready'];
    }
    setup(app) {
        this.app = app;
    }
    find(params) {
        // Return just the status
        return Promise.resolve(params.user.status);
    }

    create(data,params) {
        console.log("RecordingsService::create! ", data,params);
        // Create a pending recording for this user
        Session.setFor(params.user._id, {pendingRecording : data});

        return Promise.resolve({status: "success"});
    }


    ready(data) {
        console.log("Recording file is ready!",data);
        // Save it in session and db
        Session.setFor(data.rouserId, {pendingRecording : data});
        let recording = Object.assign({}, data);
        delete recording.alarmId;
        this.app.service('/sleeper/alarms').patch(data.alarmId,{recording: recording})
        this.emit('ready', data);
    }
}
