export default function patchAlarmHook(hook) {
    console.log("Path alarm hook!");
    if (hook.params.provider == "socketio" || hook.params.provider == "rest") {
        // User can only update the time
        let newData = {};
        if (hook.data.time) {
            newData.time = hook.data.time;
        }    
        if (hook.data.deleted) {
            newData.deleted = hook.data.deleted;
        }    
        hook.data = newData;
    }
    return hook;
}

