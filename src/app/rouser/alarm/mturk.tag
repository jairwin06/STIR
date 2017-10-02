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
            this.recording = true;
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
        .then((dataUrl) => {
            console.log("Recording stopped", dataUrl);
            this.recording = false;
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
