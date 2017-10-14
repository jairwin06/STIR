<sleeper-alarms>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Sleeper</h1>
    </div>
    <div class="pull-right">
        <span class="title arrow pull-right" data-popover-id="lang-popover">{state.auth.locale.toUpperCase()}</span>
    </div>
</header>
<div class="content">
     <div show="{state.sleeper.alarms != null}">
         <div class="welcome-back">
            <formatted-message id="CLOCK_WELCOME" name="{state.auth.user.name}"/>            
         </div>
         <div class="clock-desc">
            <formatted-message id="CLOCK_DESC"/>            
         </div>
          <alarm-time
              each={ state.sleeper.alarms } 
              data="{ {time: this.time, _id: this._id} }" 
              on-change="{parent.onAlarmTimeChange}"
              on-cancel="{parent.onAlarmCancel}"
          >
          </alarm-time>
          <div class="add-alarm">
               <a href="/sleeper/alarms/add/time">
                    <i class="material-icons">alarm_add</i>
               </a>
          </div>
     </div>
      <div show="{ state.sleeper.alarms == null }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
</div>

 <style>
     sleeper-alarms {
         .welcome-back {
            font-size: 28px;
         } 
         .clock-desc {
            margin-top: 10px;
         }

         .add-alarm {
            display: flex;
            justify-content: center;
            position: absolute;
            width: 100%;
            bottom: 15%;
            right: 1px;
             i {
                font-size: 60px;
                text-shadow: 1px 1px grey;
             }
         }
     }
 </style>
 <script>
    import './alarm-time.tag'

    this.mixin('TimeUtil');

    this.on('mount', () => {
        console.log("alarms mounted");
        this.state.sleeper.on('alarms_updated', this.onAlarmsUpdated);
    });

    this.on('ready', () => {
        this.update();
    })

    this.on('unmount', () => {
        this.state.sleeper.off('alarms_updated', this.onAlarmsUpdated);
    });

    onAlarmsUpdated() {
        this.update();
    }

    onAlarmTimeChange(item, time) {
        this.state.sleeper.chooseAlarm(item._id);
        this.saveAlarm(time);
    }

    async saveAlarm(time) {
        console.log("Save alarm!", this.state.sleeper.currentAlarm._id, time);
        try {
            let alarmTime = this.TimeUtil.getAlarmTime(time);
            let result = await this.state.sleeper.saveAlarmTime(alarmTime);
            console.log("Save result", result);
            console.log(this.state.sleeper.alarms);
            this.update();
        } catch (e) {
            console.log("Error saving alarm!", e);
            if (e.name == "Conflict") {
                phonon.alert("There is already an alarm set for this time!", "Oops!", false, "Ok");
            } else {
                phonon.alert("Something went wrong: " + e.message, "Oops!", false, "Ok");
            }
            this.update();
        }
    }
    onAlarmCancel(item) {
        console.log("Cancel alarm!",item._id);
        this.state.sleeper.currentAlarm = item;
        let confirm = phonon.confirm(
            "Cancel this alarm?", "Please confirm", false, "Yes", "No"
        );
        confirm.on('confirm', async() => {
            try {
                let result = await this.state.sleeper.deleteAlarm();
                console.log("delete result", result);
                this.update();
            } catch (e) {
                console.log("Error deleting alarm!", e);
            }
        });
        confirm.on('cancel', function() {} );
    }
 </script>
</sleeper-alarms>
