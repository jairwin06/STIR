export default function patchAlarmHook(hook) {
    console.log("Path alarm hook!");
    if (hook.params.provider == "socketio") {
        // User can only update the time
        if (hook.data.time) {
            hook.data = {time: hook.data.time}
        } else {
            hook.data = {};
        }
    }
    return hook;
}

