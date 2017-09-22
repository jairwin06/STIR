import Session from '../models/session-persistent'

export default function aferSocialLink(hook) {
    console.log("After social link hook!");
    if (hook.data.twitter) {
        console.log("Setting pending twitter");
        Session.setFor(hook.data._id, {state: {pendingTwitter: true}});
    }
}
