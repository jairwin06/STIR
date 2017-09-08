<contact>
 <h1 class="title">Your contact details</h1>
  <form onsubmit="{setContact}">
    Email:<input ref="email" type="email">
    Phone number:<input ref="phone" pattern="[+\d]*" type="tel" required>
    <input type="submit" value="Next">
  </form>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("sign-up contacts mounted");
    });

    this.on('unmount', () => {
    });

   async setContact(e) {
        e.preventDefault();
        try {
            let result = await this.state.auth.setContact({
                phone: this.refs.phone.value,
                email: this.refs.email.value
            })
            this.state.rouser.setSignUpStage("verify");
        }
        catch (err) {
           console.log("Setting contact error!", err);
        }
    }
 </script>
</contact>
