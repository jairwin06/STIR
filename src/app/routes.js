// Application routes - shared by client and server
import miscUtil from './util/misc'

class Routes {
    constructor() {
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
    next(next, req, res) {
        // Route is not yet handled (might be 404)
        if (next) {
            next();
        } else if(res) {
            res();
        }
    }

    // TODO: Webpack lazy loading?

    runRoutingTable(app,appState) {
        app.route('/').get((req, res, next) => {
            console.log("Default route!")
            req.appState.main.setRole(null)
            this.populate(req, 'auth', 'getStatus');
            this.go(next, req, res);
        });

        app.route('/sleeper*').get((req, res, next) => {
            req.appState.main.setRole("sleeper");
            this.populate(req, 'auth', 'getStatus');
            this.populate(req, 'sleeper', 'getAlarms');
            this.next(next, req, res);
            
        });
        app.route('/sleeper/alarms').get((req, res, next) => {
            req.appState.sleeper.setAction("clock");
            this.go(next, req, res);
        });
        app.route('/sleeper/alarms/add*').get((req, res, next) => {
            if (IS_SERVER) {
                this.populate(req, 'sleeper', 'restoreProgress');
            }
            this.next(next, req, res);
        });
        app.route('/sleeper/alarms/add/time').get((req, res, next) => {
            this.go(next, req, res);
        });
        app.route('/sleeper/alarms/add/personality').get((req, res, next) => {
            this.go(next, req, res);
        });
        app.route('/sleeper/alarms/add/questions').get((req, res, next) => {
            this.go(next, req, res);
        });
        app.route('/sleeper/alarm/:id').get((req, res, next) => {
            this.populate(req, 'sleeper', 'chooseAlarm', req.params.id);
            req.page = "sleeper-edit-alarm";
            this.go(next, req, res);
        });

        app.route('/rouser*').get((req, res, next) => {
            console.log("Rouser route");
            req.appState.main.setRole("rouser");

            if (IS_CLIENT) {
                if (req.appState.auth.user.status && !req.appState.auth.user.status.phoneValidated && !req.appState.auth.mturk) {
                    page.show("/sign-up/contact");
                }
            } else {
                this.populate(req, 'auth', 'getStatus');
            }
            this.next(next, req, res);
        });

        app.route('/rouser/alarms').get((req, res, next) => {
            console.log("Rouser alarms route", req.query);
            req.appState.rouser.setAction("alarms");
            this.populate(req, 'rouser', 'getAlarms');
            this.go(next, req, res);
        });

        app.route('/sign-up/contact').get((req, res, next) => {
            this.populate(req, 'auth', 'getStatus');
            console.log("sign-up contact route");
            this.go(next, req, res);
        });
        app.route('/sign-up/verify').get((req, res, next) => {
            console.log("sign-up verify route");
            this.go(next, req, res);
        });
        app.route('/sign-up/locale').get((req, res, next) => {
            console.log("sign-up locale route");
            this.go(next, req, res);
        });
        app.route('/sign-up/pronoun').get((req, res, next) => {
            console.log("sign-up pronoun route");
            this.go(next, req, res);
        });
        app.route('/rouser/alarm/:id/:operation?').get((req, res, next) => {
            console.log("Rouser alarm route");
            req.appState.rouser.setAction("alarm");
            if (req.query && req.query.hitId) {
                req.appState.auth.mturk = req.query;
            }
            this.populate(req, 'rouser', 'chooseAlarm', req.params.id, req.query) 
            this.next(next, req, res);
        });

        app.route('/rouser/alarm/:id/record').get((req, res, next) => {
            console.log("Rouser alarm record route");
            req.appState.rouser.setRecordStage('record');
            req.page = "rouser-alarm-record";
            this.go(next, req, res);
        });
        app.route('/rouser/alarm/:id/mix').get((req, res, next) => {
            console.log("Rouser alarm mix route");
            req.appState.rouser.setRecordStage('mix');
            req.page = "rouser-alarm-mix";
            this.go(next, req, res);
        });
        app.route('/rouser/alarm/:id/thankyou').get((req, res, next) => {
            console.log("Rouser alarm thankyou route");
            req.page = "rouser-alarm-thankyou";
            this.go(next, req, res);
        });
        app.route('/rouser/alarm/:id/mturk').get((req, res, next) => {
            console.log("Rouser alarm mturk route");
            req.appState.rouser.setRecordStage('mturk');
            req.page = "rouser-alarm-mturk";
            this.go(next, req, res);
        });

        app.route('/admin*').get((req, res, next) => {
            console.log("admin route");
            req.appState.main.setRole("admin");
            if (IS_CLIENT){
                if(req.appState.auth.user.role != "admin") {
                    if (req.appState.admin.action != "login") {
                        req.appState.admin.setAction("login");
                        page("/admin/login");            
                    }
                }
                else {
                    if (req.appState.admin.action != "dashboard") {
                        req.appState.admin.setAction("dashboard");
                        page("/admin/dashboard");            
                    }
                }
            } else {
                this.populate(req, 'auth', 'getStatus');
            }
            this.go(next, req, res);
        });
        app.route('/admin/login').get((req, res, next) => {
            console.log("admin login route");
            req.appState.admin.setAction("login");
            this.go(next, req, res);
        });

        app.route('/admin/dashboard').get((req, res, next) => {
            console.log("admin dashboard route");
            req.appState.admin.setAction("dashboard");
            this.populate(req, 'admin', 'getAlarms');
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


