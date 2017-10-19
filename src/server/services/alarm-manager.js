import Alarm from '../models/alarm'
import User from '../models/user'
import TwilioUtil from '../util/twilio'
import MTurkUtil from '../util/mturk' 
import Session from '../models/session-persistent'
import Errors from 'feathers-errors'
import {IntlMixin} from 'riot-intl'
import {withTimezone} from '../../app/i18n/i18n'

let ALARMS_IN_QUEUE = 1;
const FIELDS_TO_RETURN = "_id time name prompt locales"

const ROUTINE_TASKS_INTERVAL = 1000 * 60 * 0.5;
const STALLLING_TIMEOUT_HOURS = 1;
const NOTIFY_SLEEPERS_HOURS = 12;

export default class AlarmManager {
    constructor() {
    }
    setup(app) {
        this.app = app;
        app.service('alarms/sleeper').on('patched', alarm => this.onAlarmPatched(alarm));
    }
    getPendingAlarms() {
        console.log("Get pending alarms");
        Alarm.find({
            time: {$gt: new Date()},
            'recording.finalized': true,
            delivered: false,
            deleted: false
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

        // Routine tasks
        setInterval(() => {
            this.routineTasks();            
        },ROUTINE_TASKS_INTERVAL)
    }
    tick() {
        if (this.nextAlarms.length > 0 && this.nextAlarms[0].time.getTime() <= new Date().getTime()) {
            while(this.nextAlarms.length > 0) {
                let activeAlarm = this.nextAlarms.pop();;
                console.log("Time to wake up " + activeAlarm.name);
                this.activateAlarm(activeAlarm._id);
                // One retry after a minute
                setTimeout(() => {
                    this.retryAlarm(activeAlarm.userId);
                },1000 * 60);

            }
            this.popAlarm();
        }
    }
    activateAlarm(alarmId) {
        // Get the alarm
        let alarm;

        Alarm.findOne({
            _id: alarmId
        })
        .then((result) => {
            alarm = result;
            // Get the user
            return User.findOne({
              _id: alarm.userId  
            })
        })
        .then((user) => {
            Session.setFor(user._id, {pendingAlarm : alarm});

            // Make the call
            TwilioUtil.client.calls.create({
                    url: SERVER_URL + '/twiml-alarm.xml',
                    to: user.phone,
                    from: TwilioUtil.TWILIO_PHONE_NUMBER
            }).then((response) => {
                console.log("Twilio response", response);
            })
            .catch((err) => {
                console.log("Error dispatching alarm call", err )
            })
        })
    }
    retryAlarm(userId) {
        let sessionData = Session.getFor(userId);
        if (sessionData.pendingAlarm) {
            console.log("RETRYING ALARM!", sessionData.pendingAlarm);
            this.activateAlarm(sessionData.pendingAlarm);
        }
    }
    popAlarm() {
        if (this.pendingAlarms.length > 0) {
            // Get the next one (it was sorted so first in line)
            this.nextAlarms = [];            
            this.nextAlarms.push(this.pendingAlarms.pop());
    
            while(this.pendingAlarms.length > 0
                  && this.pendingAlarms[this.pendingAlarms.length - 1].time.getTime() == this.nextAlarms[0].time.getTime()) {
                    this.nextAlarms.push(this.pendingAlarms.pop());
            }

            console.log("Next alarms", this.nextAlarms.map(o => o.name));
        } else {
            this.nextAlarms = [];
        }

    }
    onAlarmPatched(alarm) {
        console.log("Alarm patched!", alarm);
        this.getPendingAlarms();
    }

    alarmDelivered(alarm) {
        console.log("ALARM DELIVERED!", alarm);
        this.app.service('alarms/sleeper').patch(alarm._id, {delivered: true});
        Session.setFor(alarm.userId, {pendingAlarm : null});
        if (alarm.assignedTo) {
            this.messageUser(alarm.assignedTo, "Your wake-up call was just delieverd to the sleeper! Thank you from STIR");
        }
    }
    messageUser(id, message) {
        return this.app.service('users').find({
            query: {_id: id}
        })
        .then((result) => {
            if (result.length > 0) {
                let user = result[0];
                TwilioUtil.sendMessage(user.phone, message);
            }
        })
    }
    alarmDeliveryFailed(alarm) {
        console.log("ALARM DELIVERY FAILED!", alarm);
    }

    find(params) {
        // First get the alarms that this user was assigend to
        console.log("Alarm manager for rouser", params.user);
        if (!params.user.status.phoneValidated) {
            // Can't assign alarms if they didn't sign up
            return Promise.reject(new Error("Phone not validated"));
        } else {
            // First get alarms assigned to this rouser and not finalized
            let query  = {
                assignedTo: params.user._id,
                'recording.finalized': false,
                time: {$gt: new Date()}
            };
            return Alarm.find(query).select(FIELDS_TO_RETURN)
            .then((result) => {
                if (result.length < ALARMS_IN_QUEUE) {
                    let alarmsToGo = ALARMS_IN_QUEUE - result.length;
                    let alarmIds;

                    console.log("Still need to find " + alarmsToGo + " more alarms");
                    console.log("Capable languages ", params.user.alarmLocales);
                    // TODO: Not your own alarms
                    return Alarm.find({
                        assignedTo: null,
                        mturk: false,
                        analyzed: true,
                        locales: {$elemMatch: {$in: params.user.alarmLocales}},
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
                                    assignedTo: params.user._id,
                                    assignedAt: new Date(),
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
    get(id, params) {
        console.log("Get specific alarm!", id, params);        
        return Alarm.findOne({
            _id: id,
            'recording.finalized': false,
            analyzed: true,
            time: {$gt: new Date()}
        }).select(FIELDS_TO_RETURN + " assignedTo mturk")
        .then((alarm) => {
            console.log("Alarm:", alarm);
            if (!alarm) {
                console.log("Alarm not found!");
                return Promise.reject(new Errors.NotFound());
            }
            else if (params.query.mturk && params.query.mturk.hitId && alarm.mturk) {
                console.log("It's an MTURK HIT");
                // This is MTurk, query the hit
                return MTurkUtil.getHIT(params.query.mturk.hitId)
                .then((hit) => {
                    console.log(hit);
                    console.log(hit.HITStatus);
                    if (hit && hit.RequesterAnnotation == id && (hit.HITStatus == 'Assignable' || hit.HITStatus == 'Unassignable' /* Means accepted by worker */)) {
                        // OK you can see it
                        // Adding also the mturk for submit url
                        let response = alarm.toObject();
                        response.mturkSubmit = process.env['MTURK_SUBMIT'];
                        console.log("Returning", response);
                        return response;
                    } else {
                        throw new Errors.NotFound();
                    }
                })
            }
            else if (params.user && params.user._id.toString() == alarm.assignedTo.toString()) {
                console.log("Rouser alarm");
                return alarm;
            } else {
                return Promise.reject(new Errors.NotFound());
            }
        })
        .catch((err) => {
            console.log("Error!",err);
            return Promise.reject(new Errors.NotFound());
        });
    }


    // Routine tasks
    // ---------------
    //
    routineTasks() {
        console.log("Routine tasks\n-------------");   
        this.freeStalledAlarms()
        .then((result) => {
            console.log("Free stalled alarms: " + result.n);

            return this.notifySleepers();
        })
        .then((result) => {
            console.log("Notified sleepers: " + result.n);
        })
    }

    freeStalledAlarms() {
        let timeout = new Date();
        timeout.setHours(timeout.getHours() - STALLLING_TIMEOUT_HOURS);

        return Alarm.update(
            { 
               'recording.finalized' : false,
               'deleted': false,
               'assignedTo': {$ne: null},
               'assignedAt': {$lt: timeout}
            }, 
            { $set: { assignedTo: null  } }
        );
    }

    notifySleepers() {
        if (process.env.NODE_ENV == 'production') {
            let notifyTime = new Date();
            notifyTime.setHours(notifyTime.getHours() + NOTIFY_SLEEPERS_HOURS);
            return Alarm.find({
                $and: [
                    {time: {$lt: notifyTime}},
                    {time: {$gt: new Date()}}
                ],
                deleted: false,
                notifiedSleeper: false,
                analyzed: true
            })
            .then((alarms) => {
                let action = (alarm) => {
                    return this.app.service('users').get(alarm.userId)
                    .then((user) => {
                        let message = IntlMixin.formatMessage('SLEEPER_NOTIFY',{
                            name: user.name,
                            time: alarm.time
                        },withTimezone(alarm.timezone),user.locale);

                        return this.messageUser(user._id, message);
                    })
                    .then((result) => {
                        return this.app.service('alarms/sleeper').patch(alarm._id, {notifiedSleeper: true});
                    })
                    .catch((err) => {
                        console.log("Error notifying sleeper", err);
                    })
                }
                let actions = [];
                for (let alarm of alarms) {
                    actions.push(action(alarm));
                }
                return Promise.all(actions);
            })
            .then((results) => {
                return {n: results.length}
            })
            .catch((err) => {
                console.log("Error notifying sleepers!", err);
            });
        }
        else {
            return Promise.resolve({n: 0});
        }
    }
}
