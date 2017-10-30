import Session from '../models/session-persistent'
import STIRError from '../../app/stir-error'

// Uses the persisent session
export default class SessionService {
    constructor() {
    }
    setup(app) {
        this.app = app;
    }
    find(params) {
        if (params.user) {
            let session = Session.getFor(params.user._id);
            if (session && session.state) {
                return Promise.resolve(session.state);
            } else {
                return Promise.resolve({});
            }
        } else {
            return Promise.resolve({});
        }
    }

    create(data,params) {
        console.log("Session create", data);
        return Promise.resolve()
        .then(() => {
            if (data.newAlarm) {
                return this.app.service("alarms/sleeper").find({
                    query: {
                        userId: params.user._id,
                        time: data.newAlarm.time,
                        deleted: false,
                        failed: false
                    }
                })
                .then((result) => {
                    if (result.length > 0) {
                        throw(new STIRError("EXISTS"));
                    }
                })
            } else {
                return;
            }
        })
        .then(() => {
            console.log("Set session state data!",data);
            Session.setFor(params.user._id, {state: data});
            return {status: "success"}
        });
    }

    patch(id, data, params) {
    }
}
