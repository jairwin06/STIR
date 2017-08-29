import mongoose from 'mongoose'

const AlarmSchema = new mongoose.Schema({
    time: {type: Date, required: true},
    name: {type: String, required: true},
    prompt: {type: String, required: true},
    userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
    debug: {
        watson: String
    }
}, {timestamps: true})

mongoose.set('debug', true)

const Model = mongoose.model('Alarm', AlarmSchema);

export default Model;
