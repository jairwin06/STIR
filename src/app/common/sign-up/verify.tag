<sign-up-verify>
  <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1>STIR | Contact</h1></a>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <p>
                <formatted-message if="{state.auth.user.name}" id='CONTACT_VERIFY_NAME'
                    name="{state.auth.user.name}"
                />
                <formatted-message if="{!state.auth.user.name}" id='CONTACT_VERIFY'/>
            </p>
           <form action="" onsubmit="{verifyCode}">
                <input ref="code" type="number" min="1000" max="9999">
                <div class="action">
                    <button class="btn primary raised" type="submit">
                        <formatted-message id='NEXT'/>
                    </button>
                </div>
           </form>
          <p>
          <b show"{error}" class="error">{error}</b>
          </p>
      </div>
      <div if="{state.main.role == 'sleeper'}">
          <div class="stepper-container">
              <stepper size="{state.sleeper.getSteps()}" current="4"></stepper>
          </div>
      </div>
     <div if="{state.main.role == 'rouser'}">
          <div class="stepper-container">
              <stepper size="3" current="2"></stepper>
          </div>
     </div>
  </div>
 <style>
     sign-up-verify {
         .action {
            margin-top: 15px;
         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up contacts mounted");
    });

    this.on('ready', () => {
        $(this.refs.code).focus();
    })

    this.on('unmount', () => {
    });

   async verifyCode(e) {
        e.preventDefault();
        try {
            console.log("Verify code " + this.refs.code.value);
            let result = await this.state.auth.verifyCode(this.refs.code.value);
            console.log("Verify code result status: " + result.status);
            if (result.status == "success") {
                page("/sign-up/locale");
            } else if (result.status == "EXISTS") {
                console.log("Phone exists!, asking confirmation");
                let confirm = phonon.confirm(
                    this.formatMessage('PHONE_EXISTS'), 
                    this.formatMessage('NOTICE'), 
                    true, 
                    "Ok", 
                    this.formatMessage('CANCEL')
                );
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
           console.log("Error while verifying code!", err);
           phonon.alert(err.message, "Oops!", false, "Ok");
        }
    }
 </script>
</sign-up-verify>
