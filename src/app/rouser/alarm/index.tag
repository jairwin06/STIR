<alarm>
 <div section id="rouser-alarm">
     <h1 class="title">Record an Alarm</h1>
     <stage ref="stage"></stage>
 </div>
 <style>
  #rouser #alarm {
    h1 {
     color: yellow;
    }
  }
 </style>
 <script>
    import './record.tag'
    import './mix.tag'
    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("rouser alarm mounted", this.state.rouser.recordStage);
        this.state.rouser.on('record_stage_updated', this.stageUpdated);
        this.state.rouser.on('alarm_loaded', this.alarmLoaded);
        if (this.state.rouser.recordStage) {
            this.stageTag = mount(this.refs.stage,this.state.rouser.recordStage)[0];
        } else if (this.state.rouser.currentAlarm && IS_CLIENT) {
            page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/record")
        }
    });

    this.on('unmount', () => {
        this.state.rouser.off('record_stage_updated', this.stageUpdated);
        this.state.rouser.off('alarm_loaded', this.alarmLoaded);
    });

    stageUpdated(stage) {
        this.stageTag = mount(this.refs.stage,this.state.rouser.recordStage)[0];
    }

    alarmLoaded() {
        // Go to record
        if (IS_CLIENT) {
            page("/rouser/alarm/" + this.state.rouser.currentAlarm._id + "/record")
        }
    }
 </script>
</alarm>
