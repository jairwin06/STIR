<record>
 <h1 class="title">Record a message</h1>
  <div id="prompt">
  <p>
  {state.rouser.currentAlarm.prompt}
  </p>
  </div>
  <form onsubmit="{requestCall}">
    <p>
        <b>Press the button to receive the call</b>
    </p>
    <input type="submit" value="Receive Call">
  </form>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm record mounted");
    });

    this.on('unmount', () => {
    });


    async requestCall(e) {
        e.preventDefault();
        console.log("Request a call!");
        try {
            let result = await this.state.rouser.requestCall();
            console.log("Request call result", result);
        } 
        catch(e) {
            console.log("Error requesting call", e);
        }
    }
 </script>
</record>
