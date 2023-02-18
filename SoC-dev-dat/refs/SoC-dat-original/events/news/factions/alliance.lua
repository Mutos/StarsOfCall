--[[
	Content for news event
	Faction : Planetarist Alliance
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["Alliance"] = {
		"Welcome to the Planetarist Information Network.",
		" All the headlines all the time."
	}

	greet_table["Alliance"] = {
		"Planetarist News.",
		"Keeping you informed."
	}

	articles["Alliance"]={
		{
			title = "Hoshi no Hekka Responsible for Shipping Woes",
			desc = "An undisclosed source says they were behind a number of attacks on cargo ships between Nouvelle Mars and New Earth. Despite denial from Hoshi no Hekka officials, an Alliance spokesman condemned the actions. A joint declaration with the Core League stated that the Stellar Police has orders to pursue any attacker \"to any part of space they could try to hide\"."
		},
		{
			title = "Akta Manniskor Terrorist Trial Ends",
			desc = "Akta Manniskor Terrorist Trial ended this SCU with an unsurprising death sentence for all five members of the Sanctuary spaceport bombing. Execution is scheduled in 10 STP."
		},
		{
			title = "New Challenges for New Times",
			desc = "The Planetarist council, after a unanimous ruling, decided to increase patrols in Planetarist space due to the recent uprising in various terrorist groups. The new measure is expected to start within the next SCU. Discussions are held with the Core League to involve the joint Stellar Police Corps."
		},
		{
			title = "Sanctuary Council Opens Doors",
			desc = "The supreme advisory body invited undergraduates from six top schools to sit in on a day's deliberations. Topics included biodiversity strategy."
		},
		{
			title = "Purple Trail Relies on Prison Labour",
			desc = "A recent report exfiltrated from the Ways and Means Directorate suggests infrastructure may be too dependent on the incarcerated population. Now tha even Purple Trail officials recognize what we've been telling you for years, they choose to hide it behind firewalls."
		},
		{
			title = "Election on Nouvelle Mars Marred by Fraud",
			desc = "As many as two of every hundred votes counted after the recent polling day may be falsified, an ombudsman reports. The opposition party demanded the election be annulled."
		},
		{
			title = "Stellar Police sent to patrol trade lines in Hope Sector",
			desc = "With the rise of piracy, the Core League authorized the joint Alliance-League patrol force to fly deep into League space. A full squadron of Bao Zheng corvettes reportedly left Avenir recently."
		}
	}
end
