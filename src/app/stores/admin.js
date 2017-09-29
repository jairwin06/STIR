import Store from './store';
import SocketUtil from '../util/socket'
import MiscUtil from '../util/misc'

export default class AdminStore extends Store {

    constructor(state) {
        super(state);
    }     

    async getAlarms() { 
    }

    setAction(action) {
        if (this.action != action) {
            this.action = action;
            this.trigger("admin_action_updated");
        }
    }

};
