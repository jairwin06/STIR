import sox from 'sox'
import SoxCommand from 'sox-audio';

const DELAY_BEFORE_REC = 3;
const FADE_OUT_TIME = 5;
const DELAY_AFTER_REC = 3;

class SoxUtil {
    constructor() {
    }
    mixBackingTrack(recording, backingTrack, output){
        const TimeFormat = SoxCommand.TimeFormat;
        return Promise.all([this.identifyWav(recording),this.identifyWav(backingTrack)])
        .then((waveInfo) => {
            return new Promise((resolve, reject) => {
                console.log("Wave info", waveInfo);

                let startTimeFormatted = TimeFormat.formatTimeAbsolute(waveInfo[0].duration + DELAY_BEFORE_REC + DELAY_AFTER_REC);

                let subCommand = SoxCommand(recording)
                .output('-p')
                .outputSampleRate(44100)
                .outputChannels(2)
                .outputFileType('wav')
                .addEffect('delay',DELAY_BEFORE_REC);

                let command = SoxCommand()
                .inputSubCommand(subCommand)
                .input(backingTrack)
                .combine('mix')
                .output(output)
                .outputFileType('mp3')
                .trim(0, startTimeFormatted)
                .addEffect('fade', 't 0 0 ' + FADE_OUT_TIME);

                let errorThrow = function(err, stdout, stderr) {
                  console.log('Cannot process audio: ' + err.message);
                  console.log('Sox Command Stdout: ', stdout);
                  console.log('Sox Command Stderr: ', stderr)
                  reject(new Error(err.message));
                };

                command.on('error', errorThrow);
                subCommand.on('error', errorThrow);

                command.on('end', function() {
                      resolve({status: "success"})
                });

                command.run();

            });
        })
    }
    identifyWav(file) {
        return new Promise((resolve, reject) => {
            sox.identify(file, function(err, results) {
                if (err) {
                    reject(err);
                } else {
                    resolve(results);
                }
            });
        });
    }
};

// Singleton
let instance = new SoxUtil();
export default instance;


