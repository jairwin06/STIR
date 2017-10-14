<alarm-time>
    <article class="alarm">
    <div id="alarm-container" click="{changeTime}">
        <div id="alarm-time-group">
            <formatted-time if="{opts.data.time}"class="alarm-time" value="{new Date(opts.data.time)}" format="short"/>
            <formatted-time if="{!opts.data.time}"class="alarm-time" value="{defaultTime}" format="short"/>
            <span class="alarm-timezone">{TimeUtil.getTimezone(i18n.locales[0])}</span>
        </div>
        <formatted-message if="{opts.data.time}" class="alarm-date" id="{TimeUtil.getDateMessageId(opts.data.time)}" date="{new Date(opts.data.time)}"/>            
        <formatted-message if="{!opts.data.time}" class="alarm-date" id="{TimeUtil.getDateMessageId(this.defaultTime)}" date="{new Date(this.defaultTime)}"/>            
    </div>
    <a if="{opts.onCancel}" class="alarm-action" id="cancel-alarm" click="{cancelAlarm}" href="#">
        <i class="material-icons">alarm_off</i>
    </a>
    <a id="choose-time" class="alarm-action" if="{!opts.onCancel}" click="{changeTime}">
        <i class="material-icons">arrow_drop_down</i>
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
         .alarm-action {
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

    this.defaultTime = this.TimeUtil.getDefaultTime();

    this.on('mount', () => {
        console.log("time mounted ", this.opts);
    });

    this.on('unmount', () => {
    });

    this.on('update', () => {
        console.log('alarm-time update');
    })
    this.on('updated', () => {
        console.log('alarm-time updated');
    })

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
            setTimeout(() => {
            console.log("Time Blurrr!",this.refs.time);
            $(this.refs.time).hide();
            if (this.refs.time.value) {
                if (this.opts.onChange) {
                    this.opts.onChange(this.opts.data, this.refs.time.value);
                }
            }
            },0)
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
