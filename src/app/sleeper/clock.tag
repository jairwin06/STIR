<sleeper-alarms>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Sleeper</h1>
    </div>
</header>
<div class="content">
     <div class="padded-full">
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
                   <div class="add-button">
                       <a href="/sleeper/alarms/add/time">
                            <i class="material-icons">alarm_add</i>
                       </a>
                   </div>
              </div>
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
           .add-button {
                background-color: #2196f3;
                border-radius: 35px;
                box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2), 0px 4px 5px 0px rgba(0, 0, 0, 0.14), 0px 1px 10px 0px rgba(0, 0, 0, 0.12);
                width: 65px;
                height: 65px;
                display: flex;
                justify-content: center;
                align-items: center;
                
                a {
                    width: 55px;
                    height: 55px;
                   i {
                        font-size: 55px;
                        color: white;
                   }
                }
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
            let timezone = this.TimeUtil.getTimezone();
            let prevTime = this.state.sleeper.currentAlarm.time;
            let alarmTime = this.TimeUtil.getAlarmTime(time);
            let result = await this.state.sleeper.saveAlarmTime(alarmTime,timezone);
            console.log("Save result", result);
            if (result.status == "too_early") {
                let confirm = phonon.confirm("STIR needs at least " + result.hours + " hours to prepare your message, your alarm will be set for the follwing day day", "Notice", true, "Ok", "Cancel");

                confirm.on('confirm', async () => {
                    alarmTime.setDate(alarmTime.getDate() + 1);
                    let result = await this.state.sleeper.saveAlarmTime(alarmTime, timezone);
                    this.update();
                });
                confirm.on('cancel', () => {
                    this.state.sleeper.currentAlarm.time = prevTime;
                    this.update();
                });
            } else {
                this.update();
            }
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
