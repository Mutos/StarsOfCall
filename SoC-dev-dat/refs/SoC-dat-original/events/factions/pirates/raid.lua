--[[
-- Pirate raid on a system
-- 
-- Creates a pirates squadron of one cargo and several fighters
-- Pirates select a target ship, disable it and loot it, then flee
-- 
--]]


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_Pirates_Raid_001_"

-- Number of pirate fighters
nbFightersMean			=     4
nbFightersVariant		=     1
massLow					=   250
massHigh				=  8000

-- Spawn time : base time +/- percentage
spawnTimeBase			=  1000		-- Milliseconds
spawnTimePercent		=    50		-- Percents

-- Target checks
targetCheckTimeBase		=  5000		-- Delay between two target checks, in Milliseconds
targetCheckProbability	=    25		-- Probability that a target check succeeds

-- Launch time : base time +/- percentage
launchTimeBase			=  5000		-- Milliseconds
launchTimePercent		=    25		-- Percents

-- Delay between two launches : base time +/- percentage
launchDelayBase			=  1000		-- Milliseconds
launchDelayPercent		=    10		-- Percents

-- Board time : base time +/- percentage
boardTimeBase			= 10000
boardTimePercent		=    10

-- Context
currentSystem = system.cur()

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- Pilots
pilotsPirates		= {}
pilotTarget			= nil

-- Management of player intervention
playerAttacked			=     0

-- Get player character species
pcSpecies = var.peek ("pc_species")

-- Hooks
hookPirateIdle			= {}
hookBoardingInProgress	= nil

-- Booleans to keep track of the event's progress
bExited		= {false, false}

-- Script-global variables for ships origin and destination
-- Passed as arguments to the hooks
shipJumpOrigin			= nil
shipJumpDestination		= nil

--
-- =======================================================================================


-- =======================================================================================
--
-- Setup strings
-- 
-- =======================================================================================
--

lang = naev.lang()

-- Here, we mainly use fighters equipped with swivel guns
-- that can be replaced by ion cannons
-- The number of times a line is repeated introduces ponderation
fighterTypes = {
	"Angry Bee",		-- Small 1-cannon drone modified with a cockpit added, pirates jury-rig them with their ion own cannons
	"Nelk'Tan",			-- Standard fighter armed with 4 cannons, pirates jury-rig them with their own ion cannons
	"Nelk'Tan",			-- Standard fighter armed with 4 cannons, pirates jury-rig them with their own ion cannons
	"Nelk'Tan",			-- Standard fighter armed with 4 cannons, pirates jury-rig them with their own ion cannons
	"Nelk'Tan",			-- Standard fighter armed with 4 cannons, pirates jury-rig them with their own ion cannons
	"Akk'Ti'Makkt"		-- Missiles-equipped bomber, useful to break the shields to get disabling damage through
}

if lang == "es" then
	-- not translated atm
else -- default english 
	-- No text for now
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Include convoy helper
include ("dat/events/fleets/common.lua")

-- Include helper functions
include ("dat/events/_commons/_commons.lua")
include "select/selectShipType.lua"
include "select/selectShipName.lua"

--
-- =======================================================================================


-- =======================================================================================
--
-- Main event function
-- 
-- =======================================================================================
--

