import MainStore from './stores/main';

import {observable} from 'riot'

export default class State {
    constructor() {
        observable(this);
        this.main = new MainStore();

        console.log("State Initialized");
    }
};
