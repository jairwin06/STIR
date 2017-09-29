<admin>
 <section id="admin">
     <h1>Admin</h1>
     <action ref="action"></action>
 </section>
 <style>
 #admin {
    h1  {
     color: turquoise;
    }
 }
 </style>
 <script>
    import {mount} from 'riot'
    import './login.tag'
    import './dashboard.tag'

    this.on('mount', () => {
        console.log("Admin mounted. current action", this.state.admin.action);
        this.state.admin.on('admin_action_updated', this.actionUpdated);

        console.log("Current user role", this.state.auth.user.role);
        if (IS_CLIENT && this.state.auth.user.role != "admin" && this.state.admin.action != "login") {
            page("/admin/login");            
        }
        else if (IS_CLIENT && this.state.auth.user.role == "admin" && this.state.admin.action != "dashboard") {
            page("/admin/dashboard");            
        }
        else if (this.state.admin.action) {
             mount(this.refs.action, this.state.admin.action);
        }
    });

    this.on('unmount', () => {
        this.state.admin.off('admin_action_updated', this.actionUpdated);
    });

    actionUpdated() {
        console.log("admin action updated", this.state.admin.action);
        mount(this.refs.action, this.state.admin.action);
    }

 </script>
</admin>
