include("dat/factions/spawn/_common/common.lua")

-- ================================================================================================
--   Spawn functions
-- ================================================================================================
--

function spawn_patrol_AkkTiMakkt ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "Akk'Ti'Makkt", 20 );

	return pilots
end


function spawn_patrol_AngryBee ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "Angry Bee Fighter", 5 );

	return pilots
end


function spawn_patrol_Eershlan ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "Eershlan", 12 );

	return pilots
end


function spawn_patrol_NelkTan ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "Nelk'Tan", 10 );

	return pilots
end


function spawn_patrol_Stinger ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "Stinger", 10 );

	return pilots
end


function spawn_patrol_TKalt ()
	local pilots = {}
	local r = rnd.rnd()

	scom.addPilot( pilots, "T'Kalt Patrol", 15 );

	return pilots
end

--
-- ================================================================================================


-- ================================================================================================
--   Weights table
-- ================================================================================================
--

function createWeightTable ( )
	local weights = {}

	-- Create weights for spawn table
	weights[ spawn_patrol_AngryBee    ] = 30
	weights[ spawn_patrol_NelkTan     ] = 10
	weights[ spawn_patrol_Stinger     ] = 10
	weights[ spawn_patrol_Eershlan    ] =  5
	weights[ spawn_patrol_AkkTiMakkt  ] =  2
	weights[ spawn_patrol_TKalt       ] =  1

	return weights
end

--
-- ================================================================================================


-- ================================================================================================
--   Hooks for spawning process
-- ================================================================================================
--

-- @brief Creation hook.
function create ( max )
	local weights = createWeightTable ()

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
	pilots = scom.spawn( spawn_data , "Pirate" , "pirate" )
	for k,v in ipairs(pilots) do
		v["pilot"]:rename( "Pirate " .. v["pilot"]:name() )
	end

	-- Calculate spawn data
	spawn_data = scom.choose( spawn_table )

	return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end

--
-- ================================================================================================
