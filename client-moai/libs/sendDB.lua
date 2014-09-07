sendDB  = {}
function sendDB:setLinks()
  links = sendDB.links
end

function newUser()
  local message = {}
  message.id = links.tempID
  message.name = links.name
  message.pwd = links.layer.login.inputPassword.text
  message.action = "newPlayer"
  return message,1-- we expect 1 response hubDB wont let us unsubscribe until we get them  
end

function login ()
  local message = {}
  message.id = links.id
  message.name = links.name
  message.cookie = {id = links.id, name = links.name, secret = links.layer.login.inputPassword.text}
  message.action = 'login'
  message.pwd = links.layer.login.inputPassword.text
  return message,1-- we expect 1 response hubDB wont let us unsubscribe until we get them  
end



function addWin()
  local message = {}
  message.id = links.id
  message.name = links.name
  message.cookie = links.cookie
  message.action = 'win'
  return message-- we expect no response so we only return message  
end

function addLoss()
  local message = {}
  message.id = links.id
  message.name = links.name
  message.cookie = links.cookie
  message.action = 'loose'
  return message-- we expect no response so we only return message
end

function getData ()
  if links.cookie then
    local message = {cookie = links.cookie,
		     action = 'getData',
                     }
   return message, 4  -- we expect 4 responses hubDB wont let us unsubscribe until we get them  
  end
end

sendDB.newUser = newUser
sendDB.login = login
sendDB.addWin = addWin
sendDB.addLoss = addLoss
sendDB.getData = getData