function create ()
	-- Local variables for extra arguments to function setPassThroughCourse
	-- They will receive nil and never be used, so no need to use global variables
	local shipLandOrigin			= nil
	local shipLandDestination		= nil
	
	-- Tell we're entering the event
	-- print ( string.format("\nPirates Raid Event (%s) : entering event", time.str()))

	-- Set the pirate squadron course between two jump points
	--   Return objects are systems
	shipJumpOrigin, shipLandOrigin, shipJumpDestination, shipLandDestination = setPassThroughCourse(faction, true, false)

	-- No origin or destination for one of the ship : abort the event
	if shipJumpOrigin == nil or shipJumpDestination == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : exiting event because pirate squadron could be created : origin or destination is missing",  time.str()))
		evt.finish()
		return
	end

	-- Select a name for the pirate cargo
	shipName = selectShipName({"+pirate"})

	-- Set hooks on player pilot
	hook.land("endEvent")
	hook.jumpout("endEvent")

	-- Set hook for spawning pirate squadron after a few seconds
	local spawnTime = nil
	spawnTime = spawnTimeBase * (1 + rnd.rnd(-spawnTimePercent/100, spawnTimePercent/100))
	hook.timer(spawnTime, "spawnSquadron")
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Main events sequence :
--	Spawn a pirate squadron comprising of a cargo and several fighters,
--	and make it attack a randomly designated target
--	When target ship is disabled, fighters cease fire and cargo boards target
--	When boarding ends, cargo and fighters hyperspace out to their destination system
-- 
-- =======================================================================================
--

function spawnSquadron()
	-- Spawn the lead cargo
	spawnCargo()

	if not checkPilot ( pilotsPirates[1] ) then
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo invalid", time.str()))
		endEvent()
		return
	end

	-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo set to jump to %s", time.str(), shipJumpDestination:name()))
	pilotsPirates[1]:hyperspace(shipJumpDestination, true)

	-- Setup a hook for the cargo to check for its target
	-- print ( string.format("\tPirates Raid Event (%s) : setting timer hook checkForTarget", time.str()))
	hook.timer(targetCheckTimeBase, "checkForTarget" )

	-- Setup a hook to tell other pirate ships, if any, to follow when its jumps out
	hook.pilot( pilotsPirates[1], "jump", "pirateCargoJumps" )
	hook.pilot( pilotsPirates[1], "death", "pirateCargoKilled" )
end

