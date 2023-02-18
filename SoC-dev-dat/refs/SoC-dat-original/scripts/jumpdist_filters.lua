--[[
	A set of filter functions for getsysatdistance in jumpdist.lua
--]]

filters = {}

filters.IsNotSystem = function( s, sys )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- Check second parameter, defaults to current system
	if sys == nil then
		sys = system.cur()
	end

	-- System must not be given system
	return ( s ~= sys )
end

filters.HasLandable = function( s, factionName, isKnown )
	-- Init local variables
	local strFactionName = ""
	local strPlanetName = ""
	local strPlanetFactionName = ""

	-- If no first parameter, filter is false
	if s == nil then
		-- print ( string.format( "\t\tSystem s is nil, returning false" ) )
		return false
	else
		-- print ( string.format( "\t\ttesting system \"%s\"", s:name() ) )
	end

	-- Check second parameters
	if factionName == nil then
		-- print ( string.format( "\t\ttesting with no faction specified" ) )
		strFactionName = "nil"
	else
		-- print ( string.format( "\t\ttesting faction \"%s\"", factionName ) )
		strFactionName = factionName
	end

	-- System must have at least one landable planet
	for key, v in ipairs(s:planets()) do
		strPlanetName = v:name()
		-- print ( string.format( "\t\ttesting planet \"%s\"", strPlanetName ) )
		if v:services().land then
			local objPlanetFaction = v:faction()
			if objPlanetFaction == nil then
				-- print ( string.format( "\t\t\tPlanet \"%s\" is landable with no faction", strPlanetName ) )
				if strFactionName == "nil" then
					-- No faction specified, OK
					-- print ( string.format( "\t\t\tNo faction specified, returning OK" ) )
					return true
				end
			else
				strPlanetFactionName = objPlanetFaction:name()
				-- print ( string.format( "\t\t\tPlanet \"%s\" is landable with faction \"%s\" for \"%s\"", strPlanetName, strPlanetFactionName, strFactionName ) )
				if (strFactionName == "nil" or strPlanetFactionName == strFactionName) then
					-- print ( string.format( "\t\t\tPlanet faction \"%s\" for \"%s\", returning OK", strPlanetFactionName, strFactionName ) )
					if ( isKnown == nil or ( isKnown == v:known() ) ) then
						return true
					end
				end
			end
		end
	end
	return false
end

filters.HasLessPresence = function( s, presenceMax )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- Check second parameter, defaults to 500
	if presenceMax == nil then
		presenceMax = 500
	end

	-- System must not have too much presence
	return ( s:presence("all") < presenceMax )
end

filters.HasMorePresence = function( s, presenceMax )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- Check parameter, defaults to 500
	if presenceMax == nil then
		presenceMax = 500
	end

	-- System must have enough presence
	return ( s:presence("all") > presenceMax )
end

filters.HasFactionPresence = function( s, factionName )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- System must have even minor presence
	return ( s:presence(factionName) > 0 )
end

filters.HasNoFactionPresence = function( s, factionName )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- System must not have even minor presence
	return ( s:presence(factionName) == 0 )
end

filters.HasPiratePresence = function( s )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- System must have pirate presence
	return ( filters.HasFactionPresence(s, "Pirate") )
end

filters.HasNoPiratePresence = function( s )
	-- If no first parameter, filter is false
	if s == nil then
		return false
	end

	-- System must have no pirate presence at all
	return ( filters.HasNoFactionPresence(s, "Pirate") )
end
