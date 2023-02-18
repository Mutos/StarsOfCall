local lmisn = require "lmisn"
local pir = require 'common.pirate'
local fmt = require "format"

local car = {}

--[[--
   Return a random jump distance, biased toward short missions (0-3 jumps).
--]]
local function selectMissionDistance ()
   local seed = rnd.rnd()

   -- 70% chance of 0-3 jump distance
   if seed < 0.7 then
      return rnd.rnd(0, 3)
   else
      return rnd.rnd(4, 6)
   end
end

--[[--
   Build a set of target planets
--]]
local function selectPlanets( missdist, routepos, use_hidden )
   local pcur = spob.cur()
   return lmisn.getSpobAtDistance( system.cur(), missdist, missdist, "Independent", false, function ( p )
         if p ~= pcur
            and not (p:system() == system.cur() and (vec2.dist( p:pos(), routepos) < 2500))
            and p:canLand() and car.validDest( p ) then
               return true
         end
         return false
         end,
      nil, use_hidden or false )
end

--[[--
   We have a destination, now we need to calculate how far away it is by simulating the journey there.
   Assume shortest route with no interruptions.
   This is used to calculate the reward.
--]]
function car.calculateDistance( routesys, routepos, destsys, destplanet, use_hidden )
   local traveldist = 0

   local jumps = routesys:jumpPath( destsys, use_hidden )
   if jumps then
      for k, v in ipairs(jumps) do
         -- We're not in the destination system yet.
         -- So, get the next system on the route, and the distance between
         -- our entry point and the jump point to the next system.
         -- Then, set the exit jump point as the next entry point.
         local j, r = jump.get( v:system(), v:dest() )
         traveldist = traveldist + vec2.dist(routepos, j:pos())
         routepos = r:pos()
      end
   end

   -- We ARE in the destination system now, so route from the entry point to the destination planet.
   traveldist = traveldist + vec2.dist(routepos, destplanet:pos())

   return traveldist
end

--Determines the items in table a that are not in table b.
--Used to determine what cargo is sold at current planet but not at destination planet.
local function difference(a, b)
   local ai = {}
   local r = {}
   for k,v in pairs(a) do
      r[k] = v
      ai[v]=true
   end
   for k,v in pairs(b) do
      if ai[v]~=nil then
         r[k] = nil
      end
   end
   return r
end

