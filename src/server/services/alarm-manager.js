import Alarm from '../models/alarm'

const ALARMS_IN_QUEUE = 2;
const FIELDS_TO_RETURN = "_id time name prompt"

export default class AlarmManager {
    setup(app) {
        this.app = app;
    }
    find(params) {
        // First get the alarms that this user was assigend to
        console.log("Alarm manager for rouser", params.user);
        if (!params.user.status.signedUp) {
            // Can't assign alarms if they didn't sign up
            return Promise.resolve([]);
        } else {
            // First get alarms assigned to this rouser and not fulfilled
            return Alarm.find({
                assignedTo: params.user._id,
                fulfilled: false
            }).select(FIELDS_TO_RETURN)
            .then((result) => {
                if (result.length < ALARMS_IN_QUEUE) {
                    let alarmsToGo = ALARMS_IN_QUEUE - result.length;
                    let alarmIds;

                    console.log("Still need to find " + alarmsToGo + " more alarms");
                    return Alarm.find({
                        assignedTo: null
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
                                    fulfilled: false
                                }]}]
                            }
                        ).select(FIELDS_TO_RETURN)                        
                    })
                } else {
                    return result;
                }
            }).then((alarms) => {
                console.log("Alarms queue", alarms);
            })
        }
    }

}
