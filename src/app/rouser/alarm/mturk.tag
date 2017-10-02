<mturk>
 <h1 class="title">MTurk - Record a message</h1>
  <div id="prompt">
  <p>
  {state.rouser.currentAlarm.prompt}
  </p>
  </div>
  <div show="{!done}">
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
       <button show="{previewing}" click="{submitRecording}">Submit Recording</button>
       <span show="{loading}">{progress}</span>
  </div>
  <div show="{done}">
    Thank you! Click the button to submit the HIT for review.
  <form action="https://workersandbox.mturk.com/mturk/externalSubmit" method="POST">
    <input name="assignmentId" type="hidden" ref="assignmentId">
    <input name="status" type="hidden" ref="status">
    <button type="submit">Submit</button>
  </form>

  </div>
 <style>

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
            this.refs.status.value = result || "unknown";
            this.update();
        })
        .catch((err) => {
            console.log("Error submitting recording!", err);
            this.error = err;
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
</mturk>
