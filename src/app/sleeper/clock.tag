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
          <article class="alarm" each={ state.sleeper.alarms }>
            <div id="alarm-container" click="{changeTime}">
                <div id="alarm-time-group">
                    <formatted-time class="alarm-time" value="{new Date(time)}" format="short"/>
                    <span class="alarm-timezone">{TimeUtil.getTimezone(i18n.locales[0])}</span>
                </div>
                <formatted-message class="alarm-date" id="{TimeUtil.getDateMessageId(time)}" date="{new Date(time)}"/>            
            </div>
            <a id="cancel-alarm" click="{cancelAlarm}" href="#">
                <i class="material-icons">alarm_off</i>
            </a>
          </article>
           <input ref="time" type="time" style="display:none;" change="{onTimeChange}" blur="{onTimeBlur}">
           <a href="/sleeper/alarms/add/time">Add an alarm</a>
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
         .alarm-time {
            font-size: 28px;
            margin-right: 5px;
         }
         .alarm-date {
            margin-top: 5px;
            color: #ff5100;
         }
         .alarm {
            background-color: #f9f9f9;
            margin-top: 15px;
            padding: 20px;
            margin-right: 20px;
            display: flex;
            flex-direction: row;
            align-items: center;
         }
         #alarm-container {
            display: flex;
            flex-direction: column;
         }
         #alarm-time-group {
            display: flex;
            flex-direction: row;
            align-items: baseline;
            color: #1474e0;
         }
         #cancel-alarm {
            color: #ff6969;
            position: absolute;
            right: 15%;
            i {
              font-size: 30px;
            }
         } 
     }
 </style>
 <script>
    import MiscUtil from '../util/misc'

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

    changeTime(e) {
        console.log("Change time!",e.item.time,this.refs.time);
        let alarmTime = new Date(e.item.time);
        this.state.sleeper.currentAlarm = e.item;
        this.refs.time.value = MiscUtil.pad(alarmTime.getHours(),2) + ':' + MiscUtil.pad(alarmTime.getMinutes(),2);
        console.log("Change time from",this.refs.time.value);
        $(this.refs.time).show().focus().click();
        if (phonon.device.os == "iOS") {
            $(this.refs.time).hide();
        }
    }

    onTimeChange(e) {
        if (phonon.device.os == "Android") {
            $(this.refs.time).hide();
            this.saveAlarm(this.refs.time.value);
        }
    }

    onTimeBlur(e) {
        if (phonon.device.os != "Android") {
            $(this.refs.time).hide();
            if (this.refs.time.value) {
                this.saveAlarm(this.refs.time.value);
            }
        }
    }
    async saveAlarm(time) {
        console.log("Save alarm!", this.state.sleeper.currentAlarm._id, time);
        try {
            let alarmTime = this.TimeUtil.getAlarmTime(time);
            let result = await this.state.sleeper.saveAlarmTime(alarmTime);
            console.log("Save result", result);
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
    cancelAlarm(e) {
        console.log("Cancel alarm!",e.item._id);
        this.state.sleeper.currentAlarm = e.item;
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
