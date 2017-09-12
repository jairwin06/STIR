<contact>
 <h1 class="title">Your contact details</h1>
  <p>
    Welcome {state.auth.user.name}!
  </p>
  <form onsubmit="{setContact}">
    Email:<input ref="email" type="email"><br>
    Phone number:<input id="phone" ref="phone" type="tel" change="{onPhoneChange}" required>
    <input type="submit" value="Next" disabled="{ !phonePluginLoaded }" >
  </form>
  <p>
    <b>{phoneError}</b>
  <p>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        if (IS_CLIENT) {
            this.phonePluginLoaded = false;

            let deferred = $("#phone").intlTelInput({
                utilsScript: "/lib/intl-utils.js"
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
                let result = await this.state.auth.setContact({
                    phone: phoneNumber,
                    email: this.refs.email.value,
                    name:  this.state.auth.user.name
                })
                this.state.auth.setSignUpStage("verify");
            }
            catch (err) {
               console.log("Setting contact error!", err);
               this.phoneError = err.message;
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
</contact>
