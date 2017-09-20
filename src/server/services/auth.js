import AuthSettings from '../auth-settings'

export default function(req,res,next) {
    try {
        console.log("Authentication middleware!", req.method, req.originalUrl)
        if (!req.cookies[AuthSettings.cookie.name]) {
            console.log("No token! creating user");
            createNewUser();
        } else {
            console.log("Found token! verifying");
            verifyUser(req)
            .then((result) => {
                next();
            })
            .catch ((error) => {
                console.log("Error getting user", error.message,"Creating a new one");
                createNewUser();
            })
        }
    } catch (e) {
        console.log("Error!",e)
        throw e;
    }

    function createNewUser() {
        req.app.service('users').create({
        }).then(function(user) {
          console.log("Creating JWT token");
          req.user = user;
          return req.app.passport.createJWT({userId: user._id}, AuthSettings);
        })
        .then((accessToken) => {
            console.log("Created access token", accessToken);
            req.accessToken = accessToken;
            let farFuture = new Date(new Date().getTime() + (1000*60*60*24*365*10)); // ~10y
            res.cookie( AuthSettings.cookie.name, accessToken, { expires: farFuture, httpOnly: true  });
            next();
        }, (error) => {
            console.log("Error creating JWT", error);
            throw new Error(error);
        })
    }
}

export function verifyUser(req) {
    let accessToken = req.cookies[AuthSettings.cookie.name];
    return req.app.passport.verifyJWT(accessToken, {secret: AuthSettings.secret})
    .then((result) => {
        // Verify the user exists
        return req.app.service("users").get(result.userId);
    })
    .then((user) => {
        console.log("Auth found JWT user!");
        req.user = user;
        req.accessToken = accessToken;
        return;
    })
}

