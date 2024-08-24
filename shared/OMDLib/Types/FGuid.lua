local FGuid = {
  __index = FGuid
}

function FGuid.construct(A, B, C, D)
  local self = setmetatable({}, FGuid)
  self.A = A or 0
  self.B = B or 0
  self.C = C or 0
  self.D = D or 0

  return self
end

function FGuid.ToString(guidTable)
  local guidString = ""
  for _, guidChunk in pairs(guidTable) do
    guidString = guidString .. string.sub(string.format("%016x", guidChunk), -8)
  end

  return guidString
end

return FGuid
