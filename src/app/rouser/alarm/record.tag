<rouser-alarm-record>
<header class="header-bar">
    <div class="pull-left">
       <a href="/"><h1 class="title">STIR - Rouser</h1></a>
    </div>
</header>
<div class="content">
  <div class="padded-full">
      <div class="description row">
            <b>Once you’ve read the prompt below, press the button to record your message.</b>
      </div>
      <p>
      <div class="row notice">
          We’ll give you a call to do the recording, so have your phone close by.
      </div>
      </p>
      <div id="prompt">
            <div class="intro row">
                Today you'll be waking {state.rouser.currentAlarm.name}.
            </div> 
            <p each="{text, i in state.rouser.currentAlarm.prompt.paragraphs}">{text}</p>
            <p><i>For your message to {state.rouser.currentAlarm.name}, consider the following, and feel free to elaborate:</i></p>
            <ul class="">
              <li each="{text, i in state.rouser.currentAlarm.prompt.instructions}">
                {text}
              </li>
            </ul>
       </div>
       <form show="{!loading}" action="" onsubmit="{requestCall}">
            <button class="btn primary raised" type="submit">Receive a call to leave a message</button>
       </form>
       <img show="{loading}" src="/images/loading.gif">
       <b show"{error}" class="error">{error}</b>
   </div>
</div>

 <style>    
     rouser-alarm-record {
        .description {
            margin-bottom: 10px;
        }
        .notice {
            padding-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
     }
 </style>

 <script>
    this.on('mount', () => {
        console.log("alarm record mounted");
        this.state.rouser.on('recording_ready', this.onRecordingReady);
    });

    this.on('unmount', () => {
        this.state.rouser.off('recording_ready', this.onRecordingReady);
    });

    this.on('ready', () => {
        this.loading = false;
        this.update();
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
        console.log("Recording ready!", this.state.rouser.currentAlarm.recording);
        if (this.state.rouser.currentAlarm.recording.status == "success") {
            if (IS_CLIENT) {
                page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/mix")
            }
        } else {
            console.error(this.state.rouser.currentAlarm.recording.message);
        }
    }
 </script>
</rouser-alarm-record>
