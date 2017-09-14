<clock>
 <section id="alarm-clock">
     <h1 class="title">Alarm Clock</h1>
     <ul>
        <li each={ state.sleeper.alarms }>
            <a href="/sleeper/alarm/{_id}"><b>{formatDate(time)}</b></a>
        </li>
    </ul>
     <a href="/sleeper/alarms/add">Add alarm</a>
 </section>

 <style>
  #sleeper clock {
    h1 {
     color: red;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarms mounted");
        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
        this.state.sleeper.on('alarms_updated', this.onAlarmsUpdated);
    });

    this.on('unmount', () => {
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
        this.state.sleeper.off('alarms_updated', this.onAlarmsUpdated);
    });

    onAlarmCreated() {
        console.log("New alarm created!");
        this.state.sleeper.setAction("show");
    }

    onAlarmsUpdated() {
        this.update();

    }

    formatDate(time) {
        let date = new Date(time);
        return date.getHours() + ':' + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
    }

 </script>
</clock>
