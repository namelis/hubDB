 
env = MOAIEnvironment
function loadTexture (texture, name, fileName)--(table,string,string)
  texture[name] = MOAIImage.new()   --copys to video memory use most of time
  texture[name]:load(fileName)
  return texture
end
texture = {}-- to fill use --texture = loadTexture(texture, '', .png)

texture = loadTexture(texture, 'blue', 'blue.png')
texture = loadTexture(texture, 'brown', 'brown.png')
texture = loadTexture(texture, 'ltPurple', 'ltPurple.png')
texture = loadTexture(texture, 'green', 'green.png')
texture = loadTexture(texture, 'orange', 'orange.png')
texture = loadTexture(texture, 'pink', 'pink.png')
texture = loadTexture(texture, 'purple', 'purple.png')
texture = loadTexture(texture, 'red', 'red.png')
texture = loadTexture(texture, 'teal', 'teal.png')
texture = loadTexture(texture, 'yellow', 'yellow.png')
texture = loadTexture(texture, 'yg', 'yg.png')


if MOAIEnvironment.verticalResolution then
  if MOAIEnvironment.verticalResolution > MOAIEnvironment.horizontalResolution then
    screenWidth = MOAIEnvironment.verticalResolution
    screenHeight = MOAIEnvironment.horizontalResolution
  else 
    screenHeight = MOAIEnvironment.verticalResolution
    screenWidth = MOAIEnvironment.horizontalResolution
  end
end
  
 
if screenWidth == nil then screenWidth = 1138 end
if screenHeight == nil then screenHeight = 640 end
MOAISim.openWindow('test',screenWidth,screenHeight)
viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)

require "libs/saveFunctions"


function onReturn ()
      if env.osBrand == 'Android' then
	local newText =  MOAIKeyboardAndroid.getText () 
	if kbdText then
	  layer[kbdText.layerName][kbdText.boxName].text = newText
	  kbdBox:setString(newText)
	end
      end
end
function kbdClear ()
  if env.osBrand == 'Android' then
    MOAIKeyboardAndroid.setText('')
  end
end

function keyboard (box,text,layerName,boxName)  
  if env.osBrand == 'Android' then
    if box then
      MOAIKeyboardAndroid.setText(text) 
      kbdBox = box
      kbdText = {layerName = layerName,boxName = boxName}
      MOAIKeyboardAndroid.showKeyboard()
    else
      MOAIKeyboardAndroid.setText('') 
      kbdBox = layer.main.chat
      kbdText = nil
      MOAIKeyboardAndroid.showKeyboard()
    end
  end
end
    


  
  require "libs/layerFunctions"
  
 charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'


font = MOAIFont.new ()
font:loadFromTTF ( 'arial-rounded.TTF', charcodes, 7.5, 163 )

function addTextbox (text,xmin,ymin,xmax,ymax, alignment, layer)

	local textbox = MOAITextBox.new ()
	textbox:setString ( text )
	textbox:setFont ( font )
	textbox:setTextSize ( 7.5, 163 )
	textbox:setRect (xmin,ymin,xmax,ymax)
	textbox:setAlignment ( alignment )
	textbox:setYFlip ( true )
	layer:insertProp ( textbox )
	return textbox
end

 
function addImputbox (initialText, alignment,layerName,colum,row,name, layerTable)
  layer[layerName][name] = {}
  layer[layerName][name].initialText = initialText
  layer[layerName][name].text = ''
  layer[layerName][name].box = addTextbox (initialText, 0,0,layer[layerName].columUnit,layer[layerName].rowUnit, alignment,layer[layerName].value )
  layer[layerName][name].box:setLoc(layerLib:getxyValuesFromGridCoordinates(layer[layerName],colum,row))
end



layerLib =  layerFunctions.config(viewport)

layer = layerLib.layer--shuld give me a refrence to the layer table in module so changes to one effect the outher not shure if i even need this dont fell like testing without it now
layer.direction = 'standard'
layerLib:newLayer('login',4,2,screenWidth,screenHeight)


