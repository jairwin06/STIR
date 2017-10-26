
export default function tooEarlyHook(hook) {
    if (process.env.NODE_ENV == 'production' && (hook.params.provider == "socketio" || hook.params.provider == "rest") &&
        (hook.data.newAlarm || hook.data.time)) {
        console.log("Too early hook",hook.data);
        let tooEarlyHours = hook.app.service('alarms/rouser').getTooEarlyHours();
        let alarmTime;
        if (hook.data.time) {
            alarmTime = new Date(hook.data.time);
        } else {
            alarmTime = new Date(hook.data.newAlarm.time);
        }
        let timeMs = tooEarlyHours * 60 * 60 * 1000;
        let now = Date.now();
        if (alarmTime.getTime() - now < timeMs) {
            console.log("Too early!", alarmTime.getTime() - now);
            hook.result = {status: "too_early", hours: tooEarlyHours}
        }

    }
    return hook;
}

