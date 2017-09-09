<time>
 <h1 class="title">Add Alarm time</h1>
  <form onsubmit="{ next }">
    Date/Time:<input ref="dateTime" type="datetime-local" min="{nowDate}">
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


    next(e) {
        e.preventDefault();
        let date = this.refs.dateTime.value;
        console.log("Alarm time", date, typeof(date));
        this.state.sleeper.newAlarm.time = date;
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
