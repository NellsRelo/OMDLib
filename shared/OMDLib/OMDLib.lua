local UEHelpers = require("UEHelpers")
local OMDLib = {}
OMDLib.Utils = require("OMDLib.Utils._init")
OMDLib.Type = require("OMDLib.Types._init")

-- Version 1 does not exist, we start at version 2 because the original version didn't have a version at all.
local Version = 1

-- Functions local to this module, do not attempt to use!
local CacheDefaultObject = nil

-- Everything in this section can be used in any mod that requires this module.
-- Exported functions -> START

-- Local Functions
-- Copied from UEHelpers
local CacheDefaultObject = function(ObjectFullName, VariableName, ForceInvalidateCache)
  local DefaultObject

  if not ForceInvalidateCache then
    DefaultObject = ModRef:GetSharedVariable(VariableName)
    if DefaultObject and DefaultObject:IsValid() then return DefaultObject end
  end

  DefaultObject = StaticFindObject(ObjectFullName)
  ModRef:SetSharedVariable(VariableName, DefaultObject)
  if not DefaultObject:IsValid() then error(string.format("%s not found", ObjectFullName)) end

  return DefaultObject
end
local function findInstanceOf(class)
  local instances = FindAllOf(class)
  if not instances then return print("No " .. class .. "s found\n") end
  for _, v in pairs(instances or {}) do
    if v:IsValid() then
      return v
    else
      error("No " .. class .. "found")
    end
  end
end

--- Returns the current version of OMDLib
--- @return integer Version
function OMDLib.GetUEHelpersVersion()
  return Version
end

--- Change the user's Leaderboard Opt-out setting, for use when
--- it's dangerous to have scoring enabled (i.e. when cheating)
---@param optedOut boolean Whether the user should be opted out or not. Defaults to `true`.
function OMDLib.SafeScoring(optedOut)
  optedOut = optedOut or true
  OMDLib.GetGameUserSettings():SetLeaderboardOptOut(optedOut)
end

function OMDLib.GetGameUserSettings()
  return findInstanceOf("GameUserSettings")
end

function OMDLib.GetGameState()
  return findInstanceOf("GameState")
end

function OMDLib.GetCheatManager()
  return findInstanceOf("CheatManager")
end

function OMDLib.GetCharacter()
  return findInstanceOf("Character")
end

function OMDLib.GetGameInstance()
  return findInstanceOf("GameInstance")
end

function OMDLib.GetInventory(ForceInvalidateCache)
  return CacheDefaultObject(
    "/Script/OMD.OMDInventory",
    "OMDLib_OMDInventory",
    ForceInvalidateCache
  )
end

function OMDLib.GetProtoBpLibrary(ForceInvalidateCache)
  return CacheDefaultObject(
    "/Script/OMD.Default__OMDProtoBlueprintLibrary",
    "OMDLib_OMDProtoBlueprintLibrary",
    ForceInvalidateCache
  )
end

function OMDLib.GetSaveGameBpLibrary(ForceInvalidateCache)
  return CacheDefaultObject(
    "/Script/OMD.OMDSaveGameBlueprintLibrary",
    "OMDLib_OMDSaveGameBlueprintLibrary",
    ForceInvalidateCache
  )
end

function OMDLib.GetSaveGame()
  return findInstanceOf("SaveGame")
end

--- Retrieve the active instance of OMDPlayerHUDWidget
--- @return userdata|nil
function OMDLib.GetPlayerHUDWidget()
  return findInstanceOf("OMDPlayerHUDWidget")
end

function OMDLib.GetSpellbookUMG(ForceInvalidateCache)
  return findInstanceOf("Spellbook_UMG")
end

function OMDLib.GetRandomModeUMG(ForceInvalidateCache)
  return findInstanceOf("RandomMode_UMG")
end

function OMDLib.GetRandomModeProtos()
  return findInstanceOf("OMDRandomModeBucketProto")
end

OMDLib.KeyBinds = {}

--- Register OMDLib's KeyBind dictionary based on a supplied TArray.
--- Defaults to the existing KeyMappings, but supports supplying a
--- TArray for hooking into the `SetSavedKeyMappings` function.
--- @param keyMappings TArray<FOMDKeyMapping> Array of Key Mappings
function OMDLib.RegisterKeyBinds(keyMappings)
  keyMappings = keyMapping or OMDLib.GetSaveGame().SavedKeyMappings
  keyMappings:ForEach(function(_, keyMapping)
    local action = keyMapping:get().ActionName:ToString()
    local key = keyMapping:get().KeyName:ToString()

    if OMDLib.KeyBinds[action] == nil then OMDLib.KeyBinds[action] = {} end
    table.insert(OMDLib.KeyBinds[action], key)
  end)
end

return OMDLib
