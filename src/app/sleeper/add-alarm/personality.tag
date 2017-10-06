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
    this.on('mount', () => {
        console.log("add-alarm-personality mounted");
        if (IS_CLIENT) {
            // Did we just get the twitter credentials?
            if (this.state.sleeper.pendingTwitter) {
                console.log("Got twitter credentials! analyzing tweets")
                this.state.sleeper.twitterAnalyze();
                this.loading = true;
                this.update();
            } else if (this.state.sleeper.pendingFacebook){
                this.state.sleeper.analyzeFacebook();
                this.loading = true;
                this.update();
            }
        }

        this.state.sleeper.on('analysis_status_updated', this.analysisStatusUpdated);
        this.state.sleeper.on('alarm_created', this.onAlarmCreated);
    });

    this.on('unmount', () => {
        this.state.sleeper.off('analysis_status_updated', this.analysisStatusUpdated);
        this.state.sleeper.off('alarm_created', this.onAlarmCreated);
    });

    analysisStatusUpdated() {
        this.loading = false;
        console.log("analysis status", this.state.sleeper.analysisStatus);
        if (this.state.sleeper.analysisStatus.status == "success") {
            if (!this.state.auth.user.name) {
                this.state.auth.setUserName(this.state.sleeper.analysisStatus.userName);
            }
            this.state.sleeper.currentAlarm.name = this.state.sleeper.analysisStatus.userName;
            this.validateCheck();
        } else {
            let errorText;
            if (this.state.sleeper.analysisStatus.code == 130) {
                errorText = "The twitter servers are currently over capacity, please try again in a few minutes!"
            } else {
                errorText = "We have encountred the following error: " + this.state.sleeper.analysisStatus.message + ". Please inform our developers!";
                if (this.state.sleeper.analysisStatus.code) {
                    errorText += ' (Code ' + this.state.sleeper.analysisStatus.code + ')';
                }
            }
            phonon.alert(errorText, "Something went wrong", false, "Ok");
        }
        this.update();
    }

    submitQuestions(e) {
        e.preventDefault();
        this.state.sleeper.currentAlarm.name = this.refs.name.value;
        if (!this.state.auth.user.name) {
            this.state.auth.setUserName(this.refs.name.value);
        }
        this.validateCheck();
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
