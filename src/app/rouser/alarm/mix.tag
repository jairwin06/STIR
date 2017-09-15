<mix>
    <h1 class="title">Mix your recording</h1>
    <p>
        <audio controls="controls">
            <source src={state.rouser.recording.recordingUrl} type="audio/wav">
        </audio>
    </p>
    <p>
      <form onsubmit="{finalize}">
       <input type="submit" value="Finalize rouse">
    </p>
  </form>

    <style>
    </style>
    <script>
        this.on('mount', () => {
            console.log("alarm mix mounted");
                    
        });

        this.on('unmount', () => {

        });

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
</mix>

