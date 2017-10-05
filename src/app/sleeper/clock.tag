<sleeper-alarms>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Sleeper</h1>
    </div>
</header>
<div class="content">
     <div show="{state.sleeper.alarms != null}">
         <div>
            Your current alarms:
         </div>
         <ul>
            <li each={ state.sleeper.alarms }>
                <a href="/sleeper/alarm/{_id}"><b>{formatDate(time)}</b></a>
            </li>
        </ul>
         <a href="/sleeper/alarms/add/time">Add an alarm</a>
     </div>
      <div show="{ state.sleeper.alarms == null }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
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

    this.on('ready', () => {
        this.update();
    })

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
