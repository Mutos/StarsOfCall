--[[
	Content for news event
	Faction : Pirate
--]]

if lang == 'es' then --not translated atm
else --default english
	header_table["Pirate"] =	{
		"Pirate News. News that matters."
	}

	greet_table["Pirate"] = {"News that matters.",
		"Adopt a cat today!",
		"Laughing at Core Fleet.",
		"On top of the world.",
		"Piracy has never been better."
	}

	articles["Pirate"]={
		--[[
			Science and technology
		--]]
		{
			title = "Skull and Bones Improving",
			desc = "The technology behind Skull and Bones is advancing. Not only do they steal ships, but they improve on the original design. \"This gives us pirates an edge against the injustice of the States,\" says Millicent Felecia Black, lead Skull and Bones engineer."
		},
		--[[
			Business
		--]]
		{
			title = "Tau Ceti Favorite Plundering Space",
			desc = "Tau Ceti has recently passed Delta Pavonis in the pirate polls as the most favored plundering space. The abundance of traders and large systems make it an excellent place to get some fast credits."
		},
		{
			title = "New Ships for Skull and Bones",
			desc = "The Skull and Bones was able to extract a few dozen high quality vessels from a Harushita warehouses under the nose of the Alliance. These ships will help keep production high and booming."
		},
		{
			title = "A pirate Angry Bee for the better",
			desc = "Robosys' Angry Bee blueprints have been smuggled to some of our best yards, and now the 2nd-generation Pirate Angry Bee, called the \"Stinger\", is been produced. Better than the original !"
		},
		--[[
			Politics
		--]]
		{
			title = "President Weaker Than Ever",
			desc = "Recent actions demonstrate the inefficiency and weakness of the Core League Presidency. One of the last irrational decisions left the Hope sector without a defense fleet to protect the traders. It's a great time to be a pirate!"
		},
		--[[
			Human interest.
		--]]
		{
			title = "Cats in New Haven",
			desc = "An explosion in the cat population of New Haven has created an adoption campaign with the slogan, \"Pirate Cats, for those lonely space trips.\". Is your space vessel full of vermin? Adopt a cat today!"
		}
	}
end
