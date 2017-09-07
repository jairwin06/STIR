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
        console.log("Recording file is ready!");
        this.emit('ready', data);
    }
}