function checkForTarget( )
	-- Select the target and set the GLOBAL variable pilotTarget
	pilotTarget = selectTarget()

	if checkPilot ( pilotTarget ) then
		-- Highlight target ship
		pilotTarget:setVisplayer( true )
		-- pilotTarget:setHilight( true )

		-- Debug : print parameters
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" following target ship \"%s\" of mass %i", time.str(), pilotsPirates[1]:name(), pilotTarget:name(), pilotTarget:stats().mass ))

		-- Debug : print out target cargo
		targetCargoList = pilot.cargoList(pilotTarget)
		-- print ( string.format("\tPirates Raid Event (%s) : target holds %d commodities", time.str(), #targetCargoList ) )
		for _,v in ipairs(targetCargoList) do
			-- print ( string.format("\t\tPirates Raid Event (%s) : %s: %d", time.str(), v.name, v.q ) )
		end

		--  Adapt number of fighters to target mass
		local targetMass = pilotTarget:stats().mass
		if targetMass < massLow then
			nbFightersMean = nbFightersMean - 2
			-- print ( string.format("\tPirates Raid Event (%s) : #fighters-2", time.str() ))
		elseif targetMass > massHigh then
			nbFightersMean = nbFightersMean + 2
			-- print ( string.format("\tPirates Raid Event (%s) : #fighters+2", time.str() ))
		end
		-- print ( string.format("\tPirates Raid Event (%s) : #fighters : %i+/-%i", time.str(), nbFightersMean, nbFightersVariant ))

		-- Cargo only follows target
		pilotsPirates[1]:taskClear()
		pilotsPirates[1]:follow(pilotTarget)

		-- Set the number of fighters to spawn
		nbFighters = rnd.rnd(nbFightersMean-nbFightersVariant, nbFightersMean+nbFightersVariant)
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo with %i-fighters squadron",  time.str(), nbFighters ) )

		-- Setup a hook for the cargo to launch 1st fighter
		hook.timer(launchTimeBase * (1 + rnd.rnd(-launchTimePercent/100, launchTimePercent/100)), "launchFighter" )

		-- Set hooks on target
		hook.pilot( pilotTarget, "disable", "targetDisabled" )
		hook.pilot( pilotTarget, "death", "targetKilled" )
		hook.pilot( pilotTarget, "jump", "targetJumped" )
		hook.pilot( pilotTarget, "land", "targetLanded" )
	else
		-- No suitable target is found : cargo keeps on to its destination
		-- print ( string.format("\tPirates Raid Event (%s) : no target selected, pirate cargo keping course", time.str()))
		-- print ( string.format("\tPirates Raid Event (%s) : setting timer hook checkForTarget", time.str()))

		-- Setup a hook for the cargo to check again for its target in a while
		hook.timer(targetCheckTimeBase, "checkForTarget" )
	end
end

function launchFighter( )
	-- Check pirate cargo
	if not checkPilot(pilotsPirates[1]) then
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo invalid", time.str()))
		return
	end

	if not checkPilot(pilotTarget) then
		-- print ( string.format("\tPirates Raid Event (%s) : target invalid", time.str()))
		return
	end

	-- Get index from context
	index = #pilotsPirates

	-- The innocent cargo reveals itself as a pirate, if it hasn't already
	pilotsPirates[1]:setFaction("Pirate")

	-- Create a pirate fighter
	local shipType = selectShipType({"+fighter", "+pirate", "guns", "guns", "guns", "guns", "guns", "missiles"})
	-- print ( string.format("\tPirates Raid Event (%s) : pirate fighter #%i of type \"%s\" taking off from \"%s\"", time.str(), index, shipType, pilotsPirates[1]:name()))
	local newFleet = pilot.add(shipType, "pirate", pilotsPirates[1]:pos())

	for k,v in ipairs(newFleet) do
		-- Check newly created pilot
		if not checkPilot(v) then
			-- print ( string.format("\tPirates Raid Event (%s) : pirate fighter creation invalid", time.str()))
		end

	-- Set name and faction
		v:setFaction("Pirate")
		v:rename( string.format( "Alpha %i", index ))

		 -- Change standard guns to disabling guns
		 -- and SIMs to Anti-Shieds Missile
		 local outfits = v:outfits ()
		 local nbCannons, nbMissiles = 0, 0
		 for _,o in ipairs(outfits) do
			if o:name () == "Fighter Laser Cannon" then
				nbCannons = nbCannons + 1
			end
			if o:name () == "SIM Launcher" or o:name () == "MIM Launcher" then
				nbMissiles = nbMissiles + 1
			end
		 end
		-- print ( string.format("\tPirates Raid Event (%s) : \"%s\" of type \"%s\" changing %i cannons from Lasers to Ions.", time.str(), v:name(), v:ship():name(), nbCannons))
		-- print ( string.format("\tPirates Raid Event (%s) : \"%s\" of type \"%s\" changing %i missiles from SIMs and MIMs to Anti-Shields.", time.str(), v:name(), v:ship():name(), nbMissiles))
		v:rmOutfit  ( "Fighter Laser Cannon", nbCannons )
		v:addOutfit ( "Pirates Ion Cannon",   nbCannons )
		v:rmOutfit  ( "SIM Launcher", nbMissiles )
		v:rmOutfit  ( "MIM Launcher", nbMissiles )
		v:addOutfit ( "ASM Launcher", nbMissiles )

		-- Highlight pirate fighter
		v:setVisplayer( true )
		-- v:setHilight( true )

		-- Set ship in manual control mode
		v:control(true)

		-- Fighters attack target
		v:attack(pilotTarget)
		-- After that, they will follow their leader
		v:follow(pilotsPirates[1])

		-- Store ship on global variable
		pilotsPirates[index+1] = v
		index = #pilotsPirates
	end

	-- Launch next fighter if squadron strength is not reached
	if index < nbFighters+1 then
		hook.timer(launchDelayBase * (1 + rnd.rnd(-launchDelayPercent/100, launchDelayPercent/100)), "launchFighter" )
	end
end

function targetDisabled ( pilot, attacker )
	-- Check pilot argument
	if pilot == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target is nil", time.str()))
		return
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" disabled then destroyed", time.str(), pilot:name()))
		return
	end

	-- Target is still alive, so let's echo the attacker
	if attacker == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" disabled by unknown attacker", time.str(), pilot:name()))
	else
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" disabled by \"%s\"", time.str(), pilot:name(), attacker:name()))
	end

	-- Change pirates orders :
	--	Cargo will fake-board the target
	--	Fighters will follow cargo
	local targetPos = pilot:pos()
	for k,v in ipairs(pilotsPirates) do
		if v:exists() then
			v:taskClear()
			if k == 1 then
				-- Cargo will go to target posiion
				v:goto(targetPos)
				-- Setup hook for when it reaches it
				-- print ( string.format( "\tPirates Raid Event (%s) : setting idle hook on ship \"%s\"", time.str(), pilotsPirates[1]:name() ) )
				hookPirateIdle[1] = hook.pilot( pilotsPirates[1], "idle", "boardingBegins", pilot )
			else
				-- Fighters will stop attacking and only follow their mothership
				if pilotsPirates[1]:exists() then
					v:follow(pilotsPirates[1])
				end 
			end
		end
	end
