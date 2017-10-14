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
          <div id="next-container">
              <a class="btn primary raised" href="" click="{saveProgress}">Next</a>
          </div>
      </div>
      <div class="stepper-container">
          <stepper size="5" current="1"></stepper>
      </div>
  </div>
 <style>
    sleeper-alarms-add-time {
        #next-container {
            display: flex;
            justify-content: center;
            margin-top: 60px;

            a {
                width: 100px;
            }
        }
    }
 </style>
 <script>
    import '../alarm-time.tag'
    import '../../common/stepper.tag'

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
            if (!this.state.sleeper.currentAlarm.time) {
                this.state.sleeper.currentAlarm.time = this.TimeUtil.getDefaultTime().toString();            
            }
            await this.state.sleeper.saveProgress();
            page("/sleeper/alarms/add/personality")
        } catch (e) {
            console.log("Error saving progress", e);
            phonon.alert(e.message, "Oops!", false, "Ok");
        }
    }

 </script>
</sleeper-alarms-add-time>
