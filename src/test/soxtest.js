var sox = require('sox');
var SoxCommand = require('sox-audio');
var TimeFormat = SoxCommand.TimeFormat;
runTest();

function runTest() {
    Promise.all([identifyWav('public/recordings/59ea026846bcaa7bb9327211-rec.wav'),identifyWav('backingtracks/_2014_.wav')])
    .then((waveInfo) => {
        console.log("Wave info", waveInfo);
        
        var endTimeFormatted = TimeFormat.formatTimeRelativeToEnd(waveInfo[1].duration - waveInfo[0].duration);

        var subCommand = SoxCommand('public/recordings/59ea026846bcaa7bb9327211-rec.wav')
        //.output('-p')
        .output('test.wav')
        .outputSampleRate(44100)
        .outputChannels(2)
        .outputFileType('wav')
        .addEffect('fade', 'l 3');
        //.addEffect('delay', '+3');

        var command = SoxCommand()
        .inputSubCommand(subCommand)
        .input('backingtracks/_2014_.wav')
        .combine('mix')
        .output('mix.mp3')
        .outputFileType('mp3')
        .trim(0, endTimeFormatted);

        var errorThrow = function(err, stdout, stderr) {
          console.log('Cannot process audio: ' + err.message);
          console.log('Sox Command Stdout: ', stdout);
          console.log('Sox Command Stderr: ', stderr)
          throw new Error(err.message);
        };

        command.on('error', errorThrow);
        subCommand.on('error', errorThrow);

        subCommand.run();
    })
    .catch((err) => {
        console.log("Promise error!",err);
    })
}



function identifyWav(file) {
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

