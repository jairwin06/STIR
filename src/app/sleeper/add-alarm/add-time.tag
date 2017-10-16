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
              verifying={verifying}
             >
             </alarm-time>
          <div id="next-container">
              <button class="btn primary raised" click="{next}">Next</button>
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
        this.verified = false;
    })
    this.on('update', () => {
        console.log("add-alarm-time update.");
    });

    this.on('unmount', () => {
        console.log("add-alarm-time unmounted");
    });

    async onAlarmTimeChange(item, time) {
        console.log("Alarm time change!",item,time);
        let alarmTime;
        if (time) {
            alarmTime = this.TimeUtil.getAlarmTime(time);
            this.state.sleeper.currentAlarm.time = alarmTime;
        } else {
            alarmTime = this.state.sleeper.currentAlarm.time;
        }
        let prevTime = this.state.sleeper.currentAlarm.time;
        this.verifying = true;
        this.update();
        try {
            let result = await this.saveProgress();
            if (result.status == "too_early") {
                let confirm = phonon.confirm("STIR needs at least " + result.hours + " hours to prepare your message, your alarm will be set for the follwing day day", "Notice", true, "Ok", "Cancel");

                confirm.on('confirm', async () => {
                    alarmTime.setDate(alarmTime.getDate() + 1);
                    this.state.sleeper.currentAlarm.time = item.time = alarmTime;
                    let result = await this.saveProgress();
                    this.verifying = false;
                    this.verified = true;
                    this.update();
                });
                confirm.on('cancel', () => {
                    item.time = this.state.sleeper.currentAlarm.time = prevTime;
                    this.verifying = false;
                    this.update();
                });
            } else {
                this.verified = true;
                this.verifying = false;
                this.update();
            }
            this.update();
        } catch (e) {
            console.log("Error saving progress", e);
            phonon.alert(e.message, "Oops!", false, "Ok");
            this.verifying = false;
            this.update();
        }
    }

    async next() {
        if (!this.verified) {
            if (!this.state.sleeper.currentAlarm.time) {
                this.state.sleeper.currentAlarm.time = this.TimeUtil.getDefaultTime();
            }
            await this.onAlarmTimeChange(this.state.sleeper.currentAlarm, null);
        }
        page("/sleeper/alarms/add/personality")
    }

    async saveProgress() {
        console.log("Saving progress");
        let result = await this.state.sleeper.saveProgress();
        console.log(result);
        return result;
    }

 </script>
</sleeper-alarms-add-time>
