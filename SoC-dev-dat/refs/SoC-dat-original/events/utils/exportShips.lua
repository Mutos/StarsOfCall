--[[
-- Ships export
-- 
-- Export all ships stats into stdout in CSV format, to be pasted in a spreadsheet
-- 
--]]


-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_ExportShips_"

-- List of ships to export
tabListShips = {
		"Eclair d'Etoiles",
		"Alaith",
		"Faithful",
		"StarJump",
		"Erlith",
		"Shire",
		"T'Kalt Cargo",
		"Caravelle",
		"Eresslih",
		"Arshiilan",
		"Fast Shell",
		"Mosquito",
		"Travellers' Breath",
		"Percheron Mk2 Containers",
		"Percheron Mk2 Holds",
		"Percheron Mk1",
		"Percheron Mk2 Tanker",
		"Irali",
		"L'Lintir",
		"SunFlower",
		"Iserlohn",
		"Keserlan",
		"Diwali",
		"Angry Bee Drone",
		"Valiant Drone",
		"Angry Bee Fighter",
		"Valiant Fighter",
		"Stinger",
		"Nelk'Tan",
		"Eershlan",
		"Valiant Bomber",
		"Akk'Ti'Makkt",
		"T'Telin",
		"Bao Zheng",
		"T'Kalt Patrol",
		"Sshilaan",
		"Ma'Tang",
		"Vikramaditya"
	}
	

-- List of stats to export
tabListStats = {
		{ "mass", "Mass" },
		{ "crew", "Crew" },
		{ "cpu", "CPU" },
		{ "cpu_max", "Max CPU" },
		{ "energy", "Energy" },
		{ "energy_regen", "EnReg" },
		{ "armour", "Armour" },
		{ "armour_regen", "ArmReg" },
		{ "absorb", "DamAbs" },
		{ "shield", "Shield" },
		{ "shield_regen", "ShldReg" },
		{ "speed", "Speed" },
		{ "speed_max", "MxSp" },
		{ "thrust", "Thrust" },
		{ "turn", "Turn Rate" },
		{ "fuel_consumption", "Fuel/Jmp" },
		{ "fuel_max", "MxFuel" },
		{ "fuel", "Fuel" },
		{ "jumps", "Jumps" }
}

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- None so far

--
-- =======================================================================================


-- =======================================================================================
--
-- Setup strings
-- 
-- =======================================================================================
--

lang = naev.lang()

if lang == "es" then
	-- not translated atm
else -- default english 
	-- No text for now
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Include convoy helper
include ("dat/events/fleets/common.lua")

-- Include helper functions
include ("dat/events/_commons/_commons.lua")

--
-- =======================================================================================


-- =======================================================================================
--
-- Main event function
-- 
-- =======================================================================================
--

function create ()
	-- Local variables
	local tabAllStats = {}
	
	-- Tell we're entering the event
	-- print ( string.format( "\nShip Export Event (%s) : entering event create() ", time.str()))
	
	-- CSV export, with ships as lines and stats as columns
	print("")
	
	-- Print header
	local strHeader  = "Class;Name;Structure;Utility;Weapons;"
	for k,v in ipairs(tabListStats) do
		strHeader = strHeader .. tabListStats[k][2] .. ";"
	end
	print ( strHeader )

	-- Loop on all listed ships
	for k,v in ipairs(tabListShips) do
		-- Spawn a ship to get its stats
		local objPilot = spawnShip(v)
		objPilot:rmOutfit( "all" )
		local tabRawStats = objPilot:stats()
		local slots_weapon, slots_utility, slots_structure = objPilot:ship():slots()
		local strClass = objPilot:ship():class()
	 
		-- Print ship stats line
		local strShipLine  = string.format( "%s;%s;%i;%i;%i;", strClass, v, slots_structure, slots_utility, slots_weapon )
		for k,v in ipairs(tabListStats) do
			strStatValue = tabRawStats[v[1]]
			strShipLine = string.format( "%s%i;", strShipLine, strStatValue )
		end
		print ( strShipLine )
	end
	print("")

	-- Tell we're exiting the event
	-- print ( string.format( "Ship Export Event (%s) : exiting event create() : event created", time.str()))

	-- Finish the event
	evt.finish()
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Spawn a ship of the specified class and export its stats to stdout
-- 
-- =======================================================================================
--

function spawnShip( strShipType )
	-- Tell we're entering the event
	-- print ( string.format( "\nShip Export Event (%s) : entering spawnShip()", time.str()))

	-- Flag to see if we actually create a ship
	local spawnFlag = true

	-- Set the ship's type
	local shipType = strShipType

	-- Actually generate the ship
	local newFleet = pilot.add(shipType, "dummy", true)

	-- Get stats
	local objPilot = newFleet[1]
	
	-- Tell we're exiting the event
	-- print ( string.format( "Ship Export Event (%s) : exiting spawnShip()", time.str()))

	-- Return Stats Table
	return objPilot
end

--
-- =======================================================================================
