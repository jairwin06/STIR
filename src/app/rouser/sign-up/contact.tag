<contact>
 <h1 class="title">Your contact details</h1>
  <form onsubmit="{next}">
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

   async next(e) {
        e.preventDefault();
        try {
            let result = await this.state.rouser.setContact({
                phone: this.refs.phone.value,
                email: this.refs.email.value
            })
            console.log("Setting contact result!", result);
        }
        catch (err) {
           console.log("Setting contact error!", err);
        }
    }
 </script>
</contact>
