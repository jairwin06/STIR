import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    email: String,
    phone: String,
    status : {
        signedIn: {type: Boolean, default: false},
        phoneValidated: {type: Boolean, default: false}
    }
},{timestamps: true})

const Model = mongoose.model('User', UserSchema);

export default Model;
