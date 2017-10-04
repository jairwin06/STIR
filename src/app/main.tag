<main data-page="true">
    <!--role ref="role"></role-->
    <div if="{!state.main.role}">
            <header class="header-bar">
                <div class="center">
                    <h1 class="title">STIR</h1>
                </div>
            </header>
            <div class="content">
                <a href="/sleeper">Sleeper</a>
                <a href="/rouser">Rouser</a>
            </div>
    </div>

    <style>
        main {
        }
    </style>

    <script>
        import { mount } from 'riot'
        import './sleeper/index.tag'
        import './rouser/index.tag'
        import './admin/index.tag'

        this.on('mount', () => {
            console.log("Main mounted");
            console.log("Current role ", this.state.main.role);
            if (this.state.main.role) {
                this.roleTag = mount(document.getElementsByTagName('role'), this.state.main.role)[0];
            }

            this.state.main.on('main_role_updated', this.roleUpdated);

            if (IS_CLIENT && !this.state.auth.mturk) {
               this.state.auth.loginRest();
            }
        });

        this.on('unmount', () => {
            this.state.main.off('main_role_updated', this.roleUpdated);
        })

        roleUpdated(role) {
            console.log("Main role updated!", role);
            if (role) {
                this.roleTag = mount(document.getElementsByTagName('role'), this.state.main.role)[0];
                //this.roleTag = mount(this.refs.role, role)[0];
            }
            else if (this.roleTag) {
             //   this.roleTag.unmount(true);
            }

            this.update();
        }
    </script>
</main>
