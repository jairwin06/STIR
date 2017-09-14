// Application routes - shared by client and server
import miscUtil from './util/misc'

class Routes {
    constructor() {
        this.populateQueue = [];
    }
    go(next, req, res) {
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
            req.appState.sleeper.setAction("show");
            req.populateQueue.push(
                req.appState.auth.getStatus(),
                req.appState.sleeper.getAlarms()
            )
            this.go(next, req, res);
        });

        app.route('/sleeper/alarms/add').get((req, res, next) => {
            req.appState.sleeper.setAction("add");
            req.appState.sleeper.setAddAlarmStage("time");
            this.go(next, req, res);
        });

        app.route('/rouser*').get((req, res, next) => {
            console.log("Rouser route");
            req.appState.main.setRole("rouser");
            req.populateQueue.push(
                req.appState.auth.getStatus()
            )
            this.go(next, req, res);
        });

        app.route('/rouser/alarms').get((req, res, next) => {
            console.log("Rouser alarms route");
            req.appState.rouser.setAction("alarms");
            req.populateQueue.push(
                req.appState.rouser.getAlarms()
            )
            this.go(next, req, res);
        });

        app.route('/rouser/sign-up').get((req, res, next) => {
            console.log("Rouser sign-up route");
            req.appState.rouser.setAction("sign-up");
            this.go(next, req, res);
        });

        app.route('/rouser/alarm/:id').get((req, res, next) => {
            console.log("Rouser alarm record route", req);
            req.appState.rouser.setAction("alarm");
            req.appState.rouser.chooseAlarm(req.params.id);
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
};

// Singleton
let instance = new Routes();
export default instance;


