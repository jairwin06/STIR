<time>
      <form action="" onsubmit="{ submit }">
            <input ref="time" type="time" change="{onTimeChange}" required>
            <input type="submit" value="Next">
          </form>
          <p>
          <b>Alarm will be set for: {state.sleeper.currentAlarm.time}</b>
          </p>
      </div>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("time mounted opts submit", this.opts.submit);
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
        alarmTime.setMilliseconds(0);
        this.state.sleeper.currentAlarm.time = alarmTime;
        this.update();

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

    submit(e) {
        e.preventDefault();
        if (this.opts.submit) {
            this.opts.submit();
        }
    }
 </script>
</time>
