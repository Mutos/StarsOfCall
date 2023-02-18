--[[
	Select a string based on a list of keywords, used by selection packages for various content strings.

	Keyword syntax :
		[+/-]<character string>[|<number>]

	Usage :
	  1/ Include "selectFromKeywords.lua" in a new file, for instance "selectShipType.lua" :
			include "selectFromKeywords.lua"

	  2/ Define your dataVar like :
			local shipTypes = {
				{value = "Angry Bee Fighter",		  keywords = "fighter, guns, missiles, human"},
				{value = "Alaith",						 keywords = "tramp, reentry, courier, contraband, rith"},
				{value = "T'Kalt Patrol",				keywords = "patrol, police, scout, krinn, outdated"}
			}
	  3/ Define your function like :
			function selectShipType(keywordsList)
				return selectFromKeywords(<a dataVar-style variable>, keywordsList)
			end

	  4/ Include the file where you defined your dataVar and function :
			include "selectShipType.lua"

	  5/ Call your function like :
			-- Look for tramps that often carry contraband or are used by pirates, but are not outdated
			ship1Type = selectShipType({"+tramp", "contraband", "pirate", "-outdated"})

	Note :
		You can also directly call selectListFromKeywords to get a list of values.
		The list returned can itself be used as a list of keywords for another selection.
--]]


-- =======================================================================================
--
--   Base function definition, hidden from the including script.
-- 
-- =======================================================================================
--
local function selectIndicesListFromKeywords(dataVar, keywordsList)
	-- Function-local variables
	local indicesList = {}
	local keyString   = {}
	local mandatory   = {}
	local excluded    = {}
	local number      = {}

	-- Log enter function
	-- print ( string.format( "\nEntering selectIndicesListFromKeywords" ) )

	-- Mark keyword as normal, mandatory or excluded
	-- print ( string.format( "\tKeywords" ) )
	for j, key in ipairs(keywordsList) do
		local firstChar = string.sub(key, 1, 1)
		mandatory[j] = ( firstChar == "+")
		excluded[j]  = ( firstChar == "-")
		if mandatory[j] or excluded[j] then
			keyString[j] = string.sub(key, 2)
		else
			keyString[j] = key
		end
		-- print ( string.format( "\t\tKeyword #%d : \"%s\" (mandatory : %s; excluded : %s)", j, keyString[j], tostring(mandatory[j]), tostring(excluded[j]) ) )
	end
	-- print ( string.format( "\tEnd of Keywords list" ) )

	-- Duplicate keyword if a number is given
	-- print ( string.format( "\tKeywords" ) )
	for j, key in ipairs(keyString) do
		local strSeparator = "|"
		local intStart, intEnd = key:find(strSeparator, 1, true)
		if intStart == nil then
			keyString[j] = key
			number[j] = 1
		else
			number[j] = tonumber(key:sub(intEnd+1))
			keyString[j] = key:sub(1, intStart-1)
		end
		-- print ( string.format( "\t\tKeyword #%d : \"%s\" (mandatory : %s; excluded : %s; number : %s)", j, keyString[j], tostring(mandatory[j]), tostring(excluded[j]), tostring(number[j]) ) )
	end
	-- print ( string.format( "\tEnd of Keywords list" ) )

	-- Iterate on records
	for i, typ in ipairs(dataVar) do
		local count = 0
		-- For each record, iterate on keywords
		for j, key in ipairs(keywordsList) do
			if mandatory[j] then
				if string.find(typ.keywords, keyString[j]) ~= nil then
					-- Mandatory found : increment count and keep looking
					count = count+1
				else
					-- Mandatory not found : zero count then break j loop
					count = 0
					break
				end
			elseif excluded[j] then
				-- Excluded found : 
				if string.find(typ.keywords, keyString[j]) ~= nil then
					-- Excluded found : zero count then break j loop
					count = 0
					break
				end
			else
				-- Normal found : increment count and keep looking
				if string.find(typ.keywords, keyString[j]) ~= nil then
					count = count+1
				end
			end
		end
		-- Insert record count times in the indicesList
		k = 1
		while k <= count do
			table.insert( indicesList, i )
			k = k+1
		end
	end

	-- Debug print returned list
	--[[
	print ( string.format( "\tNumber of items in the return list : %d", #indicesList ) )
	for i = 1, #indicesList do
		local recordIndex = indicesList[i]
		local dataSet = dataVar[recordIndex]
		print ( string.format( "\t\t\"%s\"", dataSet.value ) )
	end
	--]]

	-- Log exit from function
	-- print ( string.format( "Exiting selectIndicesListFromKeywords" ) )

	-- Directly returns the indices list
	return indicesList
end
--
-- =======================================================================================


-- =======================================================================================
--
--   Function definitions available for use in the including script.
-- 
-- =======================================================================================
--
function selectFromKeywords(dataVar, keywordsList)
	-- Get the indices list from the keywords
	local indicesList = selectIndicesListFromKeywords(dataVar, keywordsList)

	-- Return a randomly selected value
	if #indicesList == 0 then
		return ""
	else
		local resultIndex = rnd.rnd(1, #indicesList)
		-- print ( string.format( "\tresultIndex : %d/%d", resultIndex, #indicesList ) )
		local recordIndex = indicesList[resultIndex]
		-- print ( string.format( "\trecordIndex : %d/%d", recordIndex, #dataVar ) )
		local dataSet = dataVar[recordIndex]
		-- print ( string.format( "\tdataSet.value : \"%s\"", dataSet.value ) )
		return dataSet.value
	end
end

function selectListFromKeywords(dataVar, keywordsList, reduce)
	-- Function-local variables
	local indicesList = {}
	local resultsList = {}
	local finalResultList = {}

	-- Get the indices list from the keywords
	indicesList = selectIndicesListFromKeywords(dataVar, keywordsList)

	if #indicesList >= 0 then
		for i = 1, #indicesList do
			local recordIndex = indicesList[i]
			-- print ( string.format( "\trecordIndex : %d/%d", recordIndex, #dataVar ) )
			local dataSet = dataVar[recordIndex]
			-- print ( string.format( "\tdataSet.value : \"%s\"", dataSet.value ) )
			-- print ( string.format( "\t\tAdding value \"%s\"", dataSet.value ) )
			-- Add each value to the list to be returned
			table.insert( resultsList, dataSet.value )
		end
	end

	-- If asked, reduce the list to only one occurence of each keyword
	if reduce then
		for i, keyOriginal in ipairs(resultsList) do
			local found = false
			for j, keyFinal in ipairs(finalResultList) do
				found = found or (keyFinal == keyOriginal)
			end
			if not found then
				-- print ( string.format( "\t\tAdding value \"%s\"", keyOriginal ) )
				table.insert( finalResultList, keyOriginal )
			end
		end
		return finalResultList 
	else
		return resultsList
	end
end
--
-- =======================================================================================