end

function boardingBegins ( pilot, targetPilot )
	-- Parameter check
	if pilot == nil or not pilot:exists() then
		-- print ( string.format( "\tPirates Raid Event (%s) : (boardingBegins) pilot argument invalid", time.str() ) )
		return
	end

	-- Debug printout
	-- print ( string.format( "\tPirates Raid Event (%s) : pirate ship \"%s\" begins boarding", time.str(), pilot:name() ) )

	-- Unset hook on pirates being idle
	for k, v in ipairs(hookPirateIdle) do
		if v ~= nil then
			-- print ( string.format( "\tPirates Raid Event (%s) : removing idle hook", time.str() ) )
			hook.rm(v)
		end
	end

	-- Setup a hook to signal the end of boarding time
	-- print ( string.format( "\tPirates Raid Event (%s) : setting boarding end hook", time.str() ) )
	hookBoardingInProgress = hook.timer(boardTimeBase * (1 + rnd.rnd(-boardTimePercent/100, boardTimePercent/100)), "boardingEnds", targetPilot )
end
 
function boardingEnds ( targetPilot )
	-- Pirate cargo will jump out as fast as possible
	-- print ( string.format( "\tPirates Raid Event (%s) : boarding ends", time.str() ) )

	if not pilotsPirates[1]:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : Pirate mothership is invalid", time.str()))
	else
		-- Actually transfer looted cargo from target to pirate cargo
		targetCargoList = targetPilot.cargoList(pilotTarget)
		pirateCargoFree = pilotsPirates[1]:cargoFree()
		-- print ( string.format("\tPirates Raid Event (%s) : target holds %d commodities", time.str(), #targetCargoList ) )
		for _,v in ipairs(targetCargoList) do
			-- print ( string.format("\t\tPirates Raid Event (%s) : %s: %d", time.str(), v.name, v.q ) )
			if pirateCargoFree == 0 then
				-- print ( string.format("\t\tPirates Raid Event (%s) : looting nothing, no space left in pirate cargo holds", time.str() ) )
			else
				if pirateCargoFree > v.q then
					-- print ( string.format("\t\tPirates Raid Event (%s) : looting all", time.str() ) )
					pilotsPirates[1]:cargoAdd(v.name, v.q)
					targetPilot:cargoRm(v.name, v.q)
				else
					-- print ( string.format("\t\tPirates Raid Event (%s) : looting %d tons", time.str(), pirateCargoFree ) )
					pilotsPirates[1]:cargoAdd(v.name, pirateCargoFree)
					targetPilot:cargoRm(v.name, pirateCargoFree)
				end
			end
		end
	end

	-- Make pirate ships break
	-- print ( string.format( "\tPirates Raid Event (%s) : pirate squadron breaks out", time.str() ) )
	piratesBreak ( )
end

function pirateCargoJumps (pilot)
	if not pilot:exists() then
		-- print ( string.format( "\tPirates Raid Event (%s) : pirate mothership invalid", time.str() ) )
		return
	end

	-- Pirate fighters will jump out as fast as possible
	for k,v in ipairs(pilotsPirates) do
		if k ~=1 and v:exists() then
			-- print ( string.format( "\tPirates Raid Event (%s) : pirate fighter \"%s\" set to jump out after cargo jumps", time.str(), v:name() ) )
			v:taskClear()
			v:hyperspace(shipJumpDestination, true)
		end
	end

	-- The event finishes
	endEvent()
 end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on target ship for secondary branches :
--	Target is killed
--	Target lands
--	Target jumps out
-- 
-- =======================================================================================
--

function targetKilled ( pilot, attacker )
	-- Check pilot argument
	if pilot == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target is nil", time.str()))
		return
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" is invalid", time.str(), pilot:name()))
		return
	end

	-- Hook is invoked before actual death
	if attacker == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" killed by unknown attacker", time.str(), pilot:name()))
	else
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" killed by \"%s\"", time.str(), pilot:name(), attacker:name()))
	end

	-- Make pirate ships break
	-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" was killed", time.str(), pilot:name()))
	piratesBreak ( )
