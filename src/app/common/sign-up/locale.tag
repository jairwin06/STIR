<sign-up-locale>
  <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1 class="title">STIR - Contact</h1></a>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <div class="row description">
                <formatted-message id="{getMessageId()}"/>
            </div>

          <form action="" onsubmit="{setLocale}">
            <ul ref="localeList" class="list">
                <li class="">
                    <label class="checkbox">
                        <input type="checkbox" value="en" checked="{state.auth.locale == 'en'}" class="">
                        English
                        <span></span>
                    </label>
                </li>
                <li class="">
                    <label class="checkbox">
                        <input type="checkbox" value="fr" checked="{state.auth.locale == 'fr'}" class="">
                        French
                        <span></span>
                    </label>
                </li>
                </li>
                    <label class="checkbox">
                        <input type="checkbox" value="de" checked="{state.auth.locale == 'de'}" class="">
                        German
                        <span></span>
                    </label>
                </li>
            </ul>
            <input type="submit" value="Submit">
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
     sign-up-locale {
         .description {
            font-size: 18px;

         }
     }
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up locale mounted");
    });

    this.on('unmount', () => {
    });

    getMessageId() {
        if (this.state.main.role == 'rouser') {
            return 'ALARM_LOCALES_ROUSER';
        } else {
            return 'ALARM_LOCALES_SLEEPER';
        }
    }
    async setLocale(e) {
        e.preventDefault();
        console.log("Set locale!");
        let locales = $(this.refs.localeList).find('input').toArray()
        .filter(cb => cb.checked).map(cb => cb.value);
        try {
            if (locales.length == 0) {
                throw new Error("You need to select at least one languge!");
            }
            let result = await this.state.auth.setAlarmLocales(locales);
            if (result.status == "success") {
                if (this.state.main.role == 'sleeper' && this.state.sleeper.currentAlarm) {
                    page("/sign-up/pronoun");
                } else if (this.state.main.role == 'rouser') {
                    page("/rouser/alarms");
                } else {
                    page("/");
                }
            } else {
                throw new Error("Internal error");
            }
        }
        catch(err) {
            phonon.alert(err.message, "Oops", false, "Ok");
        }
    }
 </script>
</sign-up-locale>
