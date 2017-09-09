<clock>
 <section id="alarm-clock">
     <h1 class="title">Alarm Clock</h1>
     <ul>
        <li each={ state.sleeper.alarms }>
            <b>{formatDate(time)}</b>
        </li>
    </ul>
     <a href="/sleeper/alarms/add">Add alarm</a>
 </section>

 <add-alarm show="{state.sleeper.action == 'add'}"></add-alarm>
 
 <style>
  #sleeper clock {
    h1 {
     color: red;
    }
  }
 </style>
 <script>
    import './add-alarm/index.tag'
    this.on('mount', () => {
        console.log("alarms mounted");
        this.state.sleeper.on('sleeper_action_updated', this.actionUpdated);
        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
    });

    this.on('unmount', () => {
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
        this.state.sleeper.off('sleeper_action_updated', this.actionUpdated);
    });

    actionUpdated() {
        this.update();
    }

    onAlarmCreated() {
        console.log("New alarm created!");
        this.state.sleeper.setAction("show");
    }

    formatDate(time) {
        let date = new Date(time);
        return date.getHours() + ':' + date.getMinutes();
    }

 </script>
</clock>
