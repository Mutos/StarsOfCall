--[[
-- These are regular cargo escort missions. Pay is low, but so is difficulty.
-- Most of these missions require ARMED ships. Not for cargoes!
--]]

-- =======================================================================================
--
-- Includes
-- 
-- =======================================================================================
--

-- Debug facility
include "debug/debug.lua"

--
-- =======================================================================================


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Mission prefix for variables
msnPrefix = "msn_Cargo_Escort_001_"

-- Jump delay : base time
jumpTime				= 30000		-- ms

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- Route systems
previousSystem = nil
currentSystem = nil
nextSystem = nil

-- Marker for next system
nextSystemMarker = nil

-- Escortee
escorteeName = ""
escorteeType = ""
escorteePilot = nil

-- Startup system and asset
startupAsset = nil
startupSystem = nil

-- Destination system and asset
destinationSystem = nil
destinationAsset = nil

-- Hooks
timerWaitHook = nil
jumpAheadHook = nil

-- Timers for if player jumps before escortee
strayBefore = 0
strayBeforeLastTime = false

-- Percent of escortee's cargo that had ben looted enroute
amount = 0
remainingAmount = 0
percentLooted = 0
--
-- =======================================================================================


-- =======================================================================================
--
-- Setup strings
-- 
-- =======================================================================================
--

lang = naev.lang()

if lang == "es" then
else -- default english
	-- Mission description and reward
	misn_desc = "%s in the %s system needs escort for a shipment of %d tons of %s."
	misn_reward = "%s credits (10%% in advance, 60%% upon safe landing, 30%% if cargo is intact)"

	desc = {}
	desc[1] = "Cargo escort to %s"
	desc[2] = "Goods escort to %s"
	desc[3] = "Commodities escort to %s"
	desc[4] = "Transport escort to %s"

	cargosize = {}
	cargosize[0] = "Small" -- Note: indexed from 0, to match mission tiers.
	cargosize[1] = "Medium"
	cargosize[2] = "Sizeable"
	cargosize[3] = "Large"
	cargosize[4] = "Bulk"

	title_p1 = {}
	title_p1[1] = "Escort a %s to %s in the %s system"
	
	-- Note: please leave the trailing space on the line below! Needed to make the newline show up.
	title_p2 = [[ 
Jumps: %d
Travel distance: %d]]

	--=Landing=--
	cargo_land_title = "Escort success!"

	cargo_land_p1 = {}
	cargo_land_p1[1] = "The crates of "
	cargo_land_p1[2] = "The drums of "
	cargo_land_p1[3] = "The containers of "

	cargo_land_p2 = {}
	cargo_land_p2[1] = " are carried out of the cargo ship by a sullen group of workers. The job takes inordinately long to complete. When at last they end up, the merchant pays you without a word."
	cargo_land_p2[2] = " are rushed out of your escortee shortly after you land on the next spot. Before you can even collect your thoughts, your escortee's captain jumps out of their vessel, presses a credit chip in your hand and runs back to their ship."
	cargo_land_p2[3] = " are unloaded by an exhausted-looking bunch of dockworkers. Still, they make fairly good time. Upon completion of the job, they call you and your escortee and deliver both paychecks."
	cargo_land_p2[4] = " are unloaded by a team of robotic drones supervised by a sentient overseer. They pay the cargo's captain who, in turn, gives you your part."

	cargo_land_p1_loot = {}
	cargo_land_p1_loot[1] = "The remaining crates of "
	cargo_land_p1_loot[2] = "The remaining drums of "
	cargo_land_p1_loot[3] = "The remaining containers of "

	cargo_land_p2_loot = {}
	cargo_land_p2_loot[1] = " are carried out of the cargo ship by a sullen group of workers. When at last they end up, the merchant, disgrunteled at the cargo loss but happy to have kept their vessel, pays you."
	cargo_land_p2_loot[2] = " are rushed out of your escortee shortly after you land on the next spot. Then, your escortee's captain presses a credit chip in your hand and runs back to their ship."
	cargo_land_p2_loot[3] = " are unloaded by an exhausted-looking bunch of dockworkers. Still, they make fairly good time. Upon completion of the job, they call you and your escortee and deliver both paychecks."
	cargo_land_p2_loot[4] = " are unloaded by a team of robotic drones supervised by a sentient overseer. They pay the cargo's captain who, in turn, gives you your part with a word of complaint over your inability to protect their precious cargo."

	escort_strayTitle = "Escort mission failed."
	escort_stray = {}
	escort_stray[1] = "Taking gravleave during an escort mission is no good. Your escortee didn't wait for you and you'll not be paid."
	escort_stray[2] = "You waited too long for jumping out after your escortee. You lost them and will not be paid."
	escort_stray[3] = "You jumped in the wrong system. You lost your escortee and will not be paid."
	escort_stray[4] = "You jumped ahead of your escortee one time too many, so they resigned the contract and you'll not be paid."

	strayBeforeMax  = 2
	escort_ahead = {}
	escort_ahead[1] = "You were ordered to wait for us! We could have been attacked while you were jumping ahead of time!"
	escort_ahead[2] = "That's the second time you jump ahead of us! Do NOT do this again or we resign our contract!"
	escort_ahead[3] = "So be it, we'll fend for ourselves, this'll at least save the money you asked for your lousy services!"

	escort_deathTitle = "Escort mission failed."
	escort_death = "Sadly, you failed fending off the assaulters and your escortee was destroyed. This mission has just become a total mess."

	accept_title = "Mission Accepted"

	osd_title = "Escort %s"
	osd_msg = {}
	osd_msg[1] = "Follow %s to the %s jump point."
	osd_msg[2] = "Jump to the %s system."
	osd_msg[3] = "Wait for %s to land at %s."
	osd_msg[4] = "Land your ship at %s."
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Include helper functions
include "jumpdist.lua"
include "cargo_common.lua"
include "numstring.lua"
include "select/selectShipType.lua"
include "select/selectShipName.lua"

