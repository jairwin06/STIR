import oauth1, { Verifier } from 'feathers-authentication-oauth1';
import Session from '../models/session-persistent'
import {verifyUser} from '../services/auth'
import AuthSettings from '../auth-settings'

export default class CustomVerifier extends Verifier {
  verify(req, accessToken, refreshToken, profile, done) {
    verifyUser(req.cookies[AuthSettings.cookie.name], req.app)
    .then((user) => {
        if (profile.provider == "facebook") {
            Session.setFor(user._id, {state: {pendingFacebook: true}});
        } else if (profile.provider == "twitter") {
            Session.setFor(user._id, {state: {pendingTwitter: true}});
        }
        super.verify(req, accessToken, refreshToken, profile, done);
    })
  }
}