--[[--
   Plan out a mission and return the parameters.
   @tparam[opt] function missdist Length in jumps, chosen at random via selectMissionDistance() by default.
   @tparam[opt=false] always_available If true, always generate; otherwise, only generate if commodities are available.
   @tparam[opt=false] use_hidden If true, allow hidden jumps to be part of the route.
--]]
function car.calculateRoute( missdist, always_available, use_hidden )
   local origin_p, origin_s = spob.cur()
   local routesys = origin_s
   local routepos = origin_p:pos()

   -- Select mission tier.
   local tier = rnd.rnd(0, 4)

   if missdist == nil then
      missdist = selectMissionDistance()
   end
   local planets = selectPlanets( missdist, routepos, use_hidden )
   if #planets == 0 then
      return
   end

   local index     = rnd.rnd(1, #planets)
   local destplanet= planets[index]
   local destsys   = destplanet:system()

   -- We have a destination, now we need to calculate how far away it is by simulating the journey there.
   -- Assume shortest route with no interruptions.
   -- This is used to calculate the reward.

   local numjumps   = origin_s:jumpDist( destsys, use_hidden )
   local traveldist = car.calculateDistance(routesys, routepos, destsys, destplanet, use_hidden)

   -- Guarding factions
   local _guards = {
      faction.get("Empire"),
      faction.get("Dvaered"),
      faction.get("Soromid"),
      faction.get("Sirius"),
      faction.get("Za'lek"),
      faction.get("Frontier"),
   }
   local function guard_presence( sys )
      local p = sys:presences()
      local total = 0
      for k,f in ipairs(_guards) do
         total = total + (p[f:nameRaw()] or 0)
      end
      return total
   end
   local function calc_risk( sys )
      local risk = pir.systemPresence( sys )
      local grisk = guard_presence( sys )
      return math.max( risk/10, risk - grisk/3 )
   end

   --Determine amount of piracy along the route
   local exp = 2.0 -- We'll compute a piracy score (units of presence) per system. Score is a power mean with this exponent.
   local cursys = system.cur()
   local jumps = system.jumpPath( cursys, destsys )
   local risk = calc_risk( cursys ) ^ exp
   if risk == nil then risk = 0 end
   if jumps then
      for k, v in ipairs(jumps) do
         risk = risk + calc_risk( v:system() ) ^ exp
      end
   end
   risk = (risk/(numjumps + 1))^(1/exp)

   -- We now know where. But we don't know what yet. Randomly choose a commodity type.
   local cargo
   local cargoes = difference(spob.cur():commoditiesSold(),destplanet:commoditiesSold())
   if #cargoes == 0 then
      if always_available then
         cargo = nil
      else
         return
      end
   else
      cargo = cargoes[rnd.rnd(1,#cargoes)]:nameRaw()
   end

   -- Return lots of stuff
   return destplanet, destsys, numjumps, traveldist, cargo, risk, tier
end


--[[--
   Calculates the minimum possible time taken for the player to reach a destination.
--]]
function car.getTransit( numjumps, traveldist )
   local pstats   = player.pilot():stats()
   local stuperpx = 1 / pstats.speed_max * 30
   local arrivalt = time.get() + time.new(0, 0, traveldist * stuperpx +
         numjumps * pstats.jump_delay + 10180 + 240 * numjumps)
   return arrivalt
end

local _hidden_fact = {
   faction.get("FLF"),
   faction.get("Pirate"),
   faction.get("Marauder"),
   faction.get("Raven Clan"),
   faction.get("Dreamer Clan"),
   faction.get("Wild Ones"),
   faction.get("Black Lotus"),
   faction.get("Proteron"),
   faction.get("Thurion"),
}

function car.validDest( targetplanet )
   -- factions which cannot be delivered to by factions other than themselves
   local tfact = targetplanet:faction()
   for i, f in ipairs(_hidden_fact) do
      if tfact == f and spob.cur():faction() ~= f then
         return false
      end
   end

   -- Factions which cannot deliver to factions other than themselves
   local insular = {
      faction.get("Proteron"),
      faction.get("Thurion"),
   }
   for i, f in ipairs(insular) do
      if spob.cur():faction() == f and targetplanet:faction() ~= f then
         return false
      end
   end

   return true
end

--[[--
   Returns a block of mission-description text for the given cargo.
   @tparam string misn_desc Translated title-level description, e.g., "Cargo transport to Zeo in the Apez system."
   @tparam string cargo Cargo type (raw name). May be nil.
   @tparam number amount Cargo amount in tonnes. May be nil.
   @param target Target planet for the delivery.
   @param deadline Target delivery time. May be nil.
   @param notes Any additional text the user should see on its own detail line, such as piracy risk. May be nil.
   @tparam[opt=false] bool use_hidden Whether the description accounts for hidden jumps in its distances.
-- ]]
function car.setDesc( misn_desc, cargo, amount, target, deadline, notes, use_hidden )
   local t = { misn_desc, "" }
   if amount ~= nil then
      table.insert( t, fmt.f( _("#nCargo:#0 {cargo} ({mass})"), {cargo=_(cargo), mass=fmt.tonnes(amount)} ) )
   elseif cargo ~= nil then
      table.insert( t, fmt.f( _("#nCargo:#0 {cargo}"), {cargo=_(cargo)} ) )
   end

   local numjumps   = system.cur():jumpDist( target:system(), use_hidden )
   local dist = car.calculateDistance( system.cur(), spob.cur():pos(), target:system(), target, use_hidden )
   table.insert( t,
      fmt.f( n_( "#nJumps:#0 {jumps}", "#nJumps:#0 {jumps}", numjumps ), {jumps=numjumps} )
      .. "\n"
      .. fmt.f( n_("#nTravel distance:#0 {dist}", "#nTravel distance:#0 {dist}", dist), {dist=fmt.number(dist)} ) )

   if notes ~= nil then
      table.insert( t, notes )
   end

   if deadline ~= nil then
      table.insert( t, fmt.f( _("#nTime limit:#0 {deadline}"), {deadline=tostring(deadline - time.get())} ) )
   end

   misn.setDesc( table.concat(t, "\n" ) )
end

return car
