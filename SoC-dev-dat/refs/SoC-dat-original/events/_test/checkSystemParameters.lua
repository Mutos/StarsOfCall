--[[
	Event for checking various system parameters.
	Activated from event.xml when needed for debug purposes.
	Prints out various system parameters.
--]]

-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Event prefix for variables
evtPrefix = "evt_Test_SystemParameters_"

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

--
-- =======================================================================================


-- =======================================================================================
--
-- Setup strings
-- 
-- =======================================================================================
--

if lang == "es" then
	 -- not translated atm
else -- default english 
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Include helper functions
include "select/selectShipType.lua"
include "select/selectShipName.lua"
include "select/selectSpecies.lua"

-- Include helper functions
include ("dat/events/_commons/_commons.lua")

--
-- =======================================================================================


-- =======================================================================================
--
-- Event standard functions, called by the engine
--	create()	From event.xml
-- 
-- =======================================================================================
--

-- Create the event
function create ()
	print ( string.format( "\nDEBUG System Parameters : entering create()" ) )

	-- Get current system
	local currentSystem = system.cur()

	-- Get and print factions list
	local presencesList = currentSystem:presences()
	local factionsList = {}
	print (string.format("\n\tFactions in system %s :",currentSystem:name()))
	for faction,presence in pairs(presencesList) do
		print (string.format("\t\t%s (%u%%)",faction,presence))
		table.insert( factionsList, faction )
	end
	print (string.format("\tEnd of factions list"))

	-- Get and print species list
	local speciesList = selectSpeciesList(factionsList)
	print (string.format("\n\tSpecies in system %s :",currentSystem:name()))
	for _,species in pairs(speciesList) do
		print (string.format("\t\t%s",species))
		local keywords = { "+"..species}
		table.insert( keywords, "civilian" )
		table.insert( keywords, "spacer" )
		local shipNamesList = selectShipNamesList(keywords, true)
		print (string.format("\t\tReduced cargo ship names based on species \"%s\" in system \"%s\" :", species, currentSystem:name()))
		for _,shipName in pairs(shipNamesList) do
			print (string.format("\t\t\t%s",shipName))
		end
		print (string.format("\t\tEnd of cargo ship names list"))
	end
	print (string.format("\tEnd of species list"))

	print (string.format("\n\tExample of ship name : %s", selectShipNameFromFactionsList(factionsList)))

	-- End of print
	print ( string.format( "\nDEBUG System Parameters : exiting create()" ) )

	-- Properly close the event
	 evt.finish()
end

--
-- =======================================================================================
