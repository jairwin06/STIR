<personality>
 <h1 class="title">Add Alarm personality</h1>
  <form onsubmit="{analyzeFacebook}" show="{this.state.facebook.analysisStatus != 'success'}">
    <button type="submit">Analyze My Facebook posts</button>
  </form>

  <form onsubmit="{done}">
    Your name <input type="text" name="name" ref="name">
    <button show ="{this.state.facebook.analysisStatus == 'success'}" type="submit">Done</button>
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
        this.update();
    }

    done(e) {
        e.preventDefault();
        this.state.sleeper.newAlarm.name = this.refs.name.value;
        this.state.sleeper.addAlarm();
    }
 </script>
</personality>
