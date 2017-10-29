import Alarm from '../models/alarm'
import User from '../models/user'
import TwilioUtil from '../util/twilio'
import MTurkUtil from '../util/mturk' 
import Session from '../models/session-persistent'
import Errors from 'feathers-errors'
import {IntlMixin} from 'riot-intl'
import {BaseI18n, withTimezone} from '../../app/i18n/i18n'
import DummyAlarms from '../models/dummy-alarms'

let ALARMS_IN_QUEUE = 1;
const FIELDS_TO_RETURN = "_id time name prompt locales country pronoun recording dummy"

const ROUTINE_TASKS_INTERVAL = 1000 * 60;
const STALLLING_TIMEOUT_HOURS = 1;
const NOTIFY_SLEEPERS_HOURS = 12;
const MTURK_TRIGGER_HOURS = 3;
const ROUSERS_TO_NOTIFY = 2;
const TOO_EARLY_HOURS = 8;
const CALL_RETRY_TIMEOUT = 1000 * 90;

export default class AlarmManager {
    constructor() {
    }
    setup(app) {
        this.app = app;
        app.service('alarms/sleeper').on('patched', alarm => this.onAlarmPatched(alarm));

        // Routine tasks
        setInterval(() => {
            this.routineTasks();            
        },ROUTINE_TASKS_INTERVAL)
        //
        // Start the clock
        setInterval(() => {
            this.tick();
        },1000);
    }
    getTooEarlyHours() {
        return TOO_EARLY_HOURS;
    }
    getPendingAlarms() {
        console.log("Get pending alarms");
        Alarm.find({
            time: {$gt: new Date()},
            'recording.finalized': true,
            delivered: false,
            dummy: false,
            deleted: false,
            failed: false
        }).sort({time: -1})
        .then((result) => {
            console.log("Result:", result.length + " Alarms");
            this.pendingAlarms = result;
            this.popAlarm();
        })
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
                },CALL_RETRY_TIMEOUT);

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
            //
            // failed after a minute
            setTimeout(() => {
                this.alarmFailed(userId);
            },CALL_RETRY_TIMEOUT);
        }
    }
    alarmFailed(userId) {
        let sessionData = Session.getFor(userId);
        if (sessionData.pendingAlarm) {
            console.log("ALARM FAILED!", sessionData.pendingAlarm);
            this.app.service('users').get(userId)
            .then((user) => {
                let message = IntlMixin.formatMessage('ALARM_FAILED_NOTIFY',{
                    name: user.name,
                    time: new Date(sessionData.pendingAlarm.time),
                    url: process.env.SERVER_URL + "/sleeper/alarm/" + sessionData.pendingAlarm._id + "/summary",
                },withTimezone(sessionData.pendingAlarm.timezone),user.locale);

                return this.messageUser(user._id, message);
            })
            .then((result) => {
                return this.app.service('alarms/sleeper').patch(sessionData.pendingAlarm._id, {failed: true});
            })
            .then(() => {
                Session.setFor(userId, {pendingAlarm : null});
            })
            .catch((err) => {
                console.log("Error notifying sleeper on failed alarm", err);
                Session.setFor(userId, {pendingAlarm : null});
            })
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
        console.log("Alarm patched!",alarm);
        this.getPendingAlarms();
    }

    alarmDelivered(alarm) {
        console.log("ALARM DELIVERED!", alarm);
        this.app.service('alarms/sleeper').patch(alarm._id, {delivered: true});
        Session.setFor(alarm.userId, {pendingAlarm : null});
        if (alarm.assignedTo) {
            this.messageUser(alarm.assignedTo, "Your wake-up call was just delieverd to the sleeper! Thank you from STIR");
        }
        this.sendAlarmSummary(alarm._id, alarm.userId);
    }
    sendAlarmSummary(alarmId, userId) {
        // In 2 minutes..
        setTimeout(() => {
            console.log("Sending summary message");
            this.app.service('users').get(userId)
            .then((user) => {
                let message = IntlMixin.formatMessage('SLEEPER_SUMMARY_MESSAGE',{
                    url: process.env.SERVER_URL + "/sleeper/alarm/" + alarmId + "/summary",
                    name: user.name
                },BaseI18n,user.locale);
                return this.messageUser(userId, message);
            })
            .then((result) => {
                console.log("Sent");
            })
            .catch((err) => {
                console.log("Error sending alarm summary!", err);
            })
        }, 1000 * 60 * 2);
    }
    messageUser(id, message) {
        return this.app.service('users').find({
            query: {_id: id}
        })
        .then((result) => {
            if (result.length > 0) {
                console.log("Sending message: ", message);
                let user = result[0];
                return TwilioUtil.sendMessage(user.phone, message);
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
                deleted: false,
                failed: false,
                time: {$gt: new Date()}
            };
            return Alarm.find(query).select(FIELDS_TO_RETURN)
            .then((result) => {
                if (result.length < ALARMS_IN_QUEUE) {
                    let alarmsToGo = ALARMS_IN_QUEUE - result.length;
                    let alarmIds;

                    console.log("Still need to find " + alarmsToGo + " more alarms");
                    console.log("Capable languages ", params.user.alarmLocales);
                    let query = {
                        assignedTo: null,
                        mturk: false,
                        analyzed: true,
                        dummy: false,
                        locales: {$elemMatch: {$in: params.user.alarmLocales}},
                        time: {$gt: new Date()}
                    };

                    if (process.env.NODE_ENV == 'production') {
                        // Don't wake yourself
                        query.userId = {$ne: params.user._id};
                    }
                    return Alarm.find(query).select("_id").limit(alarmsToGo)
                    .then((newIds) => {
                        alarmIds = newIds;
                        console.log("We have " + alarmIds.length + " alarms to assign");
                        if (alarmIds.length == 0) {
                            if (process.env.NODE_ENV == 'production' && params.user.alarmsRecorded == 0) {
                                // ASSIGNING DUMMY ALARM
                                console.log("ASSIGNING DUMMY ALARM!!!");
                                return Alarm.count({
                                    dummy: true
                                })
                                .then((totalDummyAlarms) => {
                                    let random = Math.floor(Math.random()*totalDummyAlarms);                
                                    return Alarm.find({
                                        dummy: true
                                    }).skip(random).limit(1);
                                })
                                .then((result) => {
                                    console.log("Got dummy alarm for " + result[0].name);
                                    alarmIds.push(result[0]._id);
                                })
                            }
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
                                    deleted: false,
                                    failed: false,
                                    time: {$gt: new Date()}
                                }]}]
                            }
                        ).select(FIELDS_TO_RETURN)                        
                    })
                } else {
                    return result;
                }
            })
            .then((result) => {
                let waitingForAlarms = (result.length == 0);
                this.app.service("users").patch(params.user._id, {waitingForAlarms: waitingForAlarms});
                return result;
            })
        }
    }
    get(id, params) {
        console.log("Get specific alarm!", id, params);        
        return Alarm.findOne({
            _id: id,
            'recording.finalized': false,
            analyzed: true,
            $or: [
                {time: {$gt: new Date()}},
                {dummy: true}
            ]
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
            else if (params.user && (alarm.dummy || (params.user._id.toString() == alarm.assignedTo.toString()))) {
                console.log("Rouser alarm");
                if (alarm.dummy) {
                    console.log("Dummy alarm so dummy mixUrl");
                    alarm.recording.mixUrl = 
                        '/recordings/' + 
                        alarm._id + '-' + 
                        params.user._id + '-mix.mp3'
                }
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
    failedAnalysis(alarm,user) {
        let message = IntlMixin.formatMessage('FAIL_NOTIFY',{
                name: user.name,
                time: alarm.time
        },withTimezone(alarm.timezone),user.locale);

        this.messageUser(user._id, message);
    }


    // Routine tasks
    // ---------------
    //
    routineTasks() {
        this.freeStalledAlarms()
        .then((result) => {
            if (result.n > 0) {
                console.log("Free stalled alarms: " + result.n);
            }
            return this.notifySleepers();
        })
        .then((result) => {
            if (result.n > 0) {
                console.log("Notified sleepers: " + result.n);
            }

            return this.dispathMturk();
        })
        .then((result) => {
            if (result.n > 0) {
                console.log("Dispatched MTurkL " + result.n);
            }
            return this.notifyRousers();
        })
        .then((result) => {
            if (result.n > 0) {
                console.log("Notified rousers: " + result.n);
            }
        })
        .catch((err) => {
            console.log("Unexsleeper/alarms#pected error in routine tasks", err);
        })
    }

    freeStalledAlarms() {
        let timeout = new Date();
        timeout.setHours(timeout.getHours() - STALLLING_TIMEOUT_HOURS);

        return Alarm.update(
            { 
               'recording.finalized' : false,
               'deleted': false,
               'failed': false,
               'dummy': false,
               'assignedTo': {$ne: null},
               'assignedAt': {$lt: timeout}
            }, 
            { $set: { assignedTo: null  } },
            { multi: true  }
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
                failed: false,
                dummy: false,
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
                return Promise.resolve({n: 0});
            });
        }
        else {
            return Promise.resolve({n: 0});
        }
    }
    notifyRousers() {
        if (process.env.NODE_ENV == 'production') {
            return Alarm.find({
                time: {$gt: new Date()},
                deleted: false,
                failed: false,
                dummy: false,
                notifiedRousers: false,
                mturk: false,
                assignedTo: null,
                analyzed: true
            })
            .then( async (alarms) => {
                console.log(alarms.length + " alarms not yet notified to rousers");
                let rousersNotified = 0;
                let action = async (alarm) => {
                    let notified;
                    return this.notifyWaitingRousers(alarm)
                    .then((result) => {
                        notified = result;
                        console.log("This alarm Notified " + notified + " rousers");
                        if (notified > 0) {
                            return this.app.service('alarms/sleeper').patch(alarm._id, {notifiedRousers: true})
                            .then(() => {
                                return notified;
                            })
                        } else {
                            return notified;
                        }
                    })
                    .catch((err) => {
                        console.log("Error notifying rousers!", err);
                    })
                }
                let actions = [];
                for (let alarm of alarms) {
                   rousersNotified += await action(alarm);
                }
                return rousersNotified;
            })
            .catch((err) => {
                console.log("Error notifying rousers!", err);
                return Promise.resolve({n: 0});
            });
        }
        else {
            return Promise.resolve({n: 0});
        }
    }

    notifyWaitingRousers(alarm) {
        console.log("Get waiting rousers");        
        return User.count({
            waitingForAlarms: true,
            phone: {$ne: null},
            alarmLocales: {$elemMatch: {$in: alarm.locales}}
        })
        .then(async (totalWaiting) => {
            console.log(totalWaiting + " rousers waiting");

            let numToNotify = Math.min(ROUSERS_TO_NOTIFY, totalWaiting);

            let numNotified = 0;

            for (let i = 0; i < numToNotify; i++) {
                let random = Math.floor(Math.random()*totalWaiting);                
                let rousers = await User.find({
                    waitingForAlarms: true,
                    phone: {$ne: null},
                    alarmLocales: {$elemMatch: {$in: alarm.locales}}
                }).skip(random).limit(1);

                let rouser = rousers[0];
                console.log("Rouser", rouser);

                try {
                    let message = IntlMixin.formatMessage('ROUSER_NOTIFY',{
                        url: process.env.SERVER_URL + "/rouser/alarms"
                    },BaseI18n,rouser.locale);

                    console.log(message);

                    await this.messageUser(rouser._id, message);
                    numNotified++;
                }
                catch(err) {
                    console.log("Error notifying rouser " + rouser._id, err);
                }
                await this.app.service("users").patch(rouser._id, {waitingForAlarms: false});
            }

            return numNotified;
        });
    }

    dispathMturk() {
        if (process.env.NODE_ENV == 'production') {
            let triggerTime = new Date();
            triggerTime.setHours(triggerTime.getHours() + MTURK_TRIGGER_HOURS);
            return Alarm.find({
                $and: [
                    {time: {$lt: triggerTime}},
                    {time: {$gt: new Date()}}
                ],
                deleted: false,
                failed: false,
                dummy: false,
                analyzed: true,
                assignedTo: null,
                mturk: false
            })
            .then((alarms) => {
                let action = (alarm) => {
                    return this.app.service('alarms/admin').patch(alarm._id, {assignedTo: null, mturk: true});
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
                return Promise.resolve({n: 0});
                console.log("Error Dispatching mturk", err);
            });
        }
        else {
            return Promise.resolve({n: 0});
        }
    }

    createDummyAlarms() {
        console.log("Creating dummy alarms");

        let adminUser;
        return User.findOne({
            role: 'admin'
        })
        .then((user) => {
            adminUser = user;
            // Remove existing ones first
            return Alarm.remove({ dummy: true })
        })
        .then(() => {
            let actions = [];
            for (let dummyAlarm of DummyAlarms) {
                dummyAlarm.userId = adminUser._id;
                actions.push(Alarm.create(dummyAlarm));
            }
            return Promise.all(actions);
        })
        .then((result) => {
            console.log("Created");
        })
        .catch((err) => {
            console.log("Error while creating dummy alarms!", err);
        })
    }
}
