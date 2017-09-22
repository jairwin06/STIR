import Session from '../models/session-persistent'

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
        console.log("Set session state data!",data);
        Session.setFor(params.user._id, {state: data});
    }

    patch(id, data, params) {
    }
}
