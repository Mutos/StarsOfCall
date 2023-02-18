--[[--
Library for dealing with escorts in missions.

@module escort
--]]
local escort = {}

local lmisn = require "lmisn"
local fmt = require "format"
local vntk = require "vntk"
local aisetup = require "ai.core.setup"

--[[--
Initializes the library by setting all the necessary hooks.

   @tparam table ships List of ships to add.
   @tparam[opt] table params List of optional parameters.
--]]
function escort.init( ships, params )
   params = params or {}
   mem._escort = {
      params = params,
      ships_orig = ships,
      ships = tcopy(ships),
      faction = params.faction or "Independent",
      hooks = {
         jumpin   = hook.jumpin(  "_escort_jumpin" ),
         jumpout  = hook.jumpout( "_escort_jumpout" ),
         land     = hook.land(    "_escort_land" ),
         takeoff  = hook.takeoff( "_escort_takeoff"),
      },
   }

   -- Initialize to wherever the player is
   if player.isLanded() then
      mem._escort.origin = spob.cur()
   else
      mem._escort.origin = system.cur()
   end
end

local function clear_hooks ()
   if mem._escort.hooks.jumpin then
      hook.rm( mem._escort.hooks.jumpin )
      mem._escort.hooks.jumpin = nil
   end
   if mem._escort.hooks.jumpout then
      hook.rm( mem._escort.hooks.jumpout )
      mem._escort.hooks.jumpout = nil
   end
   if mem._escort.hooks.land then
      hook.rm( mem._escort.hooks.land )
      mem._escort.hooks.land = nil
   end
   if mem._escort.hooks.takeoff then
      hook.rm( mem._escort.hooks.takeoff )
      mem._escort.hooks.takeoff = nil
   end
end

--[[--
Cleans up the escort framework when done, eliminating all hooks.
--]]
function escort.exit ()
   clear_hooks()
   mem._escort = nil
end

--[[--
Gets the number of escorts that are still alive.

   @treturn number Number of escorts still alive.
--]]
function escort.num_alive ()
   return #mem._escort.ships
end

local _escort_convoy
--[[--
Gets the list of pilots.

   @treturn table Table containing the existing pilots. The first will be the leader.
--]]
function escort.pilots ()
   return _escort_convoy
end

--[[--
Sets the destination of the

   @tparam system|spob dest Destination of the escorts.
   @tparam string success Name of the global function to call on success.
   @tparam[opt] string failure Name of the global function to call on failure. Default will give a vntk message and fail the mission.
--]]
function escort.setDest( dest, success, failure )
   if dest.system then
      mem._escort.destspob = dest
      mem._escort.destsys = dest:system()
   else
      mem._escort.destspob = nil
      mem._escort.destsys = dest
   end
   mem._escort.func_success = success
   mem._escort.func_failure = failure or "_escort_failure"

   mem._escort.nextsys = lmisn.getNextSystem(system.cur(), mem._escort.destsys)
end

local exited
local function run_success ()
   clear_hooks()
   _G[mem._escort.func_success]()
end

function escort.reset_ai ()
   for k,p in ipairs(_escort_convoy) do
      p:control(false)
      p:setNoJump(false)
      p:setNoLand(false)
      p:taskClear()
   end

   local l = _escort_convoy[1]
   if not l or not l:exists() then return end
   l:control(true)
   local scur = system.cur()
   if scur == mem._escort.destsys then
      if mem._escort.destspob then
         l:land( mem._escort.destspob )
      else
         run_success()
      end
   else
      l:hyperspace( lmisn.getNextSystem( scur, mem._escort.destsys ) )
   end
end

