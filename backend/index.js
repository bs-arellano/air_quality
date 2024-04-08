const express = require('express')
const mongoose = require('mongoose');
const axios = require('axios');
const cors = require('cors');
const { DB_HOST, DB_PORT, JWT_SECRET } = require('./src/configs/constants')
const User = require('./src/userModel')
const Measurement = require('./src/measumentModel')
const jwt = require('jsonwebtoken');
const moment = require('moment');

const db_address = `mongodb://${DB_HOST}:${DB_PORT}/air_quality`
mongoose.connect(db_address, { useNewUrlParser: true, useUnifiedTopology: true })
const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error: "));
db.once("open", function () {
    console.log("Connected successfully to:", db_address);
});

const app = express()
app.use(express.json());
app.use(cors());

app.use((req, res, next) => {
    console.log(`Solicitud ${req.method} recibida en ${req.url}`)
    next()
})

app.post('/coordinates', async (req, res) => {
    const token = req.headers["authorization-token"]
    const { latitude, longitude } = req.body;
    try {
        const id = jwt.decode(token)
        if (!id) { throw new AuthError("Invalid token") }
        const user = await User.findById(id)
        if (!user) throw new AuthError("Invalid token")
        const response = await axios.get(`https://api.openaq.org/v3/locations`, {
            params: {
                sort_order: 'asc',
                coordinates: `${latitude},${longitude}`,
                radius: 25000,
                limit: 100,
                page: 1
            },
            headers: {
                'Accept': 'application/json'
            }
        });

        const filteredResults = response.data.results.filter(result =>
            result.sensors.some(sensor => sensor.parameter.id === 2)
        );

        const formattedResults = filteredResults.map(result => ({
            id: result.id,
            sensor_id: result.sensors.find(sensor => sensor.parameter.id === 2).id,
            latitude: result.coordinates.latitude,
            longitude: result.coordinates.longitude
        }));

        let bestChoise = {
            id: null,
            sensor: null,
            distance: Infinity
        }

        formattedResults.forEach(result => {
            let currentDistance = Math.sqrt((result.latitude - latitude) ** 2 + (result.longitude - longitude) ** 2)
            if (currentDistance < bestChoise.distance) {
                bestChoise = {
                    id: result.id,
                    sensor: result.sensor_id,
                    distance: currentDistance
                }
            }
        });
        console.log(bestChoise.sensor)
        const pm25_measurement = await axios.get(`https://api.openaq.org/v3/sensors/${bestChoise.sensor}/measurements`, {
            params: {
                period_name: 'hour',
                limit: 1,
                page: 1
            },
            headers: {
                'Accept': 'application/json'
            }
        });
        const formattedResponse = {
            name: pm25_measurement.data.results[0].parameter.name,
            value: pm25_measurement.data.results[0].value,
            unit: pm25_measurement.data.results[0].parameter.units,
            date: Date.now()
        }
        const latestMeasurement = await Measurement.findOne({ user: user })
            .sort({ date: -1 }) // Sort by date in descending order
            .exec();
        if (latestMeasurement) {
            const timeDifference = Date.now() - latestMeasurement.date.getTime();
            const hoursDifference = timeDifference / (1000 * 60 * 60);
            if (hoursDifference > 1) {
                const measurement = new Measurement({ user: user, date: new Date(formattedResponse.date), value: formattedResponse.value })
                measurement.save()
            }
        } else {
            const measurement = new Measurement({ user: user, date: new Date(formattedResponse.date), value: formattedResponse.value })
            measurement.save()
        }
        res.json(formattedResponse);
    } catch (error) {
        if (error instanceof AuthError) {
            return res.status(403).json({ message: error.message })
        }
        console.log(error)
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get("/measurements", async (req, res) => {
    const token = req.headers["authorization-token"]
    try {
        const id = jwt.decode(token)
        if (!id) throw new AuthError("Invalid token")
        const user = await User.findById(id)
        if (!user) throw new AuthError("Invalid token")
        const lastMonthDate = moment().subtract(1, 'months').toDate();
        const monthMeasurements = await Measurement.find({ user: user })
        const formattedMeasurements = monthMeasurements.map(measurement => {
            return {
                date: measurement.date,
                value: measurement.value
            }
        })
        console.log(formattedMeasurements.length)
        return res.status(200).json({ measurements: formattedMeasurements })
    } catch (error) {
        if (error instanceof AuthError) {
            return res.status(403).json({ message: error.message })
        }
        console.log(error)
        res.status(500).json({ error: 'Internal Server Error' });
    }
})

app.post("/signin", async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email })
        if (!user) { throw new AuthError("User not found") }
        if (user.password == password) {
            const token = jwt.sign(user.id, JWT_SECRET)
            return res.status(200).json({ name: user.username, token: token })
        }
        else { throw new AuthError("Wrong password") }
    } catch (e) {
        if (e instanceof AuthError) {
            return res.status(403).json({ message: e.message })
        }
        console.log(e)
        return res.status(500).json({ message: "Internal error" })
    }
})

const server = app.listen(53692, () => {
    console.log('Listening on:', server.address());
});

class AuthError extends Error {
    constructor(message) {
        super(message);
        this.name = 'AuthError';
    }
}