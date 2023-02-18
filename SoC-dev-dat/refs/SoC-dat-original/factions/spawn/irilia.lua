-- Common functions
include("dat/factions/spawn/_common/common.lua")

-- Set faction for this script
local strFaction = "Irilia Clan"


-- @brief Creation hook.
function create ( max )
	 local weights = {}

	-- print (string.format("\nCreating spawn hook for faction \"%s\"", faction))

	 -- Create weights for spawn table
	weights = scom.WeightTable.AllCargos()
	
	 -- Create spawn table base on weights
	 spawn_table = scom.createSpawnTable( weights )

	 -- Calculate spawn data
	 scom.data = scom.choose( spawn_table )

	 return scom.calcNextSpawn( 0, scom.presence(scom.data), max )
end


-- @brief Spawning hook
function spawn ( presence, max )
	 local pilots

	 -- Over limit
	 if presence > max then
		 return 5
	 end
  
	 -- Actually spawn the pilots as independents, then 
	 pilots = scom.spawn( scom.data, strFaction, nil )
	for i = 1, #pilots do
		-- print (string.format("\n\tSpawning pilot : \"%s\" for faction \"%s\"",pilots[i].pilot:name(), faction))
	end

	 -- Calculate spawn data
	 scom.data = scom.choose( spawn_table )

	 return scom.calcNextSpawn( presence, scom.presence(scom.data), max ), pilots
end