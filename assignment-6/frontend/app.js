const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

const app = express();
const PORT = 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Serve a simple form
app.get("/", (req, res) => {
  res.send(`
    <form action="/submit" method="POST">
      <input name="name" placeholder="Your Name" required/>
      <input name="email" placeholder="Your Email" required/>
      <button type="submit">Submit</button>
    </form>
  `);
});

// Handle form submission and send data to Flask backend
app.post("/submit", async (req, res) => {
  try {
    const response = await axios.post("http://localhost:5000/api", req.body);
    res.send("Data sent to backend successfully! Backend response: " + JSON.stringify(response.data));
  } catch (err) {
    res.send("Error: " + err.message);
  }
});

app.listen(PORT, () => {
  console.log(`Frontend running on http://localhost:${PORT}`);
});
