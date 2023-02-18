--[[
	Content for news event
	Faction : Baartish Intersystems
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["Baartish Intersystems"] = {
		"Baartish Intersystems is proud to inform you !",
		" All the headlines all the time."
	}

	greet_table["Baartish Intersystems"] = {
		"News from the Sshaad Sphere and beyond.",
		"Keeping you informed."
	}

	articles["Baartish Intersystems"]={
		{
			title = "Several high-ranking Masters petition in favor of Complementarism",
			desc = "With the rising turmoil around Complementarism in Baartish space, several Masters from multiple planets made public a joint declaration, in which they stated \"Complementarism is not only the best way Sshaads and Shapeshifters can live in peace, but a great opportunity for our two species to go far beyond our current level of contact with the rest of the Commonwealth\"."
		},
		{
			title = "Ban Piracy From Sshaad Sphere",
			desc = "This is the title of respected Spacer and Master-writer Sshiilyada Lalnesh's new controversial book. He uses his xenosociology background, built on the ground of respected sshaad, k'rinn and rithai authors, among which Aareli ud Aragwedyr and Eorath ud Orthid-Irilia, to refute the traditionalist thesis, that piracy is a means for natural selection."
		},
		{
			title = "Shoden aggression on the borders",
			desc = "Several shoden ships were sighted on the border, seemingly spying on Baartish defence lines. Most were intercepted by the 3rd Fleet fighter patrols, joined by several armed cargos willing to protect their trade routes. Baartish High-Masters officially protested against Shoden ambassadors, but were met with reaffirmation of Shoden will to invade the whole Sshaad Sphere. The 3rd Fleet will be reinforced with squadrons taken from Protectorate sectors."
		}
	}
end
