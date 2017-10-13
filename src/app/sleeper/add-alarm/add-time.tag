<sleeper-alarms-add-time>
    <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Sleeper</h1>
        </div>
    </header>
  <div class="content">
      <div class="padded-full">
           <div id="choice" class="row">
                When would you like to wake up?
            </div>
            <time submit={saveProgress}></time>
          <p>
          <b show"{error}" class="error">{error}</b>
          </p>
      </div>
  </div>
 <style>
 </style>
 <script>
    import '../alarm-time.tag'

    this.on('mount', () => {
        console.log("add-alarm-time mounted.");
    });

    this.on('ready', () => {
        if (this.state.sleeper.currentAlarm == null) {
            this.state.sleeper.currentAlarm = {};
        }
    })

    this.on('unmount', () => {
        console.log("add-alarm-time unmounted");
    });

    async saveProgress() {
        try {
            console.log("Saving progress");
            await this.state.sleeper.saveProgress();
            page("/sleeper/alarms/add/personality")
        } catch (e) {
            console.log("Error saving progress", e);
            this.error = e.message;
            this.update();
        }
    }

 </script>
</sleeper-alarms-add-time>
