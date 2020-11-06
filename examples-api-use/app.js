const fs = require('fs');
const express = require ("express");
const app = express();
var ip = require('ip');

app.use(express.json())

app.get("/", (req, res) => res.sendFile(`${__dirname}/index.html`))

app.get("/action_page", async (req, res) => {
    let json_store = {
	    ssid: req.query.ssid,
	    pass: req.query.pass,
	    curr_date: req.query.date,
	    curr_time: req.query.time,
	    msg: req.query.msg,
	    petrol_price: req.query.petrol,
	    diesel_price: req.query.diesel,
	    xml_price: req.query.xp,
    }
    let json_out = JSON.stringify(json_store);
    console.log(json_out)
    fs.writeFile("output_local_network.json", json_out, function(err) {
        if(err) {
            return console.log(err);
        }
        console.log("The file was saved!");
    });
    res.setHeader("content-type", "application/json")
    res.send(json_out)
})

app.get("/find_esp", async (req, res) => {
    var espRes = "ESP8266, "
    var ipAdd = ip.address()
    espRes = espRes + ipAdd
    res.setHeader("content-type", "text/html")
    res.send(espRes)
})

app.listen(80, () => console.log("Web server is listening.. on port 80"))
