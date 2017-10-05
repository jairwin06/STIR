<rouser-alarm-mix>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Rouser</h1>
    </div>
</header>
<div class="content">
   <div id="prompt" class="row">
      Preview your wake-up message
   </div>
   <div>
    <p>
        <audio controls="controls">
            <source src={state.rouser.recording.mixUrl} type="audio/wav">
        </audio>
    </p>
    <button type="button" click="{recordAgain}">Retry the recording</button>
    <p>
    <form action="" onsubmit="{finalize}">
       <input type="submit" value="Finalize rouse">
    </p>
    </form>
    </div>
</div>

<style>
</style>
    <script>
        this.on('mount', () => {
            console.log("alarm mix mounted");
                    
        });

        this.on('unmount', () => {

        });

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
                    page("/rouser/alarms");
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

