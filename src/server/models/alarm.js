import mongoose from 'mongoose'

const AlarmSchema = new mongoose.Schema({
    time: {type: Date, required: true},
    userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true}
}, {timestamps: true})

const Model = mongoose.model('Alarm', AlarmSchema);

export default Model;
