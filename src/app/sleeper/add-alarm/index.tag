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
    import '../../common/sign-up/index.tag'

    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("add-alarm mounted", this.state.sleeper.addAlarmStage);
        this.state.sleeper.on('sleeper_add_alarm_stage', this.stageUpdated);
        this.state.auth.on('user_code_verified', this.onCodeVerified);

        if (IS_CLIENT) {
            page("/sleeper/alarms/add/time");
        }
    });

    this.on('unmount', () => {
        this.state.sleeper.off('sleeper_add_alarm_stage', this.stageUpdated);
        this.state.auth.off('user_code_verified', this.onCodeVerified);
    });


    stageUpdated(stage) {
        console.log("Add alarm stage updated", stage);
        this.stageTag = mount(this.refs.stage,this.state.sleeper.addAlarmStage)[0];
    }

    onCodeVerified() {
        // That's the final stage in case the phoen wasn't verified
        this.state.sleeper.addAlarm();
    }
 </script>
</add-alarm>
