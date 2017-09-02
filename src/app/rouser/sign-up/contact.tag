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


    next(e) {
        e.preventDefault();
        this.state.rouser.setContact({
            phone: this.refs.phone.value,
            email: this.refs.email.value
        });
    }
 </script>
</contact>
