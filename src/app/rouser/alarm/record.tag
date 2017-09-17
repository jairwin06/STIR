<record>
 <h1 class="title">Record a message</h1>
  <div id="prompt">
  <p>
  {state.rouser.currentAlarm.prompt}
  </p>
  </div>
  <form onsubmit="{requestCall}">
    <p>
        <b>Press the button to receive the call</b>
    </p>
    <input type="submit" value="Receive Call">
  </form>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm record mounted");
        this.state.rouser.on('recording_ready', this.onRecordingReady);
    });

    this.on('unmount', () => {
        this.state.rouser.off('recording_ready', this.onRecordingReady);
    });


    async requestCall(e) {
        e.preventDefault();
        console.log("Request a call!");
        try {
            let result = await this.state.rouser.requestCall();
            console.log("Request call result", result);
        } 
        catch(e) {
            console.log("Error requesting call", e);
        }
    }

    onRecordingReady() {
        console.log("Recording ready!", this.state.rouser.recording);
        if (this.state.rouser.recording.status == "success") {
            if (IS_CLIENT) {
                page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/mix")
            }
        } else {
            console.error(this.state.rouser.recording.message);
        }
    }
 </script>
</record>