end

function targetJumped ( pilot )
	-- Check pilot argument
	if pilot == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target is nil", time.str()))
		return
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" is invalid", time.str(), pilot:name()))
		return
	end

	-- Make pirate ships break
	-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" jumped out", time.str(), pilot:name()))
	piratesBreak ( )
end

function targetLanded ( pilot )
	-- Check pilot argument
	if pilot == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : target is nil", time.str()))
		return
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" is invalid", time.str(), pilot:name()))
		return
	end

	-- Make pirate ships break
	-- print ( string.format("\tPirates Raid Event (%s) : target \"%s\" landed", time.str(), pilot:name()))
	piratesBreak ( )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on pirate cargo for secondary branches :
--	Cargo is disabled
--	Cargo is killed
-- 
-- =======================================================================================
--

function pirateCargoKilled ( pilot, attacker )
	-- Check pilot argument
	if pilot == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo is nil", time.str()))
		return
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" is invalid", time.str(), pilot:name()))
		return
	end

	-- Hook is invoked before actual death
	if attacker == nil then
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" killed by unknown attacker", time.str(), pilot:name()))
	else
		-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" killed by \"%s\"", time.str(), pilot:name(), attacker:name()))
	end

	-- Make pirate ships break
	-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" was killed", time.str(), pilot:name()))
	piratesBreak ( true )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- End of Event
-- 
-- =======================================================================================
--

function endEvent ()
	-- Debug printout of outcome
	-- print ( string.format("\tPirates Raid Event (%s) : normal end of event", time.str() ) )

	-- The event finishes, but is not unique, so the player may still encounter the same ship
	evt.finish()
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Spawn a pirate cargo hidden under an independent guise
function spawnCargo()
	-- Create the pirate cargo with dummy IA, so it does nothing after boarding
	local shipType = selectShipType({"tramp", "contraband", "+pirate", "-fighter", "-bomber", "-drone"})
	-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo \"%s\" of type \"%s\" jumping in from %s", time.str(), shipName, shipType, shipJumpOrigin:name()))
	local newFleet = pilot.add(shipType, "dummy", shipJumpOrigin)

	for k,v in ipairs(newFleet) do
		-- Check created pilot
		if not checkPilot(v) then
			-- print ( string.format("\tPirates Raid Event (%s) : pirate cargo creation invalid", time.str()))
		end

		-- Set name and faction
		v:setFaction("Independent")
		v:rename(shipName)

		-- Highlight pirate cargo
		-- v:setVisplayer( true )
		-- v:setHilight( true )

		-- Set ship in manual control mode
		v:control(true)

		-- Store ship on global variable
		pilotsPirates[1] = v
	end
