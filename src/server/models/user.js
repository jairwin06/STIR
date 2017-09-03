import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    email: String,
    phone: String,
    status : {
        phoneValidated: {type: Boolean, default: false}
    },
    verificationCode: Number
},{timestamps: true})

const Model = mongoose.model('User', UserSchema);

export default Model;
