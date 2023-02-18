-- =======================================================================================
--
-- Test ship AI
-- 
-- Creates a ship that uses a special test AI.
-- Made to observe how an AI reacts
-- 
-- =======================================================================================


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_Test_AI_"

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

-- Get player character species
pcSpecies = var.peek ("pc_species")

-- Script-global variables for ship origin
shipJumpOrigin			= nil

-- Test pilot
testPilot = nil

-- Timer hook
orderTimer = nil

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
	print (string.format("\n(%s) Entering TestAI Event", time.str()))

	-- Build-in name for the ship
	local shipName = "AI Test Ship"
	local distressedShipName = "AI Distressed Ship"
	local shipType = "Irali"
	local takeoffPlanet, takeoffSystem = planet.getLandable(true)

	-- Actually create the test_AI ship from the same planet the player just took off
	print (string.format("(%s)\tCreating AI Test Ship", time.str()))
	local newFleet = pilot.add(shipType, "test_ai", takeoffPlanet )
	for k,v in ipairs(newFleet) do
		-- Set name and faction
		v:setFaction("Independent")
		v:rename(shipName)

		-- Add extra visibility for debug and big systems
		v:setVisplayer( true )
		v:setHilight( true )

		-- Set global event variable, so that we can give it orders
		testPilot = v
	end

	--[[ Create a second ship to send a distress call from the same planet the player just took off
	print (string.format("(%s)\tCreating Distressed Ship", time.str()))
	local newFleet = pilot.add(shipType, "test_aiDistress", takeoffPlanet )
	for k,v in ipairs(newFleet) do
		-- Set name and faction
		v:setFaction("Independent")
		v:rename(distressedShipName)

		-- Add extra visibility for debug and big systems
		v:setVisplayer( true )
		v:setHilight( true )
	end
	]]--

	-- Setting the timer hook on the test ship
	print (string.format("(%s) \tSetting order timer", time.str()))
	 orderTimer = hook.timer(3000, "giveOrder")
	if orderTimer ~= nil then
		print (string.format("(%s) \tOrder timer successfully set", time.str()))
	else
		print (string.format("(%s) \tOrder timer failed to setup", time.str()))
	end

	-- End event
	print (string.format("(%s) Exiting TestAI Event", time.str()))
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Gives an order every now and then
-- 
-- =======================================================================================
--

function giveOrder()
	local separatorIndex = 0
	local x, y = 0, 0

	-- Log entry
	print (string.format("(%s) Entering giveOrder()", time.str()))

	-- Check pilot existence and status
	if testPilot==nil then
		-- Log exit
		print (string.format("(%s) \ttestPilot==nil", time.str()))
		camera.set()
		print (string.format("(%s) \tExiting the event", time.str()))
		print (string.format("(%s) Exiting giveOrder()", time.str()))
		evt.finish(true)
	end
	if not testPilot:exists() then
		-- Log exit
		print (string.format("(%s) \ttestPilot exists no more", time.str()))
		camera.set()
		print (string.format("(%s) \tExiting the event", time.str()))
		print (string.format("(%s) Exiting giveOrder()", time.str()))
		evt.finish(true)
	end

	-- Ask the player what they want the AI ship to do
	-- Orders : "exit", "hyperspace", "land", "goto"
	local num, chosen = tk.choice( "Orders, sir ?", "Choose an order to give the ship:", "none", "goto", "land", "hyperspace", "[Stop issuing orders]" )
	if num == 5 then
		camera.set()
		print (string.format("(%s) \tExiting the event", time.str()))
		print (string.format("(%s) Exiting giveOrder()", time.str()))
		evt.finish(true)
	end
	if num == 1 then
		print (string.format("(%s) \tGiving no order", time.str()))
	else
		local orderVerb = chosen

		-- First log the order itself
		local message = string.format("(%s) \tSetting mem.orderVerb \"%s\" in memory", time.str(), tostring(orderVerb))
		print (message)
		player.msg (message)

		-- Goto needs co-ordinates
		local orderWaypoint
		if orderVerb == "goto" then
			playerAnswer = tk.input("Co-ordinates, sir ?", 3, 20, "Set the co-ordinates to go to, separated by \";\":")
			local message = string.format( "(%s) \tEntered coords \"%s\" in memory", time.str(), playerAnswer )
			print (message)
			player.msg (message)
			separatorIndex = string.find(playerAnswer, ";")
			local message = string.format( "(%s) \tX=\"%s\"; Y=\"%s\"", time.str(), string.sub(playerAnswer, 1, separatorIndex-1), string.sub(playerAnswer, separatorIndex+1, -1) )
			print (message)
			player.msg (message)
			if separatorIndex ~=nil then
				x = tonumber(string.sub(playerAnswer, 1, separatorIndex-1))
				y = tonumber(string.sub(playerAnswer, separatorIndex+1, -1))
			end
			local message = string.format("(%s) \tSetting mem.order_coord [x=%f;y=%f] in memory", time.str(), x, y)
			print (message)
			player.msg (message)
			orderWaypoint = tostring(x)..";"..tostring(y)
		end

		-- Land needs a planet name
		local orderPlanet
		if orderVerb == "land" then
			orderPlanet = tk.input("Planet name, sir ?", 0, 20, "Give a planet name:")
			local message = string.format( "(%s) \tEntered planet name \"%s\" in memory", time.str(), orderPlanet )
			print (message)
			player.msg (message)
		end

		-- Hyperspace needs a system name
		local orderJumpPoint
		if orderVerb == "hyperspace" then
			orderJumpPoint = tk.input("Jump point name, sir ?", 0, 20, "Give a jump point name:")
			local message = string.format( "(%s) \tEntered jump points name \"%s\" in memory", time.str(), orderJumpPoint )
			print (message)
			player.msg (message)
		end

		-- Actually set the order variables
		testPilot:memory("orderVerb", orderVerb)
		testPilot:memory("orderWaypoint", orderWaypoint)
		testPilot:memory("orderPlanet", orderPlanet)
		testPilot:memory("orderJumpPoint", orderJumpPoint)

		-- Re-read it to see if all was OK
		local orderInMem = testPilot:memoryCheck("orderVerb")
		local message = string.format("(%s) \tmem.orderVerb read from memory : \"%s\"", time.str(), tostring(orderInMem))
		print (message)
		player.msg (message)
		local orderInMem = testPilot:memoryCheck("orderWaypoint")
		local message = string.format("(%s) \tmem.orderWaypoint read from memory : \"%s\"", time.str(), tostring(orderInMem))
		print (message)
		player.msg (message)
		local orderInMem = testPilot:memoryCheck("orderPlanet")
		local message = string.format("(%s) \tmem.orderPlanet read from memory : \"%s\"", time.str(), tostring(orderInMem))
		print (message)
		player.msg (message)
		local orderInMem = testPilot:memoryCheck("orderJumpPoint")
		local message = string.format("(%s) \tmem.orderJumpPoint read from memory : \"%s\"", time.str(), tostring(orderInMem))
		print (message)
		player.msg (message)

		-- Set the camera on testPilot
		camera.set( testPilot )
	end

	-- Rehook the timer
	print (string.format("(%s) \tSetting order timer", time.str()))
	 orderTimer = hook.timer(15000, "giveOrder")
	if orderTimer ~= nil then
		print (string.format("(%s) \tOrder timer successfully set", time.str()))
	else
		print (string.format("(%s) \tOrder timer failed to setup", time.str()))
	end

	-- Log exit
	print (string.format("(%s) Exiting giveOrder()", time.str()))
end

--
-- =======================================================================================
