<rouser-alarm-mix>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Rouser</h1>
    </div>
</header>
<div class="content">
    <div class="padded-full">
       <div class="row description">
          <b>Here’s a preview of your wakeup message</b>
       </div>
       <div class="row explanation">
            <p>We mixed your message with some personalized music for the Sleeper.</p>

            <p>If you’re happy, submit your message and we’ll deliver it to your Sleeper at their chosen wakeup time.</p>

            <p>If you’d like to rerecord, we’ll call you back.</p>
       </div>
       <div>
        <p>
            <audio ref="audio" controls="controls">
                <source src={state.rouser.currentAlarm.recording.mixUrl} type="audio/wav">
            </audio>
        </p>
        <button class="btn primary raised" type="button" click="{recordAgain}">Rerecord</button>
        <form action="" onsubmit="{finalize}">
           <button class="btn positive raised" type="submit">Submit Message</button>
        </form>
        </div>
    </div>
</div>

<style>
    rouser-alarm-mix {
        .description {
            margin-bottom: 10px;
        }
        .explanation {
            p {
                font-size: 16px;
            }
        }
        form {
            display: inline-block;
        }

    }
</style>
    <script>
        this.on('mount', () => {
            console.log("alarm mix mounted");
                    
        });

        this.on('unmount', () => {

        });

        this.on('ready', () => {
            this.refs.audio.load();
        })

        recordAgain() {
            //window.history.back();
            page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/record")
        }

        async finalize(e) {
            e.preventDefault();
            try {
                console.log("Finalizing alarm");
                let result = await this.state.rouser.finalizeAlarm();            
                console.log("Finalize result", result);
                if (result.status == "success") {
                    this.state.rouser.invalidateAlarms();
                    page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/thankyou")
                } else {
                    console.log("Error finalizing alarm!", result);
                }
            }
            catch (e) {
                console.log("Error finalizing alarm!", e);
            }
        }
    </script>
</rouser-alarm-mix>

