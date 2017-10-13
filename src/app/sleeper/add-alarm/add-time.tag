<sleeper-alarms-add-time>
    <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Sleeper</h1>
        </div>
    </header>
  <div class="content">
      <div class="padded-full">
           <div class="description row">
                When would you like to wake up?
            </div>
            <alarm-time
              data="{ state.sleeper.currentAlarm }"
              on-change="{onAlarmTimeChange}"
              on-cancel={null}
             >
             </alarm-time>
          <p>
          <a class="btn primary" href="" click="{saveProgress}">Next</a>
          </p>
          <b show"{error}" class="error">{error}</b>
      </div>
  </div>
 <style>
    sleeper-alarms-add-time {
         .description {
            font-size: 18px;

         }
        .btn {
            margin-top: 20px;
            line-height: 3;
        }
    }
 </style>
 <script>
    import '../alarm-time.tag'

    this.mixin('TimeUtil');

    this.on('before-mount', () => {
        if (this.state.sleeper.currentAlarm == null) {
            this.state.sleeper.currentAlarm = {};
        }
    });

    this.on('ready', () => {
        if (this.state.sleeper.currentAlarm == null) {
            this.state.sleeper.currentAlarm = {};
        }
        this.tags['alarm-time'].changeTime();
    })
    this.on('update', () => {
        console.log("add-alarm-time update.");
    });

    this.on('unmount', () => {
        console.log("add-alarm-time unmounted");
    });

    onAlarmTimeChange(item, time) {
        console.log("Alarm time change!",item,time);
        let alarmTime = this.TimeUtil.getAlarmTime(time);
        this.state.sleeper.currentAlarm.time = alarmTime;
        this.update();
    }

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
