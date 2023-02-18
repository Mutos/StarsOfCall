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
		"Akk'Ti'Makkt",
		"Alaith",
		"Angry Bee Fighter",
		"Angry Bee Drone",
		"Arshiilan",
		"Bao Zheng",
		"Caravelle",
		"Diwali",
		"Eclair d'Etoiles",
		"Eershlan",
		"Eresslih",
		"Erlith",
		"Faithful",
		"Fast Shell",
		"Irali",
		"Iserlohn",
		"Keserlan",
		"L'Lintir",
		"Ma'Tang",
		"Mosquito",
		"Nelk'Tan",
		"Percheron Mk1",
		"Percheron Mk2 Containers",
		"Percheron Mk2 Holds",
		"Percheron Mk2 Tanker",
		"Shire",
		"Sshilaan",
		"StarJump",
		"Stinger",
		"SunFlower",
		"T'Kalt Cargo",
		"T'Kalt Patrol",
		"Travellers' Breath",
		"Valiant Drone",
		"Valiant Fighter",
		"Valiant Bomber",
		"Vikramaditya"
	}

-- List of stats to export
tabListStats = {
		{ "crew", "Crew" },
		{ "cpu", "CPU" },
		{ "cpu_max", "Max CPU" },
		{ "mass", "Mass" },
		{ "armour", "Armour" },
		{ "armour_regen", "Armour Regeneration" },
		{ "absorb", "Damage Absorbtion" },
		{ "shield", "Shield" },
		{ "shield_regen", "Shield Regeneration" },
		{ "energy", "Energy" },
		{ "energy_regen", "Energy Regeneration" },
		{ "speed", "Speed" },
		{ "speed_max", "Max Speed" },
		{ "thrust", "Thrust" },
		{ "turn", "Turn Rate" },
		{ "fuel_consumption", "Jump Fuel Consumption" },
		{ "fuel_max", "Max Fuel" },
		{ "fuel", "Fuel" },
		{ "jumps", "Jump Capacity" },
		{ "jump_delay", "Jump Delay" }
}

-- Context
currentSystem = system.cur()
faction = "Independent"

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- Pilots
pilotTest = nil

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
	-- print ( string.format( "\nShip Export Event (%s) : entering event create() for faction \"%s\"", time.str(), faction))
	
	-- CSV export, with ships as lines and stats as columns
	print("")
	
	-- Print header
	local strHeader  = "Name;"
	for k,v in ipairs(tabListStats) do
		strHeader = strHeader .. tabListStats[k][2] .. ";"
	end
	print ( strHeader )

	-- Loop on all listed ships
	for k,v in ipairs(tabListShips) do
		-- Spawn a ship to get its stats
		local tabRawStats = spawnShip(v)
	 
		-- Print ship stats line
		local strShipLine  = v .. ";"
		for k,v in ipairs(tabListStats) do
			strStatValue = tabRawStats[v[1]]
			strShipLine = strShipLine .. strStatValue .. ";"
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
	tabRawStats = newFleet[1]:stats()
	
	-- Tell we're exiting the event
	-- print ( string.format( "Ship Export Event (%s) : exiting spawnShip()", time.str()))

	-- Return Stats Table
	return tabRawStats
end

--
-- =======================================================================================
