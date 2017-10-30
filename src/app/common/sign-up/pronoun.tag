<sign-up-pronoun>
  <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1>STIR | Contact</h1></a>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <h1><formatted-message id="CONTACT_PRONOUN"/></h1>
           <p><formatted-message id="CONTACT_PRONOUN_EXPLANATION"/></p>
          <form ref="pronounForm" action="" onsubmit="{setPronoun}">
            <ul ref="pronounList" class="list">
                <li class="padded-for-list">
                    <label class="radio">
                         <formatted-message id="HE"/>
                        <input type="radio" change="{onChange}" name="pronoun" value="he" class="">
                        <span></span>
                    </label>
                </li>
                <li class="padded-for-list">
                    <label class="radio">
                        <formatted-message id="SHE"/>
                        <input type="radio" change="{onChange}" name="pronoun" value="she" class="">
                        <span></span>
                    </label>
                </li>
                <!--li class="padded-for-list">
                    <label class="radio">
                         <formatted-message id="THEY"/>
                        <input type="radio" change="{onChange}" name="pronoun" value="they" class="">
                        <span></span>
                    </label>
                </li-->
            </ul>
            <div class="action text-center">
                <button click="this.form.submit();" disabled="{!refs.pronounForm.pronoun.value || refs.pronounForm.pronoun.value.length == 0}" class="btn primary raised">
                   <formatted-message id="SUBMIT"/>
                </button>
            </div>
          </form>
          <p>
          <b show"{error}" class="error">{error}</b>
          </p>
      </div>
      <div show="{ loading }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
     <div class="stepper-container">
          <stepper size="{state.sleeper.getSteps()}" current="{state.sleeper.getSteps()}"></stepper>
     </div>
  </div>
 <style>
     sign-up-pronoun {
         .description {
            font-size: 18px;

         }

         form {
            margin-top: 30px;
         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up pronoun mounted");
        if (IS_CLIENT) {
            // For phonon...
            $(this.refs.pronounList).find('formatted-message > span').addClass('text');
        }
    });

    this.on('unmount', () => {
    });

    onChange() {
        this.update();
    }

    async setPronoun(e) {
        e.preventDefault();
        try {
            if (!this.refs.pronounForm.pronoun.value || this.refs.pronounForm.pronoun.value.length == 0) {
                throw new Error("Please select a pronoun");
            }
            console.log("Set pronoun!", this.refs.pronounForm.pronoun.value);
            let result = await this.state.auth.setPronoun(this.refs.pronounForm.pronoun.value);
            console.log(result);
            if (result.status == "success") {
                if (this.state.main.role == 'sleeper' && this.state.sleeper.currentAlarm) {
                    await this.state.sleeper.addAlarm();
                    page("/sleeper/alarms");
                } else {
                    page("/");
                }
            } else {
                throw new Error("Internal error");
            }
        }
        catch(err) {
            console.log("set pronoun error!", err);
            phonon.alert(err.message, "Oops", false, "Ok");
        }
    }
 </script>
</sign-up-pronoun>
