import {S3} from 'aws-sdk';
import fs from 'fs';

const S3_VERSION='2006-03-01';
const BUCKET_NAME = 'stir-assets';

class S3Util {
    constructor() {
        this.s3 = new S3();
    }
    uploadFile(src,dest,type = null) {
        return new Promise((resolve, reject) => {
            let fileStream = fs.createReadStream(src);
            let uploadParams = {Bucket: BUCKET_NAME, Key: dest, Body: fileStream, ACL: 'public-read'};
            if (type) {
                uploadParams.ContentType = type;
            }
            fileStream.on('error', function(err) {
                console.log("File error", err);
                reject("Error reading source file!" + err.message);
            });
            this.s3.upload (uploadParams, function (err, data) {
              if (err) {
                  console.log("S3 Upload error", err);
                  reject("Error uploading to S3! " + err.message);
              } if (data) {
                  resolve({status: "success", location: data.Location});
              }
            });
        })
    }
    uploadRecordings(alarm,app) {
        console.log("Uploading alarm to S3");
        this.uploadAndDeleteRecording(alarm, 'recordingUrl', 'audio/vnd.wave', app);
        this.uploadAndDeleteRecording(alarm, 'mixUrl', 'audio/mpeg', app);
    }
    uploadAndDeleteRecording(alarm, key, type, app) {
        let url = alarm.recording[key];
        let sourceUrl = url.split("?")[0];
        let destKey = sourceUrl.substring(1);
        let sourceFile = 'public' + sourceUrl;
        this.uploadFile(sourceFile, destKey, type)
        .then((result) => {
            console.log("Uploaded " + key,result);            
            let data = {};
            data['recording.' + key] = result.location;
            return app.service("alarms/sleeper").patch(alarm._id, data);
        })
        .then((result) => {
            fs.unlinkSync(sourceFile);            
        })
        .catch((err) => {
            console.log("Error while uploading " + key, err);
        })
    }
};

// Singleton
let instance = new S3Util();
export default instance;
