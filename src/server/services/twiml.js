import TwilioUtil from '../util/twilio'
import {twiml} from 'twilio'
import User from '../models/user'
import Session from '../models/session-persistent'
import DownloadUtil from '../util/download'

export default { 
    getRecordingTwiML: function(req,res) {
        console.log("TWIML RECORDING SERVICE CALLED!", req.body);
        // Get the user by phone number
        User.findOne({phone: req.body.Called})
        .then((user) => {
            console.log("Found user ", user);
            const response = new twiml.VoiceResponse();

            // Get the session
            let sessionData = Session.getFor(user._id);

            if (sessionData && sessionData.pendingRecording) {
                if (req.body.RecordingSid) {
                    response.say({}, "Thank you mister");
                } else {
                    console.log("Session data", sessionData);
                    response.say({}, "It's S T I R time! Record something for 10 seconds and then press hash");
                    response.record({
                            timeout: 10,
                            recordingStatusCallback: '/twiml/recording-status/' + user._id,
                            finishOnKey: '#'
                    });
                }
            } else {
                response.say({}, "Sorry, there is no pending recording for you right now");
            }
            res.type('text/xml');
            res.send(response.toString());
        })
        .catch((err) => {
            console.log("Error in twiml service!", err);
            res.send("Error" + err);
        })
    },

    getAlarmTwiML: function(req,res) {
        console.log("TWIML ALARM SERVICE CALLED!", req.body);
        // Get the user by phone number
        User.findOne({phone: req.body.Called})
        .then((user) => {
            console.log("Found user ", user);
            const response = new twiml.VoiceResponse();

            // Get the session
            let sessionData = Session.getFor(user._id);

            if (sessionData && sessionData.pendingAlarm) {
                if (sessionData.pendingAlarm.recording.mixUrl.match(/^http.*/)) {
                    response.play({},sessionData.pendingAlarm.recording.mixUrl);
                } else {
                    response.play({},SERVER_URL + sessionData.pendingAlarm.recording.mixUrl);
                }

                req.app.service('alarms/rouser').alarmDelivered(sessionData.pendingAlarm);
            } else {
                response.say({}, "Wake up");
            }
            res.type('text/xml');
            res.send(response.toString());
        })
        .catch((err) => {
            console.log("Error in twiml alarm service!", err);
            res.send("Error" + err);
            req.app.service('alarms/rouser').alarmDeliveryFailed(pendingAlarm);

        })
    },
    dispatchRecordingCall: function(hook) {
        console.log("TWIML Dispatch call hook!", hook.data, hook.params);
        return TwilioUtil.client.calls.create({
                url: SERVER_URL + '/twiml-rec.xml',
                to: hook.params.user.phone,
                from: TwilioUtil.TWILIO_PHONE_NUMBER
        }).then((response) => {
            return hook; 
        })
        .catch((err) => {
            console.log("Error dispatching call", err )
            throw new Error(err);
        })
    },

    getRecordingStatus: function(req,res) {
        console.log("getRecordingStatus called!", req.params, req.body);
        if (req.body.RecordingStatus == 'completed') {
            let sessionData = Session.getFor(req.params.userId);
            if (sessionData.pendingRecording) {
                console.log("Downloading recording!");
                let recordingUrl = 
                    '/recordings/' + 
                    sessionData.pendingRecording.alarmId + '-' + 
                    sessionData.pendingRecording.rouserId +
                    '-rec.wav';
                DownloadUtil.saveUrl(req.body.RecordingUrl, 'public' + recordingUrl)
                .then(() => {
                    console.log("Finished download!");
                    sessionData.pendingRecording.recordingUrl = recordingUrl + '?t=' + (new Date).getTime();
                    req.app.service('recordings').ready(sessionData.pendingRecording);
                })
                .catch((err) => {
                    console.log("Error downloading file!", err);

                })

                res.send({status: "success"});
            } else {
                res.send("No pending recording");
            }
        } else {
            res.send("Recording not completed");
        }
    }
}

