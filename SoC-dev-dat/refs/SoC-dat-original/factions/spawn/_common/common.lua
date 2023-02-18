-- ==========================================================================
--
-- Common functions for all factions' spawn process
--
-- ==========================================================================


-- ==========================================================================
-- Initializations
-- ==========================================================================
--
-- Debug facility
include "debug/debug.lua"

-- Define variable to contain functions
scom = {}

-- Defines ships data as scom members
include("dat/factions/spawn/_common/ships.lua")
--
-- ==========================================================================


-- ==========================================================================
-- @brief Calculates when next spawn should occur
-- ==========================================================================
--
function scom.calcNextSpawn( cur, new, max )
	if cur == 0 then return rnd.rnd(0, 10) end -- Kickstart spawning.

	local stddelay = 10 -- seconds
	local maxdelay = 60 -- seconds. No fleet can ever take more than this to show up.
	local stdfleetsize = 1/4 -- The fraction of "max" that gets the full standard delay. Fleets bigger than this portion of max will have longer delays, fleets smaller, shorter.
	local delayweight = 1. -- A scalar for tweaking the delay differences. A bigger number means bigger differences.
	local percent = (cur + new) / max
	local penaltyweight = 1. -- Further delays fleets that go over the presence limit.
	if percent > 1. then
		penaltyweight = 1. + 10. * (percent - 1.)
	end

	local fleetratio = (new/max)/stdfleetsize -- This turns into the base delay multiplier for the next fleet.

	return math.min(stddelay * fleetratio * delayweight * penaltyweight, maxdelay)
end
--
-- ==========================================================================


