import AuthSettings from '../auth-settings'

export default function(req,res,next) {
    try {
        console.log("Authentication middleware!")
        console.log(req.cookies);
        if (!req.cookies[AuthSettings.cookie.name]) {
            console.log("No token! creating user");
            req.app.service('users').create({
              device: 'I dunno'
            }).then(function(user) {
              console.log('Created user', user);
              console.log("Creating JWT token");
              req.user = user;
              return req.app.passport.createJWT(user, {secret: AuthSettings.secret})
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
        } else {
            console.log("Found token! verifying");
            let accessToken = req.cookies[AuthSettings.cookie.name];
            req.app.passport.verifyJWT(accessToken, {secret: AuthSettings.secret})
            .then((result) => {
                req.user = result;
                req.accessToken = accessToken;
                next();
            });
        }
    } catch (e) {
        console.log("Error!",e)
        throw e;
    }
}
