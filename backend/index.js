const express = require('express')
const mongoose = require('mongoose');
const axios = require('axios');
const cors = require('cors');
const { DB_HOST, DB_PORT } = require('./src/configs/constants')
/*
const db_address = `mongodb://${DB_HOST}:${DB_PORT}/password_manager`
mongoose.connect(db_address, { useNewUrlParser: true, useUnifiedTopology: true })
const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error: "));
db.once("open", function () {
    console.log("Connected successfully to:", db_address);
});
*/
const app = express()
app.use(express.json());
app.use(cors());

app.use((req, res, next) => {
    console.log(`Solicitud ${req.method} recibida en ${req.url}`)
    console.log(req.body)
    next()
})

app.post('/coordinates', async (req, res) => {
    const { latitude, longitude } = req.body;
    try {
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
        console.log(formattedResponse)
        res.json(formattedResponse);
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

const server = app.listen(53692, () => {
    console.log('Listening on:', server.address());
});