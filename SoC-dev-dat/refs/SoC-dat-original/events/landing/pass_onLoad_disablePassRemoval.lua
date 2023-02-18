-- Toolsets include
include "numstring.lua"
include "debug/debug.lua"

function create()
	-- DEBUG
	local strPrefix = "landing/pass_onLoad_disablePassRemoval.lua:create()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Loading the game : disable removing of Landing Pass.
	dbg.stdOutput( strPrefix, 1, "setting boolDisableLandingPassRemove to true", boolDebug )
	var.push( "boolDisableLandingPassRemove", true )

	-- Hook clearing event when takeoff or re-loading game
	dbg.stdOutput( strPrefix, 1, "setting hooks on land and takeoff", boolDebug )
	hook.load("clearEvent")
	hook.takeoff("clearEvent")

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end


function clearEvent()
	-- DEBUG
	local strPrefix = "landing/pass_onLoad_disablePassRemoval.lua:clearEvent()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Taking off or reloading the game : re-enable removing of Landing Pass.
	dbg.stdOutput( strPrefix, 1, "unsetting boolDisableLandingPassRemove", boolDebug )
	var.pop( "boolDisableLandingPassRemove" )

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	-- Jumping before landing
	evt.finish(true)
end
