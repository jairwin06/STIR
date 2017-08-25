import {Schema} from 'mongoose'

const AlarmSchema = new Schema({
    time: {type: Date, required: true}
}, {timestamps: true})
