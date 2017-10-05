<rouser-alarm-record>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Rouser</h1>
    </div>
</header>
<div class="content">
   <div id="prompt" class="row">
      {state.rouser.currentAlarm.prompt}
   </div>
   <form action="" onsubmit="{requestCall}">
    <p>
        <b>Press the button to receive the call</b>
    </p>
    <input type="submit" value="Receive Call">
    </form>
    <img show="{loading}" src="/images/loading.gif">
    <b show"{error}" class="error">{error}</b>
</div>

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
            this.loading = true;
            let result = await this.state.rouser.requestCall();
            console.log("Request call result", result);
        } 
        catch(e) {
            console.log("Error requesting call", e);
            this.error = e.message;
            this.loading = false;
            this.update();
        }
    }

    onRecordingReady() {
        this.loading = false;
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
</rouser-alarm-record>
