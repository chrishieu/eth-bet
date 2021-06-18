const express  = require("express");
const app = express();
app.set("view engine", "ejs");
app.set("views", "./Views");
app.use(express.static("Public"));


var fs = require("fs");
var server = require("http").Server(app);

var io = require("socket.io")(server);
server.listen(80);


var bodyParser  = require("body-parser");
app.use(bodyParser.urlencoded({extended: true}));


const mongoose = require('mongoose');



mongoose.connect('mongodb+srv://vote2021:T48YQloUE69stHjK@cluster0.9t1xi.mongodb.net/myFirstDatabase?retryWrites=true&w=majority', {useNewUrlParser: true, useUnifiedTopology: true}, function(err) {
  if(err) console.log('Error Mongo');
  else console.log('Success')
});


loadConfig("./Config.json")

function loadConfig (file) {
  var objJson;
  fs.readFile(file, 'utf8', function(err, data) {
    if(err) throw err;
    objJson = JSON.parse(data);
    require("./Controllers/Clients")(app, objJson);
  });
}