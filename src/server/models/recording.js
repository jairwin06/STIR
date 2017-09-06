/*
 *
 * for now using denormalized
 *
 *
 *
import mongoose from 'mongoose'

const RecordingSchema = new mongoose.Schema({
    rouserId: {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
    alarmId: {type: mongoose.Schema.Types.ObjectId, ref: 'Alarm', default: null},
    recordingUrl: {type: String, default: null},
}, {timestamps: true})

const Model = mongoose.model('Recording', RecordingSchema);

export default Model;
*/
