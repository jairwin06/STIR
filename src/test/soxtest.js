var sox = require('sox');
var SoxCommand = require('sox-audio');
var TimeFormat = SoxCommand.TimeFormat;
runTest();

function runTest() {
    Promise.all([identifyWav('59b99f3cdea0a60947cf47f6-rec.wav'),identifyWav('_2014_.wav')])
    .then((waveInfo) => {
        console.log("Wave info", waveInfo);
        
        var endTimeFormatted = TimeFormat.formatTimeRelativeToEnd(waveInfo[1].duration - waveInfo[0].duration);

        var subCommand = SoxCommand('59b99f3cdea0a60947cf47f6-rec.wav')
        .output('-p')
        .outputSampleRate(44100)
        .outputChannels(2)
        .outputFileType('wav');

        var command = SoxCommand()
        .inputSubCommand(subCommand)
        .input('_2014_.wav')
        .combine('mix')
        .output('mix.wav')
        .outputBits(16)
        .outputEncoding('signed-integer')
        .outputFileType('wav')
        .trim(0, endTimeFormatted);

        var errorThrow = function(err, stdout, stderr) {
          console.log('Cannot process audio: ' + err.message);
          console.log('Sox Command Stdout: ', stdout);
          console.log('Sox Command Stderr: ', stderr)
          throw new Error(err.message);
        };

        command.on('error', errorThrow);
        subCommand.on('error', errorThrow);

        command.run();
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

