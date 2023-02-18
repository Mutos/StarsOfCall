--[[
	These are smuggling missions proposed by NPCs in bars.
	They consist of rendez-vous with a ship in a system, load a cargo, travel to a second system and rendez-vous with another ship. 
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
msnPrefix = "msn_Cargo_Smuggling_001_"

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- Parameters
-- Declared local to not be saved, as they are reinititlized each time the script is invoked.
local distanceMin           =     2
local distanceInterval      =     2
local cargoMin              =     1
local cargoMax              =    10
local rewardPerJump         =  3000
local rewardVariancePercent =    10

-- Variables
-- Declared global to be saved, only numbers and strings 
systemStart                 = nil
systemStartMarker           = nil
systemStartHook             = nil
systemEnd                   = nil
systemEndMarker             = nil
systemEndHook               = nil
cargo                       = "Smuggled Items"
amount                      = 0
reward                      = 0
ship1Name                   = ""
ship1Type                   = ""
ship2Name                   = ""
ship2Type                   = ""
currentPhase                = 0
shipPilot                  = nil

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
	misn_desc = "Transfer %d tons of smuggled cargo between a %s named %s in system %s and a %s named %s in system %s."
	misn_reward = "%d cr."

	-- What if you don't have enough room in your ship ?
	full = {}
	full[1] = "No room in ship"
	full[2] = "You don't have enough cargo space to accept this mission. You need %d tons of free space (you need %d more)."

	-- NPC - first taken from Joanne
	merchantGFX  = "human/neutral/unique/joanne"
	merchantName = "A merchant"
	merchantDesc = "A merchant sits here, enjoying a drink by herself."

	-- Dialogue with the NPC
	titleAsk = "A merchant who knows your name"
	textAsk  = [["Hello there %s," the merchant greets you. "We've heard about you here. I may have a job for you. A simple thing. Go to the system %s and find a friend of mine. They got %d tons of payload, that I want transferred to another friend in system %s. Pay is good at %d cr, risks are low, what do you say ?"]]

	-- Mission accepted
	accept_title = "Mission Accepted"

	-- On-Screen-Display title and lines
	osd_title = "Smuggling"
	osd_msg = {}
	osd_msg[1] = "Go to the %s system."
	osd_msg[2] = "Rendez-vous with %s."
	osd_msg[3] = "Go to the %s system."
	osd_msg[4] = "Rendez-vous with %s."

	-- Dialogue with the ships (index is currentPhase : 2,5)
	textHail = {}
	textHail[2]  = "Now we're both there, let's proceed for cargo transfer."
	textHail[5]  = "Now we're both there, let's proceed for cargo transfer."

	-- Boarding texts
	titleBoard = {}
	titleBoard[1] = "Cargo transfer"
	titleBoard[2] = "Cargo transfer"
	textBoard = {}
	textBoard[1]  = "After the ships are successfully docked, loading drones proceed to transfer the cargo from your contact's holds to yours."
	textBoard[2]  = "After the ships are successfully docked, loading drones proceed to transfer the cargo from your holds to your contact's."

	-- Goodbye text
	textGoodbye = {}
	textGoodbye[1] = "Farewell and give my regards to the captain of the %s"
	textGoodbye[2] = "Here's your pay, I'll take good care of the cargo, see you later, %s."
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
include "jumpdist_filters.lua"
include "cargo_common.lua"
include "patrol_common.lua"
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
--	create()	From mission.xml, when landing, creates display in the Missions panel
--	accept()	"Accept" button from Mission Computer
--	abort()	"Abort" button from Mission tab of the Information window
-- 
-- =======================================================================================
--

-- Create the mission
function create()
	local strPrefix = "smugglers-001.lua:create()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Get the current system and planet
	local base_planet, base_sys = planet.cur()
	local systems = {}

	-- Get a list of isolated systems from the current system
	systems = getsysatdistance( base_sys, distanceMin, distanceMin+distanceInterval,
		function(s)
			return (
				filters.IsNotSystem(s)
					and
				not filters.HasLandable(s)
					and
				filters.HasLessPresence(s, 50)
			)
		end
	)
	if systems==nil or #systems==0 then
		-- DEBUG
		-- dbg.stdOutput( strPrefix, 1, "no suitable end system found", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		misn.finish()
	end
	-- -- print ( string.format( "\t%i systems selected for start :", #systems ) )
	for key,sys in ipairs ( systems ) do
		-- -- print ( string.format( "\t\t%s",  sys:name() ) )
	end
	systemStart=systems[rnd.rnd(1, #systems)]

	-- Get a list of isolated systems from the starting system
	systems = getsysatdistance( systemStart, distanceMin, distanceMin+distanceInterval,
		function(s)
			return (
				filters.IsNotSystem(s)
					and
				filters.IsNotSystem(s, systemStart)
					and
				not filters.HasLandable(s)
					and
				filters.HasLessPresence(s, 50)
			)
		end
	)
	if systems==nil or #systems==0 then
		-- DEBUG
		dbg.stdOutput( strPrefix, 1, "no suitable end system found", boolDebug )
		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		misn.finish()
	end
	-- print ( string.format( "\t%i systems selected for end :", #systems ) )
	for key,sys in ipairs ( systems ) do
		-- print ( string.format( "\t\t%s",  sys:name() ) )
	end
	systemEnd=systems[rnd.rnd(1, #systems)]

	-- Exchange systems if End is closer than Start
	if systemEnd:jumpDist() > systemStart:jumpDist() then
		-- print ( string.format( "\tSystems distances OK" ) )
	else
		-- print ( string.format( "\tExchanging systems" ) )
		systemStart, systemEnd = systemEnd, systemStart
	end

	-- Debug : print systems
	local tabFactionsList = {}
	local tabSpeciesList = {}
	-- print ( string.format( "\tStarting system : %s", systemStart:name() ) )
	for strFaction, intPresence in pairs(systemStart:presences()) do
		-- print ( string.format( "\t\t%s : %i", strFaction, intPresence ) )
		table.insert(tabFactionsList, strFaction)
		for intIndex, strSpecies in pairs(selectSpeciesList({strFaction})) do
			-- print ( string.format( "\t\t\t%s", strSpecies ) )
		end
	end
	for intIndex, strSpecies in pairs(selectSpeciesList(tabFactionsList)) do
		-- print ( string.format( "\t\t%s", strSpecies ) )
		table.insert(tabSpeciesList, strSpecies)
	end
	tabFactionsList = {}
	-- print ( string.format( "\tEnding system : %s", systemEnd:name() ) )
	for strFaction, intPresence in pairs(systemEnd:presences()) do
		-- print ( string.format( "\t\t%s : %i", strFaction, intPresence ) )
		table.insert(tabFactionsList, strFaction)
		for intIndex, strSpecies in pairs(selectSpeciesList({strFaction})) do
			-- print ( string.format( "\t\t\t%s", strSpecies ) )
		end
	end
	for intIndex, strSpecies in pairs(selectSpeciesList(tabFactionsList)) do
		-- print ( string.format( "\t\t%s", strSpecies ) )
		table.insert(tabSpeciesList, strSpecies)
	end

	-- Get the ships' names and types
	-- Both ship can have the same type, but not the same name !
	local tabShipTypeKeywordsList = {"+tramp", "contraband", "contraband", "outdated", "-pupeteer"}
	for intIndex, strSpecies in pairs(tabSpeciesList) do
		table.insert(tabShipTypeKeywordsList, strSpecies)
	end
	ship1Type = selectShipType(tabShipTypeKeywordsList)
	ship2Type = selectShipType(tabShipTypeKeywordsList)
	ship1Name = selectShipName({"civilian", "-reference"})
	repeat
		ship2Name   = selectShipName({"civilian", "-reference"})
	until ship2Name ~= ship1Name

	-- Debug : print ships
	-- print ( string.format( "\tStarting ship : \"%s\" of type \"%s\"", ship1Name, ship1Type ) )
	-- print ( string.format( "\tEnding ship   : \"%s\" of type \"%s\"", ship2Name,   ship2Type   ) )

	-- Get a cargo tonnage
	amount = rnd.rnd( cargoMin, cargoMax )
	-- print ( string.format( "\tCargo amount : %s tons", amount ) )

	-- Compute a reward
	reward = ( systemStart:jumpDist( ) + systemStart:jumpDist( systemEnd ) ) * rewardPerJump
	reward = rnd.rnd( reward*(1-rewardVariancePercent/100), reward*(1+rewardVariancePercent/100) )

	-- Create a NPC - Taken from Joanne's chain of missions - accept() is trigerred when (A)pproaching the NPC
	misn.setNPC(merchantName, merchantGFX)
	misn.setDesc(merchantDesc)

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end

-- Mission is accepted
function accept()
	-- Ask the player - If no, then nothing is to be done, misn.finish() ends the script
	if not tk.yesno(titleAsk, textAsk:format( player.name(), systemStart:name(), amount, systemEnd:name(), reward )) then
	  misn.finish()
	end

	-- If player has not enough cargo space, then nothing is to be done, misn.finish() ends the script
	if player.pilot():cargoFree() < amount then
		tk.msg(full[1], full[2]:format(amount, amount - player.pilot():cargoFree()))
		misn.finish()
	end
	--

	-- Actually accept the mission
	misn.accept()

	-- Set description and reward
	misn.setDesc(misn_desc:format( amount, ship1Type, ship1Name, systemStart:name(), ship2Type, ship2Name, systemEnd:name() ))
	misn.setReward(misn_reward:format( reward ) )

	-- Set system markers
	systemStartMarker = misn.markerAdd(systemStart, "high")
	systemEndMarker = misn.markerAdd(systemEnd, "low")

	-- Setup the OSD
	misn.osdCreate(
		osd_title, 
		{
			osd_msg[1]:format( systemStart:name() ), 
			osd_msg[2]:format(ship1Name), 
			osd_msg[3]:format(systemEnd:name() ), 
			osd_msg[4]:format(ship2Name)
		}
	)

	-- Set Phase 1
	currentPhase = 1

	-- Setup hook for checking if the player is in the firt system
	systemStartHook = hook.enter("enterSystem")
end

-- Mission is aborted
function abort ()
	-- If cargo is already aboard, jettison it
	player.pilot():cargoRm(cargo, amount)

	-- Close the mission
	misn.finish(false)
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Main events sequence (hook in currentPhase) :
--	1/ Player enters first rendez-vous sytem : enterSystem()
--		Spawn first ship.
--	2/ Player hails first ship : shipHail()
--		Ship stops and becomes boardable.
--	3/ Player boards first ship : ship1Board()
--		Transfer cargo from ship to player,
--		Ship goes to jump out
--		Mark second rendez-vous system.
--	4/ Player enters second rendez-vous system : enterSystem()
--		Spawn second ship.
--	5/ Player hails second ship : shipHail()
--		Ship stops and becomes boardable.
--	6/ Player boards second ship : ship2Board()
--		Transfer cargo from player to ship,
--		Give reward to player,
--		Delete OSD,
--		Ship goes to jump out
--		End mission.
-- 
-- =======================================================================================
--
-- Enter system hook for 1st and 2nd rendez-vous
-- Phases : 1 & 4
function enterSystem()
	-- Local variables
	local systemTest = nil
	local shipName = ""
	local shipType = ""
	local cargoFree = 0

	-- Debug printout
	-- print ( string.format( "\r\nSmuggling : entering enterSystem()" ) )

	-- Setup tests according to phase
	if currentPhase == 1 then
		systemTest = systemStart
		shipName = ship1Name
		shipType = ship1Type
		-- print ( string.format( "\tCurrent Phase (%d) : checking for 1st system \"%s\"", currentPhase, systemTest:name() ) )
	elseif currentPhase == 4 then
		systemTest = systemEnd
		shipName = ship2Name
		shipType = ship2Type
		-- print ( string.format( "\tCurrent Phase (%d) : checking for 2nd system \"%s\"", currentPhase, systemTest:name() ) )
	else
		-- print ( string.format( "\tCurrent Phase (%d) : error, neither 1 nor 4", currentPhase ) )
		-- print ( string.format( "Smuggling : exiting enterSystem()" ) )
		return
	end

	-- Not the rendez-vous system : exit function
	if system.cur() ~= systemTest then
		-- print ( string.format( "\tNot rendez-vous system" ) )
		-- print ( string.format( "Smuggling : exiting enterSystem()" ) )
		return
	end

	-- This is the rendez-vous system : spawn rendez-vous ship
	-- print ( string.format( "\tRendez-vous system found!" ) )
	-- print ( string.format( "\tGenerating ship : \"%s\" of type \"%s\"", shipName, shipType ) )
	shipPilot = spawnShip(shipName, shipType)

	-- Set ship in manual control
	shipPilot:control(true)

	-- Highlight ship
	shipPilot:setVisplayer( true )
	shipPilot:setHilight( true )

	-- If no amount Compute amount so as to load the ship to the gully
	cargoFree = shipPilot:cargoFree()
	print ( string.format("\t\tFree cargo space : %d tons for %d tons of cargo", cargoFree, amount ))

	if currentPhase == 1 then
		misn.osdActive(2)
		shipPilot:cargoAdd(cargo, amount)
		currentPhase = 2
	else
		misn.osdActive(4)
		currentPhase = 5
	end

	-- Set hook for the ship
	hook.pilot( shipPilot, "hail", "shipHail" )

		-- List cargo
	print ( string.format("\t\tListing cargo (total %d item(s))", #shipPilot:cargoList() ))
	for _,cargoItem in ipairs(shipPilot:cargoList()) do
		print ( string.format("\t\t\t\"%s\" : %d tons", cargoItem.name, cargoItem.q ))
	end

	-- Debug printout for normal end
	-- print ( string.format( "Smuggling : exiting enterSystem()" ) )
end

-- Hook on hailing 1st or 2nd ship
function shipHail()
	-- Stop the ship in its wake and wait for boarding
	shipPilot:control(true)
	shipPilot: brake()
	shipPilot:setActiveBoard( true )

	-- Ship agrees to rendez-vous
	if currentPhase == 2 or currentPhase == 5 then
		shipPilot:comm(textHail[currentPhase])
	end

	if currentPhase == 2 then
		hook.pilot( shipPilot, "board", "ship1Board" )
	else
		hook.pilot( shipPilot, "board", "ship2Board" )
	end

	-- Increase phase
	currentPhase = currentPhase+1
end

-- Hook on boarding 1st ship
function ship1Board()
	-- Message describing the situation
	tk.msg ( titleBoard[1], textBoard[1] )

	-- Force immediate unboard
	player.unboard()

	-- Transfer the cargo from the ship to the player
	player.pilot():cargoAdd(cargo, amount)
	shipPilot:cargoRm(cargo, amount)

	-- Make ship thank you
	shipPilot:broadcast( string.format( textGoodbye[1], ship2Name ), true )

	-- Make ship fly away
	shipPilot:setVisplayer( false )
	shipPilot:setHilight( false )
	shipPilot:setActiveBoard( false )
	shipPilot:hyperspace()

	-- Set system markers
	misn.markerRm(systemStartMarker)
	misn.markerRm(systemEndMarker)
	systemEndMarker = misn.markerAdd(systemEnd, "high")

	-- Set Phase 4
	currentPhase = 4

	-- Setup hook for checking if the player is in the second system
	hook.rm(systemStartHook)
	systemEndHook = hook.enter("enterSystem")
	misn.osdActive(3)
end

-- Hook on boarding 2nd ship
function ship2Board()
	-- Message describing the situation
	tk.msg ( titleBoard[2], textBoard[2] )

	-- Force immediate unboard
	player.unboard()

	-- Transfer the cargo from the ship to the player
	player.pilot():cargoRm(cargo, amount)
	shipPilot:cargoAdd(cargo, amount)

	-- Give reward
	player.pay(reward)

	-- Make ship thank you
	shipPilot:broadcast( string.format( textGoodbye[2], player.name() ), true )

	-- Make ship fly away
	shipPilot:setVisplayer( false )
	shipPilot:setHilight( false )
	shipPilot:setActiveBoard( false )
	shipPilot:hyperspace()

	-- Set system markers
	misn.markerRm(systemEndMarker)

	misn.finish(false)
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Off-sequence events
--  a/ 
-- 
-- =======================================================================================
--
--
-- =======================================================================================


-- =======================================================================================
--
-- utility functions
-- 
-- =======================================================================================
--
-- Spawn 1st or 2nd cargo
function spawnShip(shipName, shipType)
	-- Local variables
	local jumpsList = nil
	local newFleet = nil

	-- Generate the ship from a random jump point
	jumpsList = system.cur():jumps()
	newFleet = pilot.add(shipType, "dummy", jumpsList[rnd.rnd(#jumpsList)])

	for k,v in ipairs(newFleet) do
		-- Check created pilot
		if not checkPilot(v) then
			print (string.format("\tRendez-vous ship creation invalid", time.str()))
			return nil
		end

		-- Add the maximum possible number of cargo holds...
		v:addOutfit("Small Cargo Hold", 10)

		-- Set name and faction
		v:setFaction("Independent")
		v:rename(shipName)

		-- Return the 1st pilot in the fleet
		return v
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
