--[[
-- Include file for npc.lua
-- Defines the messages related to events
--]]

if lang == 'es' then --not translated atm
else --default english

	-- Event hint messages. Each element should be a table containing the event name and the corresponding hint.
	-- Make sure the hints are always faction neutral.
	msg_ehint =                {}

	-- Event after-care messages. Each element should be a table containing the event name and a line of text.
	-- This text will be said by NPCs once the player has completed the event in question.
	-- Make sure the messages are always faction neutral.
	msg_edone =                {{"Animal trouble", "What? You had rodents sabotage your ship? Man, you're lucky to be alive. If it had hit the wrong power line..."},
										}
end
