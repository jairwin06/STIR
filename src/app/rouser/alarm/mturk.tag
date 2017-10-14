<rouser-alarm-mturk>
<div class="web-background">
    <div class="web-content">
        <header class="header-bar">
            <div class="pull-left">
                <h1 class="title">STIR - MTurk</h1>
            </div>
        </header>
        <div class="content">
          <div class="padded-full">
              <div class="row stir-description">
                    STIR is a personalized waking service offering morning “gifts” for people around the world. Our service is their first encounter with a new day.
              </div>
              <div class="row language-requirement">
                You will need to record a wakeup message in <b>one</b> of the following languages:
                <ul>
                    <li each="{getLanguages()}" class="language-item">
                        {name}
                    </li>
                </ul>
              </div>
              <div class="row prompt">
                  {state.rouser.currentAlarm.prompt}
              </div>
              <div show="{!ready}" class="row placeholder">
                <i>Accept the HIT to begin recording</i>
              </div>
              <div id="recording-box" show="{!done}">
                    <button class="btn primary raised" show="{ready && !recording && !loading && !previewing}" click="{startRecording}">
                    Start Recording
                    </button>
                    <div id="while-recording" class="row" show="{ready && recording}">
                        <img src="/images/recording.gif"></img>
                        <button class="btn primary raised" click="{stopRecording}">STOP</button>
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
                  <form ref="form" action="https://workersandbox.mturk.com/mturk/externalSubmit" method="POST">
                    <input name="assignmentId" type="hidden" ref="assignmentId">
                    <input name="recordingPath" type="hidden" ref="recordingPath">
                    <input name="prompt" type="hidden" ref="prompt">
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

            .header-bar {
                position: relative;

            }
            .content {
                margin-top: 10px;
                position: relative;            
            }
        }
    }
   .stir-description {
        font-size: 20px;
        margin-bottom: 20px;
    }
   .language-requirement {
        font-size: 16px;
    }
   .prompt {
        border-top: 1px solid #ddd;
        padding-top: 20px;
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
        flex-direction: column;
        width: 70px;
           img {
                height: 40px;
                width: 40px;
                margin-bottom: 10px;
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
            this.refs.prompt.value = this.state.rouser.currentAlarm.prompt;
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
