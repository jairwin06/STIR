// Fetch Util
class UploadUtil {
    constructor() {
    }

    upload(url, data, fields, onProgress) {
        return new Promise((resolve, reject) => {
            const request = new XMLHttpRequest();
            request.onreadystatechange = function() {
                console.log("Ready state change!", request.readyState, request.status);
                if (request.readyState == 4 && request.status == 200) {
                    resolve(request.responseText);
                }
                if (request.readyState == 4 && request.status == 500) {
                    reject(request.responseText);
                }
            };

            request.onerror = function(e) {
                reject(e)
            }

            request.upload.onprogress = onProgress;

            request.open('POST', url);
            const formData = new FormData();
            formData.append('file', data);
            for (let key in fields) {
                formData.append(key, fields[key]);
            }
            request.send(formData)
        });
    }
};

// Singleton
let instance = new UploadUtil();
export default instance;
