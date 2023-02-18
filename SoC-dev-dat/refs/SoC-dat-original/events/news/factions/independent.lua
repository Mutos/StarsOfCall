--[[
	Content for news event
	Faction : Independent
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["Independent"] = {
		"Welcome to Universal News Feed.",
		" All the headlines all the time."
	}

	greet_table["Independent"] = {
		"Spacers News.",
		"Keeping you informed."
	}

	articles["Independent"]={
		{
			title = "Independent shippers demand better protection of trade routes",
			desc = "After the recent pirate raids in the Hope, New Earth and Nouvelle Mars sectors, a representative from the Independent Spacers Syndicate declared that \"the League and Alliance must stop using the joint Stellar Police as a chessboard for petty politicians, but use it for its original goal : swift joint action against piracy.\"."
		},
		{
			title = "Patrol ships must stop bullying innocent cargo ships",
			desc = "A petition was held throughout the Human, K'Rinn and Rith Spheres to put some restraint on undue aggression from police patrols against cargo ships under pretext of anti-smuggling action. The text was presented to the Commonwealth officials and relayed through the Rithai Kemae Guild, whose spokesidrimarai invoked \"a question of honor for both the Police and Spacers\". Irilia officials, backed by their K'Rinn Council and Planetarist colleagues, proposed that a kind of post-war trial be held in the rith tradition, to determine if dishonourable deeds were committed."
		}
	}
end
