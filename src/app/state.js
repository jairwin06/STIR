import MainStore from './stores/main';
import AuthStore from './stores/auth'
import SleeperStore from './stores/sleeper'
import FacebookStore from './stores/facebook'

import {observable} from 'riot'

export default class State {
    constructor() {
        observable(this);
        this.main = new MainStore();
        this.auth = new AuthStore();
        this.sleeper = new SleeperStore(this);
        this.facebook = new FacebookStore();

        console.log("State Initialized");
    }
};
