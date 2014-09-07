# hubDB
*acess mongoDB from lua code
*easy to modify to meet your needs
*connects automaticaly
*disconnects automaticaly after recieveing expected number of responces

## how to use
### lua

first you need to update its send and recieve modules so they work with your code it should look something like this 


in a file called recieveDB.lua

'''lua
recieveDB = {}
function recieveDB:setLinks()
  links = recieveDB.links
end


function functionName(message) 
  --some code to process message here 
  --remember links.anyTableYouHaveInThisTableInYourMainCodeBlock gives access to data from main code block
  --you could even just call a function from a table of functions here so long as that table is in links table
end


table.insert(recieveDB,{action = 'actionThatThisFunctionIsDesignedToProcess',content = functionName})

'''

in a file called sendDB.lua

'''lua
sendDB  = {}
function sendDB:setLinks()
  links = sendDB.links
end

function sendActionName ()
  local number = 4
  if links.cookie then
    local message = {cookie = links.cookie,
		     action = 'sendActionName',
                     }
   return message, number  -- because number was 4 we expect 4 responses hubDB wont let us unsubscribe until we get them 
                           -- if number was nil hubDB would automaticaly unsubscribe after we send message to database
  end
end

sendDB.sendActionName = sendActionName
'''


once that is done in your main.lua you need something like this

```lua
links = {
  --this table shuld contain a refrence to all tables your send or recieve functions will need access to 
}

require('libs/hubDB')
database = hubDB.new("gameTest.namelis.us", 1337)

links.database = database
database.links = links
database:setLinks()-- now hubDB and more inportantly its send and recieve modules have a refrence to the links table so you can make changes to variables in main from ether

'''

now assuming that you have a function for each action that database side of this will send
in recieveDB table that part will be handeled automaticaly as long as you are subscribed
since you subscribe automaticaly when you send something to database and 
you can set the expected number of responses to wait for before unsubscribing in send function
hubDB checks to see if it can unsubscribe every time it gets a responce matching your name and id 

to send to database your code should look something like this

'''lua
database:send('sendActionName')
'''

### nodejs

from command line on your server enter each of the following lines
assuming you have nodejs and forever installed 

'''
git clone git://github.com/namelis/hubDB.git

cd hubDB/server

npm install

forever --spinSleepTime 10000 start noobHub.Server.js
forever --spinSleepTime 10000 start hubDB.sample.js 

'''



i will get around to writing more detail on this later 
for now i hope i have enough comments in my code to explain why it is how it is if something is unclear hopefully one of these resorces will be helpfull

* http://mongoosejs.com/docs/index.html
* your favorite javascript refrence there is hundrets of them on the net

## features to be added 
i will finish this later i have to go to work soon 
