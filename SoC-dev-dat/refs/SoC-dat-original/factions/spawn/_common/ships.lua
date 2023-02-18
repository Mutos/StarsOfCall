-- ==========================================================================
--
--   Module to manage ships across all spawn scripts
--	 Adds to scom a member WeightTable of functions
--	 Adds to scom a member PresenceTable of presence for all ships
--
-- ==========================================================================


-- ==========================================================================
-- Inits
-- ==========================================================================
--
-- define main variable to hold the tables
scom.WeightTable = {}
scom.PresenceTable = {}

-- Define presence for all existing ships
scom.PresenceTable["Akk'Ti'Makkt"]				=  150
scom.PresenceTable["Alaith"]					=  280
scom.PresenceTable["Angry Bee Drone"]			=   70
scom.PresenceTable["Angry Bee Fighter"]			=   90
scom.PresenceTable["Arshiilan"]					=  280
scom.PresenceTable["Bao Zheng"]					=  750
scom.PresenceTable["Caravelle"]					=  300
scom.PresenceTable["Diwali"]					= 1200
scom.PresenceTable["Eclair d'Etoiles"]			=  210
scom.PresenceTable["Eershlan"]					=  140
scom.PresenceTable["Eresslih"]					=  280
scom.PresenceTable["Erlith"]					=  300
scom.PresenceTable["Faithful"]					=  450
scom.PresenceTable["Fast Shell"]				=  300
scom.PresenceTable["Irali"]						=  750
scom.PresenceTable["Iserlohn"]					= 1050
scom.PresenceTable["Keserlan"]					= 1800
scom.PresenceTable["L'Lintir"]					= 1200
scom.PresenceTable["Ma'Tang"]					= 1800
scom.PresenceTable["Mosquito"]					=  270
scom.PresenceTable["Nelk'Tan"]					=  140
scom.PresenceTable["Percheron Mk1"]				=  300
scom.PresenceTable["Percheron Mk2 Containers"]	=  360
scom.PresenceTable["Percheron Mk2 Holds"]		=  360
scom.PresenceTable["Percheron Mk2 Tanker"]		=  360
scom.PresenceTable["Shire"]						=  240
scom.PresenceTable["Sshilaan"]					= 2100
scom.PresenceTable["StarJump"]					=  300
scom.PresenceTable["Stinger"]					=  100
scom.PresenceTable["SunFlower"]					= 1350
scom.PresenceTable["T'Kalt Cargo"]				=  300
scom.PresenceTable["T'Kalt Patrol"]				=  450
scom.PresenceTable["Travellers' Breath"]		=  600
scom.PresenceTable["T'Telin"]					=  150
scom.PresenceTable["Valiant Bomber"]			=  270
scom.PresenceTable["Valiant Drone"]				=   75
scom.PresenceTable["Valiant Fighter"]			=  150
scom.PresenceTable["Vikramaditya"]				= 1950
--
-- ==========================================================================


-- ==========================================================================
-- @brief Generates a standard weights table containing all cargos
-- ==========================================================================
--
function scom.WeightTable.AllCargos()
	-- DEBUG
	local strPrefix = "common.lua:scom.WeightTable.AllCargos()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Local table
	local weights = {}

	-- Populate table
	weights[ scom.Alaith ]					= 10
	weights[ scom.Arshiilan ]				=  3
	weights[ scom.Caravelle ]				=  5
	weights[ scom.Erlith ]					=  4
	weights[ scom.Irali ]					=  4
	weights[ scom.Iserlohn ]				=  2
	weights[ scom.Keserlan ]				=  2
	weights[ scom.Lintir ]					=  2
	weights[ scom.Mosquito ]				=  3
	weights[ scom.PercheronMk1 ]			=  3
	weights[ scom.PercheronMk2Containers ]	=  5
	weights[ scom.PercheronMk2Holds ]		=  4
	weights[ scom.PercheronMk2Tanker ]		=  3
	weights[ scom.Shire ]					=  5
	weights[ scom.StarJump ]				=  5
	weights[ scom.Eresslih ]				=  5
	weights[ scom.SunFlower ]				=  1
	weights[ scom.TKaltCargo ]				=  7
	weights[ scom.TravellersBreath ]		=  1

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return weights
end
--
-- ==========================================================================


