import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    name: String,
    email: String,
    phone: { type: String, index: { unique: true, sparse: true  }, required: false },
    country: String,
    countryCode: String,
    locale: String,
    pronoun: String,
    alarmLocales: [String],
    role: {type: String, default: "user"},
    alarmsRecorded: {type: Number, default: 0},
    password: String,
    status : {
        phoneValidated: {type: Boolean, default: false}
    },
    verificationCode: Number,
    twitter: {
        profile: {
            id: String,
            username: String,
            displayName: String
        },
        accessToken: String,
        refreshToken: String
    },
    facebook: {
        profile: {
            id: String,
            displayName: String
        },
        accessToken: String
    }
},{timestamps: true})

const Model = mongoose.model('User', UserSchema);

export default Model;
