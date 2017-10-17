<sign-up-pronoun>
  <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Contact</h1>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <div class="row description">
                <formatted-message id="CONTACT_PRONOUN"/>
            </div>

          <form ref="pronounForm" action="" onsubmit="{setPronoun}">
            <ul class="list">
                <li class="padded-for-list">
                    <label class="radio">
                        <input type="radio" change="{onChange}" name="pronoun" value="he" class="">
                        He
                        <span></span>
                    </label>
                </li>
                <li class="padded-for-list">
                    <label class="radio">
                        <input type="radio" change="{onChange}" name="pronoun" value="she" class="">
                        She
                        <span></span>
                    </label>
                </li>
                <li class="padded-for-list">
                    <label class="radio">
                        <input type="radio" change="{onChange}" name="pronoun" value="they" class="">
                        They
                        <span></span>
                    </label>
                </li>
            </ul>
            <button click="this.form.submit();" disabled="{!refs.pronounForm.pronoun.value || refs.pronounForm.pronoun.value.length == 0}" class="btn fit-parent primary raised">Submit</button>
          </form>
          <p>
          <b show"{error}" class="error">{error}</b>
          </p>
      </div>
      <div show="{ loading }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
  </div>
 <style>
     sign-up-pronoun {
         .description {
            font-size: 18px;

         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up pronoun mounted");
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