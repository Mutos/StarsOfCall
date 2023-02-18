--[[
-- Miner ships
-- 
-- Creates miner ships that go to asteroids and stop there to mine them
-- 
--]]


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_Miners_001_"

-- Spawn time : base time +/- percentage
spawnTimeBase			= 40000		-- Milliseconds
spawnTimePercent		=    75		-- Percents

-- Spawn probability
spawnProbaVariant		=    10		-- Percents

-- Wait timing : base time +/- percentage
waitTimeBase			= 90000
waitTimePercent			=    15

-- Parameters for setting mining points
--   Offset the RdV point by a random distance and angle
miningDistBase			=   400
miningDistPercent		=    25

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
pilotMiners		= {}

-- Management of player intervention
playerAttacked			=     0

-- Get player character species
pcSpecies = var.peek ("pc_species")

-- Hooks
evtIdle		= {}
evtTired	= {}
evtDeath	= {}
evtJump		= {}

-- Asteroids Clusters in system
asteroidsClustersList = {}
posMining = {}
tgtMining = {}

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
	-- Tell we're entering the event
	print ( string.format( "\nMiners Event (%s) : entering event create() for faction \"%s\"", time.str(), faction))

	-- Built list of asteroids clusters in system
	for k,v in ipairs( currentSystem:planets() ) do
		if string.match( v:name(), "Asteroids Cluster" ) ~= nil then
			table.insert( asteroidsClustersList, v )
		end
	end

	-- Print list of asteroids clusters in system
	print ( string.format( "Miners Event (%s) : \tAsteroids Clusters list for system \"%s\"", time.str(), currentSystem:name() ) )
	for k,v in ipairs( asteroidsClustersList ) do
		-- print ( string.format( "Miners Event (%s) : \t\t%s", time.str(), v:name() ) )
	end
	print ( string.format( "Miners Event (%s) : \tEnd of Asteroids Clusters list", time.str() ) )

	-- If there is asteroids, then hooks a timer to spawn the first ship
	if #asteroidsClustersList ~= 0 then
		local spawnTime = spawnTimeBase * ( 1 + rnd.rnd(-spawnTimePercent, spawnTimePercent)/100 )
		hook.timer( spawnTime, "spawnShip" )
		print ( string.format( "Miners Event (%s) : \tSpawn hook in %i ms", time.str(), spawnTime ) )
	else
		-- No further need for the event, close it directly
		print ( string.format( "Miners Event (%s) : exiting event create() : no event created", time.str()))
		evt.finish()
	end

	-- Set hooks on player pilot
	hook.land("endEvent")
	hook.jumpout("endEvent")

	-- Tell we're exiting the event
	print ( string.format( "Miners Event (%s) : exiting event create() : event created", time.str()))
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Spawn a mining ship and send it to a random asteroids cluster
-- 
-- =======================================================================================
--

