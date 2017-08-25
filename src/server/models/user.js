import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    device: String
},{timestamps: true})

const Model = mongoose.model('User', UserSchema);

export default Model;
