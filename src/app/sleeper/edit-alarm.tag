<sleeper-edit-alarm>
    <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Sleeper</h1>
        </div>
    </header>
    <div class="content">
       <div class="padded-full">
           <div id="choice" class="row">
                You can change the alarm's time
            </div>
            <time submit={saveAlarm}></time>
            <button click="{cancelAlarm}" type="button">CANCEL ALARM</button>
        </div>
    </div>
 </div>
 <style>
  action #edit-alarm {
    h1 {
     color: cyan;
    }
    button {
        color: red;
    }
  }
 </style>
 <script>
    import './time.tag'

    this.on('mount', () => {
        console.log("edit-alarm mounted");
    });

    this.on('unmount', () => {
    });

    async cancelAlarm() {
        console.log("Cancel alarm!");
        try {
            let result = await this.state.sleeper.deleteAlarm();
            console.log("delete result", result);
            if (IS_CLIENT) {
                page("/sleeper/alarms");
            }
        } catch (e) {
            console.log("Error deleting alarm!", e);
        }
    }
    async saveAlarm() {
        try {
            let result = await this.state.sleeper.saveAlarm();
            console.log("Save result", result);
            if (IS_CLIENT) {
                page("/sleeper/alarms");
            }
        } catch (e) {
            console.log("Error saving alarm!", e);
            if (e.name == "Conflict") {
                this.error = "There is already an alarm set for this time";
            } else {
                this.error = e.message;
            }
            this.update();
        }
    }
 </script>
</sleeper-edit-alarm>
