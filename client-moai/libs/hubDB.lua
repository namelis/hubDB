hubDB = {} 


function printTable(table)
  for k,v in pairs (table) do
    if type(v) == type({}) then
      print(k .. ' is a table with this')
      printTable(v)
      print('end of ' .. k)
    else
      print(k,v)
    end
  end
end


require("libs/noobhub")
require("libs/sendDB")
require("libs/recieveDB")
math.randomseed(os.time())-- hopefully will keep too meny identical tempID from hitting the server at once 
tempID = math.random(9999)
local function config (server,port)
  local self = {}
  self.subscriptionArgs = {
    channel = "databaseChannel",
  }
  self.hub =  noobhub.new({ server = server, port = port })
  self.tasks = 0
  self.active = false
  self.recieve = recieveDB
  self.sendDB = sendDB
  function self.subscriptionArgs.callback(message)
    if type(message) == type({}) then
      if( message.id == links.id and message.name == links.name) or (message.id == tempID and message.name == links.name) then-- message was probobly for us so we have to do something with it
	for i,v in ipairs(self.recieve) do 
	  if message.action == v.action then
	    v.content(message)
	    break
	  end
	end
      end
    end    
  end
  
  function self:setLinks()
    links = self.links 
    links.tempID = tempID
    recieveDB.links = self.links
    sendDB.links = self.links
    recieveDB:setLinks()
    sendDB:setLinks()
  end
  
  
  function self:subscribe()
    self.active = self.hub:subscribe(self.subscriptionArgs)
    if not self.active then 
      print('subscription failed try again')
    end
  end
  function self:send(action)
    local count = 0
    while not self.active do
      self:subscribe()
      count = count +1
      if count > 7 then
	count = nil
	print('some kind of connection problem')
	break
      end
    end
    if count then
      local message,tasks = self.sendDB[action]()
      self.hub:publish({message = message})
      if tasks then
	self.tasks = self.tasks + tasks
      end
      self:unsubscribe()
    end
  end
  function self:unsubscribe()
    if self.tasks <= 0 then 
      self.hub:unsubscribe()
      self.active = false
    end
  end
  return self
end

hubDB.new = config