-- Include helper functions
include ("dat/events/_commons/_commons.lua")

--
-- =======================================================================================


-- =======================================================================================
--
-- Mission standard functions, called by the engine
--   create()	From mission.xml, when landing, creates display in the Missions panel
--   accept()	"Accept" button from Mission Computer
--   abort()	"Abort" button from Mission tab of the Information window
-- 
-- =======================================================================================
--

-- Create the mission
function create()
	-- Note: this mission does not make any system claims. 
	-- Note : DO NOT SET THE currentSystem GLOBAL VARIABLE HERE

	-- DEBUG
	-- print ( string.format( "\tRegular Escort : entering create()" ) )

	-- The more presence in the system, the more chances the mission has to be generated
	-- Above 50% presence, the missions is always generated
	local seed = rnd.rnd(1,100)
	local presence = system.cur():presence("all")
	if ( seed > presence ) then
		-- print ( string.format( "\tRegular Escort : \tpresence check failed  (rnd=%i > presence=%i in system \"%s\")", seed, presence, system.cur():name() ) )
		misn.finish(false)
	else
		-- print ( string.format( "\tRegular Escort : \tpresence check success (rnd=%i < presence=%i in system \"%s\")", seed, presence, system.cur():name() ) )
	end

	-- Calculate the route, distance, jumps and cargo to take
	destinationAsset, destinationSystem, numjumps, traveldist, cargo, tier = cargo_calculateRoute()
	if destinationAsset == nil then
		-- print ( string.format( "\tRegular Escort : \tno suitable planet found (origin system \"%s\")", system.cur():name() ) )
		misn.finish(false)
	end

	-- Select a name and type for the escortee
	escorteeName = selectShipName({"+civilian"})
	escorteeType = selectShipType({"tramp", "bulk", "tanker", "containers"})
	-- print ( string.format( "\tRegular Escort : create() : escorteeType = \"%s\"", escorteeType ) )

	-- Choose amount of cargo and mission reward. This depends on the mission tier.
	-- Note: Pay is independent from amount by design! Not all deals are equally attractive!
	finished_mod = 1.0 -- Modifier that should tend towards 1.0 as naev is finished as a game
	jumpreward = 100
	distreward = 0.05
	reward = 1.5^tier * (numjumps * jumpreward + traveldist * distreward) * finished_mod * (1. + 0.05*rnd.twosigma())

	-- Set title and marker
	misn.setTitle(buildCargoMissionDescription( desc, nil, nil, cargo, destinationAsset, destinationSystem ))
	misn.markerAdd(destinationSystem, "computer")
	misn.setDesc(title_p1[rnd.rnd(1, #title_p1)]:format(escorteeType,destinationAsset:name(), destinationSystem:name()) .. title_p2:format(numjumps, traveldist))
	misn.setReward(misn_reward:format(numstring(reward)))

	-- Set startup system and asset
	startupSystem = system.cur()
	startupAsset = planet.cur()

	-- print ( string.format( "\tRegular Escort : exiting create()" ) )
end

-- Mission is accepted
function accept()
	-- Update global variables
	-- Note : DO NOT SET THE currentSystem GLOBAL VARIABLE HERE
	nextSystem = getNextSystem( system.cur(), destinationSystem )

	-- Record mission in player's log
	misn.accept()

	-- Advance payment for equipment (10%)
	player.pay(reward*0.1)

		-- Create the first list of objectives OSD
	misn.osdCreate(osd_title:format(escorteeName), {osd_msg[1]:format(escorteeName, nextSystem:name()), osd_msg[2]:format(nextSystem:name()) } )
	misn.osdActive(1)

	-- Hook for when the player will launch
	nextPlayerHook = hook.enter("enterSystem")

	-- DEBUG : temporary hook for testing, end mission when landing
	strayLandHook = hook.land("strayLand")
end

-- Mission is aborted
function abort ()
	misn.finish(false)
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Main events sequence :
--	1/ Player launches in startup system : enterSystem()
--		Spawn escortee ship.
--	2/ Escortee ship jumps out : escorteeJump()
--		Change OSD selection.
--	3/ Player jumps out : playerJumpOut()
--		Delete OSD.
--	4/ Player jumps in any non-destination system : enterSystem()
--		Respawn escortee ship,
--		Set OSD and marker for current system.
--	5/ Escortee ship jumps out : escorteeJump()
--		Change OSD selection.
--	6/ Player jumps out : playerJumpOut()
--		Delete OSD.
--	7/ Player jumps in destination system : enterSystem()
--		Respawn escortee ship,
--		Set OSD and marker for destination system.
--	8/ Escortee lands at destination asset : escorteeLand()
--		Adjust OSD.
--	9/ Player lands at destination asset : playerLand()
--		Compute reward,
--		Delete OSD,
--		End mission.
-- 
-- =======================================================================================
--

-- Hook : enter a system, used at steps (1), (4) and (7)
function enterSystem()
	local strPrefix = string.format( "Escort Mission : enterSystem()" )
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, "initial values", boolDebug )
	if previousSystem == nil then
		dbg.stdOutput( strPrefix, 2, "previous system : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "previous system : \"%s\"", previousSystem:name() ), boolDebug )
	end
	if currentSystem == nil then
		dbg.stdOutput( strPrefix, 2, "current system  : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "current system  : \"%s\"", currentSystem:name() ), boolDebug )
	end
	if nextSystem == nil then
		dbg.stdOutput( strPrefix, 2, "next system     : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "next system     : \"%s\"", nextSystem:name() ), boolDebug )
	end

	-- Check if we are neither taking off for the mission nor jumping in on the right path
	if currentSystem ~= nil and system.cur() ~= nextSystem then
		-- System is not the right one : fail mission
		strayWrongSystem()
		dbg.stdOutput( strPrefix, -1, "straying out of path", boolDebug )
		dbg.stdOutput( strPrefix, -1, "exiting", boolDebug )
		return
	end

	-- Update global variables
	previousSystem = currentSystem
	currentSystem = system.cur()
	nextSystem = getNextSystem( currentSystem, destinationSystem )

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, "values after update", boolDebug )
	if previousSystem == nil then
		dbg.stdOutput( strPrefix, 2, "previous system : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "previous system : \"%s\"", previousSystem:name() ), boolDebug )
	end
	if currentSystem == nil then
		dbg.stdOutput( strPrefix, 2, "current system  : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "current system  : \"%s\"", currentSystem:name() ), boolDebug )
	end
	if nextSystem == nil then
		dbg.stdOutput( strPrefix, 2, "next system     : none", boolDebug )
	else
		dbg.stdOutput( strPrefix, 2, string.format( "next system     : \"%s\"", nextSystem:name() ), boolDebug )
	end

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format( "route from \"%s\" to \"%s\"", startupSystem:name(), destinationSystem:name() ), boolDebug )

	-- Create escortee
	spawnCargo()
	-- print ( string.format( "\t\tRegular Escort : escortee name   : \"%s\"", escorteePilot:name()) )

	-- If player jumped ahead of time, escortee protests
	if strayBeforeLastTime and strayBefore>0 then
		playerJumpAheadMessage()
	end

	if currentSystem == destinationSystem then
		-- Remove the marker to the next system on the route
		if nextSystemMarker~=nil then
			misn.markerRm(nextSystemMarker)
		end

		-- Create the OSD to escort ship to landing
		if nextSystem~=nil then
			misn.osdCreate(osd_title:format(escorteeName), {osd_msg[3]:format(escorteeName, destinationAsset:name()), osd_msg[4]:format(destinationAsset:name()) } )
			misn.osdActive(1)
		end

		-- Set escortee to land at the destination aset
		dbg.stdOutput( strPrefix, 1, string.format( "escortee set to land on %s", time.str(), destinationAsset:name() ), boolDebug )
		escorteePilot:land(destinationAsset, true)

		-- Set hook on escortee landing
		hook.pilot( escorteePilot, "land", "escorteeLand" )
	else
		if currentSystem == startupSystem then
			-- Create a marker to the next system on the route
			nextSystemMarker = misn.markerAdd(nextSystem, "low")

			-- OSD already created by accept()
		else
			-- Create a marker to the next system on the route
			misn.markerMove(nextSystemMarker, nextSystem)

		-- Create the OSD to escort ship to jumping
			misn.osdCreate(osd_title:format(escorteeName), {osd_msg[1]:format(escorteeName, nextSystem:name()), osd_msg[2]:format(nextSystem:name()) } )
			misn.osdActive(1)
		end

		-- Set escortee to jump out to next system
		print (string.format("\t\tRegular Escort (%s) : escortee set to jump to %s", time.str(), nextSystem:name()))
		escorteePilot:hyperspace(nextSystem, true)

		-- Set hook on escortee jumping out
		hook.pilot( escorteePilot, "jump", "escorteeJump" )

		-- Set hook on escortee destroyed
		hook.pilot( escorteePilot, "death", "escorteeDeath" )
	end

	-- Adjusts speed to make the escortee slower than its escort
	print (string.format("\t\tRegular Escort (%s) : old speed/max escortee(%d/%d), player(%d/%d)", time.str(), escorteePilot:stats().speed, escorteePilot:stats().speed_max, player.pilot():stats().speed, player.pilot():stats().speed_max))
	if escorteePilot:stats().speed ~= 0 then
		local speedRatio = player.pilot():stats().speed/escorteePilot:stats().speed
		local newSpeed = player.pilot():stats().speed*.75*100
		if speedRatio<1.05 then
			print (string.format("\t\tRegular Escort (%s) : setting escortee speed limit to %d%%", time.str(), newSpeed ))
			escorteePilot:setSpeedLimit(newSpeed)
		end
		print (string.format("\t\tRegular Escort (%s) : new speed/max escortee(%d/%d), player(%d/%d)", time.str(), escorteePilot:stats().speed, escorteePilot:stats().speed_max, player.pilot():stats().speed, player.pilot():stats().speed_max))
	end

	-- Set the hook for when the player jumps out
	-- print ( string.format( "\tRegular Escort : \tenterSystem() : setting playerJumpAhead hook" ) )
	jumpAheadHook = hook.jumpout("playerJumpAhead")

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end

