<verify>
 <h1 class="title">Verify your phone</h1>
  <form onsubmit="{verifyCode}">
    Verification code:<input ref="code" type="text" pattern="\d\{4\}">
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

   async verifyCode(e) {
        e.preventDefault();
        try {
            console.log("Verify code " + this.refs.code.value);
            this.state.auth.verifyCode(this.refs.code.value);
        }
        catch (err) {
           console.log("Code verification error", err);
        }
    }
 </script>
</verify>
