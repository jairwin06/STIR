<sleeper-alarms>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Sleeper</h1>
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
          <article class="alarm" each={ state.sleeper.alarms } click="{changeTime}">
            <formatted-time class="alarm-time" value="{new Date(time)}" format="short"/>
            <span class="alarm-timezone">{TimeUtil.getTimezone(locales[0])}</span>
            <formatted-message class="alarm-date" id="{TimeUtil.getDateMessageId(time)}" date="{new Date(time)}"/>            
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
            flex-direction: column;
         }
     }
 </style>
 <script>
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

    changeTime() {
        console.log("Change time!");
        $(this.refs.time).show().focus().click();
        if (phonon.device.os == "iOS") {
            $(this.refs.time).hide();
        }
    }

    onTimeChange() {
        if (phonon.device.os != "iOS") {
            phonon.alert("Hi", "Time changed! " + phonon.device.os , false, "Ok");
            $(this.refs.time).hide();
        }
    }

    onTimeBlur() {
        if (phonon.device.os == "iOS") {
            phonon.alert("Hi", "Time blurred!" + phonon.device.platform, false, "Ok");
            $(this.refs.time).hide();
        }
    }

 </script>
</sleeper-alarms>
