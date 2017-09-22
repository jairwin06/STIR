import storage from 'node-persist'

class PersistentSession {
    constructor() {
        storage.init();
    }
    setFor(userId,object) {
        let userObject = storage.getItemSync(userId.toString());
        if (!userObject) {
            userObject = {};
        }
        if (object.state) {
            if (!userObject.state) {
                userObject.state = {};
            }
            Object.assign(userObject.state, object.state);
        } else {
            Object.assign(userObject, object);
        }
        console.log("Set item sync", userId.toString(), userObject);
        storage.setItemSync(userId.toString(), userObject);
    }

    getFor(userId) {
        return storage.getItemSync(userId.toString());
    }
};

// Singleton
let instance = new PersistentSession();
export default instance;
