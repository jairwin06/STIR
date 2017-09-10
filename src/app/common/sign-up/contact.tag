<contact>
 <h1 class="title">Your contact details</h1>
  <p>
    Welcome {state.auth.user.name}!
  </p>
  <form onsubmit="{setContact}">
    Email:<input ref="email" type="email"><br>
    Phone number:<input id="phone" ref="phone" type="tel" required>
    <input type="submit" value="Next">
  </form>
  <p>
    <b>{phoneError}</b>
  <p>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        $("#phone").intlTelInput();
        console.log("sign-up contacts mounted");
    });

    this.on('unmount', () => {
    });

   async setContact(e) {
        e.preventDefault();
        let countryData = $("#phone").intlTelInput("getSelectedCountryData");
        console.log("Selected country data", countryData);
        let phoneNumber = this.refs.phone.value;
        let joinedPhone = '+' + countryData.dialCode + phoneNumber;
        console.log("Joined phone", joinedPhone);
        try {
            let result = await this.state.auth.setContact({
                phone: joinedPhone,
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
    }
 </script>
</contact>
