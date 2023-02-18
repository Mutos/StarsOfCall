-- ================================================================================================================================
--
-- Define functions to equip a generic ship from the SoC TC
--   - Faction : independent
--
-- ================================================================================================================================


-- ================================================================================================================================
-- Generic equipping routines
-- ================================================================================================================================
--
include("dat/factions/equip/generic.lua")
--
-- ================================================================================================================================


-- ================================================================================================================================
-- Actually equip the ship
-- ================================================================================================================================
--
function equip ( p )
	-- Get ship info
	local class = p:ship():class()
	local shipBaseType = p:ship():baseType()
	local shipName = p:ship():name()

	 -- print ( string.format("\nEquipping independent ship \"%s\"", shipName) )
	 
	-- Split by type
	equip_generic( p )
	
	-- Set faction
	p:setFaction( "Independent" )
	-- p:rename ("Independent " .. p:name() )

	 -- Debug -- printout
	 outfits = p:outfits ()
	 for _,o in ipairs(outfits) do
		slotName, slotSize = o:slot()
		 -- print ( string.format("\t\t%s %s : %s", slotSize, slotName, o:name () ))
	 end
	 ws_name, ws = p:weapset( true )
	 -- print ( "\tWeapon Set (true) Name: " .. ws_name )
	 for _,w in ipairs(ws) do
		 -- print ( string.format ("\t\t%s", w.name ) )
	 end
	 for i = 0, 9 do
		 ws_name, ws = p:weapset( 1 )
		 -- print ( string.format ( "\tWeapon Set (%i) Name: %s", i, ws_name ) )
		 for _,w in ipairs(ws) do
			 -- print ( string.format ("\t\t%s", w.name ) )
		 end
	 end
end
--
-- ================================================================================================================================
