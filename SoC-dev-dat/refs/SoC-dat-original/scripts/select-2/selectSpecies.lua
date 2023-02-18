--[[
	Select a species list or a species based on a factions list.
	Used by events and missions to help get consistent characters species throughout the game.
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
-- Define keywords for each species.
-- This is a file-local (chunk-local in fact) variable, not seen by the including file.
-- 
-- =======================================================================================
--

-- All factions of which the species is a major element, repetition denotes probabilities
local speciesFromFactions = {
	{value = "krinn",                    keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Pirate, Ashioto Cluster, Ashioto Cluster, Ashioto Cluster, Shadow Complex, HnH, Ka'Ralt Secession, Ka'Ralt Secession, Ka'Ralt Secession, Ka'Ralt Secession, K'Rinn Council, K'Rinn Council, K'Rinn Council, K'Rinn Council, K'Rinn Council, K'Rinn Council, K'Rinn Council, K'Rinn Council, Pei Clan-Family"},
	{value = "rith",                     keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Pirate, Shadow Complex, HnH, Aragwedyr Clan, Gham Garri, Free Adrimai, JnI, Arythem Clan, Arythem Clan, Arythem Clan, Arythem Clan, Irmothem Clan, Irmothem Clan, Irmothem Clan, Irmothem Clan, Irilia Clan, Irilia Clan, Irilia Clan, Irilia Clan, Irilia Clan, Irilia Clan, Erdil Clan, Rithai Kemae, Rithai Kemae, Joint Peacekeepers Corps, Pei Clan-Family"},
	{value = "human",                    keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Pirate, Ashioto Cluster, Shadow Complex, Shadow Complex, HnH, HnH, Akta Manniskor, Purple Trail, Purple Trail, Purple Trail, Banthory Autarcy, Ziffel Empire, Core League, Core League, Core League, Core League, Core League, Pei Clan-Family, Aragwedyr Clan, Alliance, Alliance, Alliance, Alliance, Alliance, Alliance, Alliance, Alliance, Stellar Police"},
	{value = "sshaad",                   keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Pirate, Ren'sh Planetary Council, Candidate Systems, Candidate Systems, Candidate Systems, Complementarist Protectorate, Baartish Intersystems, Baartish Intersystems, Baartish Intersystems, Baartish Intersystems, Baartish Intersystems, Shoden Clusters, Shoden Clusters, Instrumentality Company, Instrumentality Company, Instrumentality Company, HnH, Aragwedyr Clan, Joint Peacekeepers Corps, Purple Trail"},
	{value = "pupeteer",                 keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Red Quadrant League, Red Quadrant League, Red Quadrant League, Red Quadrant League, Thirteen Planets League, Thirteen Planets League, Thirteen Planets League, Thirteen Planets League"},
	{value = "shapeshifter",             keywords = "Independent, Dummy, Asteroids, Civilian, Free Traders, Trader, Pirate, Proteous Resistance, Ren'sh Planetary Council, Candidate Systems, Candidate Systems, Baartish Intersystems, Baartish Intersystems, Baartish Intersystems, Complementarist Protectorate, Complementarist Protectorate, HnH, Shadow Complex, Aragwedyr Clan"}
}
--
-- =======================================================================================


-- =======================================================================================
--
--   Function definition
-- 
-- =======================================================================================
--
function selectSpecies(factionsList)
	return selectFromKeywords(speciesFromFactions, factionsList)
end

function selectSpeciesList(factionsList, reduce)
	return selectListFromKeywords(speciesFromFactions, factionsList, reduce)
end
--
-- =======================================================================================
