<sign-up-verify>
  <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Contact</h1>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <div id="choice" class="row">
                Verify your phone number with a code
           </div>
           <form action="" onsubmit="{verifyCode}">
                <input ref="code" type="number" min="1000" max="9999">
                <input type="submit" value="Next">
           </form>
          <p>
          <b show"{error}" class="error">{error}</b>
          </p>
      </div>
  </div>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up contacts mounted");
    });

    this.on('unmount', () => {
    });

   async verifyCode(e) {
        e.preventDefault();
        try {
            console.log("Verify code " + this.refs.code.value);
            let result = await this.state.auth.verifyCode(this.refs.code.value);
            if (result.status == "success") {
                if (this.state.main.role == 'sleeper' && this.state.sleeper.currentAlarm) {
                    await this.state.sleeper.addAlarm();
                    page("/sleeper/alarms");
                } else if (this.state.main.role == 'rouser') {
                    page("/rouser/alarms");
                } else {
                    page("/");
                }
            } else {
                throw new Error("Internal error");
            }
        }
        catch (err) {
           this.error = err.message;
           this.update();
        }
    }
 </script>
</sign-up-verify>
