<login>
 <section id="admin-login">
     <h1 class="title">Login</h1>
     <b>Enter password</b>
    <form onsubmit="{ login }">
        <input ref="password" type="password" required>
        <input type="submit" value="Login">
    </form>
    <b show"{error}" class="error">{error}</b>
 </section>

 <style>
  #admin login {
    h1 {
     color: blue;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("admin login mounted");
    });

    this.on('unmount', () => {
    });
    async login(e) {
        e.preventDefault();
        try {
            let result = await this.state.auth.loginLocal("admin", this.refs.password.value);
            console.log("Login result", result);
        } catch (e) {
            console.log("Error on login!", e);
            this.error = e.message;
            this.update();
        }
    }
 </script>
</login>
