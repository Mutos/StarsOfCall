--[[

INCLUDE SCOPE:
	Utility functions for convoy spawning events

USAGE: create a convoy for a given faction
	- Create a Fleet named "<faction> Convoy" in fleet.xml
		You can add any ship to it, it's just to be consistent with the universe
	- Create an event named "<faction> Convoy" in events.xml
		It has to reference a script in NAEV~/dat/fleets/convoy/
		The simplest way is to copy an already existing event and change the script name
	- Create the script in NAEV~/dat/fleets/convoy/
		It has to be named as referenced in events.xml, with lua extension
		The simplest way is to copy an already existing script and change the script name
	- Add spawn settings for the faction in NAEV~/dat/fleets/factionsspawnsettings.lua
		It has to specify { minFleetFrequency , maxFleetFrequency , frequencyDispersion }
		The simplest way is to copy an already existing line and change the faction index
REVISIONS
		TODO
			FEATURE	: when a convoy ship is attacked, all ships must fire back to the attacker
						Note : they are not to change course, but just to fire their weapons to the attacker
			FEATURE	: remove or comment debug -- printout
			FEATURE	: Smarter control of spawning delays
						Maybe limit presence to a custom range in parameters array
			CODE	: cleanup create() event
		r141
			BUGFIX	: (Medium) Some convoys seem to come from the wrong place
						This seems to be a random phenomenon
						Seen convoys take off / jump from a planet / jumppoint near the player while broadcasting another origin
						Cause : argument type was wrong, jumppoint passed instead of system to pilot.add or pilot.hyperspace
						Fix   : pass system instead of jumppoint
		r94
			FEATURE	: comment debug broadcasts
		r82
			BUGFIX	: (Medium) Sometimes a shipKilled hook fails
						Now seems fixed as a side-effect of other code cleanup
			BUGFIX	: pilot death hook didn't take jumpDestination argument
						hook.pilot() can take only one extra arguments
						Fixed by grouping both destinations into one list argument
			BUGFIX	: (Major) some events never exit when last ship lands/jumps/killed
						Linked to bad remove of ships from convoy list when landing/jumping
						Fixed by making a specific key selection loop 
			CODE	: integrated module-global variables into create() function
			CODE	: First version, holding the common part from "independant.lua" and "coucil.lua" code

]]--

include ("dat/events/fleets/common.lua")
-- include ("scripts/fleethelper.lua")

function create()
	-- Local variables for convoy origin and destination
	-- Passed as arguments to the hooks
	local convoyJumpOrigin		= nil
	local convoyLandOrigin		= nil
	local convoyJumpDestination	= nil
	local convoyLandDestination	= nil

	-- Tell we're entering the event
	-- print (string.format("\nEntering %s Convoy Event", faction))

	-- Set the convoy's course
	convoyJumpOrigin, convoyLandOrigin, convoyJumpDestination, convoyLandDestination = setPassThroughCourse(faction)
	
	-- No destination at all : don't create a convoy
	if convoyLandDestination == nil and convoyJumpDestination == nil then
		-- print (string.format("Exiting %s Convoy Event because no convoy could be created", faction))
		evt.finish()
		return
	end

	-- Create the convoy
	local text = ""
	if convoyLandOrigin ~= nil then
		-- print (string.format("\tConvoy taking off from %s",convoyLandOrigin:name()))
		text = string.format("Taking off from %s",convoyLandOrigin:name())
		convoyFleet = pilot.add(string.format("%s Convoy", faction), nil, convoyLandOrigin)
	else
		-- print (string.format("\tConvoy jumping in from %s",convoyJumpOrigin:name()))
		text = string.format("Jumping in from %s",convoyJumpOrigin:name())
		convoyFleet = pilot.add(string.format("%s Convoy", faction), nil, convoyJumpOrigin)
	end

	-- Set the other ships in the convoy to follow the Leader
	local foundLeader = false
	for i,pilot in pairs(convoyFleet) do
		pilot:control()
		if not foundLeader then
			-- Set 1st pilot found as the Convoy Leader
			convoyLeader = pilot
			foundLeader = true
			pilot:rename(string.format("%s convoy Leader", shortFaction))
			-- Set the Convoy Leader's destination
			if convoyLandDestination ~= nil then
				-- print (string.format("\tConvoy landing on %s",convoyLandDestination:name()))
				text = string.format("%s and landing on %s",text,convoyLandDestination:name())
				convoyLeader:land(convoyLandDestination)
			else
				-- print (string.format("\tConvoy jumping out to %s",convoyJumpDestination:name()))
				text = string.format("%s and jumping out to %s",text,convoyJumpDestination:name())
				convoyLeader:hyperspace(convoyJumpDestination, true)
			end
			-- pilot:broadcast(string.format("%s",text))
		else
			-- Rename the pilot
			pilot:rename(string.format("%s convoy #%u", shortFaction, i))

			-- Make pilot follow the leader
			pilot:follow(convoyLeader) 
		end
		-- print (string.format("\t'%s' (%s) %s",pilot:name(),pilot:ship():baseType(),text))
		for i,j in pairs(pilot:outfits()) do
			-- print (string.format("\t\t%s",j:name()))
		end
	end

	-- Set hooks on jump or land
	if convoyLandDestination ~= nil then
		-- print (string.format("\tConvoy due to land on %s",convoyLandDestination:name()))
		-- player.msg(string.format("Convoy due to land on %s",convoyLandDestination:name()))
		for i,pilot in pairs(convoyFleet) do
			-- Set hooks on each ship
			hook.pilot(pilot, "land", "shipLands", convoyLandDestination)
		end
	end
	if convoyJumpDestination ~= nil then
		-- print (string.format("\tConvoy due to jump to %s",convoyJumpDestination:name()))
		-- player.msg(string.format("Convoy due to jump to %s",convoyJumpDestination:name()))
		for i,pilot in pairs(convoyFleet) do
			-- Set hooks on each ship
			hook.pilot(pilot, "jump", "shipJumps", convoyJumpDestination)
		end
	end

	-- Set hooks on ships destroyed
	for i,pilot in pairs(convoyFleet) do
		hook.pilot(pilot, "death", "shipKilled", {convoyLandDestination, convoyJumpDestination})
	end

	-- Set hooks on the player
	hook.land("cleanup")
	hook.jumpout("cleanup")
