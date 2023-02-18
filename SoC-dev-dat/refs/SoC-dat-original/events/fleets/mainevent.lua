--[[

EVENT TITLE: Fleet spawn
DESCRIPTION: 
			Spawns fleet events in the current system depending on factions presence

REVISIONS
		TODO
			FEATURE	: Smarter control of spawning delays
		DONE
			CODE	: split spawnSettings[] into "factionsspawnsettings.lua"
		r82
			BUGFIX	: (Major) create() crashing when no settings are registered for a faction
						Fixed by adding a nil-check on the settings
		r80-81
			CODE	: Code cleanup
		r79
			CODE	: First version

]]--

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
	-- Nothing for now for espanol
elseif lang == "fr" then
	-- Nothing for now for français
else -- default english

end 

include("dat/events/fleets/factionsspawnsettings.lua")

-- Module-global variables
minFleetDelay = {}
maxFleetDelay = {}

function create()
	-- Tell we're entering the event
	-- print ("\nEntering Fleet Spawn Event")

	-- Get information about the current system
	local sys                  = system.cur()
	local factions             = sys:presences()

	-- Echo the information to stdout
	-- print (string.format("\tFactions in system %s :",sys:name()))
	for faction,presence in pairs(factions) do
		-- print (string.format("\t\t%s (%u%%)",faction,presence))
	end
	
	-- Loop on the factions
	local avgFleetFrequency = 0
	local avgFleetDelay = 0
	local settings = {}
	for faction,presence in pairs(factions) do
		-- Get faction settings
		settings = spawnSettings[faction]
		
		-- Check for faction settings
		if settings == nil then
			-- print (string.format("\tNo settings for faction '%s' : no fleet to create.", faction))
		else
			-- Computed average delay for fleets
			avgFleetFrequency = settings.minFleetFrequency + (settings.maxFleetFrequency - settings.minFleetFrequency) * presence /1000
			avgFleetDelay = 60000 / avgFleetFrequency

			-- Computed minimum and maximum fleet delays for the faction
			minFleetDelay[faction] = avgFleetDelay * (1 - settings.frequencyDispersion / 100)
			maxFleetDelay[faction] = avgFleetDelay * (1 + settings.frequencyDispersion / 100)
			-- print (string.format("\tSpawn interval (s) for faction '%s' : [%u ; %u]", faction, minFleetDelay[faction]/1000, maxFleetDelay[faction]/1000))

			-- Set a hook to spawn a fleet
			local nextFleetDelay = computeNextFleetDelay(faction)
			-- print (string.format("\tSpawn a '%s' fleet in %u seconds", faction, nextFleetDelay/1000))
			hook.timer(nextFleetDelay, "spawnFleet", faction)
		end
	end
	
	-- Set hooks on the player
	hook.land("cleanup")
	hook.jumpout("cleanup")
end

function computeNextFleetDelay(faction)
	return rnd.rnd(minFleetDelay[faction],maxFleetDelay[faction])
end

function spawnFleet(faction)
	-- Actually spawn a fleet
	-- Currently, the only available events are Convoy events
	-- In further versions, there will be other fleet types available
	-- print ("Spawning new fleet...")
	naev.eventStart(string.format("%s Convoy",faction))

	-- Schedule another convoy in a random delay
	local nextFleetDelay = computeNextFleetDelay(faction)
	-- print (string.format("\tSpawn a fleet in %u s for faction '%s'",nextFleetDelay/1000, faction))
	hook.timer(nextFleetDelay, "spawnFleet", faction)
end

function cleanup()
	-- Tell we're exiting the event
	-- print ("Exiting Fleet Spawn Event")
	evt.finish()
end
