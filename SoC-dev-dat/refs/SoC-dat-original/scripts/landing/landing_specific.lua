-- Called by land() for Gham Garri assets.
function land_ghamgarri_restrict( pnt )
	-- print ("\tLanding on a Gham Garri station")

	-- Faction check will be done on GG, not on actual planet faction
	local fct = faction.get("Gham Garri")

	-- Reputation check will include the species : GG do not welcome non-Rithai
	local pcSpecies = var.peek ("pc_species")

	-- Default return variables
	local land_floor   = 10
	local ok_msg      = "Welcome Brother, to this place gained upon the forces of D'rih!"
	local notyet_msg  = "I wish thou to soon gain the honor thou needst to join us here."
	local no_msg      = "We have nothing to do with akem people like you. Please show minimal honor and be gone from our view."
	local nobribe_msg = "Ta land here, you will need Honor, not money."

	-- Switches
	local boolIsRith = (pcSpecies == "Rith")

	if not boolIsRith then
		-- Non-Rith : treated like an animal
		land_floor = land_floor + 30
		ok_msg      = "Please dock and wait for a Karthanem to come to cater to you."
		notyet_msg  = "Keep battling the ennemies of Honor and we may judge you worthy of landing here."
		no_msg      = "Your kin doesn't understand the meaning of honor. Be gone in the D'rih."
		nobribe_msg = "I pardon your foolish demand. Now be gone and away, being of no Honor!"
	end

	-- Call generic function to compute landing status
	return land_reputation_strict(pnt, fct, land_floor, ok_msg, notyet_msg, no_msg, nobribe_msg)
end

-- Called by land() for Pirate clanworld.
function land_pir_clanworld( pnt )
	local fct = pnt:faction()
	local standing = fct:playerStanding()
	local can_land = standing > 20

	local land_msg
	if can_land then
		land_msg = "Permission to land granted. Welcome, brother."
	elseif standing >= 0 then
		land_msg = "Small time pirates have no business on our clanworld!"
	else
		land_msg = "Get out of here!"
	end

	-- Calculate bribe price. Custom for pirates.
	local can_bribe, bribe_price, bribe_msg, bribe_ack_msg
	if not can_land and standing >= -50 then
		bribe_price = (20 - standing) * 500 + 1000 -- 36K max, at -50 rep. Pirates are supposed to be cheaper than regular factions.
		local str	= numstring( bribe_price )
		bribe_msg	= string.format(
				"\"Well, I think you're scum, but I'm willing to look the other way for %s credits. Deal?\"",
				str )
		bribe_ack_msg = "Heh heh, thanks. Now get off the comm, I'm busy!"
	end
	return can_land, land_msg, bribe_price, bribe_msg, bribe_ack_msg
end
