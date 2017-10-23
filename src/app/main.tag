<main data-page="true">
    <!--role ref="role"></role-->
    <div if="{!state.main.role}">
            <header class="header-bar">
                <div class="pull-left">
                    <a href="/"><h1 class="title">STIR</h1></a>
                </div>
                <!--div class="pull-right">
                    <span class="title arrow pull-right" data-popover-id="lang-popover">{state.auth.locale.toUpperCase()}</span>
                </div-->
            </header>
            <div class="content">
                <div>
                </div>
                <div id="choice" class="row text-center">
                    <formatted-message id='HOME_CHOICE'/>
                </div>
                <div class="row text-center">
                    <div class="phone-6 tablet-6 column">
                        <a class="btn primary raised" href="/sleeper/alarms">
                        <formatted-message id='SLEEPER'/>
                        </a>
                    </div>
                    <div class="phone-6 tablet-6 column">
                        <a class="btn primary" href="/rouser/alarms">
                        <formatted-message id='ROUSER'/>
                        </a>
                    </div>
                </div>
            </div>
    </div>

    <style>
        body {
            font-family: Roboto, Helvetica;
        }
        .btn.raised {
                box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2), 0px 4px 5px 0px rgba(0, 0, 0, 0.14), 0px 1px 10px 0px rgba(0, 0, 0, 0.12)
                }
        a.btn {
            line-height: 3;

        }
        main {
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

        .header-bar {
            box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2),0px 4px 5px 0px rgba(0, 0, 0, 0.14),0px 1px 10px 0px rgba(0, 0, 0, 0.12);
            background-color: #2196f3;
            height: 62px;

            .title {
                line-height: 62px;

            }

        }
        .header-bar ~ .content {
            margin-top: 65px;
        }

        .description {
            font-size: 18px;
        }

        .popover {
            width: 52px;
            top: 43px !important;
            border-radius: 10px;
            .list li {
                line-height: 40px;
                height: auto;
                min-height: 40px;
            }
            background-color: rgba(118,160,243,0.6);
        }
        .stepper-container {
            display: flex;
            justify-content: center;
            position: absolute;
            bottom: 10%;
            width: 100%;
        }
        #prompt {
            .intro {
                font-size: 18px;
                margin-bottom: 10px;
            }        
            p {
                font-size: 16px;
            }
            ul {
                padding-left: 10px;
                margin-top: 0;

                li {
                    font-size: 16px;
                    margin-bottom: 5px;
                }

            }
        }

        #arte-footer {
            position: absolute;
            bottom: -80%;
            z-index: 2;
        }

        #home-suggest {
            .padded-full {
                display: flex;
                justify-content: space-between;
                align-items: center;

                span {
                    padding-right: 10px;
                    font-weight: bold;
                }
                
                a {
                    position: relative;
                    top: 3px;
                }
            }
        }

        #intro-panel {
            z-index: 9999;
            .content {
                display: flex;
                justify-content: center;
                align-items: center;

                h1 {
                    color: white;
                    position: absolute;
                    top: 30%;
                }

                video {
                    height: 100%;
                }
                
                .play-button {
                    position: absolute;
                    i {
                        color: white;
                        font-size: 72px;
                    }
                }

                .skip-link {
                    position: absolute;
                    bottom: 10%;
                    font-size: 22px;
                    font-weight: bold;
                }
                
            }
        }
        .IIV::-webkit-media-controls-play-button,
        .IIV::-webkit-media-controls-start-playback-button {
              opacity: 0;
                   pointer-events: none;
                        width: 5px;
                         
         }
    </style>

    <script>
        import { mount } from 'riot'

        import './sleeper/add-alarm/add-time.tag'
        import './sleeper/add-alarm/personality.tag'
        import './sleeper/add-alarm/questions.tag'
        import './sleeper/clock.tag'
    

        import './rouser/alarms.tag'
        import './rouser/alarm/mix.tag'
        import './rouser/alarm/record.tag'
        import './rouser/alarm/thankyou.tag'
        import './rouser/alarm/mturk.tag'

        import './common/sign-up/contact.tag'
        import './common/sign-up/verify.tag'
        import './common/sign-up/locale.tag'
        import './common/sign-up/pronoun.tag'

        import './admin/login.tag'
        import './admin/dashboard.tag'

        import MiscUtil from './util/misc'

        this.on('mount', () => {
            console.log("Main mounted");

            if (IS_CLIENT && !this.state.auth.mturk) {
               if (1 || !this.state.auth.accessToken) {
                    console.log("Opening intro");
                    MiscUtil.initVideoPanel('#intro-panel');
                    phonon.panel('#intro-panel').open();                    
               }
               this.state.auth.loginRest();
            }
        });

        this.on('ready', () => {
            this.update();
        })

        this.on('update', () => {
            console.log("Main update");
        })

        this.on('unmount', () => {
            this.state.main.off('main_role_updated', this.roleUpdated);
        })

        roleUpdated(role) {
            console.log("Main role updated!", role);
        }
    </script>
</main>
