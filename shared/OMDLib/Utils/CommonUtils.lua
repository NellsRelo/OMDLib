Utils = {}

--- Print the size of a given value
--- @param ... any
function Utils.printSize(...)
  print(tostring(#...))
end

--- Print a given value as a string.
--- @param ... any
function Utils.printString(...)
  print(tostring(...))
end

--- Retrieve Full Name of supplied userdata
--- @param userdata userdata
--- @return string Full UE name value of given userdata
function Utils.getFullName(userdata)
  return userdata:getFullName()
end

-- Get All Actors of a Specified Class. Note, this gets all actors of a given class
-- within the level. This _may_ stall the game momentarilly.
---@param WorldContextObject userdata Provided World - typically retrieved from `UEHelpers.GetWorld()`
---@param Class string String representation of Class (e.g. `"/Script/Engine.Default__InputSettings"`)
---@param OutArray table Table to return. Defaults to empty table if not supplied.
---@return any
function Utils.GetAllActorsOfClass(WorldContextObject, Class, OutArray)
  OutArray = OutArray or {}
  local ClassVal = StaticFindObject(Class)
  UEHelpers.GetGameplayStatics():GetAllActorsOfClass(WorldContextObject, ClassVal, OutArray)

  return OutArray
end

return Utils