-- ==========================================================================
-- A set of functions to spawn various ships
-- ==========================================================================
--
-- @brief Spawns a lone Alaith ship
function scom.Alaith ( faction )
	return scom.Ship( "Alaith", scom.PresenceTable["Alaith"] );
end

-- @brief Spawns a lone Arshiilan ship
function scom.Arshiilan ( faction )
	return scom.Ship( "Arshiilan", scom.PresenceTable["Arshiilan"] );
end

-- @brief Spawns a lone Caravelle ship
function scom.Caravelle ( faction )
	return scom.Ship( "Caravelle", scom.PresenceTable["Caravelle"] );
end

-- @brief Spawns a lone Eresslih ship
function scom.Eresslih ( faction )
	return scom.Ship( "Eresslih", scom.PresenceTable["Eresslih"] );
end

-- @brief Spawns a lone Erlith ship
function scom.Erlith ( faction )
	return scom.Ship( "Erlith", scom.PresenceTable["Erlith"] );
end

-- @brief Spawns a lone Irali ship
function scom.Irali ( faction )
	return scom.Ship( "Irali", scom.PresenceTable["Irali"] );
end

-- @brief Spawns a lone Iserlohn ship
function scom.Iserlohn ( faction )
	return scom.Ship( "Iserlohn", scom.PresenceTable["Iserlohn"] );
end

-- @brief Spawns a lone Keserlan ship
function scom.Keserlan ( faction )
	return scom.Ship( "Keserlan", scom.PresenceTable["Keserlan"] );
end

-- @brief Spawns a lone L'Lintir ship
function scom.Lintir ( faction )
	return scom.Ship( "L'Lintir", scom.PresenceTable["L'Lintir"] );
end

-- @brief Spawns a lone Mosquito ship
function scom.Mosquito ( faction )
	return scom.Ship( "Mosquito", scom.PresenceTable["Mosquito"] );
end

-- @brief Spawns a lone Percheron Mk1 ship
function scom.PercheronMk1 ( faction )
	return scom.Ship( "Percheron Mk1", scom.PresenceTable["Percheron Mk1"] );
end

-- @brief Spawns a lone Percheron Mk2 Containers ship
function scom.PercheronMk2Containers ( faction )
	return scom.Ship( "Percheron Mk2 Containers", scom.PresenceTable["Percheron Mk2 Containers"] );
end

-- @brief Spawns a lone Percheron Mk2 Holds ship
function scom.PercheronMk2Holds ( faction )
	return scom.Ship( "Percheron Mk2 Holds", scom.PresenceTable["Percheron Mk2 Holds"] );
end

-- @brief Spawns a lone Percheron Mk2 Tanker ship
function scom.PercheronMk2Tanker ( faction )
	return scom.Ship( "Percheron Mk2 Tanker", scom.PresenceTable["Percheron Mk2 Tanker"] );
end

-- @brief Spawns a lone Shire ship
function scom.StarJump ( faction )
	return scom.Ship( "StarJump", scom.PresenceTable["StarJump"] );
end

-- @brief Spawns a lone StarJump ship
function scom.Shire ( faction )
	return scom.Ship( "StarJump", scom.PresenceTable["StarJump"] );
end

-- @brief Spawns a lone SunFlower ship
function scom.SunFlower ( faction )
	return scom.Ship( "SunFlower", scom.PresenceTable["SunFlower"] );
end

-- @brief Spawns a lone T'Kalt Cargo ship
function scom.TKaltCargo ( faction )
	return scom.Ship( "T'Kalt Cargo", scom.PresenceTable["T'Kalt Cargo"] );
end

-- @brief Spawns a lone Travellers' Breath ship
function scom.TravellersBreath ( faction )
	return scom.Ship( "Travellers' Breath", scom.PresenceTable["Travellers' Breath"] );
end
--
-- ==========================================================================

