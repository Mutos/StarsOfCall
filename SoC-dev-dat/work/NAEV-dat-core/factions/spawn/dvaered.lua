local scom = require "factions.spawn.lib.common"

local svendetta   = ship.get("Dvaered Vendetta")
local sancestor   = ship.get("Dvaered Ancestor")
local sphalanx    = ship.get("Dvaered Phalanx")
local svigilance  = ship.get("Dvaered Vigilance")
local sretribution= ship.get("Dvaered Retribution")
local sgoddard    = ship.get("Dvaered Goddard")
local sarsenal    = ship.get("Dvaered Arsenal")

-- @brief Spawns a small patrol fleet.
local function spawn_patrol ()
   local pilots = { __doscans = true }
   local r = rnd.rnd()

   if r < 0.5 then
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   elseif r < 0.8 then
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   else
      scom.addPilot( pilots, sphalanx )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   end

   return pilots
end

-- @brief Spawns a medium sized squadron.
local function spawn_squad ()
   local pilots = {}
   if rnd.rnd() < 0.5 then
      pilots.__doscans = true
   end
   local r = rnd.rnd()

   if r < 0.5 then
      scom.addPilot( pilots, svigilance )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   elseif r < 0.8 then
      scom.addPilot( pilots, svigilance )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   else
      scom.addPilot( pilots, svigilance )
      scom.addPilot( pilots, sphalanx )
      scom.addPilot( pilots, svendetta )
   end

   return pilots
end

-- @brief Spawns a capship with escorts.
local function spawn_capship ()
   local pilots = {}

   -- Generate the capship
   local r = rnd.rnd()
   if r < 0.1 then
      scom.addPilot( pilots, sarsenal )
   elseif r < 0.4 then
      scom.addPilot( pilots, sretribution )
   else
      scom.addPilot( pilots, sgoddard )
   end

   -- Generate the escorts
   r = rnd.rnd()
   if r < 0.5 then
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   elseif r < 0.8 then
      scom.addPilot( pilots, sphalanx )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, sancestor )
   else
      scom.addPilot( pilots, svigilance )
      scom.addPilot( pilots, svendetta )
      scom.addPilot( pilots, svendetta )
   end

   return pilots
end

local fdvaered = faction.get("Dvaered")
-- @brief Creation hook.
function create ( max )
   local weights = {}

   -- Create weights for spawn table
   weights[ spawn_patrol  ] = 300
   weights[ spawn_squad   ] = math.max(1, -80 + 0.80 * max)
   weights[ spawn_capship ] = math.max(1, -500 + 1.70 * max)

   return scom.init( fdvaered, weights, max, {patrol=true} )
end
