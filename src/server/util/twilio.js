import twilio from 'twilio'

const TWILIO_ACCOUNT_SID = process.env['TWILIO_ACCOUNT_SID'];
const TWILIO_AUTH_TOKEN = process.env['TWILIO_AUTH_TOKEN'];
const TWILIO_PHONE_NUMBER = process.env['TWILIO_PHONE_NUMBER']


class TwilioUtil {
    constructor() {
        this.client = new twilio(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);
        this.TWILIO_PHONE_NUMBER = TWILIO_PHONE_NUMBER;
    }
};

// Singleton
let instance = new TwilioUtil();
export default instance;
