class Session {
    constructor() {
        this.dict = {};
    }
    for(userId) {
        if (!this.dict[userId]) {
            this.dict[userId] = {};
        }
        return this.dict[userId];
    }
};

// Singleton
let instance = new Session();
export default instance;
