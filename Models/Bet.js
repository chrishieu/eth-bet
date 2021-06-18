const mongoose = require("mongoose");
const betSchema = new mongoose.Schema({
  Address:String,
  Money:Number,
  Options:Number, // 1:Y, 0:N
  Prize: Number, // Tien thuong khi trung giai, default 0
  Status: Number, //0: wait result, 1: trung giai, -1: trat giai

});

module.exports = mongoose.model("Bet", betSchema);