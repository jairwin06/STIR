<rouser-alarm-mix>
<header class="header-bar">
    <div class="pull-left">
        <a href="/"><h1 class="title">STIR - Rouser</h1></a>
    </div>
</header>
<div class="content">
    <div class="padded-full">
       <div class="row description">
          <b><formatted-message id='ROUSER_MIX_DESCRIPTION'/></b>
       </div>
       <div class="row explanation">
            <p><formatted-message id='ROUSER_MIX_1'/></p>
            <p><formatted-message id='ROUSER_MIX_2'/></p>
            <p><formatted-message id='ROUSER_MIX_3'/></p>
       </div>
       <div>
        <p>
            <audio ref="audio" controls="controls">
                <source src={state.rouser.currentAlarm.recording.mixUrl} type="audio/wav">
            </audio>
        </p>
        <button class="btn primary raised" type="button" click="{recordAgain}">
            <formatted-message id='RERECORD'/>
        </button>
        <form action="" onsubmit="{finalize}">
           <button class="btn positive raised" type="submit">
                <formatted-message id='SUBMIT_MESSAGE'/>
            </button>
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

