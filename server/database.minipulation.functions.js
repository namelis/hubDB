/*
 * database stuff
 */
var randomString = require('random-string');
var databaseForMyGame = 'mongodb://localhost/gameTest'
var noobhub = require('./client.js').noobhub;
var dbUserName;//add here if your database requires this
var dbPassword;//add here if your database requires this
/*
 * since with this setup you never expose your database to anything but local connections 
 * if someone has gotten into your system to the point where they can access your database then 
 * they also have acess to this file so right here where you are telling your app how to login to your database 
 * you are also telling the person who has broken into your system how to login to your databse 
 * based on my research there is nothing anyone can do to stop a determined person with resources to burn from 
 * getting into any system all you can do is slow them down so you have time to find them and kick them back out
 * i dont have the time or resources to devote to monitoring a server on that level and if your using  this i doubt you do ether
 */

var options = {
  user: dbUserName,
  pass: dbPassword,
  server: { keepAlive: 1  }
}



var mongoose = require('mongoose') , Schema = mongoose.Schema;
mongoose.connect(databaseForMyGame,options);

var gameSchema = require('./gameSchema.js').expose;  //all schema from file can now be accessed by typeing gameSchema.nameOfSchema 

//////////////////////////////////////
////////define all models here////////
//////////////////////////////////////
var playerModel = mongoose.model('playerModel', gameSchema.player);
console.log('we have a model');










////////////////////////////////////////////////////////////////////////////////
////////this function will conferm cookie before makeing any changes to db//////
////////////////////////////////////////////////////////////////////////////////

var checkCookie = function(argObj, DBdata){
  var result = false;
  if ( (argObj.name == DBdata.name && argObj.secret == DBdata.secret) || (argObj.name == DBdata.name && argObj.secret == DBdata.pwd) ){//name and secret match or name and password match
    result = true; 
    DBdata.lastLogin = Date.now();
    DBdata.save(function(err, DBdata){
      if (err) return console.error(err);
      else console.log ('lastLogin updated');      
    });
  }
  var cookie = {};
  cookie.name = argObj.name;
  cookie.id = argObj.id;
  cookie.secret = DBdata.secret;
  if (result)
    return cookie;
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////this function lets us find a document and use it in a function we password to it as one of the arguments//////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var findDocumentAndUse = function(model, id, useResult, argumentObject){
  model.findOne ({_id: id}, function(err,result){
    if (err){
      var response = {};
      response.id = id;
      response.name = argumentObject.name;
      response.action = 'error';
      response.err = err;
      noobhub.publish(response);
      return console.error(err);      
    } 
    else{ 
      console.log ('we found ' + result);
      console.log('id = ' + id);
      //console.log('' + );
      var cookie = checkCookie(argumentObject.cookie, result);
      if (cookie){
	useResult(argumentObject,result);
      }
      else {
	var response = {};
	response.id = id;
	response.name = argumentObject.name;
	response.action = 'badCookie';
	noobhub.publish(response);
      }
      
    }
  });
}//since find does not return anything (mongoose seems to prefer callbacks) we have to pass refrence to function that will use document that matches id
///also this function will compare name and secret from cookie with name and secret or name and password from database before calling a function that will alter your database 
//in the event that nether match you get a response of badCookie



///////////////////////////////////////////////////////////////////////////
//////functions to be called by outher functions here  bottomLvl?/////////
/////////////////////////////////////////////////////////////////////////

var updateProgress =  function (argObj, DBdata){
  var currentRank = DBdata.rank;
  var currentProgress = DBdata.progress;
  var newProgress , newRank
  newProgress = currentProgress + argObj.amount
  switch(newProgress){
    case 4://increase rank
      newRank = currentRank + 1;
      newProgress = 1;
      break;
    case 0://decrease rank
      newRank = currentRank - 1;
      if (newRank)//in javascript 0 is equivalent to false so this will stop rank droping below 1 
	newProgress = 3;
      else 
	newProgress = 0;
  }
  DBdata.progress = newProgress;
  if (newRank){
    DBdata.rank = newRank;
  }
  DBdata.save(function(err, DBdata){
    if (err) return console.error(err);
    else{
      getData(argObj,DBdata);
    }
  });
}