-- Hook : escortee jumps out to the next system, used at steps (2) and (5)
function escorteeJump()
	-- print ( string.format( "\tRegular Escort : Entering escorteeJump()" ) )

	-- Remember the escortee's stats for next system
	remainingAmount = escorteePilot:cargoHas(cargo)
	-- print ( string.format( "\tRegular Escort : \tescorteeJump() : remaining cargo : %d tons", remainingAmount ) )

	-- Select line telling player to jump
	misn.osdActive(2)

	-- Remove hook on ahead jump
	-- print ( string.format( "\tRegular Escort : \tescorteeJump() : clearing jumpAheadHook" ) )
	hook.rm(jumpAheadHook)
	jumpAheadHook = nil

	-- Set the hook for when the player jumps out
	-- print ( string.format( "\tRegular Escort : \tescorteeJump() : setting timer hook" ) )
	hook.jumpout("playerJumpOut")

	-- Set a timer for setting the maximum time the player is to stay behind their ecortee
	timerWaitHook = hook.timer( jumpTime, "strayWait" )

	-- print ( string.format( "\tRegular Escort : Exiting escorteeJump()" ) )
end

-- Hook : player jumps out to the next system, used at steps (3) and (6)
function playerJumpOut()
	-- print ( string.format( "\tRegular Escort : Entering playerJumpOut()" ) )

	-- Destroy the OSD
	misn.osdDestroy()

	-- Remove the hook for waiting time
	if timerWaitHook == nil then
		-- print ( string.format( "\tRegular Escort : \tplayerJumpOut() : setting strayBefore++" ) )
	else
		-- print ( string.format( "\tRegular Escort : \tplayerJumpOut() : removing timer hook" ) )
		hook.rm(timerWaitHook)
		timerWaitHook = nil
	end

	-- Check if the system is the right one
	-- Not used as it is easier to check upon entering system
	if player.autonavDest() == nil then
		-- print ( string.format( "\tRegular Escort :`\tPlayerJumpOut() : player autonavDest() = nil" ) )
	else
		-- print ( string.format( "\tRegular Escort :`\tPlayerJumpOut() : player autonavDest() = %s", player.autonavDest():name() ) )
	end
	local navPlanet, navHyperspace = player.pilot():nav()
	if navHyperspace == nil then
		-- print ( string.format( "\tRegular Escort :`\tPlayerJumpOut() : player hyperspace Nav = nil" ) )
	else
		-- print ( string.format( "\tRegular Escort :`\tPlayerJumpOut() : player hyperspace Nav = %s", navHyperspace:name() ) )
	end

	-- print ( string.format( "\tRegular Escort : Exiting playerJumpOut()" ) )
