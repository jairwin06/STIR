import twilio from 'twilio'

const TWILIO_ACCOUNT_SID = "AC8f51fced58dca14ba3c9ccc454bbcd9f"
const TWILIO_AUTH_TOKEN = "94c2577dc5cd179af8652d4d5bff432c"
const TWILIO_PHONE_NUMNER = "+14154172576"

export default class UserContactService {
    setup(app) {
        this.app = app;
        this.twilioClient = new twilio(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);
    }
    find(params) {
        // Return just the status
        return Promise.resolve(params.user.status);
    }

    create(data,params) {
        console.log("set user contact", data,params);

        // TODO: Generate a verification code and send
        if (!data.phone) {
            return Promise.reject(new Error("Data does not contain a phone number"));
        }
        data.verificationCode = this.get4DigitCode();
        data.status = {
            phoneValidated: false,
        }
        
        return this.app.service("users").update(params.user._id, data)
        .then((result) => {
           console.log("User updated sending text");
           return this.twilioClient.messages.create({
                body: 'Your STIR code is ' + result.verificationCode,
                to: result.phone,  
                from: TWILIO_PHONE_NUMNER
           })
        })
        .then((result) => {
            console.log("SMS result", result);
            return Promise.resolve({
                status: "success"
            });
        })
        .catch((err) => {
           console.log("Error updating contact", err);
           return Promise.reject(err);
        }) 
    }


    get4DigitCode() {
        return Math.floor(1000 + Math.random() * 9000);
    }
}
