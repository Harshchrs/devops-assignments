const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/views/form.html');
});

app.post('/submit', async (req, res) => {
    try {
        await axios.post('http://backend:5000/submit', req.body);
        res.send("Data submitted successfully");
    } catch(err) {
        res.send("Error submitting data");
    }
});

app.listen(3000, () => console.log('Frontend running on port 3000'));
