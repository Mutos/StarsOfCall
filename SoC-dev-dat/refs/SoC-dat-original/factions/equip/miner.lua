-- Generic equipping routines, helper functions and outfit definitions.
include("dat/factions/equip/generic.lua")

-- Quick hack for absence of equip_classOutfits_weapons in generic.lua
equip_classOutfits_weapons = {}

equip_classOutfits_weapons["Yacht"] = {
   {
      "Small Ion Flak Turret", "Small Flak Turret"
   }
}

equip_classOutfits_weapons["Courier"] = {
   {
      "Small Ion Flak Turret", "Small Flak Turret"
   }
}

equip_classOutfits_weapons["Freighter"] = {
   {
      num = 1;
      "Small Ion Flak Turret", "Small Flak Turret"
   },
   {
      "Small Ion Flak Turret", "Small Flak Turret"
   }
}


--[[
-- @brief Does miner pilot equipping
--
--    @param p Pilot to equip
--]]
function equip( p )
   equip_generic( p )
end
