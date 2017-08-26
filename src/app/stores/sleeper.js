'use strict'
'use nodent';

import Store from './store';
import SocketUtil from '../util/socket'

export default class SleeperStore extends Store {

    constructor(state) {
        super(state);
        console.log("Init SleeperStore", this._state);
        this.test = "Avner";
    }     
    async getAlarms(fruit) { 
        try {
            console.log("Getting alarms");
            let result = await SocketUtil.rpc('alarms::find');
            console.log("Alarms result", result);
        }

        catch (e) {
            console.log("Error getting alarms  ", e);                    
        }
    }
};
