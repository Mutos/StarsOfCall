--[[
	Content for news event
	Faction : Hoshi no Hekka
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["HnH"] = {
		"News from the Fortresses."
	}
	greet_table["HnH"] = {
		"Fresh news from the Fortresses.",
		"We rule the Stars.",
		"Keeping you informed."
	}

	articles["HnH"]={
		--[[
			Science and technology
		--]]
		{
			title = "New Mace Rockets",
			desc = "Fortress Engineering is proud to present the new improved version of the Mace rocket. \"We have proven the new rocket to be nearly twice as destructive as the previous versions,\" says Chief Engineer Nordstrom."
		},
		--[[
			Business
		--]]
		--[[
			Politics
		--]]
		--[[
			Human interest.
		--]]
		{
			title = "Hoshi no Hekka falsely accused for Shipping Woes",
			desc = "Lies were broadcasted by the Alliance and League, accusing us of having backed recent raids between Nouvelle Mars and New Earth. A spokeswoman for the Council of Captains told of a \"provocation\" and warned Stellar Police from trying to harass ships in Hekka-protected space."
		},
		{
			title = "We have nothing to do with piracy !",
			desc = "The Council of Captains issued a statement denying any implication in the current piracy rise around Hope, but warns that any incursion of Stellar Police ships within Hoshi no Hekka space will be met with all due counter-force." 
		},
		{
			title = "Embargo Weaker Than Ever",
			desc = "The embargo maintained by nearby States around the Hoshi no Hekka has never been weaker." 
		},
		{
			title = "New Fortress To Be Commissionned",
			desc = "The Council of Captains approved the building of a new Fortress to replace the ageing \"Ame no Nuhoko\". The venerable ship, first Fortress ever and hero of the Battle of Eldorado, will be converted to a History Museum." 
		}
	}
end
