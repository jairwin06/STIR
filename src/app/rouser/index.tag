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
    import {mount} from 'riot'

    this.on('mount', () => {
        console.log("Rouser mounted");
        this.state.rouser.on('status_updated', this.statusUpdated);
        if (this.state.rouser.status && !this.state.rouser.status.signedUp) {
             mount(this.refs.action,'sign-up');
        }
    });

    this.on('unmount', () => {
        this.state.rouser.off('status_updated', this.statusUpdated);
    });

    statusUpdated() {
        console.log("Rouser status updated", this.state.rouser.status);
        if (!this.state.rouser.status.signedUp) {
             mount(this.refs.action,'sign-up');
        }
    }


 </script>
</rouser>
