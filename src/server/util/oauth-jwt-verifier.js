import oauth1, { Verifier } from 'feathers-authentication-oauth1';
import Session from '../models/session-persistent'
import {verifyUser} from '../services/auth'

export default class CustomVerifier extends Verifier {
  verify(req, accessToken, refreshToken, profile, done) {
    verifyUser(req)
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