end

-- Return a valid target or nil if none is found
function selectTarget()
	-- print ( string.format("\tPirates Raid Event (%s) : checking for target", time.str()))
	local target = nil
	local bFound = false

	-- Get list of all non-disabled ships in system
	local shipsList = pilot.get()
	local detected = nil
	local scanned = nil

	-- Loop on ships until finding a suitable target
	for index=1,#shipsList do
		-- Find the first non-pirate ship, excluding the cargo itself which is independent at that time, that can be detected by the cargo
		detected, scanned = pilotsPirates[1]:inrange( shipsList[index] )
		bFound = (
			shipsList[index] ~= pilotsPirates[1]
				and
			detected
				and
			shipsList[index]:faction():name() ~= "Pirate"
				and
			rnd.rnd(1,100) < targetCheckProbability
		)

		-- If found, record target and break the loop
		if bFound then
			target = shipsList[index]
			break
		end
	end

	-- Debug printout
	if bFound then
		-- print ( string.format("\tPirates Raid Event (%s) : target found : \"%s\"", time.str(), target:name()))
	else
		-- print ( string.format("\tPirates Raid Event (%s) : no target found", time.str()))
	end

	-- Contains the target or nil if no target found
	return target
end

-- Called when target disappears from system one way or another,
-- when pirate cargo is killed, and when boarding ends
function piratesBreak ( pirateCargoDead )
	if pirateCargoDead == nil then
		pirateCargoDead = false
	end

	-- Unset boarding hook in case it's still there
	if hookBoardingInProgress ~= nil then
		-- print ( string.format( "\tPirates Raid Event (%s) : removing boarding end hook", time.str() ) )
		hook.rm(hookBoardingInProgress)
		hookBoardingInProgress = nil
	end

	-- Pirate cargo will jump out as fast as possible
	for k,v in ipairs(pilotsPirates) do
		if v:exists() then
			if k == 1 then
				if pirateCargoDead then
					-- print ( string.format( "\tPirates Raid Event (%s) : pirate cargo \"%s\" is dying : no order to give it", time.str(), v:name() ) )
				else
					-- print ( string.format( "\tPirates Raid Event (%s) : pirate cargo \"%s\" set to jump out", time.str(), v:name() ) )
					v:taskClear()
					v:hyperspace(shipJumpDestination, true)
				end
			elseif (not pilotsPirates[1]:exists()) or pirateCargoDead then
 				-- print ( string.format( "\tPirates Raid Event (%s) : mothership destroyed : pirate fighter \"%s\" set to jump out", time.str(), v:name() ) )
				v:taskClear()
				v:hyperspace(shipJumpDestination, true)
			else
				-- print ( string.format( "\tPirates Raid Event (%s) : pirate fighter \"%s\" set to follow mothership", time.str(), v:name() ) )
				v:taskClear()
				v:follow(pilotsPirates[1])
			end
		end
	end

	-- Unset hook on pirates being idle
	for k, v in ipairs(hookPirateIdle) do
		if v ~= nil then
			-- print ( string.format( "\tPirates Raid Event (%s) : removing idle hook", time.str() ) )
			hook.rm(v)
		end
	end

	-- If the pirate mothership is dead, then properly end the event
	if pirateCargoDead then
		endEvent()
	end
end

-- Check pilot argument
function checkPilot ( pilot )
	if pilot == nil then
		-- print ( string.format("\tGeneric Check (%s) : pilot is nil", time.str()))
		return false
	end
	if pilot == nil or not pilot:exists() then
		-- print ( string.format("\tGeneric Check (%s) : pilot \"%s\" is invalid", time.str(), pilot:name()))
		return false
	end
	return true
end

--
-- =======================================================================================