end

-- Hook : escortee lands on the destination asset, used at step (8)
function escorteeLand()
	-- print ( string.format( "\tRegular Escort : Entering escorteeLand()" ) )

	-- Select line telling player to land
	misn.osdActive(2)

	-- Set the hook for when the player lands
	hook.rm(strayLandHook)
	hook.land("playerLand")

	-- Check if the escortee has been looted enroute
	if escorteePilot:cargoFree() ~= 0 then
		percentLooted = 100
	end

	-- print ( string.format( "\tRegular Escort : Exiting escorteeLand()" ) )
end

-- Hook : player lands on the destination planet, used at step (9)
function playerLand()
	-- print ( string.format( "\tRegular Escort : Entering playerLand()" ) )

	 if planet.cur() ~= destinationAsset then
		-- print ( string.format( "\tRegular Escort : playerLand() : error, wrong planet : \"%s\"", planet.cur():name() ) )
		strayLand()
	end

	-- Destroy the OSD
	misn.osdDestroy()

	-- Player gets paid
	if percentLooted == 0 then
		-- Semi-random message.
		tk.msg(cargo_land_title, cargo_land_p1[rnd.rnd(1, #cargo_land_p1)] .. cargo .. cargo_land_p2[rnd.rnd(1, #cargo_land_p2)])

		-- Total reward minus what had been paid in advance (10%)
		player.pay(reward*0.9)

		-- Reputation with the landing faction increases a little bit as word spreads of the mission success,
		-- without affecting reputation with other factions
		local reputation = 1
		local paying_faction = planet.cur():faction()
		paying_faction:modPlayerSingle( reputation )
	else
		-- Semi-random message.
		tk.msg(cargo_land_title, cargo_land_p1_loot[rnd.rnd(1, #cargo_land_p1_loot)] .. cargo .. cargo_land_p2_loot[rnd.rnd(1, #cargo_land_p2_loot)])

		-- Total reward minus advance (10%) and loot penalty (30%)
		player.pay(reward*0.6)
	end
	
	-- End the mission
	misn.finish(true)

	-- print ( string.format( "\tRegular Escort : Exiting playerLand()" ) )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Off-sequence events
--  a/ Player lands on a planet before their escortee reaches its destination
--      Mission fails
--  b/ Player waits too long after escortee jumped out to the next system
--      Mission fails
--  c/ Player jumps to the wrong system
--      Mission fails
--  d/ Player jumps before escortee
--       At first, mission doesn't fail, but escortee is unhappy and speaks it out loud...
--       Third time this happens, mission fails
--  e/ Escortee is destroyed
--       Mission fails
--  f/ Escortee is disabled and looted
--       Mission can still succeed, but with reduced reward due to cargo loss
-- 
-- =======================================================================================
--

-- Hook : land on any planet before reaching the destination
function strayLand()
	-- Popup to tell the player the mission failed
	tk.msg(escort_strayTitle, escort_stray[1])

	-- Finish the mission without completing it - Anyway, it's no unique mission...
	misn.finish(false)
end

-- Hook : wait too long after escortee jumped out to the next system
function strayWait()
	-- Popup to tell the player the mission failed
	tk.msg(escort_strayTitle, escort_stray[2])

	-- Finish the mission without completing it - Anyway, it's no unique mission...
	misn.finish(false)
end

-- Call : jumped to the wrong system
function strayWrongSystem()
	-- Popup to tell the player the mission failed
	tk.msg(escort_strayTitle, escort_stray[3])

	-- Finish the mission without completing it - Anyway, it's no unique mission...
	misn.finish(false)
end

-- Hook : jumped ahead of time
function playerJumpAhead()
	-- Just update counter
	-- print ( string.format( "\t\tRegular Escort : playerJumpAhead() : updating counter from %d to %d.", strayBefore,strayBefore+1) )
	strayBefore = strayBefore+1
	strayBeforeLastTime = true

	-- Remove the hook so it won't be triggered multiple times
	hook.rm(jumpAheadHook)
	jumpAheadHook=nil
end

-- Call : message or mission failure after jumping ahead of time
function playerJumpAheadMessage()
	-- Just complain
	-- print ( string.format( "\t\tRegular Escort : playerJumpAheadMessage() : escortee name   : \"%s\"", escorteePilot:name()) )
	-- print ( string.format( "\t\tRegular Escort : playerJumpAheadMessage() : strayBefore     = \"%d\"", strayBefore) )
	-- print ( string.format( "\t\tRegular Escort : playerJumpAheadMessage() : message         : \"%s\"", escort_ahead[strayBefore] ) )
	escorteePilot:comm( escort_ahead[strayBefore] )
	strayBeforeLastTime = false
	if strayBefore > strayBeforeMax then
		-- Fail the mission : display message,
		tk.msg(escort_strayTitle, escort_stray[4])

		-- Fail the mission : unset escortee special diplay
		escorteePilot:setVisplayer( false )
		escorteePilot:setHilight( false )

		-- Fail the mission : actually end mission,
		misn.finish(false)
	end
end

-- Hook : escortee was destroyed
function escorteeDeath()
	-- DEBUG
	-- print ( string.format( "\t\tRegular Escort : entering escorteeDeath()") )

	-- Popup to tell the player the mission failed
	tk.msg(escort_deathTitle, escort_death)

	-- Finish the mission without completing it - Anyway, it's no unique mission...
	misn.finish(false)

		-- DEBUG
	-- print ( string.format( "\t\tRegular Escort : exiting escorteeDeath()") )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Spawn the escortee cargo
function spawnCargo()
	-- Local variables
	local newFleet = nil

	if previousSystem ~= nil then
		print (string.format("\tRegular Escort (%s) : escortee \"%s\" of type \"%s\" jumping from \"%s\"", time.str(), escorteeName, escorteeType, previousSystem:name()))
		newFleet = pilot.add(escorteeType, "dummy", previousSystem)
	else
		print (string.format("\tRegular Escort (%s) : escortee \"%s\" of type \"%s\" launching from \"%s\"", time.str(), escorteeName, escorteeType, startupAsset:name()))
		newFleet = pilot.add(escorteeType, "dummy", startupAsset)
	end

	for k,v in ipairs(newFleet) do
		-- Check created pilot
		if not checkPilot(v) then
			print (string.format("\tRegular Escort (%s) : escortee creation invalid", time.str()))
		end

		-- Add the maximum possible number of cargo holds for enhancing the escortee's cargo space and also for slowing it down a little...
		v:addOutfit("Small Cargo Hold", 10)


		-- Set name and faction
		v:setFaction("Independent")
		v:rename(escorteeName)

		-- Compute amount so as to load the ship to the gully
		local cargoFree = v:cargoFree()
		if amount == 0 then
			amount = cargoFree
			remainingAmount = amount
		end

		-- Add actual cargo up to the remaining amount
		print ( string.format("\t\tRegular Escort (%s) : free cargo space : %d tons for remaining amount : %d tons from initial amount : %d tons", time.str(), cargoFree, remainingAmount, amount ))
		v:cargoAdd(cargo, remainingAmount)
		print ( string.format("\t\tRegular Escort (%s) : listing cargo", time.str() ))
		for _,cargoItem in ipairs(v:cargoList()) do
			print ( string.format("\t\t\tRegular Escort (%s) : \"%s\" : %d tons", time.str(), cargoItem.name, cargoItem.q ))
		end
		-- Highlight escortee
		v:setVisplayer( true )
		v:setHilight( true )

		 -- Debug -- printout
		 local outfits = v:outfits ()
		 for _,o in ipairs(outfits) do
			local slotName, slotSize = o:slot()
			print ( string.format("\t\tRegular Escort (%s) : %s %s : %s", time.str(), slotSize, slotName, o:name () ))
		 end

		 -- Set ship in manual control mode
		v:control(true)

		-- Set global variable
		escorteePilot = v
	end
end

-- Check pilot argument
function checkPilot ( pilot )
	if pilot == nil then
		-- print (string.format("\tGeneric Check (%s) : pilot is nil", time.str()))
		return false
	end
	if pilot == nil or not pilot:exists() then
		-- print (string.format("\tGeneric Check (%s) : pilot \"%s\" is invalid", time.str(), pilot:name()))
		return false
	end
	return true
end

--
-- =======================================================================================
