<personality>
 <h1 class="title">Add Alarm personality</h1>
  <form onsubmit="{analyzeFacebook}" show="{this.state.facebook.analysisStatus != 'success'}">
    <button type="submit">Analyze My Facebook posts</button>
  </form>

  <b>Opt-out and answer some questions</b>
  <form onsubmit="{submitQuestions}">
    Your name <input type="text" name="name" ref="name">
    <button type="submit">Submit</button>
  </form>
  
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("add-alarm-personality mounted");
        this.state.facebook.loadAPI()
        .then(() => {
           console.log("API Loaded");
        })

        this.state.facebook.on('analysis_status_updated', this.analysisStatusUpdated);
    });

    this.on('unmount', () => {
        this.state.facebook.off('analysis_status_updated', this.analysisStatusUpdated);
    });

    analyzeFacebook(e) {
        e.preventDefault();
        console.log("Logging in to facebook");
        this.state.facebook.login()
        .then(() => {
            console.log("Connecteed");
            return this.state.facebook.analyze();
        })
    }

    analysisStatusUpdated() {
        console.log("Facebook analysis status", this.state.facebook.analysisStatus);
        if (!this.state.auth.user.name) {

            this.state.auth.setUserName(this.state.facebook.analysisStatus.userName);
        }
        this.state.sleeper.newAlarm.name = this.state.facebook.analysisStatus.userName;
        this.validateCheck();
    }

    submitQuestions(e) {
        e.preventDefault();
        this.state.sleeper.newAlarm.name = this.refs.name.value;
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
