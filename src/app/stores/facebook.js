import SocketUtil from '../util/socket';
import Store from './store';

export default class FacebookStore extends Store {
    constructor() {
        super();
        console.log("Init Facebook store");
        this.apiLoaded = false;
        this.connected = false;
        this.analysisStatus = null;
    }     

    // TODO: Use OAuth2!
    loadAPI() {
        return new Promise((resolve, reject) => {
            if (this.apiLoaded) {
                resolve();
            } else {
                console.log("Loading Facebook API using JQuery");
                $.ajaxSetup({ cache: true });
                $.getScript('//connect.facebook.net/en_US/sdk.js', () => {
                    FB.init({
                      appId: '679489015579803',
                      version: 'v2.8',
                      cookie : true,
                      xfbml : true
                    });     
                    FB.AppEvents.logPageView();
                    this.apiLoaded = true;
                    resolve();
                });
            }
        });
    }

    login() {
        return new Promise((resolve, reject) => {
            FB.login((response) => {
                console.log("Login response", response);
                if (response.status == "connected") {
                    this.connected = true;
                    this.accessToken = response.authResponse.accessToken;
                    resolve();
                } else {
                    this.connected = false;
                    reject(response.status);
                }
            }, {scope: 'public_profile,email,user_posts'});
        })
    }
    async analyze() {
        try {
            console.log("Analyzing");
            let result = await SocketUtil.rpc('fbanalyze::find', {fbaccessToken: this.accessToken});
            console.log("Result", result);
            this.analysisStatus = result;
            this.trigger('analysis_status_updated');
        } catch(e) {
            console.log("Error analyzing", e);
        }
    }
};
