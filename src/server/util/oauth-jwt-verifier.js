import oauth1, { Verifier } from 'feathers-authentication-oauth1';
import {verifyUser} from '../services/auth'

export default class CustomVerifier extends Verifier {
  verify(req, accessToken, refreshToken, profile, done) {
    console.log("Custom verifier!");
    verifyUser(req)
    .then((result) => {
        super.verify(req, accessToken, refreshToken, profile, done);
    })
  }
}
