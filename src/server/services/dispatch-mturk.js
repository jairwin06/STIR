import MTurkUtil from '../util/mturk'

export default function dispatchMTurkHook(hook) {
    if (hook.data.mturk) {
        console.log("Sending HIT!");
        return MTurkUtil.createHITForAlarm(hook.id)
        .then(() => {
            console.log("Created HIT");
            return hook;
        })
    } else {
        return hook;
    }
}

