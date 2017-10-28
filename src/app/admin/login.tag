<admin-login>
  <header class="header-bar">
        <div class="pull-left">
            <h1>STIR | Admin</h1>
        </div>
  </header>
  <div class="content">
      <div class="padded-full">
           <div class="row">
             <b>Enter password</b>
           </div>
           <div>
                <form action="" onsubmit="{ login }">
                    <input ref="password" type="password" required>
                    <button type="submit" class="btn primary">Login</button>
                </form>
            </div>
            <b show"{error}" class="error">{error}</b>
     </div>
      <div show="{ loading }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
 </div>

 <style>
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
            this.loading = true;
            this.update();
            let result = await this.state.auth.loginLocal("admin", this.refs.password.value);
            console.log("Login result", result);
            if (result.status == 'success' && IS_CLIENT) {
                window.location.href = "/admin/dashboard";
            }
            this.loading = false;
        } catch (e) {
            console.log("Error on login!", e);
            this.error = e.message;
            this.loading = false;
            this.update();
        }
    }
 </script>
</admin-login>
