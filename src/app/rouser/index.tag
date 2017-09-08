<rouser>
 <section id="rouser">
     <h1>Rouser</h1>
     <action ref="action"></action>
 </section>
 <style>
 #rouser {
    h1  {
     color: blue;
    }
 }
 </style>
 <script>
    import '../common/sign-up/index.tag'
    import './alarms.tag'
    import './alarm/index.tag'

    import {mount} from 'riot'

    this.on('mount', () => {
        console.log("Rouser mounted. current action", this.state.rouser.action);

        this.state.rouser.on('status_updated', this.statusUpdated);
        this.state.rouser.on('action_updated', this.actionUpdated);
        this.state.auth.on('user_code_verified', this.codeVerified);

        this.validatedCheck();

        if (this.state.rouser.action) {
             mount(this.refs.action, this.state.rouser.action);
        }
    });

    this.on('unmount', () => {
        this.state.rouser.off('status_updated', this.statusUpdated);
        this.state.rouser.off('action_updated', this.actionUpdated);
        this.state.auth.off('user_code_verified', this.codeVerified);
    });

    statusUpdated() {
        console.log("Rouser status updated", this.state.rouser.status);
        if (!this.state.rouser.status.phoneValidated) {
             mount(this.refs.action,'sign-up');
        }
    }

    actionUpdated() {
        console.log("Rouser action updated", this.state.rouser.action);
        mount(this.refs.action, this.state.rouser.action);
    }

    
    codeVerified() {
        this.state.rouser.setAction("alarms")
    }

    validatedCheck() {
        if (this.state.rouser.status && !this.state.rouser.status.phoneValidated) {
            if (IS_CLIENT) {
                page.show("/rouser/sign-up", null, false);
            }
        } else {
            if (this.state.rouser.action != 'alarms') {
                if (IS_CLIENT) {
                    page.show("/rouser/alarms", null, false);
                }
            }
        }
    }


 </script>
</rouser>
