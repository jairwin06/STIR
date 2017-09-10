<time>
 <h1 class="title">Add Alarm time</h1>
  <b>Alarm will be set for: {state.sleeper.newAlarm.time}</b>
  <form onsubmit="{ next }">
    Date/Time:<input ref="time" type="time" change="{onTimeChange}" required>
    <input type="submit" value="Next">
  </form>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("add-alarm-time mounted");
        //this.nowDate = moment().format('YYYY-MM-DDTHH:mm:00.00');
        this.nowDate = new Date().toLocaleISOString();
        console.log("Min date", this.nowDate);
        this.update();
    });

    this.on('unmount', () => {
    });

    onTimeChange() {
        let time = this.refs.time.value;
        let timeComponents = time.split(":");
        let alarmTime = new Date(new Date().setHours(timeComponents[0],timeComponents[1],0));

        if (alarmTime.getTime() < new Date().getTime()) {
            console.log("Alarm will be set for tomorrow");
            alarmTime.setDate(alarmTime.getDate() + 1);
        }
        this.state.sleeper.newAlarm.time = alarmTime;
        this.update();

    }

    next(e) {
        e.preventDefault();
        this.state.sleeper.setAddAlarmStage("personality");
    }


    Date.prototype.toLocaleISOString = function() {
            var pad = function(num) {
                var norm = Math.abs(Math.floor(num));
                return (norm < 10 ? '0' : '') + norm;
            };
        return this.getFullYear() +
            '-' + pad(this.getMonth() + 1) +
            '-' + pad(this.getDate()) +
            'T' + pad(this.getHours()) +
            ':' + pad(this.getMinutes()) + ':00';
        //    ':' + pad(this.getSeconds());
        }
 </script>
</time>
