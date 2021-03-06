<alarm-time>
    <article class="alarm">
        <div id="alarm-container" click="{changeTime}">
            <div id="alarm-time-group">
                <formatted-time if="{opts.data.time}"class="{alarm-time: true, verifying:opts.verifying}" value="{new Date(opts.data.time)}" format="short"/>
                <formatted-time if="{!opts.data.time}"class="{alarm-time: true, verifying:opts.verifying}" value="{defaultTime}" format="short"/>
                <span class="{alarm-timezone: true, verifying:opts.verifying}">LOCAL TIME</span>
            </div>
            <formatted-message if="{opts.data.time}" class="{alarm-date:true, verifying:opts.verifying}" id="{TimeUtil.getDateMessageId(opts.data.time)}" date="{new Date(opts.data.time)}"/>            
            <formatted-message if="{!opts.data.time}" class="{alarm-date:true, verifying:opts.verifying}" id="{TimeUtil.getDateMessageId(this.defaultTime)}" date="{new Date(this.defaultTime)}"/>            
        </div>
        <a if="{opts.onCancel}" class="alarm-action" id="cancel-alarm" click="{cancelAlarm}" href="#">
            <i class="material-icons">alarm_off</i>
        </a>
        <div show="{opts.verifying}" class="circle-progress active">
            <div class="spinner"></div>
        </div>
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
         .alarm-time.verifying {
            color: lightgrey;         
         }
         .alarm-date {
            margin-top: 5px;
            color: #ff7500;
            font-weight: 600px;
         }
         .alarm-date.verifying {
            color: lightsalmon;
         }
         .alarm-timezone.verifying {
            color: lightblue;         
         }
         .alarm {
            background-color: #333;
            margin-top: 15px;
            padding: 20px;
            margin-right: 20px;
            display: flex;
            flex-direction: row;
            align-items: center;
            border-radius: 5px;
         }
         #alarm-container {
            display: flex;
            flex-direction: column;
         }
         #alarm-time-group {
            display: flex;
            flex-direction: row;
            align-items: baseline;
            color: #06c2ff;
         .clock-desc {
            margin-top: 10px;
         }
         }
         .alarm-action {
            color: #ff6969;
            position: absolute;
            right: 15%;
            i {
              font-size: 30px;
            }
         } 
         .circle-progress {
            width: 20px;
            height: 20px;
            left: 20%;
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
        console.log("Time Blurrr!",this.refs.time);
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
