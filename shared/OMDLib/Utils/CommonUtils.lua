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

local function to_binary(integer)
  local remaining = tonumber(integer)
  local bin_bits = ''

  for i = 7, 0, -1 do
    local current_power = 2 ^ i

    if remaining >= current_power then
      bin_bits = bin_bits .. '1'
      remaining = remaining - current_power
    else
      bin_bits = bin_bits .. '0'
    end
  end

  return bin_bits
end

function from_binary(bin_bits)
  return tonumber(bin_bits, 2)
end
function Utils.from_base64(to_decode)
  local index_table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

  local padded = to_decode:gsub("%s", "")
  local unpadded = padded:gsub("=", "")
  local bit_pattern = ''
  local decoded = ''

  for i = 1, string.len(unpadded) do
    local char = string.sub(to_decode, i, i)
    local offset, _ = string.find(index_table, char)
    if offset == nil then
      error("Invalid character '" .. char .. "' found.")
    end

    bit_pattern = bit_pattern .. string.sub(to_binary(offset - 1), 3)
  end

  for i = 1, string.len(bit_pattern), 8 do
    local byte = string.sub(bit_pattern, i, i + 7)
    decoded = decoded .. string.char(from_binary(byte))
  end

  local padding_length = padded:len() - unpadded:len()

  if (padding_length == 1 or padding_length == 2) then
    decoded = decoded:sub(1, -2)
  end
  return decoded
end

return Utils
