--[[
-- Include file for npc.lua
-- Defines the general portraits and lore messages
--]]

-- Get player character species
-- this will be important, as the Akta Manniskor despise non-Humans
pcSpecies = var.peek ("pc_species")

if lang == 'es' then --not translated atm
else --default english
	-- Only one Sshaad portrait is available
	civ_port["Daneb Anarchs"] =   {
		"sshaad/neutral/civilian/base"
	}

	msg_lore["Daneb Anarchs"] = {
		"Baartish people are nice, but it's their Masters the issue, they think they own the universe.",
		"We're as pure as the original Sshaads, with no Master to answer to!"
	}
	if pcSpecies == "Sshaad" then
		if pcSpecies == "Shapeshifter" then
			table.insert(msg_lore["Daneb Anarchs"],
				"Hi brother, you at least can can truly understand us True Sshaads! Welcome to one of the few Free Worlds!"
			)
		else
			if pcSpecies ~= "Human" then
				table.insert(msg_lore["Daneb Anarchs"],
					"Other species can't understand true Anarchy. Look at these Rithai bloated with honor!"
				)
			end
			if pcSpecies ~= "Rith" then
				table.insert(msg_lore["Daneb Anarchs"],
					"Other species can't understand true Anarchy. Look at these selfish Humans!"
				)
			end
		end
	else
		table.insert(msg_lore["Daneb Anarchs"],
			"Get away from me, you invasion Master! We don't want any of your devious plans to sully our beautiful planet."
		)
	end
end
