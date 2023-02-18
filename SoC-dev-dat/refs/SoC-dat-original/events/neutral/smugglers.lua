--[[
-- Rendez-vous between smugglers
-- 
-- Creates a smugglers ship that jumps in and stops far from anything.
-- Another ship will then jump in and rendez-vous with the first one.
-- 
--]]


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_Smugglers_RendezVous_001_"

-- Spawn time : base time +/- percentage
spawnTimeBase			= 20000		-- Milliseconds
spawnTimePercent		=    25		-- Percents

-- Wait timing : base time +/- percentage
waitTimeBase			= 50000
waitTimePercent			=    15

-- Board time : base time +/- percentage
boardTimeBase			=  5000
boardTimePercent		=    10

-- Parameters for setting RdV point
--   First, get the midpoint from both jump-in points
--   Multiply midpoint by a factor to shift towards outer system
--   Offset the RdV point by a random distance and angle
midpointMultiplier		=     1.5
rdvDistBase				=  2000
rdvDistPercent			=    25

-- Context
currentSystem = system.cur()
faction = "Independent"

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
pilotSmugglers		= {nil, nil}

-- Management of player intervention
playerAttacked			=     0

-- Get player character species
pcSpecies = var.peek ("pc_species")

-- Hooks
evtIdle		= {nil, nil}
evtTired	= {nil, nil}
evtDeath	= {nil, nil}
evtJump		= {nil, nil}

-- Booleans to keep track of the event's progress
bRdV		= {false, false}
bExited		= {false, false}

-- Actual ship names
shipName = {"",""}

-- Script-global variables for ships origin and destination
-- Passed as arguments to the hooks
shipJumpOrigin			= {nil, nil}
shipJumpDestination		= {nil, nil}

-- Rendez-vous coordinates
posRendezVous	= nil

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

-- Include selection for ship type to display
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
	local shipLandOrigin			= {nil, nil}
	local shipLandDestination		= {nil, nil}
	
	-- Tell we're entering the event
	-- print (string.format("\nRendezVous Event (%s) : entering event for faction \"%s\"", time.str(), faction))

	-- Select two names for the ships
	shipName[1], shipName[2] = textDoubleSelection(selectShipNamesList({"+civilian"}, true))

	-- Set the two ships course between two jump points
	--   First select both Origins, then both Destinations,
	--   This ensures ships will neither enter nor leave the system by the same points.
	--   Return objects are systems
	shipJumpOrigin[1], shipLandOrigin[1], shipJumpOrigin[2], shipLandOrigin[2] = setPassThroughCourse(faction, true, false)
	shipJumpDestination[1], shipLandDestination[1], shipJumpDestination[2], shipLandDestination[2] = setPassThroughCourse(faction, true, false)

	-- No origin or destination for one of the ship : abort the event
	if shipJumpOrigin[1] == nil or shipJumpOrigin[2] == nil or shipJumpDestination[1] == nil or shipJumpDestination[2] == nil then
		-- print ( string.format("RendezVous Event (%s) : exiting event because no ship could be created : an origin or destination is missing",  time.str()))
		evt.finish()
		return
	end

	-- Rendezvous point at mid-distance
	-- To be improved : the rdv point should be only towards the outer system
	local positionVector = {nil, nil}
	positionVector[1] = jump.get(system.cur(), shipJumpOrigin[1]):pos()
	positionVector[2] = jump.get(system.cur(), shipJumpOrigin[2]):pos()
	posRendezVous	= ( positionVector[1] + positionVector[2]) / 2 * midpointMultiplier
	angle			= rnd.rnd() * 2 * math.pi
	dist			= rdvDistBase * (1 + rnd.rnd(-rdvDistPercent, rdvDistPercent)/100) -- place it a way out
	posRendezVous	= posRendezVous + vec2.new( dist * math.cos(angle), dist * math.sin(angle) )

		-- Set hooks on player pilot
	hook.land("endEvent")
	hook.jumpout("endEvent")

	-- Set hooks for spawning both ships after a few seconds
	local spawnTime = nil
	spawnTime = spawnTimeBase * (1 + rnd.rnd(-spawnTimePercent/100, spawnTimePercent/100))
	hook.timer(spawnTime, "spawnShip", 1)
	spawnTime = spawnTimeBase * (1 + rnd.rnd(-spawnTimePercent/100, spawnTimePercent/100))
	hook.timer(spawnTime, "spawnShip", 2)
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Spawn ships
-- 
-- =======================================================================================
--

