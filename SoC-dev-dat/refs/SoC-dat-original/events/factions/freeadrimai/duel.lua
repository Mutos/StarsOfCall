--[[
-- Duel Event
-- 
-- Creates a Free Adrimai ship chasen by a Gham Garri ship.
-- The player can elect to choose a side or let them alone.
-- 
--]]


-- =======================================================================================
--
-- Setup script-global variables
-- 
-- =======================================================================================
--

-- Event name
evtPrefix = "evt_FreeAdrimai_Duel_001_"

-- Context
currentSystem = system.cur()

-- Controls for Free Adrimai faction
baseSpawnTimeFA			=    10
baseBroadcastTimeFA		= 10000
broadcastFA_ReplyPhase	=     1

-- Controls for Gham Garri faction
baseSpawnTimeGG			=  2000
baseBroadcastTimeGG		=  5000
broadcastGG_ReplyPhase	=     1
numPilotsGG				=     0

-- Management of other ships intervention
baseCheckShipTime		=  2000
percentAttackFA			=    currentSystem:presence("Gham Garri")/currentSystem:presence("all")*100
percentAttackGG			=    currentSystem:presence("Free Adrimai")/currentSystem:presence("all")*100
-- print ( string.format ( "\tPercentage of chance a ship will attack Free Adrim ship: %i",  percentAttackFA) )
-- print ( string.format ( "\tPercentage of chance a ship will attack Gham Garri fighters: %i",  percentAttackGG) )

-- Management of player intervention
playerAttackedFA		=     0
playerAttackedGG		=     0
othersAttackedFA		=     0
othersAttackedGG		=     0

-- Get player character species
pcSpecies = var.peek ("pc_species")

-- Get number of previous encounters
evtPreviousEncounters = var.peek (evtPrefix .. "previousEncounters")
if evtPreviousEncounters == nil then
	evtPreviousEncounters = 0
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Setup dialogs
-- 
-- =======================================================================================
--

lang = naev.lang()
if lang == "es" then
	-- not translated atm
else -- default english 
	-- The ship will have a unique name
	shipname = "Oti neh Irith"

	-- Broadcasts
	broadcastFA_Attacked = {
		"This is passenger ship %s. We are under attack. Requesting immediate assistance."
	}
	broadcastFA_Reply = {
		"This is %s. Indeed we are Adrimai, but we are as alive as yourself.",
		"This is %s. We are living beings, don't let these criminals kill us."
	}
	broadcastFA_NoMoreEnemy = {
		"This is %s. All the criminals have been dispatched.",
		"This is %s. It's a pity, but false honor leads to that.",
		"This is %s. We are peaceful, but we know how to fend for ourselves."
	}
	broadcastFA_Destroyed = {
		"We are fading through the Eclipse. May the living have mercy on us!"
	}
	broadcastFA_Jumped = {
		"Thanks to all who helped us! Get free from these Gham Garri lies!"
	}
	broadcastGG_Reply = {
		"Don't listen to the voice of the ghost ship.",
		"This moonless derelict must be gotten rid of at once.",
		"Don't listen to these wretched ghosts.",
		"He who listens to the Adrimai' voice, Adrim he will become."
	}
	broadcastGG_Attacked = {
		"The ghost ship is attacking me!",
		"I'll not let you get me, you damned ghost!",
		"There's nothing you can do against the Keepers of Honor!",
		"Blow these abominations out of the sky!"
	}
	broadcastGG_Death = {
		"I come down for the honor of the Rithai!",
		"My heirs will claim your true death!",
		"My clan will avenge me!",
		"Blow these abominations out of the sky!"
	}
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

--
-- =======================================================================================


-- =======================================================================================
--
-- Main event function
-- 
-- =======================================================================================
--

function create ()
	-- Script-global variables for convoy origin and destination
	-- Passed as arguments to the hooks
	convoyJumpOrigin		= nil
	convoyLandOrigin		= nil
	convoyJumpDestination	= nil
	convoyLandDestination	= nil

	-- Tell we're entering the event
	-- print (string.format("\nEntering %s Convoy Event", faction))

	-- Set the Free Adrim ship's course between two jump points
	convoyJumpOrigin, convoyLandOrigin, convoyJumpDestination, convoyLandDestination = setPassThroughCourse(faction, true, nil)

	-- No destination at all : don't create the ship and abort the event
	if convoyLandDestination == nil and convoyJumpDestination == nil then
		-- print (string.format("Exiting %s Convoy Event because no convoy could be created", faction))
		evt.finish()
		return
	end

		-- Set hooks on player pilot
	hook.land("survivedEvent")
	hook.jumpout("survivedEvent")

	-- Spawn Free Adrimai ship after a few seconds
	hook.timer(baseSpawnTimeFA + rnd.rnd(1, baseSpawnTimeFA), "spawnFreeAdrim")
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Spawning functions for both protagonist factions
-- 
-- =======================================================================================
--

