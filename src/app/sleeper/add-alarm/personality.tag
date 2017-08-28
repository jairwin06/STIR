<personality>
 <h1 class="title">Add Alarm personality</h1>
  <form onsubmit="{analyzeFacebook}">
    <button type="submit">Analyze My Facebook posts</button>
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
    });

    this.on('unmount', () => {
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
 </script>
</personality>
