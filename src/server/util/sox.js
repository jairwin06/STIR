import sox from 'sox'
import SoxCommand from 'sox-audio';

class SoxUtil {
    constructor() {
    }
    mixBackingTrack(recording, backingTrack, output){
        const TimeFormat = SoxCommand.TimeFormat;
        return Promise.all([identifyWav(reording),identifyWav(backingTrack)])
        .then((waveInfo) => {
            console.log("Wave info", waveInfo);
            
            let endTimeFormatted = TimeFormat.formatTimeRelativeToEnd(waveInfo[1].duration - waveInfo[0].duration);

            let subCommand = SoxCommand(recording)
            .output('-p')
            .outputSampleRate(44100)
            .outputFileType('wav');

            let command = SoxCommand()
            .inputSubCommand(subCommand)
            .input(backingTrack)
            .combine('mix')
            .output(output)
            .outputFileType('wav')
            .trim(0, endTimeFormatted);

            let errorThrow = function(err, stdout, stderr) {
              console.log('Cannot process audio: ' + err.message);
              console.log('Sox Command Stdout: ', stdout);
              console.log('Sox Command Stderr: ', stderr)
              throw new Error(err.message);
            };

            command.on('error', errorThrow);
            subCommand.on('error', errorThrow);

            command.run();
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


