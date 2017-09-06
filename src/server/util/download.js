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
};

// Singleton
let instance = new DownloadUtil();
export default instance;
