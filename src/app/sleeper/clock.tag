<sleeper-alarms>
<header class="header-bar">
    <div class="center">
        <h1 class="title">STIR:Sleeper</h1>
    </div>
</header>
<div class="content">
     <h1 class="title">Alarm Clock</h1>
     <ul>
        <li each={ state.sleeper.alarms }>
            <a href="/sleeper/alarm/{_id}"><b>{formatDate(time)}</b></a>
        </li>
    </ul>
     <a href="/sleeper/alarms/add/time">Add alarm</a>
</div>

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
        this.state.sleeper.on('alarms_updated', this.onAlarmsUpdated);
    });

    this.on('unmount', () => {
        this.state.sleeper.off('alarms_updated', this.onAlarmsUpdated);
    });

    onAlarmsUpdated() {
        this.update();
    }

    formatDate(time) {
        let date = new Date(time);
        return date.getHours() + ':' + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
    }

 </script>
</sleeper-alarms>
