--[[
	Select a ship name based on keywords.
	Used by events and missions to help get consistent ship names throughout the game.
--]]


-- =======================================================================================
--
--   Include generic function
-- 
-- =======================================================================================
--
include "select/selectFromKeywords.lua"
include "select/selectSpecies.lua"
--
-- =======================================================================================


-- =======================================================================================
--
-- Define keywords for each ship name.
-- This is a file-local (chunk-local in fact) variable, not seen by the including file.
-- 
-- =======================================================================================
--
local shipNames = {
	{value = "Endeavour",                keywords = "human, civilian, military, states, spacer, miner, pirate, value"},
	{value = "Lode Runner",              keywords = "human, civilian, states, spacer, pirate, reference"},
	{value = "Wanderjahr Forever",       keywords = "human, civilian, spacer, pirate, tradition"},
	{value = "Inigo-Montoya",            keywords = "human, spacer, pirate, reference, character"},
	{value = "Bandirma",                 keywords = "human, civilian, states, spacer, pirate, place"},
	{value = "Vikrant",                  keywords = "human, military, states, pirate, value"},
	{value = "Golden Nori",              keywords = "human, civilian, states, spacer, pirate"},
	{value = "Golfito ",                 keywords = "human, civilian, states, place"},
	{value = "Avenir",                   keywords = "human, civilian, states, place"},
	{value = "Fier Dandy",               keywords = "human, civilian, states, spacer, pirate, value"},
	{value = "Guoxingye",                keywords = "human, spacer, pirate, character"},
	{value = "Voortrekker",              keywords = "human, spacer, civilian, character"},
	{value = "Zheng Zhilong",            keywords = "human, spacer, pirate, character"},
	{value = "Kang Youwei",              keywords = "human, civilian, states, spacer, miner, pirate, character"},
	{value = "Irol",                     keywords = "rith, civilian, states, spacer, miner, adrim, character"},
	{value = "D'rih",                    keywords = "rith, adrim, miner, value"},
	{value = "Erlithan",                 keywords = "rith, civilian, spacer, pirate, value"},
	{value = "Skam",                     keywords = "rith, states, military, spacer, value"},
	{value = "Leinth",                   keywords = "rith, civilian, states, spacer, adrim, place"},
	{value = "Irel",                     keywords = "rith, civilian, states, place"},
	{value = "Leinth-Naan",              keywords = "rith, civilian, spacer, pirate, adrim, character"},
	{value = "Esthel Nalth",             keywords = "rith, civilian, spacer, adrim, place"},
	{value = "K'Tin'Tal",                keywords = "krinn, civilian, states, spacer, place"},
	{value = "E'Ktel",                   keywords = "krinn, civilian, states, value"},
	{value = "T'Tierlin",                keywords = "krinn, civilian, spacer, miner, miner, character"},
	{value = "B'Tierlin",                keywords = "krinn, military, states, character"},
	{value = "T'Ralt",                   keywords = "krinn, civilian, states, spacer, pirate, character"},
	{value = "Elshaal",                  keywords = "sshaad, civilian, states, spacer, pirate, character"},
	{value = "Vitzh",                    keywords = "sshaad, spacer, pirate, value"},
	{value = "Biishaama",                keywords = "sshaad, states, military, character"},
	{value = "Aaareli",                  keywords = "sshaad, civilian, states, spacer, miner, character"},
	{value = "Sshiinaal",                keywords = "sshaad, civilian, states, spacer, miner, pirate, value"}
}
--
-- =======================================================================================


-- =======================================================================================
--
--   Function definition
-- 
-- =======================================================================================
--
function selectShipName(keywordsList)
	return selectFromKeywords(shipNames, keywordsList)
end

function selectShipNamesList(keywordsList, reduce)
	return selectListFromKeywords(shipNames, keywordsList, reduce)
end

function selectShipNameFromFactionsList(factionsList, keywordsList)
	local randomSpecies = selectSpecies(factionsList)
	local keywordsFinalList = {"+"..randomSpecies}
	if keywordsList ~= nil then
		for _,s in keywordsList do
			table.insert( keywordsFinalList, s )
		end
	end
	return selectFromKeywords(shipNames, keywordsFinalList)
end
--
-- =======================================================================================
