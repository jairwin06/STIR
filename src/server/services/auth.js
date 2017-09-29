import AuthSettings from '../auth-settings'

export function authHook(hook) {
    return new Promise((resolve, reject) => {
        try {
            console.log("Authentication hook!",hook.data.strategy);
            if (hook.data.strategy == "local") {
                resolve(hook);
            }
            else {
                let accessToken = null;
                if (hook.params.provider == "rest" && hook.params.headers.authorization) {
                    accessToken = hook.params.headers.authorization;
                }
                else if (hook.params.provider == "socketio" && hook.data.accessToken) {
                    accessToken = hook.data.accessToken;
                }

                if (!accessToken) {
                    if (hook.params.provider == "rest") {
                        console.log("No token! creating user");
                        createNewUser(hook.app)
                        .then((accessToken) => {
                            hook.params.headers.authorization = accessToken;
                            resolve(hook);
                        })
                    }
                } else {
                    console.log("Found token! verifying");
                    verifyUser(accessToken, hook.app)
                    .then((result) => {
                        resolve(hook);
                    })
                    .catch ((error) => {
                        console.log("Error getting user", error.message,"Creating a new one");
                        createNewUser(hook.app)
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
        console.log("Error!",e)
        next();
    }
}
function createNewUser(app) {
    return app.service('users').create({
    }).then(function(user) {
      console.log("Creating JWT token");
      return app.passport.createJWT({userId: user._id}, AuthSettings);
    });
}
export function createFixtures(app) {
    let users = app.service('users');
    users.find({query: {role: "admin"}})
    .then((result) => {
        if (result.length == 0) {
            return users.create({
                role: "admin",
                name: "admin",
                password: process.env['ADMIN_PASSWORD']
            })
        }
    })
    users.find({query: {role: "mturk"}})
    .then((result) => {
        if (result.length == 0) {
            return users.create({
                role: "mturk",
                name: "mturk"
            })
        }
    })
}

export function verifyUser(accessToken, app) {
    return app.passport.verifyJWT(accessToken, {secret: AuthSettings.secret})
    .then((result) => {
        // Verify the user exists
        console.log("Result:", result);
        return app.service("users").get(result.userId);
    })
    .then((user) => {
        console.log("Auth found JWT user! " + user._id);
        return user;
    })
}


