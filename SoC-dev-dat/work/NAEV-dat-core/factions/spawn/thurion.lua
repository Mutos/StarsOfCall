local scom = require "factions.spawn.lib.common"

local singenuity     = ship.get("Thurion Ingenuity")
local sperspicacity  = ship.get("Thurion Perspicacity")
local svirtuosity    = ship.get("Thurion Virtuosity")
local sapprehension  = ship.get("Thurion Apprehension")
local staciturnity   = ship.get("Thurion Taciturnity")
local scertitude     = ship.get("Thurion Certitude")

-- @brief Spawns a small patrol fleet.
local function spawn_patrol ()
   local pilots = {}
   local r = rnd.rnd()

   if r < 0.3 then
      scom.addPilot( pilots, singenuity )
   elseif r < 0.6 then
      scom.addPilot( pilots, singenuity )
      scom.addPilot( pilots, sperspicacity )
   elseif r < 0.8 then
      scom.addPilot( pilots, svirtuosity )
   else
      scom.addPilot( pilots, sapprehension )
   end

   return pilots
end

-- @brief Spawns a medium sized squadron.
local function spawn_squad ()
   local pilots = {}
   local r = rnd.rnd()

   if r < 0.4 then
      scom.addPilot( pilots, svirtuosity )
      scom.addPilot( pilots, singenuity )
      scom.addPilot( pilots, sperspicacity )
   elseif r < 0.6 then
      scom.addPilot( pilots, svirtuosity )
      scom.addPilot( pilots, singenuity )
   elseif r < 0.8 then
      scom.addPilot( pilots, staciturnity )
      scom.addPilot( pilots, sperspicacity )
      scom.addPilot( pilots, sperspicacity )
   else
      scom.addPilot( pilots, sapprehension )
      scom.addPilot( pilots, sperspicacity )
      scom.addPilot( pilots, sperspicacity )
   end

   return pilots
end

-- @brief Spawns a capship with escorts.
local function spawn_capship ()
   local pilots = {}

   -- Generate the capship
   scom.addPilot( pilots, scertitude )

   -- Generate the escorts
   local r = rnd.rnd()
   if r < 0.5 then
      scom.addPilot( pilots, singenuity )
      scom.addPilot( pilots, singenuity )
      scom.addPilot( pilots, sperspicacity )
      scom.addPilot( pilots, sperspicacity )
   elseif r < 0.8 then
      scom.addPilot( pilots, svirtuosity )
      scom.addPilot( pilots, singenuity )
   else
      scom.addPilot( pilots, sapprehension )
      scom.addPilot( pilots, singenuity )
   end

   return pilots
end

local fthurion = faction.get("Thurion")
-- @brief Creation hook.
function create ( max )
   local weights = {}

   -- Create weights for spawn table
   weights[ spawn_patrol  ] = 300
   weights[ spawn_squad   ] = math.max(1, -80 + 0.80 * max)
   weights[ spawn_capship ] = math.max(1, -500 + 1.70 * max)

   -- Don't overwrite spawn func, we use custom
   return scom.init( fthurion, weights, max, {nospawnfunc=true} )
end


-- @brief Spawning hook
function spawn ( presence, max )
   -- Over limit
   if presence > max then
      return 5
   end

   -- Actually spawn the pilots
   local pilots = scom.spawn()

   -- Calculate spawn data
   scom.choose()

   -- Case no ship was actually spawned, just create an arbitrary delay
   if #pilots == 0 then
      return 10
   end

   return scom.calcNextSpawn( presence ), pilots
end
