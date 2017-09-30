import {MTurk} from 'aws-sdk';

class MTurkUtil {
    constructor() {
        this.mturk = new MTurk({
            region: 'us-east-1',
            endpoint: 'https://mturk-requester-sandbox.us-east-1.amazonaws.com'
        });
        this.params = {
          AssignmentDurationInSeconds: 500, /* required */
          Description: 'STIR is a personalized waking service offering morning “gifts” for people around the world. Our service is their first encounter with a new day.', /* required */
          // TODO: Lifetime according to time left?
          LifetimeInSeconds: 60 * 60 * 2, /* required */
          Reward: '2', /* required */
          Title: 'STIR', /* required */
          AutoApprovalDelayInSeconds: 60 * 60,
          Keywords: 'record, mobile, phone, recording',
          MaxAssignments: 1,
        };
        
    }
    createHIT(id) {
        return new Promise((resolve, reject) => {
            console.log("Creating HIT for " + id);

            let params = Object.assign({}, this.params);
            params.Question = `
                <ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">
                  <ExternalURL>` + process.env['SERVER_URL'] + '/rouser/alarms?mturk=' + id + `</ExternalURL>
                  <FrameHeight>400</FrameHeight>
                </ExternalQuestion>
            `
            params.UniqueRequestToken = id;

            console.log(params);

            this.mturk.createHIT(params, (err, data) => {
                if (err) {
                    console.log("Error!", err);
                    reject(err);
                } 
                else {
                    console.log(data);
                    resolve(data);
                }
            });
        });
    }
};

// Singleton
let instance = new MTurkUtil();
export default instance;
