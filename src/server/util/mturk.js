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
          Keywords: 'record, recording, alarm, wake-up, STIR',
          MaxAssignments: 1,
        };
        
    }
    createHITForAlarm(id) {
        console.log("Creating HIT for " + id);

        let params = Object.assign({}, this.params);
        params.Question = `
            <ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">
              <ExternalURL>` + process.env['SERVER_URL'] + '/rouser/alarm/' + id + `</ExternalURL>
              <FrameHeight>400</FrameHeight>
            </ExternalQuestion>
        `
        params.RequesterAnnotation = id;

        return this.listHITs()
        .then((hits) => {
            for (let i = 0; i < hits.length; i++) {
                let hit = hits[i];
                if (hit.RequesterAnnotation == id.toString() && hit.HITStatus != "Disposed") {
                    console.log("Found!");
                    throw new Error("A HIT already exists for this alarm!");
                }
            }
            return this.createHIT(params);
        })
    }

    createHIT(params) {
        return new Promise((resolve, reject) => {
            this.mturk.createHIT(params, (err, data) => {
                if (err) {
                    console.log("Error creating HIT!", err);
                    reject(err);
                } 
                else {
                    resolve(data);
                }
            });
        });
    }
    
    listHITs() {
        return new Promise((resolve, reject) => {
            this.mturk.listHITs({}, (err, data) => {
                if (err) {
                    console.log("Error listing HITs!", err);
                    reject(err);
                } 
                else {
                    console.log(data);
                    resolve(data.HITs);
                }
            });
        });
    }
    
    getHIT(id) {
        return new Promise((resolve, reject) => {
            this.mturk.getHIT({HITId: id}, (err, data) => {
                if (err) {
                    console.log("Error getting HIT!", err);
                    reject(err);
                } else {
                    resolve(data.HIT);
                }
            })
        })        
    }
};

// Singleton
let instance = new MTurkUtil();
export default instance;
