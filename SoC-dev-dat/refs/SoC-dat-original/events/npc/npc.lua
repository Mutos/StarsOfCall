
--[[
-- Event for creating random characters in the spaceport bar.
-- The random NPCs will tell the player things about the Naev universe in general, about their faction, or about the game itself.
-- This file contains the mechanisms to retrieve and display the messages.
-- Actual messages are dispatched in several smaller include files for different types of messages
--]]

-- Define the variables
lang = naev.lang()
civ_port = {}
civ_name = "Civilian"
msg_lore = {}

-- Include tutorial information
include "dat/events/tutorial/tutorial-common.lua"	-- Used for referencing the tutorials

-- Include common data
include "dat/events/npc/common/descriptions.lua"	-- NPCs generic descriptions
include "dat/events/npc/common/tips.lua"			-- Gameplay tips
include "dat/events/npc/common/jumps.lua"			-- Jump points information
include "dat/events/npc/common/events.lua"			-- Events hints and after-care
include "dat/events/npc/common/missions.lua"		-- Missions hints and after-care

-- Include faction-specific data
include "dat/events/npc/factions/general.lua"			-- General portraits and lore messages
include "dat/events/npc/factions/independent.lua"		-- Portraits and lore messages related to the Independents
include "dat/events/npc/factions/hoshinohekka.lua"		-- Portraits and lore messages related to the Hoshi no Hekka
include "dat/events/npc/factions/aktamanniskor.lua"		-- Portraits and lore messages related to the Akta Manniskor
include "dat/events/npc/factions/irilia.lua"			-- Portraits and lore messages related to the Irilia Clan
include "dat/events/npc/factions/arythem.lua"			-- Portraits and lore messages related to the Arythem Clan
include "dat/events/npc/factions/irmothem.lua"			-- Portraits and lore messages related to the Irmothem Clan
include "dat/events/npc/factions/coreleague.lua"		-- Portraits and lore messages related to the Core League
include "dat/events/npc/factions/danebanarchs.lua"		-- Portraits and lore messages related to the Daneb Anarchs

function create()
	-- Logic to decide what to spawn, if anything.
	-- TODO: Do not spawn any NPCs on restricted assets.

	local num_npc = rnd.rnd(1, 5)
	npcs = {}
	for i = 0, num_npc do
		spawnNPC()
	end

	-- End event on takeoff.
	hook.takeoff( "leave" )
end

