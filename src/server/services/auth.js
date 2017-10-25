import AuthSettings from '../auth-settings'
import geoip from 'geoip-lite'
import {countries} from 'country-data'

export function authHook(hook) {
    return new Promise((resolve, reject) => {
        try {
            console.log("Authentication hook! ",hook.data);
            if (hook.data.strategy == "local") {
                resolve(hook);
            }
            else {
                console.log("IP?", hook.params.ip);
                let accessToken = null;
                let mturk = hook.data.mturk || null;

                if (hook.params.provider == "rest" && hook.params.headers.authorization) {
                    accessToken = hook.params.headers.authorization;
                }
                else if (hook.params.provider == "socketio" && hook.data.accessToken) {
                    accessToken = hook.data.accessToken;
                }

                if (!accessToken) {
                    if (hook.params.provider == "rest") {
                        console.log("No token! creating user");
                        createNewUser(hook.app, mturk, hook.params.ip)
                        .then((accessToken) => {
                            hook.params.headers.authorization = accessToken;
                            resolve(hook);
                        })
                    }
                } else {
                    console.log("Found token! verifying");
                    verifyUser(accessToken, hook.app, mturk)
                    .then((result) => {
                        resolve(hook);
                    })
                    .catch ((error) => {
                        console.log("Error getting user", error.message,"Creating a new one");
                        createNewUser(hook.app, mturk, hook.params.ip)
                        .then((accessToken) => {
                            hook.data.accessToken = accessToken;
                            hook.params.headers.authorization = accessToken;
                            resolve(hook);
                        });
                    })
                }

            }
        } catch (e) {
            reject(e);
        }
    })
}
export function authMiddleware(req,res,next) {
    try {
        console.log("Authentication middleware!", req.method, req.originalUrl)
        if (!req.cookies[AuthSettings.cookie.name]) {
            next();
        } else {
            console.log("Found token! verifying");
            let accessToken = req.cookies[AuthSettings.cookie.name];
            verifyUser(accessToken, req.app)
            .then((result) => {
                req.user = result;
                req.accessToken = accessToken;
                next();
            })
            .catch ((error) => {
                console.log("Error getting user", error.message);
                next();
            })
        }
    } catch (e) {
        console.log("Error!o<",e)
        next();
    }
}
function createNewUser(app, mturk, ip) {
    let data = {};
    if (mturk) {
        console.log("Assigning mturk user to", mturk);                      
        data = {
            role: "mturk",
            mturkAlarm: mturk
        }
    }
    return Promise.resolve({})
    .then(() => {
        if (ip) {
            // Get the country code
            let geo = geoip.lookup(ip);
            if (geo) {
                data.countryCode = geo.country;
                if (countries[geo.country]) {
                    data.country = countries[geo.country].name;
                }
            }
        }
        return;
    })
    .then(() => {
        return app.service('users').create(data)
    })
    .then(function(user) {
      console.log("Creating JWT token");
      return app.passport.createJWT({userId: user._id}, AuthSettings);
    });
}
export function createFixtures(app) {
    let users = app.service('users');
    return users.find({query: {role: "admin"}})
    .then((result) => {
        if (result.length == 0) {
            return users.create({
                role: "admin",
                name: "admin",
                password: process.env['ADMIN_PASSWORD']
            })
        }
    });
}

export function verifyUser(accessToken, app, mturk = null) {
    return app.passport.verifyJWT(accessToken, {secret: AuthSettings.secret})
    .then((result) => {
        // Verify the user exists
        console.log("Result:", result);
        return app.service("users").get(result.userId);
    })
    .then((user) => {
        if (!user) {
            throw new Error("User not found");
        }
        console.log("Auth found JWT user! " + user._id);
        if (mturk) {
            console.log("Assigning mturk user to", mturk);                      
            return app.service("users").patch(user._id, {role: "mturk", mturkAlarm: mturk});
        } else {
            if (user.role == "mturk") {
                console.log("This is an mturk user assigned to", user.mturkAlarm)
            }
            return user;
        }
    })
}


