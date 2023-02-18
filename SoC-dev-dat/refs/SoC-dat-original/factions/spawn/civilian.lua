include("dat/factions/spawn/_common/common.lua")

local strFaction = "Civilian"

-- @brief Spawns a single small ship.
function spawn_patrol ()
	 local pilots = {}
	 local civships = {{"Alaith", 8},
							 {"Caravelle", 8},
							 {"Arshiilan", 8},
							 {"Erlith", 13},
							 {"Irali", 8},
							 {"Percheron Mk1", 8},
							 {"Percheron Mk2 Containers", 8},
							 {"Percheron Mk2 Holds", 8},
							 {"Percheron Mk2 Tanker", 8},
							 {"Shire", 8},
							 {"T'Kalt Cargo", 8}
							}
	 
	 local select = rnd.rnd(1, #civships)
	 
	 scom.addPilot( pilots, civships[select][1], civships[select][2] );

	 return pilots
end

-- @brief Creation hook.
function create ( max )
	 local weights = {}
	 
	 -- Create weights for spawn table
	 weights[ spawn_patrol  ] = 100
	 
	 -- Create spawn table base on weights
	 spawn_table = scom.createSpawnTable( weights )
	 
	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table )
	 
	 return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end


-- @brief Spawning hook
function spawn ( presence, max )
	 local pilots
	 
	 -- Over limit
	 if presence > max then
		  return 5
	 end
	 
	 -- Actually spawn the pilots
	 pilots = scom.spawn( spawn_data, strFaction, "civilian" )
	 
	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table )
	 
	 return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