-- Spawns an NPC.
function spawnNPC()
	local npcname = civ_name
	local factions = {}
	local func = nil

	-- Select a faction for the NPC. NPCs may not have a specific faction.
	for i, _ in pairs(msg_lore) do
		factions[#factions + 1] = i
	end

	local fac = "general"
	local select = rnd.rnd()
	if select >= (0.5) and planet.cur():faction() ~= nil then
		fac = planet.cur():faction():name()
	end

	-- Append the faction to the civilian name, unless there is no faction.
	if fac ~= "general" then
		npcname = fac .. " " .. civ_name
	end

	-- Select a portrait
	local portrait = getCivPortrait(fac)

	-- Select a description for the civilian.
	local desc = civ_desc[rnd.rnd(1, #civ_desc)]

	-- Select what this NPC should say.
	select = rnd.rnd()
	local msg
	if select <= 0.3 then
		-- Lore message.
		msg = getLoreMessage(fac)
	elseif select <= 0.55 then
		-- Jump point message.
		msg, func = getJmpMessage()
	elseif select <= 0.8 then
		-- Gameplay tip message.
		msg = getTipMessage()
	else
		-- Mission hint message.
		msg = getMissionLikeMessage()
	end

	local npcdata = {name = npcname, msg = msg, func = func}

	id = evt.npcAdd("talkNPC", npcname, portrait, desc, 10)
	npcs[id] = npcdata
end

-- Returns a lore message for the given faction.
function getLoreMessage(fac)
	-- Get lore messages for the given faction
	local facmsg = msg_lore[fac]

	if fac == nil then
		-- print (  "\tLore messages : no Faction given" )
	else
		-- print ( string.format( "\tLore messages : Faction = \"%s\"", fac ))
	end

	if facmsg == nil or #facmsg == 0 then
		-- print ( "\t\tLore messages : no messages for Faction, taking General" )
		facmsg = msg_lore["general"]
		if facmsg == nil or #facmsg == 0 then
			-- print ( "\t\tLore messages : no message for Faction or General, finishing Event" )
			evt.finish(false)
		end
	end

	-- DEBUG : -- print the # of lore messages found
	-- print ( string.format("\t\tLore messages : %i messages found", #facmsg))

	-- Select a string, then remove it from the list of valid strings. This ensures all NPCs have something different to say.
	local select = rnd.rnd(1, #facmsg)
	local pick = facmsg[select]
	-- print ( string.format("\t\tLore messages : message selected : \"%s\"", pick, #facmsg))
	table.remove(facmsg, select)
	-- print ( string.format("\t\tLore messages : %i messages at end of selection", #facmsg))
	return pick
end

-- Returns a jump point message and updates jump point known status accordingly. If all jumps are known by the player, defaults to a lore message.
function getJmpMessage()
	-- Collect a table of jump points in the system the player does NOT know.
	local mytargets = {}
	seltargets = seltargets or {} -- We need to keep track of jump points NPCs will tell the player about so there are no duplicates.
	for _, j in ipairs(system.cur():jumps(true)) do
		if not j:known() and not j:hidden() and not seltargets[j] then
			table.insert(mytargets, j)
		end
	end
	
	if #mytargets == 0 then -- The player already knows all jumps in this system.
		return getLoreMessage(), nil
	end

	-- All jump messages are valid always.
	if #msg_jmp == 0 then
		return getLoreMessage(), nil
	end
	local retmsg =  msg_jmp[rnd.rnd(1, #msg_jmp)]
	local sel = rnd.rnd(1, #mytargets)
	local myfunc = function()
							mytargets[sel]:setKnown(true)
							mytargets[sel]:system():setKnown(true, false)
						end

	-- Don't need to remove messages from tables here, but add whatever jump point we selected to the "selected" table.
	seltargets[mytargets[sel]] = true
	return retmsg:format(mytargets[sel]:dest():name()), myfunc
end

-- Returns a tip message.
function getTipMessage()
	-- All tip messages are valid always.
	if #msg_tip == 0 then
		return getLoreMessage()
	end
	local sel = rnd.rnd(1, #msg_tip)
	local pick = msg_tip[sel]
	table.remove(msg_tip, sel)
	return pick
end

-- Returns a mission hint message, a mission after-care message, OR a lore message if no missionlikes are left.
function getMissionLikeMessage()
	if not msg_combined then
		msg_combined = {}

		-- Hints.
		-- Hint messages are only valid if the relevant mission has not been completed and is not currently active.
		for i, j in pairs(msg_mhint) do
			if not (player.misnDone(j[1]) or player.misnActive(j[1])) then
				msg_combined[#msg_combined + 1] = j[2]
			end
		end
		for i, j in pairs(msg_ehint) do
			if not(player.evtDone(j[1]) or player.evtActive(j[1])) then
				msg_combined[#msg_combined + 1] = j[2]
			end
		end
	
		-- After-care.
		-- After-care messages are only valid if the relevant mission has been completed.
		for i, j in pairs(msg_mdone) do
			if player.misnDone(j[1]) then
				msg_combined[#msg_combined + 1] = j[2]
			end
		end
		for i, j in pairs(msg_edone) do
			if player.evtDone(j[1]) then
				msg_combined[#msg_combined + 1] = j[2]
			end
		end
	end

	if #msg_combined == 0 then
		return getLoreMessage()
	else
		-- Select a string, then remove it from the list of valid strings. This ensures all NPCs have something different to say.
		local sel = rnd.rnd(1, #msg_combined)
		local pick
		pick = msg_combined[sel]
		table.remove(msg_combined, sel)
		return pick
	end
end

-- Returns a portrait for a given faction.
function getCivPortrait(fac)
	-- Get a factional portrait if possible, otherwise fall back to the generic ones.
	if civ_port[fac] == nil or #civ_port[fac] == 0 then
		fac = "general"
	end
	return civ_port[fac][rnd.rnd(1, #civ_port[fac])]
end

function talkNPC(id)
	local npcdata = npcs[id]

	if npcdata.func then
		-- Execute NPC specific code
		npcdata.func()
	end

	tk.msg(npcdata.name, "\"" .. npcdata.msg .. "\"")
end

--[[
--	 Event is over when player takes off.
--]]
function leave ()
	evt.finish()
end
