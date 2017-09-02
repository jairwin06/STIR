export default class UserContactService {
    setup(app) {
        this.app = app;
    }
    find(params) {
        // Return just the status
        return Promise.resolve(params.user.status);
    }

    create(data,params) {
        console.log("set user contact", data,params);

        // TODO: Generate a verification code and send
        
       return this.app.service("users").update(params.user._id, data)
       .then((result) => {
         return this.app.service("users").update(params.user._id, {status: {signedUp: true}})
       })
       .then((result) => {
           console.log("User updated", result);
           return Promise.resolve({
               status: "success"
           });
       })
       .catch((err) => {
           return Promise.reject(err);
       })
    }


    get4DigitCode() {
        return Math.floor(1000 + Math.random() * 9000);
    }
}
