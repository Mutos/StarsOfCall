--[[
	Content for news event
	Faction : Core League
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["Core League"] = {
		"Welcome to the official Core League News."
	}

	greet_table["Core League"] = {
		"Keeping you informed."
	}

	articles["Core League"]={
		{
			title = "Hoshi no Hekka Responsible for Shipping Woes",
			desc = "An unofficial source says they were behind the recent series of attacks on cargo ships operating between Nouvelle Mars and New Earth. Despite denial on the Hekka side, League officials unanimously condemned the actions and held a joint declaration with the Alliance, declaring the Stellar Police has orders to pursue any attacker \"to any part of space they could try to hide\"."
		},
		{
			title = "The League approves Planetarist change of policy towards terrorism",
			desc = "The Planetarist council, after a unanimous ruling, decided to increase patrols in Planetarist space due to the recent uprising in various terrorist groups. The new measure is expected to start within the next SCU. Core League approves \"this departure from the ordinary cowardice of the Alliance\" and is ready to help via the joint Stellar Police patrol forces."
		},
		{
			title = "Governor Helmer Jailed",
			desc = "Core Auditors arrested governor Rex Helmer of the High Plains region on Hope, on charges of corruption. He has been removed from office and transported to a holding facility awaiting trial. He is said to have illegally detained numerous Ziffelian Minidragons."
		},
		{
			title = "Jouvanin Tapped as Interim Chief",
			desc = "Following the arrest of Rex Helmer, former High Plains deputy governor Elene Jouvanin will be sworn in today. She will serve out the term as regional governor."
		},
		{
			title = "Hoshi no Hekka Responsible for Piracy",
			desc = "Earthian law enforcement expert Paet Dohmer's upcoming essay describes the Hoshi no Hekka as \"more a stack of criminal gangs than a proper State\", according to his publicist."
		},
		{
			title = "Hope Sector protected by Stellar Police",
			desc = "As piracy has risen in the Hope Sector, Core League and Planetarist Alliance officials called for a meeting. It was decided to have the Stellar Police supplement regular patrols in the sector. A full squadron of Bao Zheng corvettes reportedly left Avenir to defend trader ships against pirate raids near Hope."
		}
	}
end