function spawnFreeAdrim ()
	-- Create the Free Adrimai transport.
	-- print (string.format("\tFree Adrimai ship jumping in from %s",convoyJumpOrigin:name()))
	pilotFA = pilot.add("Irali", "dummy", convoyJumpOrigin)

	-- Set ship's characteristics
	for k,v in ipairs(pilotFA) do
		  v:rename(shipname)
		v:setFaction("Free Adrimai")
		v:rmOutfit("all")
		v:addOutfit("Small Flak Turret", 2)
		v:control()
		-- Set destination
		-- print (string.format("\Free Adrim ship jumping out to %s",convoyJumpDestination:name()))
		v:hyperspace(convoyJumpDestination, true)

		-- Added extra visibility for big systems (A.)
		v:setVisplayer( true )
		-- v:setHilight( true )
	end

	-- Set hooks on Free Adrimai ship
	hook.pilot( pilotFA[1], "death", "destroyEventFA" )
	hook.pilot( pilotFA[1], "jump", "jumpEventFA" )
	hook.pilot( pilotFA[1], "attacked", "attackedEventFA" )

	-- Set hook for spawning Gham Garri ships a little later
	hook.timer(baseSpawnTimeGG + rnd.rnd(1, baseSpawnTimeGG), "spawnAttackers")
end

function spawnAttackers ()
	-- Create a fighter squadron to attack the Free Adrimai ship.
	pilotGG = {}
	local minPilots = evtPreviousEncounters-2
	if minPilots < 2 then
		minPilots = 2
	end
	local maxPilots = evtPreviousEncounters+2
	if minPilots > 7 then
		minPilots = 7
	end
	numPilotsGG = rnd.rnd(minPilots,maxPilots)
	local newPilot = nil
	-- print (string.format("\tFree Adrimai previous encounters: %i", evtPreviousEncounters))
	-- print (string.format( "\tNumber of Gham Garri fighters (%i) => [%i;%i]: %i", evtPreviousEncounters, minPilots, maxPilots, numPilotsGG))
	-- print (string.format("\tGham Garri ships jumping in from %s",convoyJumpOrigin:name()))
	for i=1,numPilotsGG do
		newPilot = pilot.add("Nelk'Tan", nil, convoyJumpOrigin)
		table.insert(pilotGG, newPilot [1])
	end

	-- Set ship's characteristics
	for k,v in ipairs(pilotGG) do
		  v:rename("Gham Garri Fighter")
		v:setFaction("Gham Garri")
		v:rmOutfit("all")
		v:addOutfit("Fighter Laser Cannon", 4)

		-- Set orders to attack Free Adrimai ship
		v:control()
		v:attack(pilotFA[1])

		-- Added extra visibility for big systems (A.)
		v:setVisplayer( true )
		-- v:setHilight( true )

		-- Set hooks on Gham Garri ship
		hook.pilot( v, "attacked", "attackedEventGG" )
		hook.pilot( v, "death", "deathEventGG" )
		hook.pilot( v, "exploded", "explodedEventGG" )
	end
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Event managers for the Free Adrim ship
-- 
-- =======================================================================================
--

function attackedEventFA(pilot, attacker)
	if not pilot:exists() then
		return
	end
	if broadcastFA_ReplyPhase == 1 then
		-- Brodcast when attacked for the first time
		pilot:broadcast( string.format( textSelection(broadcastFA_Attacked) , shipname ), true )
		broadcastFA_ReplyPhase = 2
		-- Setup timer to broadcast further defiance messages
		hook.timer(baseBroadcastTimeFA + rnd.rnd(1, baseBroadcastTimeFA), "broadcastEventFA", pilot)
		-- Setup timer to check other pilots for intervention
		hook.timer(baseCheckShipTime + rnd.rnd(1, baseCheckShipTime), "checkOthersAttackEvent")
	end
	if attacker == player.pilot() then
		playerAttackedFA = playerAttackedFA + 1
		-- print (string.format("\tPlayer attacked Free Adrimai ship %i times", playerAttackedFA))
	else
		found = false
		for k,v in ipairs(pilotGG) do
			found = found or attacker == v
		end
		if not found then
			-- print "\tA non-Gham Garri ship attacked Free Adrimai ship"
			othersAttackedFA = othersAttackedFA + 1 
		end
	end
end

