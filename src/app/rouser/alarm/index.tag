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
    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("rouser alarm mounted", this.state.rouser.recordStage);
        this.state.rouser.on('record_stage_updated', this.stageUpdated);
        if (this.state.rouser.recordStage) {
            this.stageTag = mount(this.refs.stage,this.state.rouser.recordStage)[0];
        }
    });

    this.on('unmount', () => {
        this.state.rouser.off('record_stage_updated', this.stageUpdated);
    });


    stageUpdated(stage) {
        this.stageTag = mount(this.refs.stage,this.state.rouser.recordStage)[0];
    }
 </script>
</alarm>
