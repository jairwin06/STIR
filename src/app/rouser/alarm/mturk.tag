<mturk>
 <h1 class="title">MTurk - Record a message</h1>
  <div id="prompt">
  <p>
  {state.rouser.currentAlarm.prompt}
  </p>
  </div>
  <p>
    <button show="{ready && !recording}" click="{startRecording}">Start Recording</button>
    <img show="{recording}" src="/images/recording.gif"></img>
    <button show="{ready && recording}" click="{stopRecording}">Stop Recording</button>
  </p>
  <img show="{loading}" src="/images/loading.gif"></img>
   <b show"{error}" class="error">{error}</b>
   <p show="{previewing}">
        <audio ref="preview" controls="controls">
        </audio>
   </p>
 <style>
 </style>
 <script>
    import Recorder from '../../util/recorder'

    this.on('mount', () => {
        console.log("alarm record mturk mounted");
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

    this.on('unmount', () => {
    });
 </script>
</mturk>
