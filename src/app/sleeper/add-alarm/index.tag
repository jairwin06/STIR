<add-alarm>
 <h1 class="title">Add Alarm</h1>
 <stage ref="stage"></stage>
 <style>
  #sleeper alarms add-alarm {
    h1 {
     color: green;
    }
  }
 </style>
 <script>
    import './time.tag'
    import './personality.tag'

    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("add-alarm mounted", this.state.sleeper.addAlarmStage);
        this.state.sleeper.on('sleeper_add_alarm_stage', this.stageUpdated);
        this.stageTag = mount(this.refs.stage,this.state.sleeper.addAlarmStage)[0];
    });

    this.on('unmount', () => {
        this.state.sleeper.off('sleeper_add_alarm_stage', this.stageUpdated);
    });


    stageUpdated(stage) {
        console.log("Add alarm stage updated", stage);
        this.stageTag = mount(this.refs.stage,this.state.sleeper.addAlarmStage)[0];
    }
 </script>
</add-alarm>
