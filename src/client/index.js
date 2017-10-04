'use strict';

import { mount,mixin } from 'riot';
import '../app/main.tag'
import page from 'page';
import Routes from '../app/routes';
import pageExpressMapper from 'page.js-express-mapper.js';
import State from '../app/state'
import 'nodent-runtime'
import SocketUtil from '../app/util/socket'

import 'phonon'

console.log("Client loading!");

window.IS_SERVER = false
window.IS_CLIENT = true

SocketUtil.initWithUrl(window.location.protocol + "//" + window.location.host);

// PHONON
phonon.options({
	navigator: {
	    defaultPage: 'main',
	    hashPrefix: '!', 
	    animatePages: true,
	    enableBrowserBackButton: true,
	    templateRootDirectory: '',
	    useHash: false,
        riotEnabled: true,
        riot: {
            compile: (fn) => {fn()},
            mount: mount
        }
	},
	// i18n: null if you do not want to use internationalization
	i18n: null
});

window.page = page;

// activate express-mapper plugin
pageExpressMapper({
    renderMethod: null,
    expressAppName: 'app'
});

let state = new State();
let initialData = JSON.parse(window.initialData);

Object.keys(state).forEach((key) => {
    if (initialData[key]) {
        Object.assign(state[key], initialData[key]);
    }
});

page('*', function(ctx,next) {
    console.log("Set state in page context");
    ctx.appState = state;
    ctx.populateQueue = [];
    next();
});

Routes.runRoutingTable(window.app);

page('*', function(ctx,next) {
    if (ctx.canonicalPath == "/") {
         phonon.navigator().changePage('main');
    } else {
        let tagName = ctx.canonicalPath.substring(1).replace(/\//g,"-");
        console.log("Phonon change page to ", tagName);
        phonon.navigator().changePage(tagName);
    }
})

console.log("Initial state", state);
mixin({state: state}); // Global state mixin

page();
phonon.navigator().start();
