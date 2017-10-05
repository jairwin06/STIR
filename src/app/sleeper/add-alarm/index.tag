<sleeper-alarms-add>
 <h1 class="title">Add Alarm</h1>
 <stage ref="stage"></stage>
 <b show"{error}" class="error">{error}</b>
 <style>
  #sleeper alarms add-alarm {
    h1 {
     color: green;
    }
  }
 </style>
 <script>
    import './add-time.tag'
    import './personality.tag'
    import '../../common/sign-up/index.tag'

    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("add-alarm mounted", this.state.sleeper.addAlarmStage);
        this.state.sleeper.on('alarm_create_error', this.onCreateError);
        this.state.auth.on('user_code_verified', this.onCodeVerified);

        if (!this.state.sleeper.addAlarmStage) {
            if (IS_CLIENT) {
                page("/sleeper/alarms/add/time");
            }
        }

    });

    this.on('unmount', () => {
        this.state.sleeper.off('sleeper_add_alarm_stage', this.stageUpdated);
        this.state.sleeper.off('alarm_create_error', this.onCreateError);
        this.state.auth.off('user_code_verified', this.onCodeVerified);
    });

    onCodeVerified() {
        console.log("Sleeper code verified!");
        // That's the final stage in case the phoen wasn't verified
        this.state.sleeper.addAlarm();
    }

    onCreateError(err) {
        this.error = err;
        this.update();
    }
 </script>
</sleeper-alarms-add>
