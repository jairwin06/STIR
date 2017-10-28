<main data-page="true">
    <!--role ref="role"></role-->
    <div if="{!state.main.role}">
            <div class="content">
                <div class="padded-full">
                    <h1><formatted-message id='HOME_TITLE'/></h1>
                    <p><formatted-message id='HOME_EXPLANATION'/></p>
                    <p><formatted-message id='HOME_CHOICE1'/></p>
                    <p><formatted-message id='HOME_CHOICE2'/></p>
                    <h1><formatted-message id='HOME_ACTION'/></h1>
                    <a class="btn primary" href="/sleeper/alarms">
                        <formatted-message id='SLEEPER'/>
                    </a>
                    <a class="btn primary" href="/rouser/alarms">
                        <formatted-message id='ROUSER'/>
                    </a>
                </div>
            </div>
    </div>

    <style>
        body {
            font-family: Abel, Helvetica;
            color: white;
        }
        .app-page {
            background-color: #000;
        }
        .btn.raised {
                box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2), 0px 4px 5px 0px rgba(0, 0, 0, 0.14), 0px 1px 10px 0px rgba(0, 0, 0, 0.12)
                }
        .btn {
            display: inline-block;
            font-family: 'Abel', Helvetica, sans-serif;
            text-transform: uppercase;
            font-size: .9rem;
            letter-spacing: .1rem;
            border: 3px solid white;
            padding: 20px;
            margin-top: 10px;
            text-align: center;
            width: 100%;
            color: white !important;
        }
       .btn:hover, .btn.btn-flat:hover {
         background: white !important;
         color: black !important;
         transition: all .5s;
       }
        .btn.btn-flat {
            border: none;
            color: white !important;
        }
       .primary {
            background-color: #000 !important;        
        }
        .padded-full {
            font-size: 16px;
            padding: 20px;
            margin: 0;
            min-height: 580px;
            p {
                font-family: Abel, Helvetica;
                font-size: 1rem;
                margin-bottom: 10px;
                color: #ebebeb;
                margin-top: 16px;
            }
        }
        h1 {
            text-transform: uppercase;
            font-size: 1.3rem;
            letter-spacing: .1rem;
            margin-top: 10px;
            font-weight: 700;
            line-height: unset;
            margin: unset;
            margin-bottom: 13.9333px;
            margin-left: 0px;
            margin-right: 0px;
            margin-top: 13.9333px;
        }

        a {
            font-weight: 600;
        }

        label {
            color: white;
        }

        input, select, textarea {
            background-color: transparent !important;
        }
    

        main {
            .title {
                margin-bottom: 30px;
            }
            .explanation {
                font-size: 16px;
                margin-bottom: 10px;
            }
            .choice {
                font-size: 16px;
                margin-bottom: 50px;
            }
            .action {
                margin-bottom: 30px;
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
            //box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2),0px 4px 5px 0px rgba(0, 0, 0, 0.14),0px 1px 10px 0px rgba(0, 0, 0, 0.12);
            background-color: #000;
            border-bottom: 3px solid white;

            h1 {
                line-height: 26px;
                color: white;

            }

        }
        .header-bar ~ .content {
            margin-top: 65px;
        }

        .description {
            font-size: 18px;
        }
        .title {
            font-size: 18px;

        }
        .explanation {
            margin-top: 15px;

        }
        .action {
            margin-top: 20px;

        }
        .disclaimer, .disclaimer > p  {
            color: #ff5c5c;
            margin-top: 30px;
        }

        .dialog {
            background-color: #333;
            box-shadow: none
        }

        .circle-progress {
            background-color: transparent;

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
            @media (max-height: 650px) {
                position: relative;
            }
            position: absolute;
            bottom: 5%;
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
        .panel {
            background-color: #333;

            .padded-full {
                min-height: 0;
            }
        }

        .intro-panel {
            z-index: 9999;
            .content {
                background-color: black;
                video {
                    height: 100%;
                }
            }
            .overlay {
                width: 100%;
                height: 100%;
                position: absolute;
                top: 0;
                left: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;

                h1 {
                    color: white;
                    position: absolute;
                    top: 30%;
                    width: 100%;
                    text-align: center;
                }

                a {
                    width: 100%;
                    text-align: center;
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
        import './sleeper/alarm-summary.tag'
        import './sleeper/welcome.tag'

        import './rouser/alarms.tag'
        import './rouser/welcome.tag'
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
               if (!this.state.auth.accessToken) {
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
