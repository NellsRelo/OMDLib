FGuid = require("OMDLib.Types.FGuid")

local FOMDSoftProtoPtr = {
  __index = FOMDSoftProtoPtr
}

--- Construct an FOMDSoftProtoPtr with an FGuid struct
--- @param fguid FGuid Struct containing GUID values
--- @return FOMDSoftProtoPtr
function FOMDSoftProtoPtr.construct(fguid)
  local self = setmetatable({}, FOMDSoftProtoPtr)
  self.Guid = fguid

  return self
end

--- Translate an OMDSoftProtoPtr from Userdata to Struct
--- @param pointer userdata OMDSoftProtoPtr returned from the game
--- @return FOMDSoftProtoPtr Struct to work with
function FOMDSoftProtoPtr.UserdataToStruct(pointer)
  local self = setmetatable({}, FOMDSoftProtoPtr)
  -- @class FGuid
  local guid = FGuid.construct(
    pointer.Guid.A,
    pointer.Guid.B,
    pointer.Guid.C,
    pointer.Guid.D
  )

  self = FOMDSoftProtoPtr.construct(guid)

  return self
end

return FOMDSoftProtoPtr
