<personality>
 <h1 class="title">Add Alarm personality</h1>
 <p>
  <span class="title">Use my facebook data</span>
  <form onsubmit="{analyzeFacebook}">
    <button type="submit" disabled="{!state.facebook.apiLoaded}">Analyze My Facebook posts</button>
  </form>
  <img show="{loading}" src="/images/loading.gif"></img>
 </p>
  <p>
      <a href="/auth/twitter" class="button">Use my Twitter data</a>
 </p>
 <p>
  <span class="title">Or Opt-out and answer some questions</span>
  <form onsubmit="{submitQuestions}">
    Your name <input type="text" name="name" ref="name">
    <button type="submit">Submit</button>
  </form>
  </p>
  
 <style>
     stage[data-is="personality"] {
         .title {
            font-size: 30px;
         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("add-alarm-personality mounted");
        if (IS_CLIENT) {
            this.state.facebook.loadAPI()
            .then(() => {
               console.log("API Loaded");
               this.update();
            })
        }

        this.state.facebook.on('analysis_status_updated', this.analysisStatusUpdated);
    });

    this.on('unmount', () => {
        this.state.facebook.off('analysis_status_updated', this.analysisStatusUpdated);
    });

    analyzeFacebook(e) {
        e.preventDefault();
        console.log("Logging in to facebook");
        this.loading = true;
        this.state.facebook.login()
        .then(() => {
            console.log("Connecteed");
            return this.state.facebook.analyze();
        })
    }

    analysisStatusUpdated() {
        this.loading = false;
        console.log("Facebook analysis status", this.state.facebook.analysisStatus);
        if (!this.state.auth.user.name) {
            this.state.auth.setUserName(this.state.facebook.analysisStatus.userName);
        }
        this.state.sleeper.currentAlarm.name = this.state.facebook.analysisStatus.userName;
        this.validateCheck();
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
            this.state.sleeper.setAddAlarmStage('sign-up');
        } else {
            this.state.sleeper.addAlarm();
        }
    }
 </script>
</personality>
