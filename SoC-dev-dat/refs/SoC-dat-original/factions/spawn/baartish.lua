include("dat/factions/spawn/_common/common.lua")

local strFaction = "Baartish Intersystems"

-- @brief Spawns a small trade fleet.
function spawn_trade ()
	 local pilots = {}
	 local r = rnd.rnd()

	 if r < 0.6 then
		 scom.addPilot( pilots, "Eresslih", 15 );
	 elseif r < 0.9 then
		 scom.addPilot( pilots, "L'Lintir", 30 );
	 else
		 scom.addPilot( pilots, "Irali", 30 );
	 end

	 return pilots
end


-- @brief Creation hook.
function create ( max )
	 local weights = {}

	 -- Create weights for spawn table
	 weights[ spawn_trade  ] = 100
	
	 -- Create spawn table base on weights
	 spawn_table = scom.createSpawnTable( weights )

	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table )

	 return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end


-- @brief Spawning hook
function spawn ( presence, max )
	 local pilots

	-- Begin debug
	 -- print ("\nDEBUG BEGIN : generating Baartish ship")

	 -- Over limit
	 if presence > max then
		 return 5
	 end
  
	 -- Actually spawn the pilots
	 pilots = scom.spawn( spawn_data, strFaction, nil )

	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table )

	-- End debug
	 -- print ("DEBUG END   : generating Baartish ship")

	 return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
