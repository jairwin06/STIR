class MiscUtil {
    constructor() {
    }

    isBrowser() {
        return (typeof window != 'undefined');
    }
    nextTick(callback) {
        setTimeout(callback
        , 0);
    }
    generateUUID(){
        var d = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = (d + Math.random()*16)%16 | 0;
            d = Math.floor(d/16);
            return (c=='x' ? r : (r&0x3|0x8)).toString(16);
        });
        return uuid;
    }

    findById(collection, id) {
        for (let i = 0; i < collection.length; i++) {
            if (collection[i]._id == id) {
                return collection[i];
            }
        }
        return null;
    }
    findIndexById(collection, id) {
        for (let i = 0; i < collection.length; i++) {
            if (collection[i]._id == id) {
                return i;
            }
        }
        return null;
    }
};

// Singleton
let instance = new MiscUtil();
export default instance;

