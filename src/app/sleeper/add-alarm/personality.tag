<sleeper-alarms-add-personality>
    <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1 class="title">STIR - Sleeper</h1></a>
        </div>
    </header>
  <div class="content">
    <div class="padded-full">
       <div class="description">
            <formatted-message id='PERSONALITY_DESCRIPTION'/>
        </div>
        <div id="choose-text" class="row">
            Choose the social media account you post on most frequently
        </div>
        <div id="social-buttons" class="row">
          <a href="/auth/facebook" class="btn primary raised">Connect with Facebook</a>
          <a href="/auth/twitter" class="btn primary raised">Connect with Twitter</a>
        </div>
        <div class="row">
            <a id="questions-link" href="/sleeper/alarms/add/questions">Not on social media?</a>
        </div>
        <div class="disclaimer">
            </p><formatted-message id='PERSONALITY_DISCLAIMER_1'/></p>
            </p><formatted-message id='PERSONALITY_DISCLAIMER_2'/></p>
        </div>
      </div>
      <div class="stepper-container">
          <stepper size="{state.sleeper.getSteps()}" current="2"></stepper>
      </div>
      <img show="{loading}" src="/images/loading.gif"></img>
  </div>
  
 <style>

     sleeper-alarms-add-personality {
         #choose-text {
            margin-top: 20px;
         } 
         #social-buttons {
             display: flex;
             margin-top: 15px;
             margin-bottom: 15px;
             
             a {
                line-height: 1.5;
                margin-left: 10px;
                margin-right: 10px;
             }
         }
         #questions-link {
            font-size: 12px;     
         }

         .disclaimer {
             margin-top: 30px;
             color: red;
         }
     }
 </style>
 <script>
    this.on('mount', async () => {
        console.log("add-alarm-personality mounted");
        if (IS_CLIENT) {
            try {
                let analysisStatus = null;

                // Did we just get the twitter credentials?
                if (this.state.sleeper.pendingTwitter) {
                    console.log("Got twitter credentials! analyzing tweets")
                    this.loading = true;
                    this.update();
                    analysisStatus = await this.state.sleeper.twitterAnalyze();
                    this.state.sleeper.currentAlarm.analysis = 'twitter';
                    this.state.sleeper.pendingTwitter = false;
                    this.loading = false;
                } else if (this.state.sleeper.pendingFacebook){
                    this.loading = true;
                    this.update();
                    analysisStatus = await this.state.sleeper.analyzeFacebook();
                    this.state.sleeper.currentAlarm.analysis = 'facebook';
                    this.state.sleeper.pendingFacebook = false;
                    this.loading = false;
                }

                if (analysisStatus) {
                    console.log("analysis status", analysisStatus);
                    if (analysisStatus.status == "success") {
                        if (!this.state.auth.user.name) {
                            this.state.auth.setUserName(analysisStatus.userName);
                        }
                        this.state.sleeper.currentAlarm.name = analysisStatus.userName;
                        this.validateCheck();
                   } else {
                        throw new Error(analysisStatus);
                   }
                }
            }

            catch (err) {
                this.state.sleeper.pendingTwitter = false;
                this.state.sleeper.pendingFacebook = false;
                this.loading = false;
                this.showError(err.message);
            }
            this.update();
        }

        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
    });

    showError(err) {
        let errorText;
        if (err.code && err.code == 130) {
            errorText = "The twitter servers are currently over capacity, please try again in a few minutes!"
        } else {
            errorText = "We have encountred the following error: " + err.message + ". Please inform our developers!";
            if (err.code) {
                errorText += ' (Code ' + err.code + ')';
            }
        }
        phonon.alert(errorText, "Something went wrong", false, "Ok");
    }

    this.on('unmount', () => {
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
    });

    this.on('ready', () => {
        this.update();
    });


    validateCheck() {
        if (!this.state.auth.user.status.phoneValidated) {
            if (IS_CLIENT) {
                page("/sign-up/contact")
            }
        } else if (!this.state.auth.user.pronoun) {
            if (IS_CLIENT) {
                page("/sign-up/pronoun")
            }
        }
        else {
            try {
                this.state.sleeper.addAlarm();
            } catch(err) {
                this.showError(err);
            }
        }
    }
    onAlarmCreated() {
        console.log("New alarm created!");
        if (IS_CLIENT) {
            page("/sleeper/alarms");
        }
    }
 </script>
</sleeper-alarms-add-personality>