function _escort_e_death( p )
   for k,v in ipairs(_escort_convoy) do
      if v==p then
         player.msg( "#r"..fmt.f(_("{plt} has been lost!"), {plt=p} ).."#0" )

         table.remove(_escort_convoy, k)
         table.remove(mem._escort.ships, k)

         if escort.num_alive() <= 0 then
            lmisn.fail( n_("The escort has been lost!","All escorts have been lost!",#mem._escort.ships_orig) )
         end

         -- Set a new leader and tell them to move on
         if k==1 then
            local l = _escort_convoy[1]
            l:setLeader()
            l:setHilight(true)
            for i,e in ipairs(_escort_convoy) do
               if i~=1 then
                  e:taskClear()
                  e:setLeader( l )
               end
            end
            escort.reset_ai()
         end

         if mem._escort.params.func_pilot_death then
            _G[mem._escort.params.func_pilot_death]( p )
         end
         return
      end
   end
end

function _escort_e_attacked( p, attacker )
   if mem._escort.params.func_pilot_attacked then
      _G[mem._escort.params.func_pilot_attacked]( p, attacker )
   end
end

function _escort_e_land( p, landed_spob )
   if landed_spob == mem._escort.destspob then
      table.insert( exited, p )
      if p:exists() then
         player.msg( "#g"..fmt.f(_("{plt} has landed on {pnt}."), {plt=p, pnt=landed_spob} ).."#0" )
      end
   else
      _escort_e_death( p )
   end
end

function _escort_e_jump( p, j )
   if j:dest() == mem._escort.nextsys then
      table.insert( exited, p )
      if p:exists() then
         player.msg( "#g"..fmt.f(_("{plt} has jumped to {sys}."), {plt=p, sys=j:dest()} ).."#0" )
      end
   else
      _escort_e_death( p )
   end
end

--[[--
Spawns the escorts at location. This can be useful at the beginning if you want them to jump in or take of while in space. It is handled automatically when the player takes off or jumps into a system.

   @tparam Vector|Spob|System pos Position to spawn the fleet at. The argument is directly passed to pilot.add.
   @return table Table of newly created pilots.
--]]
function escort.spawn( pos )
   pos = pos or mem._escort.origin

   -- Set up the new convoy for the new system
   exited = {}
   _escort_convoy = {}
   local l
   for k,s in ipairs( mem._escort.ships ) do
      local p = pilot.add( s, mem._escort.faction, pos, nil, mem._escort.params.pilot_params )
      if not l then
         l = p
      else
         p:setLeader( l )
      end
      table.insert( _escort_convoy, p )
   end

   -- See if we have a post-processing function
   local fcreate
   if mem._escort.params.func_pilot_create then
      fcreate = _G[mem._escort.params.func_pilot_create]
   end

   -- Some post-processing for the convoy
   local minspeed = player.pilot():stats().speed_max * 0.9
   for k,p in ipairs(_escort_convoy) do
      p:setInvincPlayer(true)
      p:setFriendly(true)

      hook.pilot( p, "death", "_escort_e_death" )
      hook.pilot( p, "attacked", "_escort_e_attacked" )
      hook.pilot( p, "land", "_escort_e_land" )
      hook.pilot( p, "jump", "_escort_e_jump" )

      if fcreate then
         fcreate( p )
         aisetup.setup( p )
      end

      minspeed = math.min( p:stats().speed_max, minspeed )
   end

   -- Have the leader move as slow as the slowest ship
   l:setSpeedLimit( minspeed )
   l:setHilight(true)
   -- Moving to system
   escort.reset_ai()

   -- Mark destination
   local scur = system.cur()
   if mem._escort.nextsys ~= scur then
      system.markerAdd( jump.get( scur, mem._escort.nextsys ):pos() )
   else
      if mem._escort.destspob then
         system.markerAdd( mem._escort.destspob:pos() )
      end
   end

   return _escort_convoy
end

function _escort_spawn ()
   escort.spawn()
end

function _escort_takeoff ()
   -- We want to defer it one frame in case an enter hook clears all pilots
   hook.safe( "_escort_spawn" )
end

function _escort_jumpin ()
   if system.cur() ~= mem._escort.nextsys then
      lmisn.fail( _("You jumped into the wrong system.") )
      return
   end
   mem._escort.nextsys = lmisn.getNextSystem(system.cur(), mem._escort.destsys)
   -- We want to defer it one frame in case an enter hook clears all pilots
   hook.safe( "_escort_spawn" )
end

local function update_left ()
   local ships_alive = {}
   for i,p in ipairs(exited) do
      for j,v in ipairs(_escort_convoy) do
         if v==p then
            table.insert( ships_alive, mem._escort.ships[j] )
         end
      end
   end
   mem._escort.ships = ships_alive
end

function _escort_jumpout()
   update_left ()
   if #exited <= 0 then
      lmisn.fail( _("You jumped before the convoy you were escorting.") )
   end
   mem._escort.origin = system.cur()
end

-- luacheck: globals _escort_failure
function _escort_failure ()
   local n = #mem._escort.ships_orig
   if escort.num_alive() <= 0 then
      vntk.msg( n_("You landed before your escort!","You landed before your escorts!", n),
            n_([[You landed at the planet before ensuring that your escort was safe. You have abandoned your duties, and failed your mission.]],
               [[You landed at the planet before ensuring that your escorts were safe. You have abandoned your duties, and failed your mission.]], n))
   else
      vntk.msg(_("You abandoned your mission!"),
         n_("You have landed, abandoning your mission to protect your escort.",
            "You have landed, abandoning your mission to protect your escorts.", n))
   end
   misn.finish(false)
end

function _escort_land()
   update_left ()
   if spob.cur() ~= mem._escort.destspob or escort.num_alive() <= 0 then
      _G[mem._escort.func_failure]()
   else
      run_success()
   end
end

return escort
