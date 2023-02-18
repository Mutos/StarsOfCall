-- Toolsets include
include "numstring.lua"
include "debug/debug.lua"

-- Landing functions include
include "landing/landing_params_passes.lua"		-- Parameters table used by the generic functions.

function create()
	-- DEBUG
	local strPrefix = "landing/pass_onLand_removePass.lua:create()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Loading the game : disable removing of Landing Pass.
	local boolDisableLandingPassRemove = var.peek( "boolDisableLandingPassRemove" )
	if boolDisableLandingPassRemove then
		dbg.stdOutput( strPrefix, 1, "removing of Landing Pass disabled", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		evt.finish(true)
		return
	end

	-- Check if planet has landing pass
	local strPlanetName = planet:cur():name()
	if landing_passes[strPlanetName] == nil then
		dbg.stdOutput( strPrefix, 1, "planet without Landing Pass", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		evt.finish(true)
		return
	end

	-- Actually remove one landing pass from the player
	local strLandingPassName = landing_passes[strPlanetName].passName
	dbg.stdOutput( strPrefix, 1, string.format( "remove one landing pass : \"%s\"", strLandingPassName ), boolDebug )
	player.rmOutfit( strLandingPassName, 1 )

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	-- Hook clearing event when takeoff or re-loading game
	evt.finish(true)
end
