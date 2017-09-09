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

        this.state.auth.on('status_updated', this.statusUpdated);
        this.state.rouser.on('action_updated', this.actionUpdated);
        this.state.auth.on('user_code_verified', this.codeVerified);

        this.validatedCheck();

        if (this.state.rouser.action) {
             mount(this.refs.action, this.state.rouser.action);
        }
    });

    this.on('unmount', () => {
        this.state.auth.off('status_updated', this.statusUpdated);
        this.state.rouser.off('action_updated', this.actionUpdated);
        this.state.auth.off('user_code_verified', this.codeVerified);
    });

    statusUpdated() {
        console.log("Rouser status updated", this.state.auth.user.status);
        this.validatedCheck();
    }

    actionUpdated() {
        console.log("Rouser action updated", this.state.rouser.action);
        mount(this.refs.action, this.state.rouser.action);
    }

    
    codeVerified() {
        page.show("/rouser/alarms");
    }

    validatedCheck() {
        if (this.state.auth.user.status && !this.state.auth.user.status.phoneValidated) {
            if (IS_CLIENT) {
                page.show("/rouser/sign-up");
            }
        } else {
            if (this.state.rouser.action != 'alarms') {
                if (IS_CLIENT) {
                    console.log("Redirecting to alarms");
                    //page.show("/rouser/alarms", null, false);
                    page.show("/rouser/alarms");
                }
            }
        }
    }


 </script>
</rouser>