end

-- A ship lands
function shipLands(pilot, landPlanet, landDestination)
	-- Message the player
	-- print (string.format("Entering shipLands() on pilot %s",pilot:name()))

	-- print (string.format("\t%s landing on %s",pilot:name(),landDestination:name()))
	-- print (string.format("\tOld convoy number : %u",#convoyFleet))
	-- pilot:broadcast(string.format("Landing on %s",convoyLandDestination:name()))

	local pilotKey = -1
	if pilot == convoyLeader then
		-- If Convoy Leader, then tell the others
		for i,j in ipairs(convoyFleet) do
			if j:exists() and j ~= ConvoyLeader then
				j:control()
				j:taskClear()
				j:land(landDestination)
			end
		end
	end

	-- Remove landing pilot from the table
	for i,j in ipairs(convoyFleet) do
	-- If landing pilot, then prepare remove from table
		if j == pilot then
			pilotKey = i
		end
	end
	table.remove(convoyFleet, pilotKey)
	-- print (string.format("\tNew convoy number : %u",#convoyFleet))
	
	-- If no remaining ship, finish the now pointless event
	if #convoyFleet == 0 then
		-- print (string.format("Exiting %s Convoy Event as last convoy ship landed", faction))
		evt.finish()
	end
end

-- A ship jumps out
function shipJumps(pilot, jumpSystem, jumpDestination)
	-- print (string.format("\nEntering shipJumps() on pilot \"%s\" destination iystem \"%s\"", pilot:name(), jumpDestination:name()))
	-- player.msg(string.format("\t%s jumping to %s",pilot:name(),jumpDestination:name()))

	if jumpDestination == nil then
		-- print (string.format("\tJump destination NIL"))
		-- print (string.format("Exiting shipJumps() on pilot %s",pilot:name()))
		return
	end

	-- Message the player
	-- print (string.format("\t%s jumping to %s",pilot:name(),jumpDestination:name()))
	-- print (string.format("\tOld convoy number : %u",#convoyFleet))

	local pilotKey = -1
	if pilot == convoyLeader then
		-- If Convoy Leader, then tell the others
		for i,j in ipairs(convoyFleet) do
			if j:exists() and j ~= ConvoyLeader then
				j:control()
				j:taskClear()
				j:hyperspace(jumpDestination)
			end
		end
	end

	-- Remove jumping pilot from the table
	for i,j in ipairs(convoyFleet) do
	-- If jumping pilot, then prepare remove from table
		if j == pilot then
			pilotKey = i
		end
	end
	table.remove(convoyFleet, pilotKey)
	-- print (string.format("\tNew convoy number : %u",#convoyFleet))
	
	-- If no remaining ship, finish the now pointless event
	if #convoyFleet == 0 then
		-- print (string.format("Exiting %s Convoy Event as last convoy ship jumped out", faction))
		evt.finish()
	end
end

-- A ship is killed
function shipKilled(killedPilot, attacker, destinationsList)
	-- Message the player
	-- print (string.format("\t%s killed by %s",killedPilot:name(),attacker:name()))

	-- Remove killed pilot from the table
	-- print (string.format("\tOld convoy number : %u",#convoyFleet))
	local pilotKey = -1
	for i,j in ipairs(convoyFleet) do
		-- If killed pilot, then prepare remove from table
		if j == killedPilot then
			pilotKey = i
		end
	end
	table.remove(convoyFleet, pilotKey)
	-- print (string.format("\tNew convoy number : %u",#convoyFleet))
	for i,j in ipairs(convoyFleet) do
		-- print (string.format("\t\t%s",j:name()))
	end

	-- If Convoy Leader is killed, then draft a new leader and assign him the objectives
	if killedPilot == convoyLeader then
		local landDestination = destinationsList[1]
		local jumpDestination = destinationsList[2]
		local foundNewLeader = false
		for i,j in ipairs(convoyFleet) do
			-- Reset the control on the pilot
			j:control()
			j:taskClear()
			if not foundNewLeader then
				-- Set new Convoy leader to the first ship in the list
				convoyLeader = j
				if landDestination ~= nil then
					convoyLeader:land(landDestination)
				else
					convoyLeader:hyperspace(jumpDestination, true)
				end
				-- j:broadcast(string.format("'%s' renamed 'New Convoy Leader'",convoyLeader:name()))
				-- print (string.format("\t'%s' renamed 'New Convoy Leader'",convoyLeader:name()))
				j:rename("New Convoy Leader")
				foundNewLeader = true
			else
				-- Already got a new leader, other ships follow it
				j:follow(convoyLeader) 
			end
		end
	else
		-- Nothing to do for now
		-- At a point, there will be a script for vengeance here
	end

	-- If no remaining ship, finish the now pointless event
	if #convoyFleet == 0 then
		-- print (string.format("Exiting %s Convoy Event as last convoy ship was killed", faction))
		evt.finish()
	end
end

--everything is done
function cleanup()
	-- print (string.format("Exiting %s Convoy Event when player exits", faction))
	evt.finish()
end