-- ==========================================================================
--[[
	@brief Creates the spawn table based on a weighted spawn function table.
		@param weights Weighted spawn function table to use to generate the spawn table.
		@return The matching spawn table.
--]]
-- ==========================================================================
--
function scom.createSpawnTable( weights )
	local strPrefix = "Spawn common function scom.createSpawnTable()"
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	dbg.stdOutput( strPrefix, 1, string.format( "#weights = %i", #weights ), boolDebug )

	local spawn_table = {}
	local max = 0

	-- Create spawn table
	for k,v in pairs(weights) do
		max = max + v
		spawn_table[ #spawn_table+1 ] = { chance = max, func = k }
		-- print ( string.format( "\tweight[%i] = %i ; max = %i", #spawn_table, v, max ))
	end
	dbg.stdOutput( strPrefix, 1, string.format( "#weights = %i", #weights ), boolDebug )

		-- Sanity check
	if max == 0 then
		-- print("\tNo weight specified")
		dbg.stdOutput( strPrefix, 1, string.format( "WARNING : no weight specified" ), boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return
	end

	-- Normalize
	for k,v in ipairs(spawn_table) do
		v["chance"] = v["chance"] / max
	end

	-- Job done
	-- print ( string.format( "\tFinal #spawn_table = %i", #spawn_table ))
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return spawn_table
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Chooses what to spawn
-- ==========================================================================
--
function scom.choose( stable )
	local strPrefix = string.format( "common.lua:scom.choose()" )
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- dbg.stdOutput( strPrefix, 1, string.format( "strFaction = \"%s\"", strFaction ), boolDebug )

	if stable == nil then
		dbg.stdOutput( strPrefix, 1, "No spawn function passed, (stable == nil)", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return nil
	else
		dbg.stdOutput( strPrefix, 1, string.format( "#stable = %i", #stable ), boolDebug )
	end

	local r = rnd.rnd()
	for k,v in ipairs( stable ) do
		if r < v["chance"] then
			dbg.stdOutput( strPrefix, 1, "Before generating spawn data", boolDebug )
			local spawn_data = v["func"]()
			dbg.stdOutput( strPrefix, 1, "After generating spawn data", boolDebug )
			if spawn_data == nil then
				dbg.stdOutput( strPrefix, 1, "No spawn data generated", boolDebug )
			else
				dbg.stdOutput( strPrefix, 1, "Spawn data :", boolDebug )
				for k1,v1 in ipairs(spawn_data) do
					dbg.stdOutput( strPrefix, 2, string.format( "spawn_data[%s] = %s", tostring(k1), tostring(v1) ), boolDebug )
					for k2,v2 in pairs(v1) do
						dbg.stdOutput( strPrefix, 3, string.format( "spawn_data[%s][%s] = %s", tostring(k1), tostring(k2), tostring(v2) ), boolDebug )
					end
				end
			end
			dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
			return spawn_data 
		end
	end
	dbg.stdOutput( strPrefix, 1, "No suitable spawn function found", boolDebug )
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Actually spawns the pilots
-- ==========================================================================
--
function scom.spawn( pilots, faction, ai )
	local strPrefix = string.format( "common.lua:scom.spawn()" )
	local boolDebug = true

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	local sFaction = faction
	local sAI = ai
	local spawned = {}

	-- Check if there is actually any pilot to spawn
	if pilots == nil then
		dbg.stdOutput( strPrefix, 1, "pilots == nil : nothing to spawn", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return spawned
	end
	if #pilots == 0 then
		dbg.stdOutput( strPrefix, 1, "#pilots == 0 : nothing to spawn", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return spawned
	end

	-- No faction : default to Independent
	if sFaction == nil then
		dbg.stdOutput( strPrefix, 1, "Faction == nil, taking \"Independent\"", boolDebug )
		sFaction = "Independent"
	else
		dbg.stdOutput( strPrefix, 1, string.format( "Faction == %s", sFaction ), boolDebug )
	end

	-- No AI : default to independent
	if sAI == nil then
		dbg.stdOutput( strPrefix, 1, "AI == nil, taking \"independent\"", boolDebug )
		sAI = "independent"
	else
		dbg.stdOutput( strPrefix, 1, string.format( "AI == %s", sAI ), boolDebug )
	end

	-- Actually add the pilots
	for k,v in ipairs(pilots) do
		dbg.stdOutput( strPrefix, 1, string.format( "Adding ships \"%s\" with faction \"%s\" and AI \"%s\"", v["pilot"], sFaction, sAI ), boolDebug )
		local p = pilot.addRaw( v["pilot"], sAI, nil, sFaction )
		if p == nil then
			dbg.stdOutput( strPrefix, 1, "No pilots actually added", boolDebug )
		else
			spawned[ #spawned+1 ] = { pilot = p, presence = v["presence"] }
			dbg.stdOutput( strPrefix, 1, string.format( "Pilot actually added : \"%s\"", p:name() ), boolDebug )
		end
	end

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
	return spawned
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief adds a pilot to the table of pilots to spawn
-- ==========================================================================
--
function scom.addPilot( pilots, name, presence )
	pilots[ #pilots+1 ] = { pilot = name, presence = presence }
	if pilots[ "__presence" ] then
		pilots[ "__presence" ] = pilots[ "__presence" ] + presence
	else
		pilots[ "__presence" ] = presence
	end
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Gets the presence value of a group of pilots
-- ==========================================================================
--
function scom.presence( pilots )
	-- print ( "\tEntering scom.presence()" )
	if pilots == nil then
		-- print ( "\t\tpilots == nil" )
		-- print ( "\tExiting scom.presence()" )
		return 0
	end
	if pilots[ "__presence" ] then
		-- print ( string.format( "\t\tpilots[ \"__presence\" ] = %i", pilots[ "__presence" ] ))
		-- print ( "\tExiting scom.presence()" )
		return pilots[ "__presence" ]
	else
		-- print ( string.format( "\t\tpilots[ \"__presence\" ] non numeric : \"%s\"", pilots[ "__presence" ]:string() ))
		-- print ( "\tExiting scom.presence()" )
		return 0
	end
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Default decrease function
-- ==========================================================================
--
function scom.decrease( cur, max, timer )
	return timer
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Spawns a lone ship of the given type and presence
-- ==========================================================================
--
scom.Ship = function( shipClass, presence )
	-- DEBUG
	local strPrefix = "common.lua:scom.Ship()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Check parameters
	if shipClass == nil or shipClass == "" then
		dbg.stdOutput( strPrefix, 0, "Exiting : no ship class specified.", boolDebug )
		return
	end
	if presence == nil or presence == 0 then
		dbg.stdOutput( strPrefix, 0, "Exiting : no presence specified.", boolDebug )
		return
	end
	dbg.stdOutput( strPrefix, 1, string.format( "Parameters : ( \"%s\", %i )", shipClass, presence ), boolDebug )

	-- Get pilots to be spawned
	local pilots = {}
	scom.addPilot( pilots, shipClass, presence );

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return pilots
end
--
-- ==========================================================================


