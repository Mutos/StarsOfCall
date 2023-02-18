-- Common functions
include("dat/factions/spawn/_templates/freighters.lua")

-- Set faction and AI for the script
strFaction = "Core League"
strAI      = "patrol"

-- @brief Spawns a Core League small patrol
function spawnSmallPatrol ( faction )
	if faction == nil then
		faction = ""
	end
	local pilots = {}
	scom.addPilot( pilots, "T'Telin"          , 100, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );

	return pilots
end

-- @brief Spawns a Core League medium patrol
function spawnMediumPatrol ( faction )
	if faction == nil then
		faction = ""
	end
	local pilots = {}
	scom.addPilot( pilots, "T'Telin"          , 100, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );

	return pilots
end

-- @brief Spawns a Core League large patrol
function spawnLargePatrol ( faction )
	if faction == nil then
		faction = ""
	end
	local pilots = {}
	scom.addPilot( pilots, "Eclair d'Etoiles" , 200, faction );
	scom.addPilot( pilots, "T'Telin"          , 100, faction );
	scom.addPilot( pilots, "T'Telin"          , 100, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );
	scom.addPilot( pilots, "Angry Bee Fighter",  50, faction );

	return pilots
end

-- @brief Generates a standard weights table containing all Core League Patrols
function WeightTableCoreLeague()
	local weights = {}
	weights[ spawnSmallPatrol ]		=  5
	weights[ spawnMediumPatrol ]	=  2
	weights[ spawnLargePatrol ]		=  1
	return weights
end

-- Set weights table
tabWeights = WeightTableCoreLeague()
