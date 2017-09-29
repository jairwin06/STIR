import SocketUtil from '../util/socket';
import FetchUtil from '../util/fetch';
import Store from './store';

export default class AuthStore extends Store {
    constructor() {
        super();
        console.log("Init AuthStore");
        this.user = {};
        this.signUpStage = "contact";
    }     

    setAcessToken(accessToken) {
        console.log("Setting access token");
        this.accessToken = accessToken;
    }

    async loginSocket() {
        try {
            console.log("User login");
            //let response = await fetchUtil.postJSON("http://localhost:3000/authentication", loginData);
            let response = await SocketUtil.rpc("authenticate", {
                strategy: "jwt",
                accessToken: this.accessToken
            });
            console.log("SOCKET Login reply: ", response);
            if (response.errors) {
                this.trigger("login_error", response.message);
            } else {
                this.accessToken = response.accessToken;
                this.trigger("login_success", response.accessToken);
            }
        }
        catch (e) {
            console.log("Error logging in", e);                    
        }
        
    }

    async loginRest() {
        try {
            console.log("User login");
            let response = await FetchUtil.postJSON("/authentication", {strategy: "jwt"}, this.accessToken)
            console.log("REST Login reply: ", response);
            if (response.errors) {
                this.trigger("login_error", response.message);
            } else {
                this.accessToken = response.accessToken;
                this.loginSocket();
                this.trigger("login_success", response.accessToken);
                return {status: "success"};
            }
        }
        catch (e) {
            console.log("Error logging in", e);                    
        }
        
    }

    async loginLocal(name, password) {
        // TODO: If this fails then the JWT cookie is cleared and a new user will be created. is this ok?
        console.log("Local login", name, password);
        let response = await FetchUtil.postJSON("/authentication", {
            strategy: "local",
            name: name,
            password: password
        })
        console.log("LOCAL Login reply: ", response);
        if (response.errors) {
            throw new Error(response.message);
        } else {
            this.accessToken = response.accessToken;
            this.trigger("login_success", response.accessToken);
        }
        
    }
    async getStatus() { 
        if (!this.user.status && !this.gettingStatus)  {
            try {
                this.gettingStatus = true;
                console.log("Getting user status");
                let result = await SocketUtil.rpc('user/contact::find', {accessToken: this.accessToken});
                this.gettingStatus = false;
                console.log("User contact status", result);
                this.user.status = result.status;
                this.user.role = result.role;
                this.trigger("status_updated");
            }

            catch (e) {
                console.log("Error getting rouser status  ", e);                    
                this.gettingStatus = false;
            }
        }
    }
    async getSession() { 
        if (!this.user.session && !this.gettingSession)  {
            try {
                this.gettingSession = true;
                console.log("Getting user session");
                let result = await SocketUtil.rpc('user/session::find', {accessToken: this.accessToken});
                this.gettingStatus = false;
                this.user.session = result;
                return this.user.session;
            }

            catch (e) {
                console.log("Error getting user session", e);                    
                this.gettingSession = false;
            }
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
                this.user.status.phoneValidated = true;
                this.trigger("user_code_verified");
            }
        } catch (e) {
            console.log("Error verifying code", e);
        }
    }

    setSignUpStage(stage) {
        console.log("Set sign up stage", stage);
        this.signUpStage = stage;
        this.trigger('sign_up_stage');
    }

    setUserName(name) {
        console.log("Setting user name to", name);
        this.user.name = name;
    }

    async setSession(data) {
        let result = await SocketUtil.rpc('user/session::create',data);
        return result;
    }

};