function spawnShip( index )
	-- Create the ship
	-- print (string.format("\tRendezVous Event (%s) : ship #%i jumping in from %s", time.str(), index, shipJumpOrigin[index]:name()))
	local shipType = selectShipType({"tramp", "contraband"})
	local newFleet = pilot.add(shipType, "dummy", shipJumpOrigin[index])

	for k,v in ipairs(newFleet) do
		-- Set name and faction
		v:setFaction("Independent")
		v:rename(shipName[index])

		-- Add extra visibility for debug and big systems
		-- v:setVisplayer( true )
		-- v:setHilight( true )

		-- Set orders to go to the rendezvous point
		v:control(true)
		v:goto(posRendezVous)

		-- Set hooks on ship
		evtIdle[index]	= hook.pilot( v, "idle", "shipIdleEvent" )
		evtDeath[index]	= hook.pilot( v, "death", "shipDeathEvent" )
		evtJump[index]	= hook.pilot( v, "jump", "shipJumps" )

		-- Store ship on global variable
		pilotSmugglers[index] = v
	end
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on either ship
-- 
-- =======================================================================================
--

function shipIdleEvent ( pilot )
	-- Check pilot validity and find its index in global list
	local index = getPilotIndex(pilot, pilotSmugglers)
	if pilot == nil then
		-- print ( string.format( "\tRendezVous Event (%s) : pilot is invalid", time.str() ) )
		return
	end

	-- Debug -- printout of outcome
	-- print ( string.format( "\tRendezVous Event (%s) : ship #%i \"%s\" is idle", time.str(), index, pilot:name() ) )

	-- Remove the event, it must not be fired twice
	-- print ( string.format( "\tRendezVous Event (%s) : removing evtIdle #%i", time.str(), index ) )
	hook.rm( evtIdle[index] )
	evtIdle[index] = nil

	-- Mark the ship has reached RdV
	bRdV[index] = true

	if bRdV[1] and bRdV[2] then
		-- Remove the Tired hook on the other ship
		if evtTired[3-index] ~= nil then
			-- print ( string.format( "\tRendezVous Event (%s) : removing evtTired #%i", time.str(), 3-index ) )
			hook.rm( evtTired[3-index] )
			evtTired[3-index] = nil
		end

		-- Set timer for board wait time
		hook.timer(boardTimeBase * (1 + rnd.rnd(-boardTimePercent/100, boardTimePercent/100)), "cargoExchangeWait" )
	else
		-- Set timer for maximum wait time
		-- print ( string.format( "\tRendezVous Event (%s) : setting evtTired #%i", time.str(), index ) )
		evtTired[index] = hook.timer(waitTimeBase * (1 + rnd.rnd(-waitTimePercent/100, waitTimePercent/100)), "shipTiredToWait", pilot )
	end
end


function shipDeathEvent ( pilot )
	-- Check pilot validity and find its index in global list
	local index = getPilotIndex(pilot, pilotSmugglers)

	-- Debug -- printout of outcome
	-- print ( string.format( "\tRendezVous Event (%s) : ship #%i \"%s\" died", time.str(), index, pilot:name() ) )

	-- Remove any hook on the defunct ship if need be
	if evtTired[index] ~= nil then
		-- print ( string.format( "\tRendezVous Event (%s) : removing evtTired #%i", time.str(), index ) )
		hook.rm(evtTired[index])
		evtTired[index] = nil
	end
	if evtIdle[index] ~= nil then
		-- print ( string.format( "\tRendezVous Event (%s) : removing evtIdle #%i", time.str(), index ) )
		hook.rm(evtIdle[index])
		evtIdle[index] = nil
	end
	if evtDeath[index] ~= nil then
		-- print ( string.format( "\tRendezVous Event (%s) : removing evtDeath #%i", time.str(), index ) )
		hook.rm(evtDeath[index])
		evtDeath[index] = nil
	end

	-- Mark the ship as being no more in system
	bExited[index] = true
