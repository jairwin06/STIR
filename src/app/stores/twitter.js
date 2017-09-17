import SocketUtil from '../util/socket';
import Store from './store';

export default class TwitterStore extends Store {
    constructor() {
        super();
        console.log("Init twitter store");
        this.apiLoaded = false;
        this.connected = false;
        this.analysisStatus = null;
    }     

    loadAPI() {
        return new Promise((resolve, reject) => {
            if (this.apiLoaded) {
                resolve();
            } else {
                console.log("Loading Twitter API using JQuery");
                $.ajaxSetup({ cache: true });
                window.twttr = { ready: () => resolve();}
                $.getScript('//platform.twitter.com/widgets.js', function(){
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
