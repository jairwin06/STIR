<sign-up-contact>
  <header class="header-bar">
        <div class="pull-left">
            <a href="/"><h1>STIR | Contact</h1></a>
        </div>
  </header>
  <div class="content">
      <div show="{ phonePluginLoaded }" class="padded-full">
        <div if="{state.main.role == 'sleeper'}">
            <p><formatted-message id='SLEEPER_CONTACT_THANKS'
                    name="{state.auth.user.name}"
                />
            </p>
            <p>
                <formatted-message id='SLEEPER_CONTACT_EXPLANATION'/>
            </p>
        </div>
        <div if="{state.main.role == 'rouser'}">
            <p><formatted-message id='ROUSER_CONTACT'/></p>
        </div>
        <p><formatted-message id='CONTACT_EXPLANATION'/></p>
        <form action="" onsubmit="{setContact}">
            <input id="phone" ref="phone" type="tel" change="{onPhoneChange}" required>
            <div class="action">
                <button class="btn primary raised" type="submit">Next</button>
            </div>
        </form>
        <div class="disclaimer">
            <p if="{state.main.role == 'rouser'}"><formatted-message id='ROUSER_CONTACT_DISCLAIMER'/></p>
            <span if="{state.main.role == 'rouser'}">*</span><formatted-message id='CONTACT_DISCLAIMER'/>
        </div>
      </div>
      <div show="{ !phonePluginLoaded || loading }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
     <div if="{state.main.role == 'sleeper'}">
          <div class="stepper-container">
              <stepper size="{state.sleeper.getSteps()}" current="3"></stepper>
          </div>
     </div>
     <div if="{state.main.role == 'rouser'}">
          <div class="stepper-container">
              <stepper size="3" current="1"></stepper>
          </div>
     </div>
 </div>
 <style>
     sign-up-contact {
         .explanation {
            margin-top: 15px;
            font-size: 16px;
         }

         .action {
            margin-top: 15px;
         }

         form {
            margin-top: 10px;
         }

         .country-list {
            background-color: #333 !important;
         }
     }
 </style>
 <script>
    
    this.mixin('UIUtil');

    this.on('mount', () => {
        if (IS_CLIENT) {
            this.phonePluginLoaded = false;

            let deferred = $("#phone").intlTelInput({
                utilsScript: "/lib/intl-utils.js",
                initialCountry: this.state.auth.user.countryCode || ""
            });
            deferred.done(() => {
                this.onPhonePluginLoaded();
            })
        }

        this.PHONE_VALIDATION_MESSAGES = {
            1: "Please provide a valid country code",
            2: "Phone number is too short",
            3: "Phone number is too long"
        }
        console.log("sign-up contacts mounted");
    });

    this.on('unmount', () => {
    });

    this.on('ready', () => {
    });

   onPhoneChange() {
       $("#phone")[0].setCustomValidity("");
   }

   onPhonePluginLoaded() {
        console.log("Phone plugin loaded");
        this.phonePluginLoaded = true;
        this.update();
   }

   async setContact(e) {
        e.preventDefault();
        let isValid = $("#phone").intlTelInput("isValidNumber");
        console.log("Is number valid?", isValid);
        if (isValid) {
            let phoneNumber = $("#phone").intlTelInput("getNumber");
            console.log("Joined phone", phoneNumber);
            try {
                this.loading = true;
                this.update();
                let result = await this.state.auth.setContact({
                    phone: phoneNumber,
                    name:  this.state.auth.user.name,
                    locale: this.state.auth.locale
                })
                page("/sign-up/verify")
            }
            catch (err) {
               console.log("Setting contact error!", err);
               this.UIUtil.showError(err.message);
               this.loading = false;
               this.update();
            }
        } else {
            let error = $("#phone").intlTelInput("getValidationError");
            if (this.PHONE_VALIDATION_MESSAGES[error]) {
                $("#phone")[0].setCustomValidity(this.PHONE_VALIDATION_MESSAGES[error]);
            } else {
                $("#phone")[0].setCustomValidity("Please provide a valid phone number");
            }
        }
    }
 </script>
</sign-up-contact>
