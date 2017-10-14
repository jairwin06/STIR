import {MTurk} from 'aws-sdk';
const MTURK_VERSION='20170117'
const NOTIFICATION_VERSION='2014-08-15';

class MTurkUtil {
    constructor() {
        this.mturk = new MTurk({
            region: 'us-east-1',
            endpoint: 'https://mturk-requester-sandbox.us-east-1.amazonaws.com'
        });
        this.params = {
          AssignmentDurationInSeconds: 300, /* required */
          Description: 'STIR is a personalized waking service offering morning “gifts” for people around the world. Our service is their first encounter with a new day.', /* required */
          Reward: '2', /* required */
          Title: 'STIR', /* required */
          AutoApprovalDelayInSeconds: 60 * 60,
          Keywords: 'record, recording, alarm, wake-up, STIR',
        };

        // Setup the HITType
        this.registerHITType()
        .then((hitType) => {
            console.log("Hit type", hitType);
            this.hitTypeId = hitType.HITTypeId;
            return this.setNotifications()
        })
        .then((result) => {
            console.log("Updated notification settings", result);
//            return this.testNotification();
        })
        /*
        .then((result) => {
            console.log("test notification result", result);
        })*/
    }
    createHITForAlarm(id, time) {
        console.log("Creating HIT for " + id + " at " + time);
        let timeLeft = Math.floor((time.getTime() - new Date().getTime()) / 1000);
        console.log(timeLeft + " seconds left for this alarm");

        let params = {};
        params.Question = `
            <ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">
              <ExternalURL>` + process.env['SERVER_URL'] + '/rouser/alarm/' + id + '/mturk' + `</ExternalURL>
              <FrameHeight>600</FrameHeight>
            </ExternalQuestion>
        `
        params.RequesterAnnotation = id;
        params.MaxAssignments = 1;
        params.LifetimeInSeconds = timeLeft;

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

    setNotifications() {
        let params = {
          HITTypeId: this.hitTypeId,
          Active: true,
          Notification: {
            Destination: 'arn:aws:sns:us-east-1:486219526892:MTurk', /* required */
            //Destination: 'https://sqs.us-east-2.amazonaws.com/486219526892/MTurk',
            EventTypes: [ /* required */
              //'AssignmentAccepted', 'AssignmentSubmitted', 'HITCreated', 'HITExpired', 'HITReviewable'
              'HITReviewable'
            ],
            Transport: 'SNS',
            Version: NOTIFICATION_VERSION
          }
        };
        return new Promise((resolve, reject) => {
            this.mturk.updateNotificationSettings(params, (err, data) => {
                if (err) {
                    console.log("Error updating notification settings!", err);
                    reject(err);
                } 
                else {
                    resolve(data);
                }
            });
        });
    }
    testNotification() {
        let params = {
          Notification: {
            Destination: 'arn:aws:sns:us-east-1:486219526892:MTurk', /* required */
            //Destination: 'https://sqs.us-east-2.amazonaws.com/486219526892/MTurk',
            EventTypes: [ /* required */
              'AssignmentAccepted', 'AssignmentSubmitted', 'HITCreated', 'HITExpired', 'HITReviewable'
            ],
            Transport: 'SNS',
            Version: NOTIFICATION_VERSION
          },
          TestEventType: 'HITReviewable'
        };
        return new Promise((resolve, reject) => {
            this.mturk.sendTestEventNotification(params, (err, data) => {
                if (err) {
                    console.log("Error sending test notification!", err);
                    reject(err);
                } 
                else {
                    resolve(data);
                }
            });
        });
    }
    registerHITType() {
        console.log("Registering HITType")
        return new Promise((resolve, reject) => {
            this.mturk.createHITType(this.params, (err, data) => {
                if (err) {
                    console.log("Error creating HITType!", err);
                    reject(err);
                } 
                else {
                    resolve(data);
                }
            });
        });
    }

    createHIT(params) {
        return new Promise((resolve, reject) => {
            params.HITTypeId = this.hitTypeId;
            this.mturk.createHITWithHITType(params, (err, data) => {
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
