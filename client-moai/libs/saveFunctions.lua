 







module ( "saveFunctions", package.seeall )



local env = MOAIEnvironment
local defultWorkingDir =  MOAIFileSystem.getWorkingDirectory ()


function dataDir()-- switches working directory to defult documentDirectory tested on android and linux
  if env.documentDirectory then
    MOAIFileSystem.setWorkingDirectory(env.documentDirectory)
  end
end
function startDir()-- switches back to the initial directory so moai can stil find assets included in initial install
  MOAIFileSystem.setWorkingDirectory(defultWorkingDir)
end


function saveTable(fileName, table, overwrite)-- (string, table, boolean) returns sucess (boolean)
  dataDir()
  local buffer = MOAIDataBuffer.new()
  if type(table) == type({}) then
    buffer:setString(MOAIJsonParser.encode (table))--[[  might not need this 
  else
    buffer:setString('')--]]
  end
  if MOAIFileSystem.checkFileExists(fileName) and not overwrite then
    startDir()
    return false
  else
    if buffer:save(fileName) then
      startDir()
      return true
    else
      startDir()
      return false
    end
  end
end--will save a json string of table to a file with name of fileName will not overwrite file so long as overwrite is nil or false

function loadTable (fileName)-- will take a file saved using above save table function and return the table saved or nil
  dataDir()
  local buffer = MOAIDataBuffer.new()
  local table
  if buffer:load(fileName) then
    table = MOAIJsonParser.decode(buffer:getString())
  end
  startDir()
  if table == '' then
    table = nil
  end
  return table
end

