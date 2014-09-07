 
module ( "layerFunctions", package.seeall )

layerFunctions = {}

function config(viewport)
  local self = {}
  self.viewport = viewport 
  self.layer = {}
  self.layerGroup = {}
  self.renderTable = {}
  
  function self:changeLayerGroup (groupName)--(string)
    self.layerGroup.current = groupName
    self.renderTable[1] =  self.layerGroup[groupName]
  end
  function self:addLayerGroup(layers,groupName)--(table,string)
    self.layerGroup[groupName] = layers
  end
  
  function self:newLayer(name,numColums,numRows,screenWidth,screenHeight)--(string,number,number,number,number)
    local rightEdgeOFScreen,bottomEdgeOfScreen,leftEdgeOfScreen,topEdgeOfScreen = 0 + screenWidth*.5,0 - screenHeight*.5 ,0 - screenWidth*.5 , 0 + screenHeight*.5
    local table = {}
    
   
    table.value = MOAILayer2D.new()
    table.value:setViewport(self.viewport)
    table.columUnit = screenWidth/numColums
    table.rowUnit = screenHeight/numRows
    table.numColums = numColums
    table.numRows = numRows
    table.leftEdgeOfScreen =  leftEdgeOfScreen
    table.topEdgeOfScreen = topEdgeOfScreen
    table.rightEdgeOFScreen = rightEdgeOFScreen
    table.bottomEdgeOfScreen =  bottomEdgeOfScreen
    table.map,table.key = makeGrid(numColums,numRows,table.columUnit,table.rowUnit,rightEdgeOFScreen,bottomEdgeOfScreen,leftEdgeOfScreen,topEdgeOfScreen)
  
    
    
    self.layer[name] = table
  end
  
  function self:getxyValuesFromBlockNum(layer,blocknum) -- (table,number)
    local returnThis = layer.map[layer.key[blocknum].colum][layer.key[blocknum].row][self.layer.direction]
    return returnThis.x,returnThis.y
  end
  
  function self:getxyValuesFromGridCoordinates(layer,colum,row) --table,number,number
    local returnThis = layer.map[colum][row][self.layer.direction]
    return returnThis.x,returnThis.y
  end
  
  function self:newPropImage(layerName,propName,spriteName,x,y,propGroupName)-- (string,(string/number),MOAIGfxQuad2D,number,number,string) propGroupName is optional table with name must allready exist)
    local newProp = MOAIProp2D.new()
    local layer = self.layer[layerName]
    newProp:setDeck(layer[spriteName])
    newProp:setLoc(x,y)
    layer.value:insertProp(newProp)
    if propGroupName then
      self.layer[layerName][propGroupName][propName] = newProp
    else
      self.layer[layerName][propName] = newProp
    end
  end
  
  function self:newSprite(layerName,sprName,texture,numColums,numRows)--(string,string,MOAIImage,number,number)
    local layer = self.layer[layerName]
    local newSprite = MOAIGfxQuad2D.new()
    newSprite:setTexture(texture)
    newSprite:setRect(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
    layer[sprName] = newSprite
  end
  
  function self:turnXYValuesIntoLocation(c,r,layer)--(number,number,table)
    local colum,row
    local test = 1
    while not (colum and row) do
      if c/layer.columUnit <= test and not colum then colum = test end
      if r/layer.rowUnit <=test and not row then row = test end
      test = test +1
    end
    if inverted then
      colum = layer.numColums +1 -colum
      row  = layer.numRows +1 -row
    end
    return colum,row
  end
  return self
end

layerFunctions.new = config


 

-----------------V-need to be converted-V---------
    






------------^-need to be converted-^---------------------


  
---------V----converted--V-----------------------  

function turnXYValuesIntoLocation(c,r,layer)
  local colum, row
  local test = 1
  while not (colum and row)  do
    if c/layer.columUnit <=test and not colum then colum = test  end
    if r/layer.rowUnit <=test and not row then row = test end
    test = test + 1
  end
  if inverted then
    colum = 15-colum
    row = 9-row
  end
  print('grid was selected at    colum: '..colum, 'row: '..row)
  return colum, row
end



function newSprite (layer,sprName,texture,numColums,numRows)   -- (table,string,MOAIImage,number,number) returns layer
  local newSprite = MOAIGfxQuad2D.new()
  newSprite:setTexture(texture)
  newSprite:setRect(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  print("0,0,numColums*layer.columUnit,numRows*layer.rowUnit")
  print(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  layer[sprName] = newSprite
  return layer  
end         

function getxyValuesFromGridCoordinates(layerTable,layerName,colum,row)
  print(layerTable,layerName,colum,row)
  local returnThis = layerTable[layerName].map[colum][row][layerTable.direction]
  return returnThis.x,returnThis.y
end

function getxyValuesFromBlockNum(layerTable,layerName,blocknum)
   local returnThis = layerTable[layerName].map[layerTable[layerName].key[blocknum].colum][layerTable[layerName].key[blocknum].row][layerTable.direction] 
  return returnThis.x,returnThis.y
end
  
function addLayerGroup(layerGroup, layers, groupName)--(table, table, string)
  layerGroup[groupName] = layers
  return layerGroup
end
 


function newLayer( layerTable,name,numColums,numRows,screenWidth,screenHeight)--(table,string,number,number,number,number)
  local rightEdgeOFScreen,bottomEdgeOfScreen,leftEdgeOfScreen,topEdgeOfScreen = 0 + screenWidth*.5,0 - screenHeight*.5 ,0 - screenWidth*.5 , 0 + screenHeight*.5
  layerTable[name] = {
                      numberOfProps = 0,
		      textboxPropList = {},
		      imagePropList = {},
                     }
  layerTable[name].value = MOAILayer2D.new()
  layerTable[name].value:setViewport(layerTable.viewport)
  layerTable[name].columUnit = screenWidth/numColums
  layerTable[name].rowUnit = screenHeight/numRows
  layerTable[name].numColums = numColums
  layerTable[name].numRows = numRows
  layerTable[name].leftEdgeOfScreen =  leftEdgeOfScreen
  layerTable[name].topEdgeOfScreen = topEdgeOfScreen
  layerTable[name].rightEdgeOFScreen = rightEdgeOFScreen
  layerTable[name].bottomEdgeOfScreen =  bottomEdgeOfScreen
  layerTable[name].map,layerTable[name].key = makeGrid(numColums,numRows,layerTable[name].columUnit,layerTable[name].rowUnit,rightEdgeOFScreen,bottomEdgeOfScreen,leftEdgeOfScreen,topEdgeOfScreen)
  
  return layerTable
end--[[this function expcts a table that contains a viewport as the first agrument 
       it adds a table to this table with a key of the seccond argument that will hold all info about layer
  --]]--viewport is assumed to be same size as screen so far i have not looked into scrolling in a world bigger then screen

  

function newPropImage(layer,propName,spriteName,x,y,propGroupName)  --(table,string,MOAIGfxQuad2D,number,number,string) propGroupName is optional table with name must allready exist
  local newProp = MOAIProp2D.new()
  newProp:setDeck(layer[spriteName])
  newProp:setLoc(x,y)  
  layer.value:insertProp(newProp)
  if propGroupName then
    layer[propGroupName][propName] = newProp
  else
    layer[propName] = newProp
  end
  return  layer
end--TODO alter this so propGroup works as an array 



----------^end converted^---------------------------------------------------------------------------------------------------------------------------------







function makeGrid(numColums,numRows,columUnit,rowUnit,rightEdgeOFScreen,bottomEdgeOfScreen,leftEdgeOfScreen,topEdgeOfScreen) --(number,number,number,number)
  local map, key = {},{}
  local num = 0
  for c = 1,numColums do
    map[c] = {}
    for r = 1, numRows do 
      num = num +1
      map[c][r] = {inverted  = {
	                        x = rightEdgeOFScreen-((c-1)*columUnit),
                                y = bottomEdgeOfScreen+(r*rowUnit),
                               },
		   standard = {
		                x = leftEdgeOfScreen+((c-1)*columUnit),
                                y = topEdgeOfScreen-(r*rowUnit),
		               },
	           number = num,
		  }
      key[num] = {colum = c,
	          row = r,
                  }
    end
  end  
  return map,key
  
  --[[
  
      map[c][r] = {inverted  = {
	                        x = (rightEdgeOFScreen-((c-1)*columUnit))+columUnit*.5,
                                y = (bottomEdgeOfScreen+(r*rowUnit))-rowUnit*.5,
                               },
		   standard = {
		                x = (leftEdgeOfScreen+((c-1)*columUnit))-columUnit*.5,
                                y = (topEdgeOfScreen-(r*rowUnit))+rowUnit*.5,
		               },
  --]]
end--[[this function makes a grid with number of colums and rows passed to it then returns 2 tables 
  the first table is an index of colums each of which is a table containing an index of rows each of which is a table containing number which is a number value for this block in grid also
  inverted and standard each of which are a table containing x,y locations to place props in center of block in grid 
  
  the second table is a index of block numbers in grid that each hold a table with colum, row values for that block
  --]]
  --TODO add a function somewhere that makes a MOAIEaseDriver for all props in layer and rotates them
  --TODO redo math so that props are centered so they can rotate without moving location
  
  





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



    
 
  

--[[ works if grid with 4 colums and 2 rows doesnot work with a grid with 3 colums and 4 rows so its back to the slower way
function turnXYValuesIntoLocation(x,y,layer)-- (number,number,table)
  print('turnXYValuesIntoLocation')
  print(layer.leftEdgeOfScreen,layer.topEdgeOfScreen,'layer.leftEdgeOfScreen,layer.topEdgeOfScreen')
  print(layer.columUnit,layer.rowUnit,'columUnit,rowUnit')
  print(x,y)
  if inverted then 
    print('inverted')
    x,y = layer.rightEdgeOFScreen+x,layer.bottomEdgeOfScreen-y
    x,y = x/layer.columUnit,y/layer.rowUnit
    x=x+1
  else
    print('not inverted')
    x,y = layer.leftEdgeOfScreen-x,layer.topEdgeOfScreen+y
    x,y = x/layer.columUnit,y/layer.rowUnit
    x = x+1
  end
  x = math.floor(math.abs(x))
  y = math.floor(y)
  print(x,y)
  print('end of turnXYValuesIntoLocation')
  return x,y   --actualy colum,row but why make an extra variable
end
--]]

function newSprite (layer,sprName,texture,numColums,numRows)   -- (table,string,MOAIImage,number,number) returns layer
  local newSprite = MOAIGfxQuad2D.new()
  newSprite:setTexture(texture)
  newSprite:setRect(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  print("0,0,numColums*layer.columUnit,numRows*layer.rowUnit")
  print(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  layer[sprName] = newSprite
  return layer  
end             

function turnXYValuesIntoLocation(c,r,layer)
  local colum, row
  local test = 1
  while not (colum and row)  do
    if c/layer.columUnit <=test and not colum then colum = test  end
    if r/layer.rowUnit <=test and not row then row = test end
    test = test + 1
  end
  if inverted then
    colum = 15-colum
    row = 9-row
  end
  print('grid was selected at    colum: '..colum, 'row: '..row)
  return colum, row
end


function newSprite (layer,sprName,texture,numColums,numRows)   -- (table,string,MOAIImage,number,number) returns layer
  local newSprite = MOAIGfxQuad2D.new()
  newSprite:setTexture(texture)
  newSprite:setRect(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  print("0,0,numColums*layer.columUnit,numRows*layer.rowUnit")
  print(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  layer[sprName] = newSprite
  return layer  
end             

function turnXYValuesIntoLocation(c,r,layer)
  local colum, row
  local test = 1
  while not (colum and row)  do
    if c/layer.columUnit <=test and not colum then colum = test  end
    if r/layer.rowUnit <=test and not row then row = test end
    test = test + 1
  end
  if inverted then
    colum = 15-colum
    row = 9-row
  end
  print('grid was selected at    colum: '..colum, 'row: '..row)
  return colum, row
end


function newSprite (layer,sprName,texture,numColums,numRows)   -- (table,string,MOAIImage,number,number) returns layer
  local newSprite = MOAIGfxQuad2D.new()
  newSprite:setTexture(texture)
  newSprite:setRect(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  print("0,0,numColums*layer.columUnit,numRows*layer.rowUnit")
  print(0,0,numColums*layer.columUnit,numRows*layer.rowUnit)
  layer[sprName] = newSprite
  return layer  
end             

function turnXYValuesIntoLocation(c,r,layer)
  local colum, row
  local test = 1
  while not (colum and row)  do
    if c/layer.columUnit <=test and not colum then colum = test  end
    if r/layer.rowUnit <=test and not row then row = test end
    test = test + 1
  end
  if inverted then
    colum = 15-colum
    row = 9-row
  end
  print('grid was selected at    colum: '..colum, 'row: '..row)
  return colum, row
end
