const mongoose = require('mongoose')

const measurementSchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    value: {
        type: Number,
        required: true
    },
    date: {
        type: Date,
        required: true
    }
})

const Measurement = mongoose.model('Measurement', measurementSchema);

module.exports = Measurement;