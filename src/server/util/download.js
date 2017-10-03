import fs from 'fs'
import https from 'https'

class DownloadUtil {

    constructor() {
    }

    saveUrl(url, dest) {
        return new Promise((resolve, reject) => {
            let file = fs.createWriteStream(dest); 
            let request = https.get(url, function(response) {
                    response.pipe(file);
                    file.on('finish', function() {
                          file.close(() => resolve());  
                    });
            }).on('error', function(err) { // Handle errors
                fs.unlink(dest); 
                reject(err.message);
            }); 
        })
    }

    copyFile(from, to) {
        return new Promise((resolve, reject) => {
            console.log("Copying from " + from + " to " + to);
            let rd = fs.createReadStream(from);
            rd.on("error", function(err) {
              reject(err);
            });
            let wr = fs.createWriteStream(to);
            wr.on("error", function(err) {
              reject(err);
            });
            wr.on("close", function(ex) {
              resolve();
            });
            rd.pipe(wr);
        });
    }
};

// Singleton
let instance = new DownloadUtil();
export default instance;
