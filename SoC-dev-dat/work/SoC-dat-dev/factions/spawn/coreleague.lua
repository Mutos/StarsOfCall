local fmt  = require "format"
local scom = require "factions.spawn.lib.common"

local slancelot   = ship.get("Core League Lancelot")
local sshark      = ship.get("Core League Shark")
local sadmonisher = ship.get("Core League Admonisher")
local spacifier   = ship.get("Core League Pacifier")
local shawking    = ship.get("Core League Hawking")
local speacemaker = ship.get("Core League Peacemaker")
local srainmaker  = ship.get("Core League Rainmaker")

-- @brief Spawns a small patrol fleet.
local function spawn_patrol ()
   warn("function spawn_patrol () : begin")

   local pilots = { __doscans = true }
   local r = rnd.rnd()

   if r < 0.5 then
      scom.addPilot( pilots, slancelot )
   elseif r < 0.8 then
      scom.addPilot( pilots, slancelot )
      scom.addPilot( pilots, sshark )
   else
      scom.addPilot( pilots, spacifier )
   end

   warn("function spawn_patrol () : end")
   return pilots
end


-- @brief Spawns a medium sized squadron.
local function spawn_squad ()
   warn("function spawn_squad () : begin")
   local pilots = {}
   if rnd.rnd() < 0.5 then
      pilots.__doscans = true
   end
   local r = rnd.rnd()

   if r < 0.5 then
      scom.addPilot( pilots, sadmonisher )
      scom.addPilot( pilots, slancelot )
   elseif r < 0.8 then
      scom.addPilot( pilots, sadmonisher )
      scom.addPilot( pilots, slancelot )
      scom.addPilot( pilots, sshark )
   else
      scom.addPilot( pilots, spacifier )
      scom.addPilot( pilots, slancelot )
      scom.addPilot( pilots, sshark )
   end

   warn("function spawn_squad () : end")
   return pilots
end


-- @brief Spawns a capship with escorts.
local function spawn_capship ()
   warn("function spawn_capship () : begin")
   local pilots = {}
   local r = rnd.rnd()

   -- Generate the capship
   if r < 0.1 then
      scom.addPilot( pilots, srainmaker )
   elseif r < 0.7 then
      scom.addPilot( pilots, shawking )
   else
      scom.addPilot( pilots, speacemaker )
   end

   -- Generate the escorts
   r = rnd.rnd()
   if r < 0.5 then
      scom.addPilot( pilots, slancelot )
      scom.addPilot( pilots, slancelot )
      scom.addPilot( pilots, sshark )
   elseif r < 0.8 then
      scom.addPilot( pilots, sadmonisher )
      scom.addPilot( pilots, slancelot )
   else
      scom.addPilot( pilots, spacifier )
      scom.addPilot( pilots, slancelot )
   end

   warn("function spawn_capship () : end")
   return pilots
end

local fCoreLeague = faction.get("Core League")

-- @brief Creation hook.
function create( max )
   warn(fmt.f(_("function create ( '{max}' ) : begin"), {max=max}) )
   local weights = {}

   -- Create weights for spawn table
   weights[ spawn_patrol  ] = 300
   weights[ spawn_squad   ] = math.max(1, -80 + 0.80 * max)
   weights[ spawn_capship ] = math.max(1, -500 + 1.70 * max)

   -- Initialize spawn stuff
   warn(fmt.f(_("function create ( '{max}' ) : end"), {max=max}) )
   return scom.init( fCoreLeague, weights, max, {patrol=true} )
end
