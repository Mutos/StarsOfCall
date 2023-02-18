--[[
-- Include file for npc.lua
-- Defines the messages related to jump points
--]]

if lang == 'es' then --not translated atm
else --default english
	-- Jump point messages.
	-- For giving the location of a jump point in the current system to the player for free.
	-- All messages must contain exactly one %s, this is the name of the target system.
	-- ALL NPCs have a chance to say one of these lines instead of a lore message.
	-- So, make sure the tips are always faction neutral.
	msg_jmp =                  {"Hi there, traveler. Is your system map up to date? Just in case you didn't know already, let me give you the location of the jump from here to %s. I hope that helps.",
										 "Quite a lot of people who come in here complain that they don't know how to get to %s. I travel there often, so I know exactly where the jump point is. Here, let me show you.",
										 "So you're still getting to know about this area, huh? Tell you what, I'll give you the coordinates of the jump to %s. Check your map next time you take off!",
										 "True fact, there's a direct jump from here to %s. Want to know where it is? It'll cost you! Ha ha, just kidding. Here you go, I've added it to your map.",
										 "There's a system just one jump away by the name of %s. I can tell you where the jump point is. There, I've updated your map. Don't mention it."
										}
end