addImputbox('enter name here', MOAITextBox.LEFT_JUSTIFY, 'login',1,1,'inputName', layer)
addImputbox('enter password here (optional nessairy if you want recovery options)', MOAITextBox.LEFT_JUSTIFY, 'login',4,1,'inputPassword', layer )
addImputbox('enter id if not a new user', MOAITextBox.LEFT_JUSTIFY, 'login',1,2,'inputID', layer )
addImputbox('this is extra', MOAITextBox.LEFT_JUSTIFY, 'login',4,2,'inputExtra' , layer)
layer.login.button = addTextbox('click here login/setup new user',0,0,layer.login.columUnit*2,layer.login.rowUnit*2, MOAITextBox.CENTER_JUSTIFY, layer.login.value)
layer.login.button:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'login',2,2))


layerLib:newLayer('loginBackground',4,2,screenWidth,screenHeight)

layerLib:newSprite('loginBackground','sprNameBgrnd',texture.blue,1,1)
layerLib:newSprite('loginBackground','sprIdBgrnd',texture.brown,1,1)
layerLib:newSprite('loginBackground','sprButtonBgrnd',texture.ltPurple,2,2)
layerLib:newSprite('loginBackground','sprPwdBgrnd',texture.green,1,1)
layerLib:newSprite('loginBackground','sprXtraBgrnd',texture.orange,1,1)

layerLib:newPropImage('loginBackground','nameBgrnd','sprNameBgrnd', layerLib:getxyValuesFromBlockNum(layer.loginBackground,1))
layerLib:newPropImage('loginBackground','idBgrnd','sprIdBgrnd', layerLib:getxyValuesFromBlockNum(layer.loginBackground,2))
layerLib:newPropImage('loginBackground','buttonBgrnd','sprButtonBgrnd', layerLib:getxyValuesFromBlockNum(layer.loginBackground,4))
layerLib:newPropImage('loginBackground','pwdBgrnd','sprPwdBgrnd', layerLib:getxyValuesFromBlockNum(layer.loginBackground,7))
layerLib:newPropImage('loginBackground','xtraBgrnd','sprXtraBgrnd', layerLib:getxyValuesFromBlockNum(layer.loginBackground,8))


layerLib:newLayer('mainBackground',3,4,screenWidth,screenHeight)



layerLib:newSprite ('mainBackground','sprNameBgrnd',texture.blue,1,1)   -- (table,string,MOAIImage,number,number) returns layer
layerLib:newSprite ('mainBackground','sprIdBgrnd',texture.brown,1,1) 
layerLib:newSprite ('mainBackground','sprRankBgrnd',texture.ltPurple,1,1) 
layerLib:newSprite ('mainBackground','sprProgressBgrnd',texture.green,1,1) 
layerLib:newSprite ('mainBackground','sprWinBgrnd',texture.orange,1,1)
layerLib:newSprite ('mainBackground','sprLossBgrnd',texture.pink,1,1)   
layerLib:newSprite ('mainBackground','sprLogoutBgrnd',texture.purple,1,2) 
layerLib:newSprite ('mainBackground','sprAddWin',texture.teal,1,2)  
layerLib:newSprite ('mainBackground','sprAddLoss',texture.yg,1,2)