-- Ship broadcasts an SOS every 15 to 25 seconds, until destroyed.
function broadcastEventFA(pilot)
	-- Setup next execution
	hook.timer(baseBroadcastTimeFA + rnd.rnd(1, baseBroadcastTimeFA), "broadcastEventFA", pilot)

	-- Basic arguments check
	if not pilot:exists() then
		return
	end

	-- Are there still Gham Garri fighters alive ? Else no reason to broadcast 
	if #pilotGG == 0 then
		return
	end

	-- Broadcast phase OK ?
	if broadcastFA_ReplyPhase == 2 then
		pilot:broadcast( string.format(textSelection(broadcastFA_Reply), shipname), true )
	end
end

function destroyEventFA (pilot)
	if not pilot:exists() then
		return
	end
	pilot:broadcast( textSelection(broadcastFA_Destroyed), true )

	-- Make remaining Gham Garri ships come back from where they came
	for k,v in ipairs(pilotGG) do
		if v:exists() then
			v:hyperspace(convoyJumpOrigin)
		end
	end

	-- The event finishes and cannot be played again as the Free Adrimai ship has been destroyed
	var.pop (evtPrefix .. "previousEncounters")
	killedEvent()
 end

function jumpEventFA (pilot)
	if not pilot:exists() then
		return
	end

	-- Free Adrimai ship broadcasts a thanks message before leaving
	if broadcastFA_ReplyPhase == 2 then
		pilot:broadcast( textSelection(broadcastFA_Jumped), true )
	end

	-- Make remaining Gham Garri ships follow their prey
	for k,v in ipairs(pilotGG) do
		if v:exists() then
			v:hyperspace(convoyJumpDestination)
		end
	end
	
	-- The event finishes, but we may still encounter the same ship
	survivedEvent()
 end

--
-- =======================================================================================


-- =======================================================================================
--
-- Event managers for the Gham Garri ships
-- 
-- =======================================================================================
--

function attackedEventGG(pilot, attacker)
	if not pilot:exists() then
		return
	end
	if rnd.rnd()<=0.05 then
		pilot:broadcast( textSelection(broadcastGG_Attacked), true )
	end
	if attacker == player.pilot() then
		playerAttackedGG = playerAttackedGG + 1
		-- print (string.format("\tPlayer attacked Gham Garri ships %i times", playerAttackedGG))
	else
		if attacker ~= pilotFA[1] then
			-- print "\tA non-Free-Adrimai ship attacked Gham Garri ships"
			othersAttackedGG = othersAttackedGG + 1 
		end
	end
end

function deathEventGG (pilot, attacker)
	if not pilot:exists() then
		return
	end

	-- 1/5 of fighters will broadcast
	if rnd.rnd()<=0.2 then
		pilot:broadcast( textSelection(broadcastGG_Death), true )
	end
end

function explodedEventGG (pilot, attacker)
	-- Remove the pilot from the table
	for k,v in ipairs(pilotGG) do
		if not v:exists() then
			table.remove(pilotGG,k)
		end
	end
	
	-- If this was the last Gham Garri pilot, then the Free Adrimai ship will broadcast
	if #pilotGG == 0 then
		pilotFA[1]:broadcast( string.format(textSelection(broadcastFA_NoMoreEnemy), shipname), true )
		-- print ( "\t\tLast Gham Garri fighter destroyed" )
		cleanAttackOrdersGG()
	end
 end

--
-- =======================================================================================


-- =======================================================================================
--
-- Hooks to get other pilots attack one of the duelling parties
-- 
-- =======================================================================================
--