function spawnShip( )
	-- Tell we're entering the event
	-- print ( string.format( "\nMiners Event (%s) : entering spawnShip()", time.str()))

	-- Flag to see if we actually create a ship
	local spawnFlag = true

	-- Printing out initial conditions
	-- print ( string.format( "Miners Event (%s) : \t%i ships already there for %i asteroids clusters", time.str(), #pilotMiners, #asteroidsClustersList ) )
	-- displayMinerPilots()

	-- If there are too few asteroids, don't spawn a new ship
	local probability = 50 + spawnProbaVariant*(#asteroidsClustersList - #pilotMiners)
	local randomPercent = rnd.rnd()*100
	-- print ( string.format( "Miners Event (%s) : \tRandom : %i/%i", time.str(), randomPercent, probability ) )
	if randomPercent >= probability  then
		-- print ( string.format( "Miners Event (%s) : \tRandom number out of bounds : no ship will be generated.", time.str() ) )
		spawnFlag = false
	end

	-- Select a ship name, but don't spawn if a ship with the same name already exists in the system
	local shipName = selectShipName({"miner"})
	local pilotAll = pilot.get( nil, true )
	local nameFound = false
	for k,v in ipairs(pilotAll) do
		if v == nil then
			-- print ( string.format( "Miners Event (%s) : \tpilot is nil in name search", time.str() ) )
		elseif not v:exists() then
			-- print ( string.format( "Miners Event (%s) : \tpilot is invalid in name search", time.str() ) )
		else
			if v:name() == shipName then
				-- print ( string.format( "Miners Event (%s) : \tName already used : no ship will be generated.", time.str() ) )
				nameFound = true
			end
		end
	end
	if nameFound  then
		-- print ( string.format( "Miners Event (%s) : \tname \"%s\" already taken : no ship will be generated.", time.str(), shipName ) )
		spawnFlag = false
	end

	if spawnFlag then
		-- Set the ship's type
		local shipType = selectShipType({"miner"})
		-- print ( string.format( "Miners Event (%s) : \tSpawning ship \"%s\" of type \"%s\"", time.str(), shipName, shipType ) )

		-- Actually generate the ship
		local newFleet = pilot.add(shipType, "dummy", true)

		-- Set the ship's parameters
		for k,v in ipairs(newFleet) do
			-- Store ship on global variable
			table.insert( pilotMiners, v )

			-- Set name and faction
			v:setFaction("Independent")
			v:rename(shipName)

			-- Add extra visibility for debug and big systems
			-- v:setVisplayer( true )
			-- v:setHilight( true )

			-- Set the ship's mining sector at a random Asteroids Cluster
			local index = rnd.rnd(1, #asteroidsClustersList)
			tgtMining[#pilotMiners] = asteroidsClustersList[index]
			-- print ( string.format( "Miners Event (%s) : \tShip going to \"%s\"", time.str(), tgtMining[#pilotMiners]:name() ) )
			local angle	= rnd.rnd() * 2 * math.pi
			local dist	= miningDistBase * (1 + rnd.rnd(-miningDistPercent, miningDistPercent)/100)
			posMining[#pilotMiners] = tgtMining[#pilotMiners]:pos() + vec2.new( dist * math.cos(angle), dist * math.sin(angle) )

			-- Set orders to go to the mining sector
			v:control(true)
			v:goto(posMining[#pilotMiners])

			-- Set hooks on ship
			evtIdle[#pilotMiners]	= hook.pilot( v, "idle", "shipIdleEvent" )
			evtTired[#pilotMiners]	= -1
			evtJump[#pilotMiners]	= hook.pilot( v, "jump", "shipJumpEvent" )
			evtDeath[#pilotMiners]	= hook.pilot( v, "death", "shipDeathEvent" )

			-- Debugging issue with index
			-- print ( string.format( "Miners Event (%s) : \t%i ships", time.str(), #pilotMiners ) )
			-- displayMinerPilots()
		end
	end

	-- Hooks a new timer to spawn the next ship
	local spawnTime = spawnTimeBase * ( 1 + rnd.rnd(-spawnTimePercent, spawnTimePercent)/100 )
	hook.timer( spawnTime, "spawnShip" )
	-- print ( string.format( "Miners Event (%s) : \tNew spawn hook in %i ms", time.str(), spawnTime ) )

	-- Tell we're exiting the event
	-- print ( string.format( "Miners Event (%s) : exiting spawnShip()", time.str()))
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks on ships
-- 
-- =======================================================================================
--

function shipIdleEvent ( pilot )
	-- print ( string.format( "\nMiners Event (%s) : entering shipIdleEvent()", time.str() ) )

	-- Debugging issue with index
	-- print ( string.format( "Miners Event (%s) : \t%i ships", time.str(), #pilotMiners ) )
	-- displayMinerPilots()

	-- Check pilot validity and find its index in global list
	if pilot == nil then
		-- print ( string.format( "Miners Event (%s) : \tpilot is nil in idle event", time.str() ) )
		return
	elseif not pilot:exists() then
		-- print ( string.format( "Miners Event (%s) : \tpilot is invalid in idle event", time.str() ) )
		return
	end
	local index = getPilotIndex(pilot, pilotMiners)

	-- Debug -- printout of outcome
	local xs, ys = pilot:pos():get()
	local xm, ym = posMining[index]:get()
	local xt, yt = tgtMining[index]:pos():get()
	-- print ( string.format( "Miners Event (%s) : \tship #%i \"%s\" is idle at [%i;%i] for [%i, %i] in Asteroid Cluster at [%i, %i]", time.str(), index, pilot:name(), xs, ys, xm, ym, xt, yt ) )

	-- Remove the event, it must not be fired twice
	-- print ( string.format( "Miners Event (%s) : \tremoving evtIdle #%i", time.str(), index ) )
	hook.rm( evtIdle[index] )
	evtIdle[index] = -1

	-- Set timer for maximum wait time
	-- print ( string.format( "Miners Event (%s) : \tsetting evtTired #%i", time.str(), index ) )
	evtTired[index] = hook.timer(waitTimeBase * (1 + rnd.rnd(-waitTimePercent/100, waitTimePercent/100)), "shipTiredToWait", pilot )

	-- Debugging issue with index
	-- print ( string.format( "Miners Event (%s) : \t%i ships", time.str(), #pilotMiners ) )
	-- displayMinerPilots()

	-- print ( string.format( "Miners Event (%s) : exiting shipIdleEvent()", time.str() ) )
end


function shipTiredToWait ( pilot )
	-- print ( string.format( "\nMiners Event (%s) : entering shipTiredToWait()", time.str() ) )

	-- Debugging issue with index
	-- print ( string.format( "Miners Event (%s) : \t%i ships", time.str(), #pilotMiners ) )
	-- displayMinerPilots()

	-- Check pilot validity
	if pilot == nil then
		-- print ( string.format( "Miners Event (%s) : \tpilot is nil in tired event", time.str() ) )
		return
	elseif not pilot:exists() then
		-- print ( string.format( "Miners Event (%s) : \tpilot is invalid in tired event", time.str() ) )
		return
	end

	-- Find pilot index in global list
	local index = getPilotIndex(pilot, pilotMiners)

	-- Debug -- printout of outcome
	-- print ( string.format( "Miners Event (%s) : \tship #%i \"%s\" tired to wait : set to jump out.", time.str(), index, pilot:name() ) )

	-- Removing hook, it must not be fired twice
	-- print ( string.format( "Miners Event (%s) : \tremoving evtTired #%i", time.str(), index ) )
	hook.rm( evtTired[index] )
	evtTired[index] = -1

	-- Make ship fly away to the end of its errand
	pilot:control()
	pilot:hyperspace(nil, true)

	-- Debugging issue with index
	-- print ( string.format( "Miners Event (%s) : \t%i ships", time.str(), #pilotMiners ) )
	-- displayMinerPilots()

	-- print ( string.format( "Miners Event (%s) : exiting shipTiredToWait()", time.str() ) )
end


function shipJumpEvent ( pilot )
	-- print ( string.format( "\nMiners Event (%s) : entering shipJumpEvent()", time.str() ) )

	shipExitsSystem(pilot)

	-- print ( string.format( "Miners Event (%s) : exiting shipJumpEvent()", time.str() ) )
end


function shipDeathEvent ( pilot )
	-- print ( string.format( "\nMiners Event (%s) : entering shipDeathEvent()", time.str() ) )

	shipExitsSystem(pilot)

	-- print ( string.format( "Miners Event (%s) : exiting shipDeathEvent()", time.str() ) )
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
	-- print ( string.format( "\tMiners Event (%s) : normal end of event", time.str() ) )

	-- The event finishes, but is not unique, so the player may still encounter mining ships
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

function shipExitsSystem ( pilot )
	-- print ( string.format( "\nMiners Event (%s) : entering shipExitsSystem()", time.str() ) )

	-- Check pilot validity and find its index in global list
	if pilot == nil then
		-- print ( string.format( "Miners Event (%s) : \tpilot is nil in exit event", time.str() ) )
		return
	elseif not pilot:exists() then
		-- print ( string.format( "Miners Event (%s) : \tpilot is invalid in exit event", time.str() ) )
		return
	end

	-- Find pilot's index in global list
	local index = getPilotIndex(pilot, pilotMiners)

	-- Debug -- printout of outcome
	-- print ( string.format( "Miners Event (%s) : \tship #%i \"%s\" died", time.str(), index, pilot:name() ) )

	-- Remove any remaining hook on the defunct ship
	if evtIdle[index] ~= -1 then
		-- print ( string.format( "Miners Event (%s) : \tremoving evtIdle #%i", time.str(), index ) )
		hook.rm(evtIdle[index])
		evtIdle[index] = -1
	end
	if evtTired[index] ~= -1 then
		-- print ( string.format( "Miners Event (%s) : \tremoving evtTired #%i", time.str(), index ) )
		hook.rm(evtTired[index])
		evtTired[index] = -1
	end
	if evtJump[index] ~= -1 then
		-- print ( string.format( "Miners Event (%s) : \tremoving evtJump #%i", time.str(), index ) )
		hook.rm(evtJump[index])
		evtJump[index] = -1
	end
	if evtDeath[index] ~= -1 then
		-- print ( string.format( "Miners Event (%s) : \tremoving evtDeath #%i", time.str(), index ) )
		hook.rm(evtDeath[index])
		evtDeath[index] = -1
	end

	-- Actually remove its rank on the lists
	-- print ( string.format( "Miners Event (%s) : \tcompacting all tables", time.str() ) )
	table.remove(pilotMiners, index)
	table.remove(posMining,   index)
	table.remove(tgtMining,   index)
	table.remove(evtIdle,     index)
	table.remove(evtTired,    index)
	table.remove(evtJump,     index)
	table.remove(evtDeath,    index)

	-- print ( string.format( "Miners Event (%s) : exiting shipExitsSystem()", time.str() ) )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- DEBUG helper functions
-- 
-- =======================================================================================
--

function displayMinerPilots ()
	for k,v in ipairs(pilotMiners) do
		if v ~= nil and v:exists() then
			local sIdle, sTired, sJump, sDeath
			if evtIdle[k] == -1 then
				sIdle = "nil"
			else
				sIdle = tostring(evtIdle[k])
			end
			if evtTired[k] == -1 then
				sTired = "nil"
			else
				sTired = tostring(evtTired[k])
			end
			if evtJump[k] == -1 then
				sJump = "nil"
			else
				sJump = tostring(evtJump[k])
			end
			if evtDeath[k] == -1 then
				sDeath = "nil"
			else
				sDeath = tostring(evtDeath[k])
			end
			-- print ( string.format( "Miners Event (%s) : \t\t[%i] \"%s\" [evtIdle(total %i)=%s]  [evtTired(total %i)=%s]  [evtJump(total %i)=%s]  [evtDeath(total %i)=%s]", time.str(), k, v:name(), #evtIdle, sIdle, #evtTired, sTired, #evtJump, sJump, #evtDeath, sDeath ) )
		end
	end
end

--
-- =======================================================================================
