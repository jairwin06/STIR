<sign-up>
 <div section id="sign-up">
     <h1 class="title">Sign Up</h1>
     <stage ref="stage"></stage>
 </div>
 <style>
  main #sign-up {
    h1 {
     color: green;
    }
  }
 </style>
 <script>
    import './contact.tag'
    import './verify.tag'
    import { mount } from 'riot'

    this.on('mount', () => {
        console.log("sign-up mounted", this.state.auth.signUpStage);
        this.state.auth.on('sign_up_stage', this.stageUpdated);
        this.stageTag = mount(this.refs.stage,this.state.auth.signUpStage)[0];
    });

    this.on('unmount', () => {
        this.state.auth.off('sign_up_stage', this.stageUpdated);
    });


    stageUpdated() {
        console.log("Sign up stage updated", this.state.auth.signUpStage);
        this.stageTag = mount(this.refs.stage,this.state.auth.signUpStage)[0];
    }
 </script>
</sign-up>
