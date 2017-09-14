import mongoose from 'mongoose'

const AlarmSchema = new mongoose.Schema({
    time: {type: Date, required: true},
    name: {type: String, required: true},
    prompt: {type: String, required: true},
    userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
    assignedTo: {type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null},
    delivered: {type: Boolean, default: false},
    recording: {
        rouserId: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
        recordingUrl: {type: String, default: null},
        mixUrl: {type: String, default: null},
        finalized: {type: Boolean, default: false},
    },
    debug: {
        watson: String
    }
}, {timestamps: true})

mongoose.set('debug', true)

const Model = mongoose.model('Alarm', AlarmSchema);

export default Model;
