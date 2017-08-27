<time>
 <h1 class="title">Add Alarm time</h1>
  <form onsubmit="{ addAlarm }">
    Date/Time:<input ref="dateTime" type="datetime-local" min="{nowDate}">
    <input type="submit" value="Next">
  </form>
 <style>
 </style>
 <script>
    import moment from 'moment'

    this.on('mount', () => {
        console.log("add-alarm-time mounted");
        this.nowDate = moment().format('YYYY-MM-DDTHH:mm:00.00');
    });

    this.on('unmount', () => {
    });


    addAlarm(e) {
        e.preventDefault();
        let date = moment(this.refs.dateTime.value).toDate();
        console.log("Add alarm!", date);
        this.state.sleeper.addAlarm(date);
    }
 </script>
</time>
