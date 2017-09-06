import TwilioUtil from '../util/twilio'

export default { 
    getTwiML: function(req,res) {
        console.log("TWIML SERVICE CALLED!", req.body);
        res.send("Great");
    },

    dispatchCall: function(hook) {
        console.log("TWIML Dispatch call hook!", hook.data, hook.params);
        TwilioUtil.client.calls.create({
                url: 'http://stir.avner.us/twiml.xml',
                to: hook.params.user.phone,
                from: TwilioUtil.TWILIO_PHONE_NUMBER
        })

        return hook; 
    }
}

