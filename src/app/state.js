import MainStore from './stores/main';
import AuthStore from './stores/auth'
import SleeperStore from './stores/sleeper'
import RouserStore from './stores/rouser'
import AdminStore from './stores/admin'

import {observable} from 'riot'

export default class State {
    constructor() {
        observable(this);
        this.main = new MainStore();
        this.auth = new AuthStore();
        this.sleeper = new SleeperStore(this);
        this.rouser = new RouserStore(this);
        this.admin = new AdminStore(this);
            
        console.log("State Initialized");
    }
};
