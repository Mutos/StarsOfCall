-- ================================================================================================================================
--
-- Define functions to equip a generic ship from the SoC TC
--
-- ================================================================================================================================


-- ================================================================================================================================
-- Define a table of ship-specific equip functions
-- ================================================================================================================================
--
-- Define the table as void
shipEquipFunctions = {}

-- Include all ship-specific scripts
-- Each one adds the ship's script to the table under the ship's name index
include("dat/factions/equip/ships/angrybee.lua")
include("dat/factions/equip/ships/nelktan.lua")
--
-- ================================================================================================================================


-- ================================================================================================================================
-- Reequip ship Utility and Weapon defaults so they are taken into account for Weapon Groups
-- ================================================================================================================================
--
function shipReequipDefaults ( p )
	-- Get all currently equipped outfits
	 outfits = p:outfits ()

	-- Loop on the outfits to reequip them 
	 for _,o in ipairs ( outfits ) do
		-- Get information
		outfitName = o:name ()
		slotName, slotSize = o:slot ()

		-- Leave alone Structure outfits
		if slotName ~= "Structure" then
			-- Unequip the outfit
			p:rmOutfit ( outfitName )

			-- Reequip the outfit
			p:addOutfit ( outfitName )
		end
	 end
end
--
-- ================================================================================================================================


-- ================================================================================================================================
-- Generic equip function
-- ================================================================================================================================
--
function equip_generic( p )
	-- Get ship info
	local shipName = p:ship():name()
	
	 -- print ( string.format("\n\tEquipping generic ship \"%s\"", shipName) )

	 -- Basically reequip the default Utility and Weapon outfits
	 -- so that they are taken into account for the Weapons Groups
	shipReequipDefaults (p)

	-- Call function from a table built by ship-specific Lua scripts
	if shipEquipFunctions[shipName] ~= nil then
		shipEquipFunctions[shipName] (p)
	end
end
--
-- ================================================================================================================================
