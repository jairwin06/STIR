<sleeper>
 <section id="sleeper">
     <h1>Sleeper</h1>
     <action ref="action"></action>
 </section>
 <style>
 #sleeper {
    h1  {
     color: yellow;
    }
 }
 </style>
 <script>
    import './clock.tag'
    import './add-alarm/index.tag'
    import './edit-alarm.tag'

    import {mount} from 'riot'

    this.on('mount', () => {
        console.log("Sleeper mounted current action", this.state.sleeper.action);
        this.state.sleeper.on('sleeper_action_updated', this.actionUpdated);
        this.state.sleeper.on('alarm_created', this.onAlarmCreated);

        if (this.state.sleeper.action) {
             mount(this.refs.action, this.state.sleeper.action);
        }
    });

    this.on('unmount', () => {
        this.state.sleeper.off('sleeper_action_updated', this.actionUpdated);
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
    });

    actionUpdated() {
        mount(this.refs.action, this.state.sleeper.action);
    }

    onAlarmCreated() {
        console.log("New alarm created!");
        this.state.sleeper.setAction("clock");
    }


 </script>
</sleeper>
