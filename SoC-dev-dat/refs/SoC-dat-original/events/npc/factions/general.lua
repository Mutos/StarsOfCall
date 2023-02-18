--[[
-- Include file for npc.lua
-- Defines the general portraits and lore messages
--]]

if lang == 'es' then --not translated atm
else --default english
	-- Portraits.
	-- When adding portraits, make sure to add them to the table of the faction they belong to.
	-- Does your faction not have a table? Then just add it. The script will find and use it if it exists.
	-- Make sure you spell the faction name exactly the same as in faction.xml though!
	-- Only a small selection of Human figures are given there, until more portraits are available for the other species
	civ_port["general"] =	{
		"human/neutral/civilian/asian",
		"human/neutral/civilian/male10",
		"human/neutral/civilian/male11",
		"human/neutral/civilian/male12",
		"human/neutral/civilian/male13",
		"human/neutral/civilian/male14",
		"human/neutral/civilian/male15",
		"human/neutral/civilian/male16",
		"human/neutral/civilian/male17",
		"human/neutral/civilian/male18",
		"human/neutral/civilian/male19",
--		"human/neutral/civilian/male2",
--		"human/neutral/civilian/male20",
--		"human/neutral/civilian/male3",
--		"human/neutral/civilian/male4",
--		"human/neutral/civilian/male6",
--		"human/neutral/civilian/male7",
--		"human/neutral/civilian/male8",
--		"human/neutral/civilian/male9",
--		"human/neutral/civilian/women",
--		"human/neutral/civilian/women10",
--		"human/neutral/civilian/women11",
--		"human/neutral/civilian/women12",
--		"human/neutral/civilian/women13",
--		"human/neutral/civilian/women14",
--		"human/neutral/civilian/women15",
--		"human/neutral/civilian/women16",
--		"human/neutral/civilian/women17",
--		"human/neutral/civilian/women18",
--		"human/neutral/civilian/women19",
--		"human/neutral/civilian/women2",
--		"human/neutral/civilian/women20",
--		"human/neutral/civilian/women21",
--		"human/neutral/civilian/women22",
--		"human/neutral/civilian/women23",
--		"human/neutral/civilian/women24",
--		"human/neutral/civilian/women25",
--		"human/neutral/civilian/women26",
--		"human/neutral/civilian/women27",
--		"human/neutral/civilian/women28",
--		"human/neutral/civilian/women29",
--		"human/neutral/civilian/women3",
--		"human/neutral/civilian/women30",
--		"human/neutral/civilian/women31",
--		"human/neutral/civilian/women32",
--		"human/neutral/civilian/women33",
--		"human/neutral/civilian/women34",
--		"human/neutral/civilian/women35",
--		"human/neutral/civilian/women36",
--		"human/neutral/civilian/women37",
--		"human/neutral/civilian/women38",
--		"human/neutral/civilian/women39",
--		"human/neutral/civilian/women4",
--		"human/neutral/civilian/women40",
--		"human/neutral/civilian/women41",
--		"human/neutral/civilian/women42",
--		"human/neutral/civilian/women43",
--		"human/neutral/civilian/women44",
--		"human/neutral/civilian/women45",
		"human/neutral/civilian/women46",
		"human/neutral/civilian/women47",
		"human/neutral/civilian/women48",
		"human/neutral/civilian/women49",
		"human/neutral/civilian/women5",
		"human/neutral/civilian/women50",
		"human/neutral/civilian/women6",
		"human/neutral/civilian/women7",
		"human/neutral/civilian/women9",
		"rith/neutral/civilian/Rith-004-DD",
		"rith/neutral/civilian/Rith-014-Gelweo",
		"rith/neutral/civilian/Rith-016-PM"
	}

	-- Lore messages. These come in general and factional varieties.
	-- General lore messages will be said by non-faction NPCs, OR by faction NPCs if they have no factional text to say.
	-- When adding factional text, make sure to add it to the table of the appropriate faction.
	-- Does your faction not have a table? Then just add it. The script will find and use it if it exists.
	-- Make sure you spell the faction name exactly the same as in faction.xml though!
	msg_lore["general"] = {
		"Rithai say some passthrough systems in the Hoshi no Hekka are haunted! My uncle Bobby told me he saw one of the ghost ships himself over between Eden and Engelstadt!",
		"I don't believe in those space ghost stories. The people who talk about it are just trying to scare you.",
		"Pupeteers fly organic ships! I heard they can even heal themselves in flight. That's so weird.",
		"Ordinary ships can only detect and use massive jump tunnels. If you wanna use lower mass jumps, you'll need special detectors.",
		"Have you ever seen a meeting of Fortresses? It's real huge!",
		"Pupeteers fly the same ships as Navigators, some say! They're weird, they can't even live on their own",
		"They say some Ha'Tinkar are drifting in space somewhere, entombed in ages-old purgatorian ships! What I wouldn't give to rummage through there...",
		"Ah man, I lost all my money on Engelstadt. I love the third-gee airfights they stage there, but the guys I bet on always lose. What am I doing wrong?",
		"Don't try to fly into the New Fringes. I've known people who tried, and none of them came back.",
		"Have you heard of Captain T. Practice? He's amazing, I'm his biggest fan!",
		"Some old-fashioned Rithai are furious at the 13-Planets naming one of their planet \"Son of the Eclipse\"! They say it scares the stones out of their gizzards.",
		"I wouldn't travel too far beyond  Arcadia if I were you, unless you're willing to commit suicide! They say that area of space is home to Navigators.",
		"Sometimes I look at the stars and wonder... So few sentient species, and the galaxy is so huge!",
		"Pirates often raid a system by posing as innocent freighters. You wouldn't tell them until they launch they fighters, and by that time, it's often too late!",
		"They have no interest as destroying ships, I mean, pirates. They just want to disable a big fat freighter, board it, then loot it!",
		"Did you know pirate fighter pilots have only fuel for one jump? They hide in their mothership's holds, launch and attack, then jump out to safety as quickly as possible."
	}
end
