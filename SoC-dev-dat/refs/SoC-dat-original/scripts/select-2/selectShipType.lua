--[[
	Select a ship type based on keywords.
	Used by events and missions to help get consistent ship types throughout the game.
--]]


-- =======================================================================================
--
--   Include generic function
-- 
-- =======================================================================================
--
include "select/selectFromKeywords.lua"
--
-- =======================================================================================


-- =======================================================================================
--
-- Define keywords for each ship type.
-- This is a file-local (chunk-local in fact) variable, not seen by the including file.
-- 
-- =======================================================================================
--
local shipTypes = {
	{value = "Angry Bee Fighter",        keywords = "military, fighter, guns, missiles, pirate, human, human, human, krinn, krinn, sshaad, shapeshifter"},
	{value = "Angry Bee Drone",          keywords = "military, fighter, drone, guns, missiles, pirate, human, human, krinn, krinn, krinn, rith, sshaad, shapeshifter"},
	{value = "Akk'Ti'Makkt",             keywords = "military, fighter, bomber, missiles, pirate, krinn, krinn, human, rith"},
	{value = "Alaith",                   keywords = "cargo, tramp, reentry, courier, contraband, pirate, rith, rith, rith, krinn, krinn, human, human, sshaad, shapeshifter"},
	{value = "Arshiilan",                keywords = "cargo, tramp, miner, pirate, sshaad, sshaad, sshaad, sshaad, shapeshifter, shapeshifter, human, rith, krinn"},
	{value = "Bao Zheng",                keywords = "patrol, police, scout, human, human, human, krinn, rith"},
	{value = "Caravelle",                keywords = "cargo, tramp, pirate, human, human, human, krinn, krinn, rith, rith, sshaad, shapeshifter, outdated"},
	{value = "Diwali",                   keywords = "liner, luxury, human"},
	{value = "Eclair d'Etoiles",         keywords = "cargo, courier, contraband, pirate, human, human, krinn, rith"},
	{value = "Eershlan",                 keywords = "military, fighter, guns, pirate, sshaad, sshaad, sshaad, shapeshifter, shapeshifter, human, krinn, rith"},
	{value = "Eresslih",                 keywords = "cargo, tramp, miner, pirate, sshaad, sshaad, shapeshifter, shapeshifter, human, krinn, rith, outdated"},
	{value = "Erlith",                   keywords = "cargo, tramp, reentry, pirate, rith, rith, human, krinn, outdated"},
	{value = "Faithful",                 keywords = "cargo, tramp, courier, contraband, pupeteer"},
	{value = "Irali",                    keywords = "cargo, containers, pirate, rith, human, krinn, outdated"},
	{value = "Iserlohn",                 keywords = "cargo, containers, human, human, human, rith, krinn, outdated"},
	{value = "L'Lintir",                 keywords = "cargo, containers, krinn, krinn, krinn, human, rith, pirate, outdated"},
	{value = "Keserlan",                 keywords = "cargo, armored, bulk, rith, rith, krinn, human"},
	{value = "Ma'Tang",                  keywords = "military, carrier, cruiser, krinn"},
	{value = "Mosquito",                 keywords = "miner, miner, miner, miner, miner, human, human, krinn, rith"},
	{value = "Nelk'Tan",                 keywords = "military, fighter, guns, missiles, krinn, krinn, human, sshaad, pirate, outdated"},
	{value = "Percheron Mk1",            keywords = "cargo, bulk, miner, pirate, human, krinn, rith, sshaad, outdated"},
	{value = "Percheron Mk2 Containers", keywords = "cargo, container, human, human, krinn, rith"},
	{value = "Percheron Mk2 Holds",      keywords = "cargo, bulk, pirate, human, human, krinn, rith"},
	{value = "Percheron Mk2 Tanker",     keywords = "cargo, tanker, human, human, krinn, rith"},
	{value = "Shire",                    keywords = "cargo, tramp, miner, pirate, human, human, human, krinn, krinn, rith, sshaad, shapeshifter, outdated"},
	{value = "StarJump",                 keywords = "cargo, tramp, miner, pirate, human, human, krinn, krinn, rith, sshaad, shapeshifter, armored"},
	{value = "Sshilaan",                 keywords = "military, carrier, cruiser, sshaad"},
	{value = "SunFLower",                keywords = "cargo, containers, pupeteer"},
	{value = "T'Kalt Cargo",             keywords = "cargo, tramp, miner, pirate, krinn, krinn, human, rith, shapeshifter, outdated"},
	{value = "T'Kalt Patrol",            keywords = "patrol, police, scout, pirate, krinn, krinn, human, rith, sshaad, shapeshifter, outdated"},
	{value = "Travellers' Breath",       keywords = "cargo, bulk, pupeteer"},
	{value = "T'Telin",                  keywords = "military, fighter, guns, missiles, krinn"},
	{value = "Valiant Drone",            keywords = "military, drone, guns, pupeteer"},
	{value = "Valiant Fighter",          keywords = "military, fighter, guns, pupeteer"},
	{value = "Valiant Bomber",           keywords = "military, fighter, bomber, guns, missiles, pupeteer"},
	{value = "Vikramaditya",             keywords = "military, carrier, cruiser, human"}
}
--
-- =======================================================================================


-- =======================================================================================
--
--   Function definition
-- 
-- =======================================================================================
--
function selectShipType(keywordsList)
	return selectFromKeywords(shipTypes, keywordsList)
end

function selectShipTypesList(keywordsList, reduce)
	return selectListFromKeywords(shipTypes, keywordsList, reduce)
end
function selectShipTypeFromFactionsList(factionsList, keywordsList)
	local randomSpecies = selectSpecies(factionsList)
	local keywordsFinalList = {"+"..randomSpecies}
	if keywordsList ~= nil then
		for _,s in keywordsList do
			table.insert( keywordsFinalList, s )
		end
	end
	return selectFromKeywords(shipTypes, keywordsFinalList)
end
--
-- =======================================================================================
