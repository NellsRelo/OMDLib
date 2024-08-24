-- Enable Spellbook during waves
local UEHelpers = require("UEHelpers")
local OMDLib = require("OMDLib")
IsInitialized = false

function Init()
  userSettings = OMDLib.GetGameUserSettings()
  userSettings:SetLeaderboardOptOut(true)
  IsInitialized = true
end

Init()

--- This fires when checking via the in-mission Spellbook, so we can set this
--- to always be true, allowing items to be sold mid-wave.
RegisterHook("/Game/UI/PlayerHUD/Inventory_UMG.Inventory_UMG_C:CheckTrapSellable", function(_, _, bSellable)
  bSellable:set(true)
end)

--- Bring up the Inventory menu
RegisterKeyBind(Key.B, {}, function()
OMDLib.GetPlayerHUDWidget():ShowInventory()
end)
