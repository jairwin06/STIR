import feathers from 'feathers';
import rest from 'feathers-rest';
import socketio from 'feathers-socketio'
import Routes from '../app/routes';

import { render,mixin } from 'riot';
import '../app/main.tag'

import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser';
import compress from 'compression'
import cors from 'cors'
import FS from 'fs';

import mongoose from 'mongoose'
import service from 'feathers-mongoose'

import State from '../app/state'
import hooks from 'feathers-hooks'
import session from 'express-session';
import authentication from 'feathers-authentication'
import jwt from 'feathers-authentication-jwt'
import oauth1 from 'feathers-authentication-oauth1'
import CustomOAuthVerifier from './util/oauth-jwt-verifier'
import CustomOAuthHandler from './util/oauth-jwt-handler'
import { Strategy as TwitterStrategy } from 'passport-twitter'

import authHooks from 'feathers-authentication-hooks'
import errorHandler from 'feathers-errors/handler'
import AuthSettings from './auth-settings'
import AuthService from './services/auth'
import {disallow, pluck} from 'feathers-hooks-common'
import TwiMLService from './services/twiml'

import FBAnalyzeService from './services/fbanalyze'
import UserContactService from './services/user-contact'
import RecordingsService from './services/recordings'

import UserModel from './models/user'
import AlarmModel from './models/alarm'

import GeneratePrompt from './services/generate-prompt'
import AlarmManager from './services/alarm-manager'
import patchAlarmHook from './services/patch-alarm'

import SocketUtil from '../app/util/socket'

global.fetch = require('node-fetch');
global.io = require('socket.io-client');

global.SERVER_URL = process.env['SERVER_URL'];

SocketUtil.initWithUrl("http://localhost:3030");

const app = feathers()
.set('views', process.env.APP_BASE_PATH + "/src/server/views")
.set('view engine', 'ejs')
//.configure(rest())
.configure(socketio({wsEngine: 'uws'}))
.configure(hooks())
.use(compress())
.options('*', cors())
.use(cors())
.use(feathers.static(process.env.APP_BASE_PATH + "/public"))
.use(cookieParser())
.use(bodyParser.json())
.use(bodyParser.urlencoded({ extended: true  }))
.use(session({ secret: AuthSettings.secret, resave: true, saveUninitialized: true  }));

// Services
mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/stir', {useMongoClient: true});

app
.use('/users', service({Model: UserModel}))
.use('/sleeper/alarms', service({Model: AlarmModel}))
.use('/rouser/alarms', new AlarmManager())
.use('/fbanalyze', new FBAnalyzeService())
.use('/user/contact', new UserContactService())
.use('/recordings',new RecordingsService());

// TWIML
app.post('/twiml-rec.xml', TwiMLService.getRecordingTwiML)
app.post('/twiml-alarm.xml', TwiMLService.getAlarmTwiML)
app.post('/twiml/recording-status/:userId', TwiMLService.getRecordingStatus)

//Setup authentication
app.configure(authentication(AuthSettings));
app.configure(jwt());
app.configure(oauth1({
  name: 'twitter',
  Strategy: TwitterStrategy,
  consumerKey: process.env['TWITTER_API_KEY'],
  consumerSecret: process.env['TWITTER_API_SECRET'],
  Verifier: CustomOAuthVerifier,
  handler:  CustomOAuthHandler({
    successRedirect: "/sleeper/alarms/add"
  })
}));

app.service('users').before({
  all: disallow('external')
});


// Setup a hook to only allow valid JWTs or successful 
// local auth to authenticate and get new JWT access tokens
app.service('authentication').hooks({
  before: {
    create: [
      authentication.hooks.authenticate(['jwt'])
    ]
  }
});

app.service('/sleeper/alarms').before({
  create: [
    authHooks.associateCurrentUser(),
    GeneratePrompt
  ],
  find: [
    authentication.hooks.authenticate(['jwt']),
    authHooks.queryWithCurrentUser(),
    (hook) => {hook.params.query.$select = ['id','time']; return hook}
  ],
  patch: [
      authHooks.restrictToOwner({ ownerField: 'userId' }),
      patchAlarmHook
  ],
  remove: disallow('external')
});

app.service('/sleeper/alarms').after({
  create: [
    pluck('_id', 'time') 
  ],
  patch: [
    pluck('_id', 'time') 
  ]
});

app.service('/user/contact').before({
  find: [
    authentication.hooks.authenticate(['jwt']),
    authHooks.queryWithCurrentUser()
  ]
});

app.service('/rouser/alarms').before({
  find: [
    authentication.hooks.authenticate(['jwt'])
  ]
});

app.service('/recordings').before({
  create: [
      authHooks.associateCurrentUser({ as: 'rouserId'})
  ]
});

app.service('/recordings').after({
  create: [
      TwiMLService.dispatchRecordingCall
  ]
});

app.service('/recordings').filter('ready', function(data, connection, hook) {
    if (connection.user._id.toString() == data.rouserId) {
        return data;
    } else {
        return false;
    }
});

// Client routes

// Auth middleware
app.use(AuthService);

app.use(function (req, res, next) {
    try {
        console.log("Init state");
        req.appState = new State();
        req.populateQueue = [];
        req.appState.auth.setAcessToken(req.accessToken);
        next();
    } catch (e) {
        console.log("Error in middleware!", e);
    }
});

Routes.runRoutingTable(app);

app.use(async function (req, res, next) {
    console.log("Render middleware");
    if (!req.handledRoute) {
        res.status(404).send('Nothing to see here!');
    } else {
        for (let i = 0; i < req.populateQueue.length; i++) {
            let taskObj = req.populateQueue[i];
            console.log("Runnint task", taskObj);
            await req.appState[taskObj.store][taskObj.task].apply(req.appState[taskObj.store], taskObj.args);
        }
        console.log("Render riot");
        mixin({state: req.appState}); // Global state mixin
        res.render('index', {
          initialData: JSON.stringify(req.appState, (key,value) => {
              return ((key == '_state' || key == 'debug') ? function() {} : value); 
          }),
          body: render('main', req.appState)
        })
    }
});

//app.use(errorHandler());


console.log("Starting server");

// Server routes
let server = 
    app.listen(3030, () => {

    let host = server.address().address
    let port = server.address().port

    console.log('Node/Feathers app listening at http://%s:%s', host, port);
});
