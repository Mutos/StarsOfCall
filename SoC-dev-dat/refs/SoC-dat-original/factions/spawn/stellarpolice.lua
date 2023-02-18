include("dat/factions/spawn/_common/common.lua")


-- @brief Spawns a single human patrol ship.
function spawn_patrol ()
	 local pilots = {}
	 local spships = {{"Akk'Ti'Makkt", 6},
							 {"Nelk'Tan", 6},
							 {"Angry Bee Fighter", 8},
							 {"Bao Zheng", 4},
							 {"Eclair d'Etoiles", 15},
							 {"T'Kalt Patrol", 10}
							}
	 
	 local select = rnd.rnd(1, #spships)
	 
	 scom.addPilot( pilots, spships[select][1], spships[select][2] );

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
	 pilots = scom.spawn( spawn_data )
	 
	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table, "Stellar Police", "patrol" )
	 
	 return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end


