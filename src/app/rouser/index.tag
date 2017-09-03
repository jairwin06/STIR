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
    import './sign-up/index.tag'
    import './alarm-queue.tag'
    import './alarm/index.tag'

    import {mount} from 'riot'

    this.on('mount', () => {
        console.log("Rouser mounted");
        if (this.state.rouser.status && !this.state.rouser.status.phoneValidated) {
             mount(this.refs.action,'sign-up');
        } else {
            if (this.state.rouser.action) {
                mount(this.refs.action, this.state.rouser.action);
            }
        }

        this.state.rouser.on('status_updated', this.statusUpdated);
        this.state.rouser.on('action_updated', this.actionUpdated);
    });

    this.on('unmount', () => {
        this.state.rouser.off('status_updated', this.statusUpdated);
        this.state.rouser.off('action_updated', this.actionUpdated);
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


 </script>
</rouser>
