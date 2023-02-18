-- ==========================================================================
--
-- Basic template for generating generic freighters for a faction
--   Needs 3 variables to work :
--     - strFaction : name of the faction
--     - strAI      : name of the AI to use for generated ships
--     - tabWeights : table of ships to generate
--
-- ==========================================================================


-- ==========================================================================
-- Initializations
-- ==========================================================================
--
-- Debug facility
include "debug/debug.lua"

-- Common functions
include("dat/factions/spawn/_common/common.lua")
--
-- ==========================================================================


-- ==========================================================================
-- @brief Creation hook.
-- ==========================================================================
--
function create ( max )
	local strPrefix = string.format( "freighters.lua:create()" )
	local boolDebug = false

	if strFaction==nil then
		strFaction = "Independent"
	end
	if strAI==nil then
		strAI = "independent"
	end
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "strFaction = \"%s\"", strFaction ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "strAI      = \"%s\"", strAI      ), boolDebug )

	-- Create weights for spawn table
	weights = tabWeights
	if weights == nil then
		-- Default table if global variable is nil
		dbg.stdOutput( strPrefix, 1, string.format( "Passed weight table = nil" ), boolDebug )
		weights = scom.WeightTable.AllCargos()
	else
		dbg.stdOutput( strPrefix, 1, string.format( "Passed weight table OK" ), boolDebug )
	end

	-- Create spawn table base on weights
	spawn_table = scom.createSpawnTable( weights )

	-- Calculate spawn data
	spawn_data = scom.choose( spawn_table )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end
--
-- ==========================================================================


-- ==========================================================================
-- @brief Spawning hook
-- ==========================================================================
--
function spawn ( presence, max )
	local strPrefix = string.format( "freighters.lua:spawn()" )
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	local pilots

	if strFaction==nil then
		strFaction = "Independent"
	end
	dbg.stdOutput( strPrefix, 1, string.format("spawn(%i, %i) for \"%s\"", presence, max, strFaction), boolDebug )

	-- Over limit
	if presence > max then
		dbg.stdOutput( strPrefix, 1, string.format("Presence %i over max %i, returning 5", presence, max ), boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return 5
	end

	-- Actually spawn the pilots
	pilots = scom.spawn( spawn_data, strFaction, strAI )

	if #pilots == 0 then
		dbg.stdOutput( strPrefix, 1, string.format("No pilot generated for \"%s\", returning 5", strFaction ), boolDebug )
		print (string.format("spawn() for \"%s\" : end", strFaction))
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return 5
	end

	for i = 1, #pilots do
		dbg.stdOutput( strPrefix, 1, string.format("Spawning pilot : \"%s\"",pilots[i].pilot:name() ), boolDebug )
	end

	-- Calculate next batch of pilots to spawn
	spawn_data = scom.choose( spawn_table )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
--
-- ==========================================================================
