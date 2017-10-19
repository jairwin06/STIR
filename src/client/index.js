'use strict';

import { mount,mixin } from 'riot';
import '../app/main.tag'
import page from 'page';
import Routes from '../app/routes';
import pageExpressMapper from 'page.js-express-mapper.js';
import State from '../app/state'
import 'nodent-runtime'
import SocketUtil from '../app/util/socket'
import TimeUtil from '../app/util/time'

// i18n
import {IntlMixin} from 'riot-intl'
import Messages from '../app/i18n/messages'
import Formats from '../app/i18n/formats'
import 'riot-intl/dist/locale-data/fr'

// Phonon
import 'phonon/dist/js/phonon-core'
import 'phonon/dist/js/components/dialogs'
import 'phonon/dist/js/components/preloaders'
import 'phonon/dist/js/components/forms'
//import 'phonon/dist/js/components/popovers'

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

/*
let popover = phonon.popover('#lang-popover').onItemChanged(function (data) {
        if (data.value != state.auth.locale) {
            console.log("Language changed!", data)
            state.auth.locale = data.value;
            state.auth.updateContact(
                {locale: state.auth.locale}
            );
            let mixinObj = mixin('i18n', null, true);            
            mixinObj.i18n.messages = Messages[state.auth.locale];
            mixinObj.i18n.locales = [state.auth.locale];
            updateTag(phonon.navigator().currentPage);
        }
})*/ 

function updateTag(name) {
    let tags = phonon.tagManager.getAll();
    let found = false;
    for (let i = 0; i < tags.length && !found; i++) {
        if(tags[i].tagName === name) {
            tags[i].update();
            found = true;
        }
    }
}

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
    console.log("Page!", ctx);
    let path = ctx.canonicalPath.split('#')[0];
    if (ctx.page) {
        phonon.navigator().changePage(ctx.page);
    }
    else if (path == "/") {
         phonon.navigator().changePage('main');
    } 
    else if (path.indexOf('auth/') == -1)  {
        let tagName = path.substring(1).replace(/\//g,"-");
        console.log("Phonon change page to ", tagName);
        phonon.navigator().changePage(tagName);
    } else {
        next();
    }
})

console.log("Initial state", state);
mixin({state: state}); // Global state mixin
/* Locale */
IntlMixin.i18n = {
    locales: [state.auth.locale],
    messages: Messages[state.auth.locale],
    formats: Formats
}
mixin('i18n', IntlMixin, true); 
mixin('TimeUtil', {TimeUtil: TimeUtil}); 

page();
phonon.navigator().start();
