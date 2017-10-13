<sleeper-alarms-add-personality>
    <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Sleeper</h1>
        </div>
    </header>
  <div class="content">
   <div id="choice" class="row">
        How do you want to personalize your experience?
    </div>
     <p>
      <div class="title">Use my facebook data</div>
       <a href="/auth/facebook" class="button">Analyze posts</a>
     </p>
    <img show="{loading}" src="/images/loading.gif"></img>
      <p>
          <div class="title">Use my twitter data</div>
          <a href="/auth/twitter" class="button">Analyze tweets</a>
     </p>
     <b show"{error}" class="error">{error}</b>
     <p>
      <span class="title">Or Opt-out and answer some questions</span>
      <form action="" onsubmit="{submitQuestions}">
        Your name <input type="text" name="name" ref="name">
        <button type="submit">Submit</button>
      </form>
      </p>
      <p>
        <a href="/sleeper/alarms/add/time" class="button">Back to alarm time</a>
      </p>
  </div>
  
 <style>
     stage[data-is="personality"] {
         .title {
            font-size: 30px;
         }
         .error {
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
                } else if (this.state.sleeper.pendingFacebook){
                    this.loading = true;
                    this.update();
                    analysisStatus = await this.state.sleeper.analyzeFacebook();
                    this.state.sleeper.currentAlarm.analysis = 'facebook';
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
                this.showError(err.message);
            }
        }

        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
    });

    showError(err) {
        let errorText;
        if (err.code == 130) {
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

    async submitQuestions(e) {
        e.preventDefault();
        try {
            this.state.sleeper.currentAlarm.analysis = 'questions';
            this.state.sleeper.currentAlarm.name = this.refs.name.value;
            if (!this.state.auth.user.name) {
                this.state.auth.setUserName(this.refs.name.value);
            }
            let analysisStatus = await this.state.sleeper.questionsAnalyze(
                {name: this.refs.name.value}            
            );
            console.log("Analysis status", analysisStatus);

            this.validateCheck();
        
        } catch (err) {
            console.log("Questions analyze error!", err);
            this.showError(err);
        }
    }

    validateCheck() {
        if (!this.state.auth.user.status.phoneValidated) {
            if (IS_CLIENT) {
                page("/sign-up/contact")
            }
        } else {
            this.state.sleeper.addAlarm();
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
