-- ================================================================================================================================
--
-- Define functions to equip a generic ship from the SoC TC
--   - Faction : pirate
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

	 -- print ( string.format ( "\nEquipping pirate ship %s", shipName ) )

	 -- Split by type
	 equip_generic( p )
	
	-- On fighters, replace all Laser Cannons by Ion Cannons to disable rather than kill
	 outfits = p:outfits ()
	 for _,o in ipairs(outfits) do
		if o:name () == "Fighter Laser Cannon" then
			p:rmOutfit("Fighter Laser Cannon")
			p:addOutfit("Fighter Ion Cannon")
		end 
	 end
	 
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
