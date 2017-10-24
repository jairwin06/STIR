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
    pad(num, size) {
        let s = num+"";
        while (s.length < size) s = "0" + s;
        return s;
    }

    getRandomElement(arr) {
        let item = arr[Math.floor(Math.random()*arr.length)];
        return item;
    }

    initVideoPanel(panelId) {
        let panel = $(panelId);
        enableInlineVideo(panel.find('video'));

        panel.find('.play-button').click((e) => {
            e.preventDefault();
            console.log("Play video!");
            panel.find('.play-button').fadeOut("slow");
            panel.find('.video-title').fadeOut("slow");
            panel.find('video')[0].play();
        })
        panel.find('.skip-link').click((e) => {
            e.preventDefault();
            panel.find('video')[0].pause();
            phonon.panel(panelId).close();                    
        })

        panel.find('video').on('ended', () => {
            phonon.panel(panelId).close();                    
        });
    }

    isStandaone() {
        return (navigator.standalone || (window.matchMedia('(display-mode: standalone)').matches));
    }
};

// Singleton
let instance = new MiscUtil();
export default instance;

