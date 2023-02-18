--[[
-- Include file for npc.lua
-- Defines the messages related to missions
--]]

if lang == 'es' then --not translated atm
else --default english
	-- Mission hint messages. Each element should be a table containing the mission name and the corresponding hint.
	-- ALL NPCs have a chance to say one of these lines instead of a lore message.
	-- So, make sure the hints are always faction neutral.
	msg_mhint =                {}

	-- Mission after-care messages. Each element should be a table containing the mission name and a line of text.
	-- This text will be said by NPCs once the player has completed the mission in question.
	-- Make sure the messages are always faction neutral.
	msg_mdone =                {}
end
