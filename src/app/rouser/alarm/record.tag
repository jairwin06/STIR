<rouser-alarm-record>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Rouser</h1>
    </div>
</header>
<div class="content">
   <div id="prompt" class="padded-full">
        <div class="intro row">
            Today you'll be waking {state.rouser.currentAlarm.name}.
        </div> 
        <p each="{text, i in state.rouser.currentAlarm.prompt.paragraphs}">{text}</p>
        <ul class="">
          <li each="{text, i in state.rouser.currentAlarm.prompt.instructions}">
            {text}
          </li>
        </ul>

   <form action="" onsubmit="{requestCall}">
    <p>
        <b>Press the button to receive the call</b>
    </p>
    <button class="btn primary raised" type="submit">Receive Call</button>
    </form>
    <img show="{loading}" src="/images/loading.gif">
    <b show"{error}" class="error">{error}</b>
   </div>
</div>

 <style>    
    #prompt {
        .intro {
            font-size: 18px;
            margin-bottom: 10px;
        }        
        p {
            font-size: 16px;
        }
        ul {
            padding-left: 10px;
            margin-top: 0;

            li {
                font-size: 16px;
                margin-bottom: 5px;
            }
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
