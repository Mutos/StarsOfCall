include("dat/factions/spawn/_common/common.lua")

local strFaction = "Ka'Ralt Secession"

-- @brief Spawns a small trade fleet.
function spawn_patrol ()
	 local pilots = {}
	 local r = rnd.rnd()

	 if r < 0.6 then
		 scom.addPilot( pilots, "T'Kalt Cargo", 15 );
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
	 weights[ spawn_patrol  ] = 100
	
	 -- Create spawn table base on weights
	 spawn_table = scom.createSpawnTable( weights )

	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table, "Ka'Ralt Secession", nil )

	 return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end


-- @brief Spawning hook
function spawn ( presence, max )
	 local pilots

	-- Begin debug
	 -- print ("\nDEBUG BEGIN : generating Secession ship")

	 -- Over limit
	 if presence > max then
		 return 5
	 end
  
	 -- Actually spawn the pilots
	 pilots = scom.spawn( spawn_data, strFaction, nil )

	 -- Calculate spawn data
	 spawn_data = scom.choose( spawn_table )

	-- End debug
	 -- print ("DEBUG END   : generating Secession ship")

	 return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
