local FOMDSoftProtoPtr = {
  __index = FOMDSoftProtoPtr
}

function FOMDSoftProtoPtr.construct(fguid)
  local self = setmetatable({}, FOMDSoftProtoPtr)
  self.Guid = fguid

  return self
end

return FOMDSoftProtoPtr
