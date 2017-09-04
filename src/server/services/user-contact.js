import twilio from 'twilio'

const TWILIO_ACCOUNT_SID = process.env['TWILIO_ACCOUNT_SID'];
const TWILIO_AUTH_TOKEN = process.env['TWILIO_AUTH_TOKEN'];
const TWILIO_PHONE_NUMBER = process.env['TWILIO_PHONE_NUMBER']

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
        if (data.code && params.user.verificationCode) {
            return this.verify(data,params)
        } else {
            return this.generateVerficationCode(data,params);
        }
    }

    generateVerficationCode(data, params) {
        if (!data.phone) {
            return Promise.reject(new Error("Data does not contain a phone number"));
        }
        data.verificationCode = this.get4DigitCode();
        data.status = {
            phoneValidated: false,
        }
        
        return this.app.service("users").update(params.user._id, data)
        .then((result) => {
            /*
           console.log("User updated sending text");
           return this.twilioClient.messages.create({
                body: 'Your STIR code is ' + result.verificationCode,
                to: result.phone,  
                from: TWILIO_PHONE_NUMBER
           })*/
           return Promise.resolve({});
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

    verify(data,params) {
        console.log("Verify code service", data,params);
        if (data.code == params.user.verificationCode) {
            return this.app.service("users").patch(params.user._id, {status: {phoneValidated: true}})
            .then((result) => {
               return {status: "success"}
            })
        } else {
            return Promise.reject(new Error("Code is incorrect"));
        }
    }


    get4DigitCode() {
        return Math.floor(1000 + Math.random() * 9000);
    }
}
