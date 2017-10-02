import Alarm from '../models/alarm'
import Session from '../models/session-persistent'
import SoxUtil from '../util/sox'
import formidable from 'formidable'

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

    patch(id, data, params) {
        console.log("Finalize alarm!", id, data, params);
        // Get the alarm
        return Alarm.findOne({
            _id: id
        }).then((alarm) => {
            console.log("Found alarm", alarm);            
            if (alarm.recording.rouserId.toString() == params.user._id.toString()) {
                console.log("Patching");
                let query = {};
                query['recording.finalized'] = data['recording.finalized'];
                return this.app.service('/alarms/sleeper').patch(id, query);
            } else {
                throw new Error("Invalid rouser id for this alarm!")
            }
        })
        .then((result) => {
            if (data['recording.finalized'] == true) {
                console.log("Alarm set!", result);
                this.emit('finalized', result);
                return {status: "success"}
            }
        });
    }


    ready(data) {
        console.log("Recording file is ready! mixing",data);
        // Delete from session, save in db
        Session.setFor(data.rouserId, {pendingRecording : null});
        // Mix
        SoxUtil.mixBackingTrack(
            'public/recordings/' + data.alarmId + '-rec.wav',
            'backingtracks/_2014_.wav',
            'public/recordings/' + data.alarmId + '-mix.wav'
        )
        .then((result) => {
            console.log("Mixing result", result);
            data.mixUrl = '/recordings/' + data.alarmId + '-mix.wav?t=' + new Date().getTime();
            let recording = Object.assign({}, data);
            recording.finalized = false;
            data.mixUrl = '/recordings/' + data.alarmId + '-mix.wav?t=' + new Date().getTime();
            data.status = "success";
            delete recording.alarmId;
            this.app.service('/alarms/sleeper').patch(data.alarmId,{recording: recording})
            this.emit('ready', data);
        })
        .catch((err) => {
            console.log("Mixing error",err);
            data.status = "error";
            data.message = err.toString();
            this.emit('ready', data);
        });
    }

    upload(req, res) {
        console.log("Recording upload!");
        const form = new formidable.IncomingForm();

        form.parse(req, function(err, fields, files) {
          console.log("Received form", fields, files);
          res.send({status: "success"})
        });
    }
}
