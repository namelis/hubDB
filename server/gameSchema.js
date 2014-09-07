var mongoose = require('mongoose') , Schema = mongoose.Schema;




//////////////////////////////////////////////////////
///////////add schemas here///////////////////////////
//////////////////////////////////////////////////////

var player = new Schema({
    name: String,
    secret: String,
    win: {type: Number, default: 0},
    loss: {type: Number, default: 0},
    rank: {type: Number, default: 1},
    progress: {type: Number, default: 0},
    twitter: Schema.ObjectId,
    facebook: Schema.ObjectId,
    gameCenter: Schema.ObjectId,
    pwd: {type: String, default:''},
    lastLogin: {type: Date, default: Date.now()},
    gameState: String// json encoded lua table 
    //may want to break gameState into smaller json strings 
    //add remove rename fields as nessairy useing syntax below 
    //key: type,  key: {options}
    //checkout the site listed below if you want to learn more about avalable options and types or just schema definition in general
    //http://mongoosejs.com/docs/guide.html
  
}) 
//TODO move pwd to its own schema more secure that way 

var twitter = new Schema({
  //TODO define this Schema
  playerID: Schema.ObjectId
})


var facebook = new Schema({
  //TODO define this Schema
  playerID: Schema.ObjectId
})

var gameCenter = new Schema({
  //TODO define this Schema
  playerID: Schema.ObjectId
})



//////////////////////////////////////////////////////
///////////////expose schemas here////////////////////
//////////////////////////////////////////////////////
var expose = {};


expose.player = player;
expose.twitter = twitter;
expose.facebook = facebook;
expose.gameCenter = gameCenter;





exports.expose = expose;