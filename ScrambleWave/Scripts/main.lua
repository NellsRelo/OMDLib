local UEHelpers = require("UEHelpers")
local OMDLib = require("OMDLib")
IsInitialized = false

function Init()
  IsInitialized = true
end

Init()

-- Ensure Random Buff Choices are loaded before we try to create them
ExecuteInGameThread(function()
  LoadAsset("/Game/UI/Postgame/UBP_Postgame_C.UBP_Postgame_C")
  LoadAsset("/Game/UI/Postgame/UBP_Postgame_RandomModeBuffChoice.UBP_Postgame_RandomModeBuffChoice_C")
end)

RegisterKeyBind(Key.L, {}, function()
OMDLib.GetCheatManager():InfiniteRift()
end)

--- Create the Buff's UI Element and place it on the screen
--- @param modifierProto FOMDSoftProtoPtr Struct containing UUID of Modifier
--- @param xPos number X Position to place on the screen
--- @return UUBP_Postgame_RandomModeBuffChoice_C UI Buff choice element
function createModifier(modifierProto, xPos)
  -- @class UUBP_Postgame_RandomModeBuffChoice_C
  local modifier = StaticConstructObject(StaticFindObject("/Game/UI/Postgame/UBP_Postgame_RandomModeBuffChoice.UBP_Postgame_RandomModeBuffChoice_C"), OMDLib.GetGameInstance())
  if not modifier:IsValid() then
    print("Error creating modifier")
  else
    print("Modifier created")
  end
  
  local pos = UEHelpers.GetKismetMathLibrary():MakeVector2D(xPos, 500)
  modifier.OMDSoftProtoPtr = modifierProto
  modifier.OMDGameInstance = OMDLib.GetGameInstance()
  OMDLib.GetProtoBpLibrary():GetModifierProtodata(modifierProto, modifier.ModifierProto, {})
  -- print(#getModifierProto)
  -- print(#getModifierSuccess)
  print(tostring(OMDLib.Type.FGuid.ToString(modifierProto.Guid)))
  modifier:Setup(modifierProto, nil, nil)
  modifier:Construct()
  modifier:SetPositionInViewport(pos, true)
  modifier:AddToViewport(1)

  return modifier
end



local function RetrieveBuffPointers()
  local pointers = {}
  local buffChoices = OMDLib.GetSaveGame():GetBuffChoicesForTier(3, 3)

  for _, v in pairs(buffChoices) do
    table.insert(pointers, v:get())
  end

  return pointers
end
--- Testing capability to display Random Mode buffs outside of Random Mode
RegisterKeyBind(Key.K, {}, function()
  OMDLib.GetGameInstance():InitializeRandomMode()
  local xPos = 550
  local pointers = RetrieveBuffPointers()

  for _, v in pairs(pointers) do
    -- @class FGuid
    local guid = OMDLib.Type.FGuid.construct(
      v.Guid.A,
      v.Guid.B,
      v.Guid.C,
      v.Guid.D
    )

    -- @class FOMDSoftProtoPtr
    local OMDSoftProtoPtr = OMDLib.Type.FOMDSoftProtoPtr.construct(guid)
    createModifier(OMDSoftProtoPtr, xPos)
    xPos = xPos + 450
    --print(tostring(OMDLib.GetProtoBpLibrary():IsValid_OMDSoftProtoPtr(OMDSoftProtoPtr)))
  end

  -- local OMDSoftProtoPtr = {
  --   Guid = {}
  -- }
  -- local getModifierProto = {}
  -- local getModifierSuccess = {}

  -- OMDSoftProtoPtr.Guid.A = v:get().Guid.A or 0
  -- OMDSoftProtoPtr.Guid.B = v:get().Guid.B or 0
  -- OMDSoftProtoPtr.Guid.C = v:get().Guid.C or 0
  -- OMDSoftProtoPtr.Guid.D = v:get().Guid.D or 0
  -- --
    

  -- 
  -- for _,pval in pairs(getModifierProto) do
  --   print(tostring(pval))
  -- end
  -- 
end)
