-- Generic landing function using faction pre-set parameters.
-- If 2nd parameter is nil, defaults to planet's faction
function land_faction( pnt, fct )
	-- DEBUG
	local strPrefix = "landing.lua:land_faction()"
	local boolDebug = false
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Define local variables to be returned
	local tabReturn = {
		boolCanLand                  = false,
		strMessage                   = land_factions["default"].land_no_msg,
		optBribePriceOrDenialMessage = nil,
		strBribeMessage              = nil,
		strBribeAckMessage           = nil,
	}

	-- Parameters check
	if pnt==nil then
		-- No planet => no landing, default message
		dbg.stdOutput( strPrefix, 0, "exiting (no planet passed)", boolDebug )
		return tabReturn.boolCanLand, tabReturn.strMessage
	end

	-- Get planet name
	local strPlanetName = pnt:name()
	dbg.stdOutput( strPrefix, 1, string.format( "Planet : \"%s\"", strPlanetName ), boolDebug )

	-- If faction is not passed, use planet's faction
	if fct==nil then
		dbg.stdOutput( strPrefix, 1, "No faction passed, assuming planet faction.", boolDebug )
		fct = pnt:faction()
	end

	-- Get faction name
	local strFactionName = fct:name()
	dbg.stdOutput( strPrefix, 1, string.format( "Faction : \"%s\"", strFactionName ), boolDebug )

	-- Get landing parameters from faction
	local tabLandingParams = {}
	for i,v in pairs(land_factions[ "default" ]) do
		tabLandingParams[i] = v
	end
	if land_factions[ strFactionName ] ~= nil then
		dbg.stdOutput( strPrefix, 1, "Faction found in parameters table, replacing default parameters.", boolDebug )
		for i,v in pairs(land_factions[ strFactionName ]) do
			dbg.stdOutput( strPrefix, 2, string.format( "\"%s\" : replacing \"%s\" by \"%s\"", tostring(i), tostring(tabLandingParams[i]), tostring(v) ), boolDebug )
			tabLandingParams[i] = v
		end
	end

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, "Landing parameters :", boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"land_floor\"      ] = \"%s\"", tostring(tabLandingParams.land_floor)      ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"bribe_floor\"     ] = \"%s\"", tostring(tabLandingParams.bribe_floor)     ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"land_msg\"        ] = \"%s\"", tostring(tabLandingParams.land_msg)        ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"land_warn_msg\"   ] = \"%s\"", tostring(tabLandingParams.land_warn_msg)   ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"land_bribe_msg\"  ] = \"%s\"", tostring(tabLandingParams.land_bribe_msg)  ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"land_no_msg\"     ] = \"%s\"", tostring(tabLandingParams.land_no_msg)     ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"bribe_base\"      ] = \"%s\"", tostring(tabLandingParams.bribe_base)      ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"bribe_rate\"      ] = \"%s\"", tostring(tabLandingParams.bribe_rate)      ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"bribe_ack_msg\"   ] = \"%s\"", tostring(tabLandingParams.nobribe_msg)     ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"nobribe_msg\"     ] = \"%s\"", tostring(tabLandingParams.bribeprice_fmsg) ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabLandingParams.[\"bribeprice_fmsg\" ] = \"%s\"", tostring(tabLandingParams.bribe_ack_msg)   ), boolDebug )
	dbg.stdOutput( strPrefix, 1, "}", boolDebug )

	-- Get bare landing status
	local numPlayerReputation       = fct:playerStanding()
		tabReturn.boolCanLand       = (numPlayerReputation >= tabLandingParams.land_floor)
	local boolCanBribe              = (numPlayerReputation >= tabLandingParams.bribe_floor)
	local boolIsPositive            = (numPlayerReputation >= 0)

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format( "Player can land (%s) / bribe (%s) / has positive reputation (%s)", tostring(tabReturn.boolCanLand), tostring(boolCanBribe), tostring(boolIsPositive) ), boolDebug )

	-- Branch according to the status
	if tabReturn.boolCanLand then
		if boolIsPositive then
			tabReturn.strMessage                   = tabLandingParams.land_msg
		else
			tabReturn.strMessage                   = tabLandingParams.land_warn_msg
		end
	else
		if boolCanBribe then
			tabReturn.strMessage = tabLandingParams.land_bribe_msg
			tabReturn.optBribePriceOrDenialMessage = (tabLandingParams.land_floor - numPlayerReputation) * tabLandingParams.bribe_rate * getshipmod() + tabLandingParams.bribe_base
			tabReturn.strBribeMessage = string.format( tabLandingParams.bribeprice_fmsg, tostring(tabReturn.optBribePriceOrDenialMessage) )
			tabReturn.strBribeAckMessage = tabLandingParams.bribe_ack_msg
		else
			tabReturn.strMessage = tabLandingParams.land_no_msg
			tabReturn.optBribePriceOrDenialMessage = tabLandingParams.nobribe_msg
		end
	end

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, "Return parameters : {", boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabReturn.[\"boolCanLand\"                 ] = \"%s\"", tostring(tabReturn.boolCanLand)                  ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabReturn.[\"strMessage\"                  ] = \"%s\"", tostring(tabReturn.strMessage)                   ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabReturn.[\"optBribePriceOrDenialMessage\"] = \"%s\"", tostring(tabReturn.optBribePriceOrDenialMessage) ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabReturn.[\"strBribeMessage\"             ] = \"%s\"", tostring(tabReturn.strBribeMessage)              ), boolDebug )
	dbg.stdOutput( strPrefix, 2, string.format( "tabReturn.[\"strBribeAckMessage\"          ] = \"%s\"", tostring(tabReturn.strBribeAckMessage)           ), boolDebug )
	dbg.stdOutput( strPrefix, 1, "}", boolDebug )

	-- DEBUG
	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	-- Return landing variables
	return tabReturn.boolCanLand, tabReturn.strMessage, tabReturn.optBribePriceOrDenialMessage, tabReturn.strBribeMessage, tabReturn.strBribeAckMessage
end


-- Low-class landing function. Low class planets let you land and bribe at much lower standings.
function land_lowclass( pnt )
	-- Some faction deserve a different function
	local fct = pnt:faction()

	return land_civilian(pnt, fct, -20, -80)
end

-- High class landing function. High class planets can't be bribed.
function land_hiclass( pnt )
	-- Some faction deserve a different function
	local fct = pnt:faction()

	return land_civilian(pnt, fct, 0, 0)
end

-- Asteroids field : will give you a random amount of Ore
function land_asteroids( pnt )
	-- print ("\tLanding on an asteroids field")
	-- Give the player a random amount of ore
	local oreAmount = rnd.rnd ( 2, 5 )
	local playerPilot = player.pilot()
	-- print ( string.format( "\t\tPlayer Pilot Name : %s", playerPilot:name()))
	-- playerPilot:cargoAdd("Ore", oreAmount)

	-- The asteroids will not communicate, not will they prevent you from landing on them
	return true, string.format("You make yourself ready to land and exploit %s", pnt:name())
end

-- Helper function for determining the bribe cost multiplier for the player's current ship.
-- Returns the factor the bribe cost is multiplied by when the player tries to bribe.
-- NOTE: This should be replaced by something better in time.
function getshipmod()
	local light = {"Yacht", "Luxury Yacht", "Drone", "Fighter", "Bomber", "Scout"}
	local medium = {"Destroyer", "Corvette", "Courier", "Armoured Transport", "Freighter"}
	local heavy = {"Cruiser", "Carrier"}
	local ps = player.pilot():ship()
	for _, j in ipairs(light) do
		if ps == j then return 1 end
	end
	for _, j in ipairs(medium) do
		if ps == j then return 2 end
	end
	for _, j in ipairs(heavy) do
		if ps == j then return 4 end
	end
	return 1
end

-- Helper function for calculating bribe availability and cost.
-- Expects the faction, the minimum standing to land, the minimum standing to bribe, and a going rate for bribes.
-- Returns whether the planet can be bribed, and the cost for doing so.
function getcost(fct, land_floor, bribe_floor, rate)
	local standing = fct:playerStanding()
	if standing < bribe_floor then
		return "\"I'm not dealing with dangerous criminals like you!\""
	else
		-- Assume standing is always lower than the land_floor.
		return (land_floor - standing) * rate * getshipmod() + 5000
	end
end

-- Civilian planet landing logic.
-- Expects the planet, the faction, the lowest standing at which landing is allowed, and the lowest standing at which bribing is allowed.
function land_civilian( pnt, fct, land_floor, bribe_floor )
	-- Check parameters
	if bribe_floor>=land_floor then
		bribe_floor = land_floor-5
	end

	-- Base test
	local can_land = fct:playerStanding() >= land_floor

	-- Get land message
	local land_msg
	if can_land then
			 if (fct:playerStanding() >= 0) then
				land_msg = "Permission to land granted."
			 else
				land_msg = "Landing permission granted, but given your reputation, you'd better behave."
			 end
	else
	  land_msg = "Landing request denied."
	end

	local bribe_msg, bribe_ack_msg
	-- Calculate bribe price. Note: Assumes bribe floor < land_floor.
	local bribe_price = getcost(fct, land_floor, bribe_floor, 1000) -- TODO: different rates for different factions.
	if not can_land and type(bribe_price) == "number" then
		 local str		= numstring( bribe_price )
		 bribe_msg		= string.format("\"I'll let you land for the modest price of %s credits.\"\n\nPay %s credits?", str, str )
		 bribe_ack_msg  = "Make it quick."
	end
	return can_land, land_msg, bribe_price, bribe_msg, bribe_ack_msg
end

-- Military planet landing logic.
-- Expects the planet, the lowest standing at which landing is allowed, and four strings:
-- Landing granted string, standing too low string, landing denied string, message upon bribe attempt.
function land_military( pnt, land_floor, ok_msg, notyet_msg, no_msg, nobribe )
	local fct = pnt:faction()
	local standing = fct:playerStanding()
	local can_land = standing >= land_floor

	local land_msg
	if can_land then
		land_msg = ok_msg
	elseif standing >= 0 then
		land_msg = notyet_msg
	else
		land_msg = no_msg
	end

	return can_land, land_msg, nobribe
end

-- Planet landing logic based on strict reputation limits and no bribe at all.
-- Expects the planet, the faction, the lowest standing at which landing is allowed, and four strings:
-- Landing granted string, standing too low string, landing denied string, message upon bribe attempt.
function land_reputation_strict( pnt, fct, land_floor, ok_msg, notyet_msg, no_msg, nobribe_msg )
	local standing = fct:playerStanding()
	local can_land = standing >= land_floor

	local land_msg
	if can_land then
		land_msg = ok_msg
	elseif standing >= 0 then
		land_msg = notyet_msg
	else
		land_msg = no_msg
	end

	return can_land, land_msg, nobribe_msg
end
