<main>
    <h1>STIR</h1>
    <role ref="role"></role>

    <div if="{!state.main.role}">
        <a href="/sleeper">Sleeper</a>
        <a href="/rouser">Rouser</a>
    </div>

    <style>
        main {
            display: block;
            background-color: #FC87FF;
        }
    </style>

    <script>
        import { mount } from 'riot'
        import './sleeper/index.tag'

        this.on('mount', () => {
            console.log("Main mounted");
            console.log("Current role ", this.state.main.role);
            if (this.state.main.role) {
                this.roleTag = mount(this.refs.role, this.state.main.role)[0];
            }

            this.state.main.on('main_role_updated', this.roleUpdated);

            if (IS_CLIENT) {
               this.state.auth.login();
            }
        });

        this.on('unmount', () => {
            this.state.main.off('main_role_updated', this.roleUpdated);
        })

        roleUpdated(role) {
            console.log("Main role updated!", role);
            if (role) {
                this.roleTag = mount(this.refs.role, role)[0];
            }
            else if (this.roleTag) {
                this.roleTag.unmount(true);
            }

            this.update();
        }
    </script>
</main>
