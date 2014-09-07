 
recieveDB = {}
function recieveDB:setLinks()
  links = recieveDB.links
end
require "libs/saveFunctions"
  
function newUserSucess(message)   
  links.cookie = message.cookie
  links.name = links.cookie.name
  links.id = links.cookie.id
  if saveFunctions.saveTable('cookie.dat', links.cookie,true) then
    links.layerLib:changeLayerGroup('main')
    links.getData()
  else
    print ('save cookie fail')
  end
end
function loginSucess(message)   
  links.cookie = message.cookie
  links.name = links.cookie.name
  links.id = links.cookie.id
  if saveFunctions.saveTable('cookie.dat', links.cookie,true) then
    links.layerLib:changeLayerGroup('main')
    links.getData()
  else
    print ('save cookie fail')
  end
end
function winData(message)  
  if not (links.wins == message.data) then
    links.wins = message.data
    links.layer.main.win:setString('wins: ' .. tostring(links.wins))
    links.database.tasks = links.database.tasks-1
    links.database:unsubscribe()
  end
end
function lossData(message)   
  if not (links.loss == message.data) then
    links.loss = message.data
    links.layer.main.loss:setString('loss: ' .. tostring(links.loss))
    links.database.tasks = links.database.tasks-1
    links.database:unsubscribe()
  end
end
function rankData(message)   
  if not (links.rank == message.data) then
    links.rank = message.data
    links.layer.main.rank:setString('rank: ' .. tostring(links.rank))
    links.database.tasks = links.database.tasks-1
    links.database:unsubscribe()
  end
end
function progressData(message)   
  if not (links.progress == message.data) then
    links.progress = message.data
    links.layer.main.progress:setString('progress: ' .. tostring(links.progress))
    links.database.tasks = links.database.tasks-1
    links.database:unsubscribe()
  end
end


table.insert(recieveDB,{action = 'newUserSucess',content = newUserSucess})
table.insert(recieveDB,{action = 'loginSucess',content = loginSucess})
table.insert(recieveDB,{action = 'progressData',content = progressData})
table.insert(recieveDB,{action = 'rankData',content = rankData})
table.insert(recieveDB,{action = 'lossData',content = lossData})
table.insert(recieveDB,{action = 'winData',content = winData})


