<sign-up>
 <div section id="sign-up">
     <h1 class="title">Sign Up</h1>
     <stage ref="stage"></stage>
 </div>
 <style>
  #rouser #sign-up {
    h1 {
     color: green;
    }
  }
 </style>
 <script>
    import './contact.tag'
    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("sign-up mounted", this.state.rouser.signUpStage);
        this.state.rouser.on('rouser_sign_up_stage', this.stageUpdated);
        this.stageTag = mount(this.refs.stage,this.state.rouser.signUpStage)[0];
    });

    this.on('unmount', () => {
        this.state.rouser.off('rouser_sign_up_stage', this.stageUpdated);
    });


    stageUpdated(stage) {
        console.log("Sign up stage updated", stage);
        this.stageTag = mount(this.refs.stage,this.state.rouser.signUpStage)[0];
    }
 </script>
</sign-up>