var sendData = function (id, name, data, action){
  var response = {};
  response.id = id ;
  response.name = name ;
  response.data = data
  response.action = action
  noobhub.publish(response);
}










//////////////////////////////////////////////////////////////////////////////////
////////functions designed to be called by findDocumentAndUse here midLvl?///////
////////////////////////////////////////////////////////////////////////////////


var addWin = function (argObj, DBdata){
  DBdata.win++
  argObj.amount = 1
  updateProgress(argObj,DBdata)
}

var addLoss = function (argObj,DBdata){
  DBdata.loss++
  argObj.amount = -1
  updateProgress(argObj,DBdata)
}

var getData = function (argObj,DBdata){
  sendData (argObj.cookie.id, argObj.cookie.name, DBdata.win, 'winData')//send win data to player
  sendData (argObj.cookie.id, argObj.cookie.name, DBdata.loss, 'lossData')//send loss data to player
  sendData (argObj.cookie.id, argObj.cookie.name, DBdata.rank, 'rankData')//send rank data to player
  sendData (argObj.cookie.id, argObj.cookie.name, DBdata.progress, 'progressData')//send progress data to player
}

var login = function (argObj,DBdata){
  var result = false;
  if (argObj.name == DBdata.name && argObj.password == DBdata.password){
    result = true; 
    DBdata.secret = randomString();
    DBdata.lastLogin = Date.now();
    DBdata.save(function(err, DBdata){
      if (err) 
	return console.error(err);
      else 
	console.log ('lastLogin updated in login function');      
    });
  }
  var response = {};
  var cookie = {};
  if (result) {
    cookie.name = argObj.name;
    cookie.id = argObj.id;
    cookie.secret = DBdata.secret;
    response.action = 'loginSucess';
  }
  else
    response.action = 'loginFail';
  
  
  response.id = argObj.id;
  response.name = argObj.name;
  response.cookie = cookie;
  response.value = result;
  
  console.log(response)
  
  noobhub.publish(response);
}// this function enshures name and password match responds with a cookie if true and a response of loginFail if false
/// if true it updates lastLogin value on database and generates a new sectet for cookie 










///////////////////////////////////////////////////////////////////////////////////////////
///////define all top level functions here we are going to export them to our main/////////
///////////////////////////////////////////////////////////////////////////////////////////
var addPlayer = function(argObj){
  var name = argObj.name
  var newPlayer = new playerModel({name:name, secret:randomString(), pwd:argObj.pwd});
  
  newPlayer.save(function(err, newPlayer){
    if (err) return console.error(err);
    else console.log ('new player created');
  });
  
  var cookie = {};
  cookie.id = newPlayer._id;// let mongo created unique ids for us return it so we can send it to the player
  cookie.name = name;
  cookie.secret = newPlayer.secret;

  var response = {};
  response.id = argObj.id;
  response.name = name;
  response.cookie = cookie;
  response.action = 'newUserSucess';
  console.log(response);
  noobhub.publish(response);
}


var getNewCookie = function(argObj){
  findDocumentAndUse(playerModel, argObj.cookie.id, login, argObj)
}

var youWin = function (argObj){
  findDocumentAndUse(playerModel, argObj.cookie.id, addWin, argObj)
}
var youLoose = function (argObj){
  findDocumentAndUse(playerModel, argObj.cookie.id, addLoss, argObj)
}

var getGameData = function(argObj){
  findDocumentAndUse(playerModel, argObj.cookie.id, getData, argObj)
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////link toplevel functions to an object so we can export one thing and access all of them//////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
var exportThis = {};
exportThis.addPlayer = addPlayer;
exportThis.getNewCookie = getNewCookie;
exportThis.youWin = youWin;
exportThis.youLoose = youLoose;
exportThis.getGameData = getGameData;


//exportThis.functionName = functionName;
//if you add toplevel db functions expose them to your main program like above line


exportThis.db = mongoose.connection;//we need this in our main app

exports.exportThis = exportThis;