function checkOthersAttackEvent ()
	-- print ( "\tcheckOthersAttackEvent" )

	-- Setup next execution
	hook.timer(baseCheckShipTime + rnd.rnd(1, baseCheckShipTime), "checkOthersAttackEvent")

	-- Get all pilots in system
	local pilots = pilot.get({ faction.get("Independent") })
	if pilots == nil then
		-- print ( "\t\tNo active Independent pilots in system" )
		return
	end

	-- Get a random pilot
	pilotToCheck = pilots[rnd.rnd(1,#pilots)]
	-- print ( string.format("\t\tPilot to check : %s", pilotToCheck:name()))

	-- Check pilot existence
	if not pilotToCheck:exists() then
		-- print ( "\t\tPilot does not exist anymore" )
		return
	end

	-- Check if pilot has already chosen a side
	if pilotToCheck:memoryCheck( evtPrefix .. "shipMarkedForAttack" ) ~= nil then
		-- print ( string.format("\t\tPilot is already attacking %s", pilotToCheck:memoryCheck( evtPrefix .. "shipMarkedForAttack" ) ) )
		return
	end

	randomNumber = rnd.rnd()
	if randomNumber < (percentAttackFA/100) and pilotFA[1]:exists() then
		pilotToCheck:control()
		pilotToCheck:taskClear()
		pilotToCheck:attack(pilotFA[1])
		pilotToCheck:setVisplayer( true )
		pilotToCheck:memory( evtPrefix .. "shipMarkedForAttack", "FA" )
		-- print ( "\t\tPilot will attack Free Adrimai ship" )
		-- pilotToCheck:broadcast ( string.format ( "Pilot %s will attack Free Adrimai ship", pilotToCheck:name() ) )
	elseif randomNumber > (1-percentAttackGG/100) and #pilotGG>0 and pilotGG[1]:exists() then
		pilotToCheck:control()
		pilotToCheck:taskClear()
		pilotToCheck:attack(pilotGG[1])
		pilotToCheck:setVisplayer( true )
		pilotToCheck:memory( evtPrefix .. "shipMarkedForAttack", "GG" )
		-- print ( "\t\tPilot will attack lead Gham Garri fighter" )
		-- pilotToCheck:broadcast ( string.format ( "Pilot %s will attack lead Gham Garri fighter", pilotToCheck:name() ) )
	else
		-- Pilot formally chose not to interfere and will not change decision
		pilotToCheck:memory( evtPrefix .. "shipMarkedForAttack", "None" )
		-- print ( "\t\tPilot will not take side" )
		-- pilotToCheck:broadcast ( string.format ( "Pilot %s will not take side", pilotToCheck:name() ) )
	end
end

function returnIndependentPilotToAuto (pilot)
	-- print and broadcast for debug
	-- print ( string.format ( "\tReturning pilot %s to automatic AI.", pilot:name() ) )
	-- pilot:broadcast ( string.format ( "\tReturning pilot %s to automatic AI.", pilot:name() ) ) 
	pilot:control(false)
end

function cleanAttackOrdersFA ()
	-- Get all pilots in system
	local pilots = pilot.get({ faction.get("Independent") })
	if pilots == nil then
		return
	end
	-- For now, list their status
	-- print ( "\tcleanAttackOrdersFA: list of pilots in system:" )
	for i, j in ipairs (pilots) do
		attackFlag = j:memoryCheck( evtPrefix .. "shipMarkedForAttack" )
		if attackFlag == nil then
			attackFlag = "none"
		end 
		-- j:broadcast ( string.format( "\t\t%s : %s", j:name(), attackFlag ) )
		-- print ( string.format( "\t\t%s : %s", j:name(), attackFlag ) )
		if attackFlag == "FA" then
			j:control(false)
			-- print ( "\t\t\tFreeing ship from orders" )
		end 
	end
end

function cleanAttackOrdersGG ()
	-- Get all pilots in system
	local pilots = pilot.get({ faction.get("Independent") })
	if pilots == nil then
		return
	end
	-- For now, list their status
	-- print ( "\tcleanAttackOrdersGG: list of pilots in system:" )
	for i, j in ipairs (pilots) do
		attackFlag = j:memoryCheck( evtPrefix .. "shipMarkedForAttack" )
		if attackFlag == nil then
			attackFlag = "none"
		end 
		-- j:broadcast ( string.format( "\t\t%s : %s", j:name(), attackFlag ) )
		-- print ( string.format( "\t\t%s : %s", j:name(), attackFlag ) )
		if attackFlag == "GG" then
			j:control(false)
			-- print ( "\t\t\tFreeing ship from orders" )
		end 
	end
end

--
-- =======================================================================================


-- =======================================================================================
--
-- End of Event hooks
-- 
-- =======================================================================================
--

function survivedEvent ()
	-- Debug -- printout of outcome
	-- print ("\tFree Adrimai ship survived")
	cleanAttackOrdersFA()

	-- If the player attacked either side, then earn reputation
	local repDelta = getRepDelta(playerAttackedFA, playerAttackedGG, 2, 10)
	-- print (string.format("\tReputation shift towards FA [FA=%i;GG=%i] => %f", playerAttackedFA, playerAttackedGG, repDelta))
	faction.get( "Free Adrimai" ):modPlayer( repDelta )

	-- The event finishes, but we may still encounter the same ship
	evtPreviousEncounters = evtPreviousEncounters + 1
	var.push (evtPrefix .. "previousEncounters", evtPreviousEncounters)
	evt.finish()
end

function killedEvent ()
	-- Debug -- printout of outcome
	-- print ("\tFree Adrimai ship was killed")
	cleanAttackOrdersFA()

	-- If the player attacked either side, then earn reputation
	local repDelta = getRepDelta(playerAttackedFA, playerAttackedGG, 2, 10)
	-- print (string.format("\tReputation shift with FA [FA=%i;GG=%i] => %f", playerAttackedFA, playerAttackedGG, repDelta))
	faction.get( "Free Adrimai" ):modPlayer( repDelta )

	-- The event finishes, but we may still encounter the same ship
	var.pop (evtPrefix .. "previousEncounters")
	evt.finish(true)
end

--
-- =======================================================================================
