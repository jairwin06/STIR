<clock>
 <section id="alarm-clock">
     <h1 class="title">Alarm Clock</h1>
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
    });

    this.on('unmount', () => {
        this.state.sleeper.off('sleeper_action_updated', this.actionUpdated);
    });

    actionUpdated() {
        this.update();
    }

 </script>
</clock>
