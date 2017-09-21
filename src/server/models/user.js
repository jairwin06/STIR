import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    name: String,
    email: String,
    phone: String,
    status : {
        phoneValidated: {type: Boolean, default: false}
    },
    verificationCode: Number,
    twitterId: String
},{timestamps: true})

const Model = mongoose.model('User', UserSchema);

export default Model;
