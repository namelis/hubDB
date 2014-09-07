
var dmf = require('./database.minipulation.functions.js').exportThis;
var noobhub = require('./client.js').noobhub;
var configDefMod = require('./config.js').clientJs;
///////////////////////////////////////////////////////////////////////////////
/////this function will process all the messages coming in threw noobhub///////
///////////////////////////////////////////////////////////////////////////////
var handleMessage = function(data){
  if (typeof data == "string"){
    console.log(data)
    var message = JSON.parse(data);
  }
  else
    var message = data;
 
  switch(message.action){
    case 'win':
      dmf.youWin(message);
      break;
    case 'loose':
      dmf.youLoose(message);
      break;
    case 'login':
      dmf.getNewCookie (message);
      break;
    case 'newPlayer':
      dmf.addPlayer(message);
      break;
    case 'getData':
      dmf.getGameData(message);
      break;
    
  }
   
};
//////////////////////////////////////////////////////////////////////////
///////everything below this shuld not need to be changed/////////////////
//////////////////////////////////////////////////////////////////////////

var db = dmf.db
db.on('error', console.error.bind(console, 'connection error:'));

db.once('open', function callback () {  //this will connect to our database and then everything else must go in this code block or it wont have database access
noobhub.subscribe(
    configDefMod
    , function(s){
        console.log('subscribed callback');
			
		noobhub.publish({ action : 'serverRestart'}, function(){
			console.log("data sent");
		});
		
    }    
    , function(data) {
	handleMessage(data) 
    },
	function(err) {
		console.log("error callback : " + err)
	}
);


});
/*all we did was open connection to database then subscribe to noobhub
 *everytime a message comes in it gets sent to handleMessage function 
 *where message.action is tested if the string matches one of the cases then 
 *a function from database.minipulation.functions.js gets called 
 *at the end of that function chain noobhub's publish function should be called with a response
 */