<rouser-alarm-mturk>
<div class="web-background">
    <div class="web-content">
        <header class="header-bar">
            <div class="pull-left">
                <h1>STIR | MTurk</h1>
            </div>
        </header>
        <div class="content">
          <div class="padded-full">
                <h1>STIR is a personalized waking service offering morning “gifts” for people around the world. Our service is their first encounter with a new day.</h1>
              <div class="row stir-details">
                You’ve joined STIR as a Rouser, and today you’ll be leaving a pre-recorded wakeup message for a Sleeper. Keep the following guidelines in mind as you create your wakeup message:
                <ul>
                    <li>Hearing one’s name is powerfully personal. To be most effective, incorporate the Sleeper’s name into your message.</li>
                    <li>As a Rouser, you are the face of our service. Be kind and compassionate to our Sleepers!</li>
                    <li>Remember, you’re giving a gift. You’re this Sleeper’s first encounter with a new day!</li>
                </ul>
              </div>
              <div class="row language-requirement">
                You will can record the message in <b>one</b> of the following languages:
                <ul>
                    <li each="{getLanguages()}" class="language-item">
                        {name}
                    </li>
                </ul>
              </div>
              <div class="row length-requirement">
                <b>Please record a message between 45 and 60 seconds long</b>
              </div>
              <div id="prompt">
                    <div class="intro row">
                        Today you'll be waking {state.rouser.currentAlarm.name}.
                    </div> 
                    <p each="{text, i in state.rouser.currentAlarm.prompt.en.paragraphs}">{text}</p>
                    <p><i>For your message to {state.rouser.currentAlarm.name}, consider the following, and feel free to elaborate:</i></p>
                    <ul class="">
                      <li each="{text, i in state.rouser.currentAlarm.prompt.en.instructions}">
                        {text}
                      </li>
                    </ul>
               </div>
              <div show="{!ready}" class="row placeholder">
                <i>Accept the HIT to begin recording</i>
              </div>
              <div id="recording-box" show="{!done}">
                    <button class="btn primary raised" show="{ready && !recording && !loading && !previewing}" click="{startRecording}">
                    Start Recording
                    </button>
                    <div id="while-recording" class="row" show="{ready && recording}">
                        <div class="actions">
                            <img src="/images/recording.gif"></img>
                            <button class="btn primary raised" click="{stopRecording}">STOP</button>
                        </div>
                        <span class="counter">{counter}</span>
                    </div>
                    <div id="after-recording" show="{previewing && !loading}">
                        <div class="row">
                            <audio ref="preview" controls="controls">
                            </audio>
                        </div>
                        <div class="row actions">
                            <button class="btn primary raised" click="{startRecording}">
                                Record Again
                            </button>
                            <button class="btn positive raised" click="{submitRecording}">Submit Recording</button>
                            </button>
                        </div>
                    </div>
                  <div show="{ loading }" class="circle-progress active">
                    <div class="spinner"></div>
                 </div>
                   <div><b show"{error}" class="error">{error}</b></div>
                   <div show="{loading}">{progress}</div>
              </div>
              <div show="{done}">
                Thank you! Submitting HIT
                  <form ref="form" action="{state.rouser.currentAlarm.mturkSubmit}" method="POST">
                    <input name="assignmentId" type="hidden" ref="assignmentId">
                    <input name="recordingPath" type="hidden" ref="recordingPath">
                    <input name="prompt" type="hidden" ref="prompt">
                    <input name="locales" type="hidden" ref="locales">
                    <button type="submit">Submit</button>
                  </form>
              </div>
          </div>
        </div>
    </div>