end


function shipTiredToWait ( pilot )
	-- Debugging issue with index
	-- print ( string.format("\tRendezVous Event (%s) : executing shipTiredToWait hook",  time.str() ))

	-- Check pilot validity and find its index in global list
	local index = getPilotIndex(pilot, pilotSmugglers)

	-- Debug -- printout of outcome
	-- print ( string.format( "\tRendezVous Event (%s) : ship #%i \"%s\" tired to wait : set to jump out.", time.str(), index, pilot:name() ) )

	-- Make ship fly away to the end of its errand
	pilot:control()
	pilot:hyperspace(shipJumpDestination[index], true)

	-- Mark the ship has exited RdV point
	bRdV[index] = false
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on both ships
-- 
-- =======================================================================================
--

function cargoExchangeWait ( )
	-- Check both pilots validity
	local indexBound = {1,2}
	for index = 1,2 do
		if pilotSmugglers[index] == nil then
			-- print ( string.format( "\tRendezVous Event (cargoExchangeWait, %s) : pilot #%i is nil", time.str(), index ) )
			indexBound[index] = 3-index
		end
		if not pilotSmugglers[index]:exists() then
			-- print ( string.format( "\tRendezVous Event (cargoExchangeWait, %s) : pilot #%i exists no more", time.str(), index ) )
			indexBound[index] = 3-index
		end
	end

	-- Debug -- printout of outcome
	-- print (string.format( "\tRendezVous Event (%s) : exchange finished",  time.str() ))

	-- Make both ships fly away to the end of its errand
	for index = indexBound[1],indexBound[2] do
		-- print ( string.format( "\tRendezVous Event (%s) : ship #%i \"%s\" set to jump out after exchange", time.str(), index, pilotSmugglers[index]:name() ) )
		pilotSmugglers[index]:hyperspace(shipJumpDestination[index], true)
	end

	-- Remove any evtTired hook on both ships if need be
	for index = 1,2 do
		if evtTired[index] ~= nil then
			-- print ( string.format( "\tRendezVous Event (%s) : removing evtTired #%i", time.str(), index ) )
			hook.rm(evtTired[index])
			evtTired[index] = nil
		end
	end
end

function shipJumps ( pilot )
	-- Check pilot validity and find its index in global list
	local index = getPilotIndex(pilot, pilotSmugglers)

	-- Debug -- printout of outcome
	if pilot == nil then
		return
	end
	-- print ( string.format("\tRendezVous Event (%s) : ship #%i \"%s\" jumps out", time.str(), index, pilot:name() ))

	-- Mark the ship as being no more in system
	bExited[index] = true

	-- Remove evtTired hook on the jumping ship if need be
	if evtTired[index] ~= nil then
		-- print ( string.format( "\tRendezVous Event (%s) : removing evtTired #%i", time.str(), index ) )
		hook.rm(evtTired[index])
		evtTired[index] = nil
	end

	-- If both ships have exited system, terminate the event
	if bExited[1] and bExited[2] then
		-- print ( string.format( "\tRendezVous Event (%s) : both ships have exited system", time.str() ) )
		endEvent()
	end
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on player
-- 
-- =======================================================================================
--

function endEvent ()
	-- Debug -- printout of outcome
	-- print ( string.format("\tRendezVous Event (%s) : normal end of event", time.str() ) )

	-- The event finishes, but is not unique, so the player may still encounter the same ship
	evt.finish()
end

--
-- =======================================================================================
