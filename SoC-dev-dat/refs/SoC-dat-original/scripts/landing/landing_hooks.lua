--[[
	=========================== Base landing file ===========================
	
	Contains only includes of function-defining files
	
	Prototype function:
		Parameter: pnt - Planet to set landing stuff about.
		Return:	1) Boolean whether or not can land
				2) Land message which should be denial if can't land or acceptance if can
				3) (optional) Bribe price or message that can't be bribed or nil in the case of no possibility to bribe.
				4) (Needed with bribe price) Bribe message telling the price to pay
				5) (Needed with bribe price) Bribe acceptance message

	Examples:

	function yesland( pnt )
		return true, "Come on in dude"
	end

	function noland( pnt )
		return false, "Nobody expects the spanish inquisition!"
	end

	function noland_nobribe( pnt )
		return false, "No can do.", "Seriously, don't even think of bribing me dude."
	end

	function noland_yesbribe( pnt )
		return false, "You can't land buddy", 500, "But you can bribe for 500 credits", "Thanks for the money"
	end
--]]


-- Default function. Any asset that has no landing script explicitly defined will use this.
function land( pnt )
	-- DEBUG
	local strPrefix = "landing.lua:land()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Some faction deserve a different function
	local fct = pnt:faction()
	local strPlanetName = pnt:name()

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format("Planet : \"%s\" (\"%s\")", strPlanetName, fct:name()), boolDebug )

	-- Check if planet has landing pass
	if landing_passes[strPlanetName] ~= nil then
		-- DEBUG
		dbg.stdOutput( strPrefix, 0, "exiting with generic Landing Pass call", boolDebug )

		return land_pass( pnt )
	end

	-- Gham Garri
	if fct:name() == "Gham Garri" then
		-- DEBUG
		dbg.stdOutput( strPrefix, 0, "exiting with Gham Garri call", boolDebug )

		return land_ghamgarri_restrict( pnt )
	end

	if pnt:class() == "Z" then
		-- print ("\tEnd of Landing function : land_asteroids")
		-- DEBUG
		dbg.stdOutput( strPrefix, 0, "exiting with asteroid call", boolDebug )

		return land_asteroids(pnt)
	end

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting with standard land_faction() call", boolDebug )
	return land_faction(pnt)
end


-- Called by land() for assets with Landing Pass set on landing_params.lua.
function land_pass( pnt )
	-- DEBUG
	local strPrefix = "landing.lua:land_pass()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	local planetName       = pnt:name()
	local returnAuthorized = true
	local returnMessage    = ""
	local passName         = ""
	local okMessage        = ""
	local noPassMessage    = ""

	-- Some faction deserve a different function
	local fct = pnt:faction()

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format("Planet : \"%s\" (\"%s\")", pnt:name(), fct:name()), boolDebug )

	-- Check planet name and parameters
	if landing_passes[planetName] ~= nil then
		passName      = landing_passes[planetName].passName
		okMessage     = landing_passes[planetName].okMessage    
		noPassMessage = landing_passes[planetName].noPassMessage
	else
		passName      = planetName .. " Landing Pass"
		okMessage     = "Welcome to " .. planetName .. ". Beware, your pass is only valid for one landing."
		noPassMessage = "You have no valid Landing Pass for " .. planetName .. ". Please return only duly accredited."
	end

	returnAuthorized = (player.numOutfit( passName ) > 0)
	if returnAuthorized then
		dbg.stdOutput( strPrefix, 1, string.format( "OK for landing, one \"%s\" will be removed", passName ), boolDebug )
		returnMessage = okMessage
	else
		dbg.stdOutput( strPrefix, 1, "no valid pass, landing not authorized", boolDebug )
		returnMessage = noPassMessage
	end

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	return returnAuthorized, returnMessage, nil
end


-- Free Adrimai assets.
function land_freeAdrimai_restrict( pnt )
	-- print ("\tLanding on a Free Adrimai world")

	-- Faction check will be done on FA, not on actual planet faction
	local fct = faction.get("Free Adrimai")

	-- Reputation floor, SoE is more restrictive
	local rep_floor = 10
	if pnt:name() == "Son of the Eclipse" then
		rep_floor = 30
	end

	return land_reputation_strict(pnt, fct, rep_floor,
		"Welcome to the Drih Kemae.",
		"I hope thou wilst soon gain the honor thou needst to join us here.",
		"We have nothing to do with akem people like you. Please do not force us to take measures.",
		"\"Here, you will need Honor, not money.\""
	)
end

-- Called by land() for Gham Garri assets.
function land_garri_ud_skarae( pnt )
	-- print ("\tLanding on a Gham Garri station")

	-- Faction check will be done on GG, not on actual planet faction
	local fct = faction.get("Gham Garri")

	-- Reputation check will include the species : GG do not welcome non-Rithai
	local pcSpecies = var.peek ("pc_species")

	-- Default return variables
	local land_floor   = 30
	local ok_msg      = "Welcome Brother, to this place gained upon the forces of D'rih!"
	local notyet_msg  = "I wish thou to soon gain the honor thou needst to join us here."
	local no_msg      = "We have nothing to do with akem people like you. Please show minimal honor and be gone from our view."
	local nobribe_msg = "Ta land here, you will need Honor, not money."

	if (pcSpecies == "Rith") then
		-- Rith attempting to land at GuS : more ceremonial
		ok_msg      = "Be welcome, Brother, to the Core of the Watchdogs' Honor!"
		notyet_msg  = "I wish thou to soon gain what thou needst to join us on this Land of Honor."
		nobribe_msg = "Do you have any stone in your gizzard to propose such a dishonorable thing?"
	else
		-- Non-Rith : treated like an animal
		land_floor = land_floor + 30
		ok_msg      = "Head to Port 3B, a Karthanem will come and take care of to you during your visit."
		notyet_msg  = "Keep battling the ennemies of Honor and we may judge you worthy of landing here."
		no_msg      = "No underbeing is allowed to soil the Land of the Watchdogs. Be gone in the D'rih."
		nobribe_msg = "I pardon your foolish demand. Now be gone and away, being of no Honor!"
	end

	-- Call generic function to compute landing status
	return land_reputation_strict(pnt, fct, land_floor, ok_msg, notyet_msg, no_msg, nobribe_msg)
end

