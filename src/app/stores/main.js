import Store from './store';

export default class MainStore extends Store {
    constructor() {
        super();
        console.log("Init MainStore");
        this.role = null;
    }     

    setRole(role) {
        if (this.role != role) {
            console.log("Setting role", role);
            this.role = role;
            this.trigger("main_role_updated", role);
        }
    }
};

