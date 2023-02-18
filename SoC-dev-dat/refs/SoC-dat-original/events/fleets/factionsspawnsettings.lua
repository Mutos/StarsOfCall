--[[

INCLUDE SCOPE:
	Utility variable for fleet spawning events

REVISIONS
		DONE
			CODE	: First version from "mainevent.lua"

]]--

-- Get a list holding the spawning settings for all factions
-- Header-defined constants to drive the script's behavior
-- For each faction, the list contains :
--	- minFleetFrequency		: Minimum number of convoys per minute
--	- maxFleetFrequency		: Maximum number of convoys per minute
--	- frequencyDispersion	: Dispersion percentage
spawnSettings = {
	["Pirate"]								= { minFleetFrequency = 0.5,	maxFleetFrequency = 2.0, frequencyDispersion = 20},
	["Independent"]						= { minFleetFrequency = 0.5,	maxFleetFrequency = 2.0, frequencyDispersion = 20},
	["K'Rinn Council"]					= { minFleetFrequency = 0.5,	maxFleetFrequency = 2.0, frequencyDispersion = 20},
	["Instrumentality Company"]	= { minFleetFrequency = 0.5,	maxFleetFrequency = 2.0, frequencyDispersion = 20}
}
