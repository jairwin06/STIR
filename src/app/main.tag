<main data-page="true">
    <!--role ref="role"></role-->
    <div if="{!state.main.role}">
            <header class="header-bar">
                <div class="center">
                    <h1 class="title">STIR</h1>
                </div>
            </header>
            <div class="content">
                <div>
                </div>
                <div id="choice" class="row text-center">
                    What are you today?
                </div>
                <div class="row text-center">
                    <div class="phone-6 tablet-6 column">
                        <div class="padded-full btn primary">
                            <a class="btn primary" href="/sleeper/alarms">Sleeper</a>
                        </div>
                    </div>
                    <div class="phone-6 tablet-6 column">
                        <div class="padded-full btn primary">
                            <a class="btn primary" href="/rouser/alarms">Rouser</a>
                        </div>
                    </div>
                </div>
            </div>
    </div>

    <style>
        main {
            .btn {
                line-height: 3;
            }
            #choice {
                margin-top: 50px;
                margin-bottom: 20px;
            }
        }
    </style>

    <script>
        import { mount } from 'riot'
        import './sleeper/index.tag'
        import './rouser/index.tag'
        import './admin/index.tag'

        this.on('mount', () => {
            console.log("Main mounted");

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
                //this.roleTag = mount(document.getElementsByTagName('role'), this.state.main.role)[0];
                //this.roleTag = mount(this.refs.role, role)[0];
            }
            else if (this.roleTag) {
             //   this.roleTag.unmount(true);
            }

            this.update();
        }
    </script>
</main>
