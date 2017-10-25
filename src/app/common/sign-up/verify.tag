<sign-up-verify>
  <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1 class="title">STIR - Contact</h1></a>
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
                page("/sign-up/locale");
            } else if (result.status == "EXISTS") {
                let confirm = phonon.confirm(this.formatMessage('PHONE_EXISTS'), this.formatMessage('NOTICE'), true, "Ok", "Cancel");
                confirm.on('confirm', async () => {
                    console.log("Forcing!");
                    let result = await this.state.auth.verifyCode(this.refs.code.value, true);
                    console.log("Result", result);
                    if (result.status == "success") {
                        this.state.sleeper.invalidateAlarms();
                        page("/sign-up/locale");
                    }
                });
            } else {
                throw new Error("Internal error");
            }
        }
        catch (err) {
           phonon.alert(err.message, "Oops!", false, "Ok");
        }
    }
 </script>
</sign-up-verify>
