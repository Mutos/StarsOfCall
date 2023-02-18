--[[
-- Include file for npc.lua
-- Defines the general portraits and lore messages
--]]

-- Get player character species
-- this will be important, as the Akta Manniskor despise non-Humans
pcSpecies = var.peek ("pc_species")

if lang == 'es' then --not translated atm
else --default english
	-- Portraits exclusively represent Humans
	civ_port["Akta Manniskor"] =   {
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
		"human/neutral/civilian/male2",
		"human/neutral/civilian/male20",
		"human/neutral/civilian/male3",
		"human/neutral/civilian/male4",
		"human/neutral/civilian/male6",
		"human/neutral/civilian/male7",
		"human/neutral/civilian/male8",
		"human/neutral/civilian/male9",
		"human/neutral/civilian/women",
		"human/neutral/civilian/women10",
		"human/neutral/civilian/women11",
		"human/neutral/civilian/women12",
		"human/neutral/civilian/women13",
		"human/neutral/civilian/women14",
		"human/neutral/civilian/women15",
		"human/neutral/civilian/women16",
		"human/neutral/civilian/women17",
		"human/neutral/civilian/women18",
		"human/neutral/civilian/women19",
		"human/neutral/civilian/women2",
		"human/neutral/civilian/women20",
		"human/neutral/civilian/women21",
		"human/neutral/civilian/women22",
		"human/neutral/civilian/women23",
		"human/neutral/civilian/women24",
		"human/neutral/civilian/women25",
		"human/neutral/civilian/women26",
		"human/neutral/civilian/women27",
		"human/neutral/civilian/women28",
		"human/neutral/civilian/women29",
		"human/neutral/civilian/women3",
		"human/neutral/civilian/women30",
		"human/neutral/civilian/women31",
		"human/neutral/civilian/women32",
		"human/neutral/civilian/women33",
		"human/neutral/civilian/women34",
		"human/neutral/civilian/women35",
		"human/neutral/civilian/women36",
		"human/neutral/civilian/women37",
		"human/neutral/civilian/women38",
		"human/neutral/civilian/women39",
		"human/neutral/civilian/women4",
		"human/neutral/civilian/women40",
		"human/neutral/civilian/women41",
		"human/neutral/civilian/women42",
		"human/neutral/civilian/women43",
		"human/neutral/civilian/women44",
		"human/neutral/civilian/women45",
		"human/neutral/civilian/women46",
		"human/neutral/civilian/women47",
		"human/neutral/civilian/women48",
		"human/neutral/civilian/women49",
		"human/neutral/civilian/women5",
		"human/neutral/civilian/women50",
		"human/neutral/civilian/women6",
		"human/neutral/civilian/women7",
		"human/neutral/civilian/women9"
	}

	msg_lore["Akta Manniskor"] = {
		"They say some local Mayor in a remote town was found to have cyber implants. He was executed last week.",
		"Did you see te latest smuggling attempt ? Nanobonds. They were taken and destroyed, of course.",
		"There are a few people here, who would like to gain access to true civilisation. But, you've heard nothing!",
	}
	if pcSpecies == "Human" then
		table.insert(msg_lore["Akta Manniskor"],
			"Don't pay attention to the naysayers. We are the True Humans out there. All other are corrupted by nanos, cybs or contact with these freaky aliens."
		)
	else
		table.insert(msg_lore["Akta Manniskor"],
			"Get away from me, you freak! We don't want any of your kind to sully our beautiful planet."
		)
	end
end
