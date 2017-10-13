<alarm-time>
    <article class="alarm">
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
 <style>
     alarm-time {
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
        console.log("time mounted opts", this.opts);
        this.update();
    });

    this.on('unmount', () => {
    });

    changeTime(e) {
        console.log("Change time!",opts.data.time,this.refs.time);
        let alarmTime = new Date(opts.data.time);
        this.refs.time.value = MiscUtil.pad(alarmTime.getHours(),2) + ':' + MiscUtil.pad(alarmTime.getMinutes(),2);
        console.log("Change time from",this.refs.time.value);
        $(this.refs.time).show().focus().click();
        if (phonon.device.os == "iOS") {
            $(this.refs.time).hide();
        }
    }
    
    onTimeChange(e) {
        if (phonon.device.os == "Android") {
            console.log("Time Change!");
            $(this.refs.time).hide();
            if (this.opts.onChange) {
                this.opts.onChange(this.opts.data, this.refs.time.value);
            }
        }
    }

    onTimeBlur(e) {
        if (phonon.device.os != "Android") {
            console.log("Time Blur!");
            $(this.refs.time).hide();
            if (this.refs.time.value) {
                if (this.opts.onChange) {
                    this.opts.onChange(this.opts.data, this.refs.time.value);
                }
            }
        }
    }

    cancelAlarm(e) {
        console.log("Cancel alarm!",this.opts.data);
        if (this.opts.onCancel) {
            this.opts.onCancel(this.opts.data);
        }
    }
 </script>
</alarm-time>
