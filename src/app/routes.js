// Application routes - shared by client and server
import miscUtil from './util/misc'

class Routes {
    constructor() {
    }
    go(next, req, res) {
        console.log("Go!");
        req.handledRoute = true;
        if (next) {
            next();
        } else if(res) {
            req.handled = true;
            res();
        }
    }


    // TODO: Router based tags? 
    // TODO: Webpack lazy loading?

    runRoutingTable(app,appState) {
        app.route('/').get((req, res, next) => {
            console.log("Default route!")
            req.appState.main.setRole(null)
            this.go(next, req, res);
        });

        app.route('/sleeper*').get((req, res, next) => {
            console.log("Sleeper route!");
            req.appState.main.setRole("sleeper");
            req.appState.sleeper.setAction("clock");
            this.populate(req, 'auth', 'getStatus');
            this.populate(req, 'sleeper', 'getAlarms');
            this.go(next, req, res);
        });

        app.route('/sleeper/alarms/add').get((req, res, next) => {
            req.appState.sleeper.setAction("add-alarm");
            req.appState.sleeper.setAddAlarmStage("time");
            this.go(next, req, res);
        });

        app.route('/sleeper/alarm/:id').get((req, res, next) => {
            this.populate(req, 'sleeper', 'chooseAlarm', req.params.id);
            req.appState.sleeper.setAction("edit-alarm");
            this.go(next, req, res);
        });

        app.route('/rouser*').get((req, res, next) => {
            console.log("Rouser route");
            req.appState.main.setRole("rouser");
            this.populate(req, 'auth', 'getStatus');
            this.go(next, req, res);
        });

        app.route('/rouser/alarms').get((req, res, next) => {
            console.log("Rouser alarms route");
            req.appState.rouser.setAction("alarms");
            this.populate(req, 'rouser', 'getAlarms');
            this.go(next, req, res);
        });

        app.route('/rouser/sign-up').get((req, res, next) => {
            console.log("Rouser sign-up route");
            req.appState.rouser.setAction("sign-up");
            this.go(next, req, res);
        });

        app.route('/rouser/alarm/:id').get((req, res, next) => {
            console.log("Rouser alarm route", req);
            req.appState.rouser.setAction("alarm");
            this.populate(req, 'rouser', 'chooseAlarm', params.id)
            this.go(next, req, res);
        });

        app.route('/rouser/alarm/:id/record').get((req, res, next) => {
            console.log("Rouser alarm record route", req);
            req.appState.rouser.setRecordStage('record');
            this.go(next, req, res);
        });
        app.route('/rouser/alarm/:id/mix').get((req, res, next) => {
            console.log("Rouser alarm mix route", req);
            req.appState.rouser.setRecordStage('mix');
            this.go(next, req, res);
        });

        /*

        app.route('*').get((req, res, next) => {
            if (!req.handledRoute) {
                res.status(404).send('Nothing to see here!');
            } else {
                this.go(next, req);
            }
        }); */
    }
    populate(req, store, task, ...args) {
        if (IS_CLIENT) {
            // Execute now
            req.appState[store][task].apply(req.appState[store], args);
        } else {
            // Execute after
            req.populateQueue.push ({task: task, store: store, args: args});
        }
    }
};

// Singleton
let instance = new Routes();
export default instance;


