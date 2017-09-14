import Alarm from '../models/alarm'
import TwilioUtil from '../util/twilio'

const ALARMS_IN_QUEUE = 1;
const FIELDS_TO_RETURN = "_id time name prompt"

export default class AlarmManager {
    constructor() {
        console.log("Alarm manager starting");
        this.getPendingAlarms();
    }
    setup(app) {
        this.app = app;
        app.service('recordings').on('finalized', alarm => this.onAlarmSet(alarm));
    }
    getPendingAlarms() {
        console.log("Get pending alarms");
        Alarm.find({
            time: {$gt: new Date()},
            'recording.finalized': true
        }).sort({time: -1})
        .then((result) => {
            console.log("Result:", result.length + " Alarms");
            this.pendingAlarms = result;
            this.popAlarm();
        })

        // Start the clock
        setInterval(() => {
            this.tick();
        },1000);
    }
    tick() {
        if (this.nextAlarm && this.nextAlarm.time.getTime() <= new Date().getTime()) {
            console.log("Time to wake up " + this.nextAlarm.name);

            // Already pop the next alarm to continue processing

        }
    }
    popAlarm() {
        if (this.pendingAlarms.length > 0) {
            // Get the next one (it was sorted so first in line)
            this.nextAlarm = this.pendingAlarms.pop();
            console.log("Next alarm at", this.nextAlarm.time);
           
            // TODO: Support for multiple alarms at the same time!
        } else {
            this.nextAlarm = null;
        }

    }
    onAlarmSet(alarm) {
        console.log("New alarm set!", alarm);
        this.getPendingAlarms();
    }

    find(params) {
        // First get the alarms that this user was assigend to
        console.log("Alarm manager for rouser", params.user);
        if (!params.user.status.phoneValidated) {
            // Can't assign alarms if they didn't sign up
            return Promise.reject(new Error("Phone not validated"));
        } else {
            // First get alarms assigned to this rouser and not finalized
            return Alarm.find({
                assignedTo: params.user._id,
                'recording.finalized': false,
                time: {$gt: new Date()}
            }).select(FIELDS_TO_RETURN)
            .then((result) => {
                if (result.length < ALARMS_IN_QUEUE) {
                    let alarmsToGo = ALARMS_IN_QUEUE - result.length;
                    let alarmIds;

                    console.log("Still need to find " + alarmsToGo + " more alarms");
                    return Alarm.find({
                        assignedTo: null,
                        time: {$gt: new Date()}
                    }).select("_id").limit(alarmsToGo)
                    .then((newIds) => {
                        alarmIds = newIds;
                        console.log("We have " + alarmIds.length + " alarms to assign");
                        if (alarmIds.length == 0) {
                            // TODO: Backup alarms , only on first usage
                        } else {
                            console.log("Assigning " ,alarmIds);
                            return Alarm.update(
                                {_id: {$in: alarmIds}},
                                {"$set": {
                                    assignedTo: params.user._id
                                }}, {multi: true}
                            )
                        }
                    })
                    .then(()=> {
                        return Alarm.find(
                            { $or: 
                                [{_id: {$in: alarmIds}},
                                {$and : [{
                                    assignedTo: params.user._id,
                                    'recording.finalized': false,
                                    time: {$gt: new Date()}
                                }]}]
                            }
                        ).select(FIELDS_TO_RETURN)                        
                    })
                } else {
                    return result;
                }
            })
        }
    }

}
