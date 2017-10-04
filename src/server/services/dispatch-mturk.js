import MTurkUtil from '../util/mturk'

export default function dispatchMTurkHook(hook) {
    if (hook.data.mturk) {
        console.log("Sending HIT!");
        return hook.app.service('alarms/sleeper').get(hook.id, {query : {$select : ['id','time']}})
        .then((alarm) => {
            return MTurkUtil.createHITForAlarm(hook.id, alarm.time)
        })
        .then(() => {
            console.log("Created HIT");
            return hook;
        })
    } else {
        return hook;
    }
}

