const RECORDING_SAMPLE_RATE = 8000;
import BrowserDetect from './browser'
    
export default class Recorder {
    constructor() {
    }

    init() {
        BrowserDetect.init();
        console.log("Browser: ", BrowserDetect.browser);
        this.isSupported = (navigator.mediaDevices.getUserMedia);
        if (this.isSupported) {
            this.options = {
               type: 'audio',
               mimeType : 'audio/ogg',
            };
            if (this.isMimeTypeSupported('audio/ogg')) {
                this.options.mimeType = 'audio/ogg; codecs=opus'
                this.options.fileExtension = 'ogg';
            }
            else if (this.isMimeTypeSupported('audio/webm')) {
                this.options.mimeType = 'audio/webm; codecs=opus'
                this.options.fileExtension = 'webm';
            }
            else {
                this.options.mimeType = 'audio/wav';
                this.options.recorderType = StereoAudioRecorder;
                this.options.desiredSampRate = RECORDING_SAMPLE_RATE;
                this.options.numberOfAudioChannels = 1;
                this.options.fileExtension = 'wav';
            }

            console.log("Supported recording options", this.options);
        }
    }

    startRecording() {
        return navigator.mediaDevices.getUserMedia({audio: true})
        .then((stream) => {
            console.log("Got stream");
            this.recordRTC = new RecordRTCPromisesHandler(stream, this.options);
            return this.recordRTC.startRecording();
        });
    }
    stopRecording() {
        return this.recordRTC.stopRecording()
        .then((url) => {
            console.log("Recording stopped", url);
            return url;
        })
    }
    isMimeTypeSupported(mimeType) {
        // Firefox supports audio/ogg
        // Chrome supports audio/webm
        // Safari supports only audio/wav
        // For now sticking to wav
        return false;
        ///
        //
        //
        if(BrowserDetect.browser.name === 'Edge' || BrowserDetect.browser.name === 'Safari' || typeof MediaRecorder === 'undefined') {
            return false;
        }
        if(typeof MediaRecorder.isTypeSupported !== 'function') {
            return true;
        }
        return MediaRecorder.isTypeSupported(mimeType);
    }
};