</div>

 <style>
 rouser-alarm-mturk {
   .web-background {
        width: 100%;
        height: 100%;
        background: lightgrey;
        display: flex;
        justify-content: center;

        .web-content {
            width: 768px;
            background: white;
            color: #000;

            .header-bar {
                position: relative;

            }
            .content {
                margin-top: 10px;
                position: relative;            
            }

            font-weight: 700;
        }
    }
   p {
    color: black !important;
    font-weight: 600 !important
   }
   .stir-description {
        font-size: 20px;
        margin-bottom: 20px;
    }
    .stir-details {
        font-size: 14px;
    }
   .language-requirement {
        font-size: 16px;
    }
   .length-requirement {
        font-size: 16px;
        padding-bottom: 10px;
        margin-bottom: 10px;
        border-bottom: 1px solid #ddd;
    }
   .prompt {
        font-size: 16px;
        line-height: 23px;
    }
    
   .placeholder {
       margin-top: 50px;
       text-align: center;
   }

   #recording-box {
    display: flex;
    justify-content: center;
    margin-top: 50px;
   }

    #while-recording {
        display: flex;
        flex-direction: row;
        justify-content: center;
           
       .actions {
            display: flex;
            flex-direction: column;
            img {
                height: 40px;
                width: 40px;
                margin-bottom: 10px;
            }
       }
       span {
            font-weight: bold;
            font-size: 36px;
       }
    }

    #after-recording {
        audio {
            width: 400px;
        }
    }
    .circle-progress {
        position: unset;
    }
 }

 </style>
 <script>
    import Recorder from '../../util/recorder'
    import UploadUtil from '../../util/upload'

    this.on('mount', () => {
        console.log("alarm record mturk mounted");
        this.done = false;
        this.recorder = new Recorder();
        this.recorder.init();
        if (this.recorder.isSupported) {
            if(this.state.auth.mturk.assignmentId && this.state.auth.mturk.assignmentId != 'ASSIGNMENT_ID_NOT_AVAILABLE') {
                this.ready = true;
            }
        } else {
            this.error = "Recording is not supported on this browser! Please use a modern browser";
        }
        this.update();
    });

    getLanguages() {
        const names = {
            'en': 'English',
            'fr': 'French',
            'de': 'German'
        }
        return this.state.rouser.currentAlarm.locales.map(code => {return {name: names[code]}});
    }

    startRecording() {
        console.log("Start recording!");
        this.recorder.startRecording()
        .then(() => {
            this.counter = 0;
            if (this.interval) {
                clearInterval(this.interval);
            }
            this.interval = setInterval(() => {
                this.counter++;
                this.update();
            },1000);
            console.log("Recording started");
            this.refs.preview.removeChild(this.refs.preview.lastChild);
            this.recording = true;
            this.previewing = false;
            this.update();
        })
        .catch((err) => { 
            console.log("Error starting recording!", err);
            this.error = err.message;
            this.update();
        })
    }

    stopRecording() {
        console.log("Stop recording!");
        this.recorder.stopRecording()
        .then((url) => {
            console.log("Recording stopped", url);
            if (this.interval) {
                clearInterval(this.interval);
                this.interval = null;
            }
            this.recording = false;
            this.previewing = true;
            let source = document.createElement('source');
            source.src = url;
            source.type = this.recorder.options.mimeType;
            this.refs.preview.appendChild(source);
            this.refs.preview.load();
            this.update();
        })
        .catch((err) => { 
            console.log("Error stopping recording!", err);
            this.error = err.message;
            this.update();
        })
    }

    submitRecording() {
        console.log("Submit recording!");
        var file = new File([this.recorder.recordRTC.getBlob()], 'recording.' + this.recorder.options.fileExtension, {
            type: this.recorder.options.mimeType
        });
        UploadUtil.upload("/recordings/upload", file, this.state.auth.mturk, this.uploadProgress)
        .then((result) => {
            console.log("Upload finished!", result);            
            this.loading = false;
            this.done = true;
            this.refs.assignmentId.value = this.state.auth.mturk.assignmentId;
            this.refs.recordingPath.value = result || "unknown";
            this.refs.prompt.value = JSON.stringify(this.state.rouser.currentAlarm.prompt.en);
            this.refs.locales.value = this.state.rouser.currentAlarm.locales.join(',');
            this.update();
            // Submit the form
            this.refs.form.submit();
        })
        .catch((err) => {
            console.log("Error submitting recording!", err);
            this.error = "Could not submit recording - " + err;
            this.update();
        })
        this.loading = true;
        this.update;
    }

    uploadProgress(event) {
        console.log("Upload progress!", event.loaded + "/" + event.total);
        this.progress = event.loaded + "/" + event.total;
        this.update();
    }

    this.on('unmount', () => {
    });
 </script>
</rouser-alarm-mturk>
