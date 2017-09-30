import MTurkUtil from '../util/mturk'

export default function dispatchMTurkHook(hook) {
    if (hook.data.mturk) {
        console.log("Sending HIT!");
        MTurkUtil.createHIT(hook.id);
    }
    return hook;
}

