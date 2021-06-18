const mongoose = require("mongoose");
var Bet = require("../Models/Bet");




module.exports = function(app, obj) {
  app.get("/", function(req, res) {
    res.render("master", {config: obj});
  });
}