layerLib:newPropImage('mainBackground','nameBgrnd','sprNameBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,1))--start
layerLib:newPropImage('mainBackground','idBgrnd','sprIdBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,2))
layerLib:newPropImage('mainBackground','rankBgrnd','sprRankBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,5))
layerLib:newPropImage('mainBackground','progressBgrnd','sprProgressBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,6))
layerLib:newPropImage('mainBackground','winBgrnd','sprWinBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,9))
layerLib:newPropImage('mainBackground','lossBgrnd','sprLossBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,10))
layerLib:newPropImage('mainBackground','logoutBgrnd','sprLogoutBgrnd', layerLib:getxyValuesFromBlockNum(layer.mainBackground,4))
layerLib:newPropImage('mainBackground','addWin','sprAddWin', layerLib:getxyValuesFromBlockNum(layer.mainBackground,8))
layerLib:newPropImage('mainBackground','addLoss','sprAddLoss', layerLib:getxyValuesFromBlockNum(layer.mainBackground,12))

layerLib:newLayer('main',3,4,screenWidth,screenHeight)


layer.main.name = addTextbox('name',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.name:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',1,1))
layer.main.id = addTextbox('id',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.id:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',1,2))
layer.main.rank = addTextbox('rank',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.rank:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',2,1))
layer.main.progress = addTextbox('progress',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.progress:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',2,2))
layer.main.win = addTextbox('win',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.win:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',3,1))
layer.main.loss = addTextbox('loss',0,0,layer.main.columUnit,layer.main.rowUnit, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.loss:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',3,2))
layer.main.logout = addTextbox('logout',0,0,layer.main.columUnit,layer.main.rowUnit*2, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.logout:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',1,4))
layer.main.addWin = addTextbox('addWin',0,0,layer.main.columUnit,layer.main.rowUnit*2, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.addWin:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',2,4))
layer.main.addLoss = addTextbox('addLoss',0,0,layer.main.columUnit,layer.main.rowUnit*2, MOAITextBox.CENTER_JUSTIFY, layer.main.value)
layer.main.addLoss:setLoc(layerFunctions.getxyValuesFromGridCoordinates(layer,'main',3,4))


layerGroup = layerLib.layerGroup


layerLib:addLayerGroup({[1] = layer.loginBackground.value, [2] = layer.login.value}, 'login')
layerLib:addLayerGroup({[1] = layer.mainBackground.value, [2] = layer.main.value}, 'main')

if env.osBrand == 'Android' then
  MOAIKeyboardAndroid.setListener ( MOAIKeyboardAndroid.EVENT_INPUT, onInput )
  MOAIKeyboardAndroid.setListener ( MOAIKeyboardAndroid.EVENT_RETURN, onReturn )
  --[[
else    
  layer.login.inputID.text = '53f625fa4c8a7df303664e8b'
  layer.login.inputName.text = 'tester'
  layer.login.inputPassword.text = 'this'
  layer.login.inputID.box:setString('53f625fa4c8a7df303664e8b')
  layer.login.inputName.box:setString('tester')
  layer.login.inputPassword.box:setString('this')
end--]]
---[[
else
  layer.login.inputID.text = '53ecf0ab4c8a7df303664e89'
  layer.login.inputName.text = 'test user 1st'
  layer.login.inputPassword.text = 'hi'
  layer.login.inputID.box:setString('53ecf0ab4c8a7df303664e89')
  layer.login.inputName.box:setString('test user 1st')
  layer.login.inputPassword.box:setString('hi')
end


-------------------------------------------------------------------------------------------------------------------
-------links table will make shure we have access to any variables we need in our send and recieve functions -------
---------------------so make shure you add them to links table then call :setLinks()--------------------------------
links = {
  layerLib = layerLib,
  layer = layer,
}
--------------------------------------------------------------------------------------------------------------

function updateNameAndId()
  if links.cookie then 
    links.name = links.cookie.name
    links.id = links.cookie.id
  else
    links.name = layer.login.inputName.text
    links.id = layer.login.inputID.text
  end
  layer.main.name:setString('name: ' .. tostring(links.name))
  layer.main.id:setString('id: ' .. tostring(links.id))
end


require('libs/hubDB')
database = hubDB.new("gameTest.namelis.us", 1337)

links.database = database
database.links = links
database:setLinks()-- now hubDB and more inportantly its send and recieve modules have a refrence to the links table so you can make changes to variables in main from ether

function links.getData()
  database:send('getData')
end
 
links.cookie =  saveFunctions.loadTable('cookie.dat')

cookie = links.cookie




renderTable = layerLib.renderTable

if links.cookie then 
  updateNameAndId()
  links.getData()
  layerLib:changeLayerGroup('main')
else
  layerLib:changeLayerGroup('login')
end


--renderTable[2] = layer.name.value
MOAIRenderMgr.setRenderTable(renderTable)





function getGridNumberMain(colum, row)
  local gridNumber 
  if (row == 1) or (row == 2) then
   gridNumber = 1
  elseif  colum == 1 then
    gridNumber = 4
  elseif colum == 2 then
    gridNumber = 8
  elseif colum == 3 then
    gridNumber = 12
  end
  return gridNumber    
end

function getGridNumberLogin  (colum,row)
  local selectionGrid
  if colum == 2 or colum == 3 then
     selectionGrid = 3
   elseif colum == 1 then
     if row == 1 then 
       selectionGrid = 1
     else 
       selectionGrid = 2
     end
   elseif colum == 4 then
     if row == 1 then
       selectionGrid = 7
     else
       selectionGrid = 8
     end
   end
  return selectionGrid
end





function loginOrNewUser()
  updateNameAndId()
  if  not(links.name == '') then-- if name is not blank then we will do something
    if id == '' then-- if id is blank we will make a new user
      links.id = tempID
      database:send('newUser')
    else-- if id is not blank we will try to log in 
      database:send('login')
    end
  end
end
    
function handleClickOrTouchLogin(x,y)
  local colum,row = layerFunctions.turnXYValuesIntoLocation(x,y,layer.login)
  local gridNumber = getGridNumberLogin(colum,row)
  if gridNumber == 1 then
    keyboard(layer.login.inputName.box,layer.login.inputName.text,'login','inputName')
  elseif gridNumber == 7 then
    keyboard(layer.login.inputPassword.box,layer.login.inputPassword.text,'login','inputPassword')
  elseif gridNumber == 2 then
    keyboard(layer.login.inputID.box,layer.login.inputID.text,'login','inputID')
  elseif gridNumber == 8 then
    keyboard(layer.login.inputExtra.box,layer.login.inputExtra.text,'login','inputExtra')
  elseif gridNumber == 3 then
    loginOrNewUser()    
  end
end




function logout()
  if saveFunctions.saveTable('cookie.dat', '', true) then
    links.cookie = nil--set cookie value to nil
    layerLib:changeLayerGroup('login')--switch to login layerGroup
    --database:subscribe()
  else
    print ('save cookie fail')
  end  --deleat cookie if sucessfull do nothing if not
end




function handleClickOrTouchMain(x,y)
  x,y = layerFunctions.turnXYValuesIntoLocation(x,y,layer.main)
  local gridNumber = getGridNumberMain(x,y)
  if gridNumber == 8 then
    database:send('addWin')
    database:send('getData')
  elseif gridNumber == 12 then
    database:send('addLoss')
    database:send('getData')
  else
    database:send('getData')
  end
    database:send('getData')
  if gridNumber == 4 then
    logout()
  end
end

if links.cookie then
  database:send('getData')
end

oncePerPress = true

function handleClickOrTouch(x,y)
  if oncePerPress then
    oncePerPress = false
    if layerGroup.current == 'main' then
      handleClickOrTouchMain(x,y)
    elseif layerGroup.current == 'login' then
      handleClickOrTouchLogin(x,y)
    end
  end
end


if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback(
        function(isMouseDown)
            if(isMouseDown) then
	      oncePerPress = true
	      handleClickOrTouch(MOAIInputMgr.device.pointer:getLoc())
	    end
            -- Do nothing on mouseUp
	    
        end
    )
    MOAIInputMgr.device.mouseRight:setCallback(
        function(isMouseDown)
            if(isMouseDown) then
            end
        end
    )
else
-- If it isn't a mouse, its a touch screen... or some really weird device.
    MOAIInputMgr.device.touch:setCallback (

        function ( eventType, idx, x, y, tapCount )
            if eventType == MOAITouchSensor.TOUCH_UP then
	      oncePerPress = true 
	    else
	      handleClickOrTouch(x,y)
	    end
	end
    )
end