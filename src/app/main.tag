<main data-page="true">
    <!--role ref="role"></role-->
    <div if="{!state.main.role}">
            <header class="header-bar">
                <div class="pull-left">
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

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            /* display: none; <- Crashes Chrome on hover */
            -webkit-appearance: none;
            margin: 0; /* <-- Apparently some margin are still there even though it's hidden */
        }
        input[type="number"] {
            -moz-appearance: textfield !important;
        }
    </style>

    <script>
        import { mount } from 'riot'

        import './sleeper/add-alarm/add-time.tag'
        import './sleeper/add-alarm/personality.tag'
        import './sleeper/clock.tag'
        import './sleeper/edit-alarm.tag'
    

        import './rouser/alarms.tag'
        import './rouser/alarm/mix.tag'
        import './rouser/alarm/record.tag'
        import './rouser/alarm/mturk.tag'

        import './common/sign-up/contact.tag'
        import './common/sign-up/verify.tag'

        import './admin/login.tag'
        import './admin/dashboard.tag'

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
        }
    </script>
</main>
