import SocketUtil from '../util/socket';
import Store from './store';

export default class AuthStore extends Store {
    constructor() {
        super();
        console.log("Init AuthStore");
        this.user = null;
    }     

    setAcessToken(accessToken) {
        console.log("Setting access token");
        this.accessToken = accessToken;
    }

    async login() {
        try {
            console.log("User login");
            //let response = await fetchUtil.postJSON("http://localhost:3000/authentication", loginData);
            let response = await SocketUtil.rpc("authenticate", {
                strategy: "jwt",
                accessToken: this.accessToken
            });
            console.log("Login reply: ", response);
            if (response.errors) {
                this.trigger("login_error", response.message);
            } else {
                this.accessToken = response.accessToken;
                // Reconnect the socket to gain session auth
                //socketUtil.reconnect();
                this.trigger("login_success", response.accessToken);
            }
        }
        catch (e) {
            console.log("Error logging in", e);                    
        }
        
    }

    async setContact(contact) {
        console.log("Set contact", contact);
        let result = await SocketUtil.rpc('user/contact::create',contact);
        console.log("Rouser contact status", result);
        return result;
    }

    async verifyCode(code) {
        try {
            console.log("Verify code ", code);
            let result = await SocketUtil.rpc('user/contact::create',{code: code});
            console.log("Verify result", result);
            if (result.status == "success") {
                this.trigger("user_code_verified");
            }
        } catch (e) {
            console.log("Error verifying code", e);
        }
    }

};
