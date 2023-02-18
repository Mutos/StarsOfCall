--[[
	Select a value in a values-keystrings table, based on a string of keyword.
	Used by selection packages for various content strings.

	Keyword syntax :
		[<"+"|"-"><"="|"#">]<character string without spaces or "|" and not starting by "+#", "-#", "+=" or "-=">["|"<number>]
			<number> : denotes keyword weight, 1 of not present
			"+"      : keyword must be found more than <number> times
			"-"      : keyword must be found less than <number> times
			"="      : includes the case where the keyword is found exactly <number> times
			"#"      : excludes the case where the keyword is found exactly <number> times
			Default  : "+="

	Separator syntax
		<(" "|"\t")(1..n)>

	AND-Expression syntax :
		<"("[Separator]><Expression>(<Separator>"AND"<Separator><Expression>)(1..n)<[Separator]")">

	OR-Expression syntax :
		<"("[Separator]><Expression>(<Separator>"OR"<Separator><Expression>)(1..n)<[Separator]")">

	Expression syntax :
		<Keyword>|<AND-Expression>|<AND-Expression>

	Usage :
	  1/ Include "selectFromKeywords.lua" in a new file, for instance "selectShipType.lua" :
			include "selectFromKeywords.lua"

	  2/ Define your dataVar like :
			local tabShipTypes = {
				{value = "Angry Bee Fighter",			keywords = {"fighter",1},{"guns",1},{"missiles",1},{"human",1},{"outdated",1}},
				{value = "Nelk'Tan",					keywords = {"fighter",1},{"guns",4},{"k'rinn",1}},
				{value = "Akk'Ti'Makkt",				keywords = {"fighter",1},{"missiles",5},{"k'rinn",1}},
				{value = "T'Telin",						keywords = {"fighter",1},{"guns",4},{"missiles",1},{"k'rinn",1}},
				{value = "Alaith",						keywords = {"tramp",1},{"reentry",1},{"courier",1},{"contraband",1},{"rith",1},
				{value = "T'Kalt Patrol",				keywords = {"patrol",1},{"police",1},{"scout",1},{"k'rinn",1},{"outdated",1}}
			}

		3/ Define your function, respectively to return a value or a list of values, like :
			function selectShipType(keywordsList)
				return selectStringFromKeywords(strKeywords)
			end
			function selectShipTypesList(keywordsList)
				return selectListFromKeywords(strKeywords)
			end

	  4/ Include the file where you defined your dataVar and function :
			include "selectShipType.lua"

	  5/ Call your function like :
			-- Look for tramps that often carry contraband or are used by pirates, but are not outdated
			ship1Type = selectShipType( "(tramp AND (contraband OR pirate) AND -#outdated)" )
			-- Look for older fighters used by human, sshaad or k'rinn pirates, with 1 or more guns and 1 or more missile launcher
			ship1Type = selectShipType( "(fighter AND (human OR sshaad OR k'rinn) AND pirate AND outdated AND +=gun|2 AND +=missile)" )

	Note :
		You can also directly call selectListFromKeywords to get a list of values.
		The list returned can itself be used as a list of keywords for another selection.
--]]


-- =======================================================================================
--
--   Matching functions definition, hidden from the including script.
-- 
-- =======================================================================================
--

---- =======================================================================================
-- Match a keyword with a keyword in the data table
-- Arguments :
--    strKeywordArgument  : keyword to match
--    tabDataVar          : data table
--    numDataRecordIndex  : record index within the data table
--    numDataKeywordIndex : keyword index within the data record
-- Return
--    numWeightFound      : this keyword weight if found, 0 otherwise
---- =======================================================================================
local function matchOnSingleKeyword( strKeywordArgument, tabDataVar, numDataRecordIndex, numDataKeywordIndex )
	-- Get keyword and weigth
	strKeywordData = tabDataVar[numDataRecordIndex].keywords[1]
	numWeightData  = tabDataVar[numDataRecordIndex].keywords[2]

	-- Check if argument keyword matches data keyword
	if strKeywordData:lower() == strKeywordArgument:lower() then
		return numWeightData
	else
		return 0
	end if
end
---- =======================================================================================

---- =======================================================================================
-- Match a keyword with a record's keywords in the data table
-- Arguments :
--    strKeywordArgument  : keyword to match
--    tabDataVar          : data table
--    numDataRecordIndex  : record index within the data table
-- Return
--    numWeightFound      : this keyword's weight if found one or more times, 0 otherwise
---- =======================================================================================
local function matchOnSingleRecord( strKeywordArgument, tabDataVar, numDataRecordIndex )
	local numWeightFound = 0
	for numDataKeywordIndex, _ in ipairs(tabDataVar[numDataRecordIndex]) do
		numWeightFound += matchOnSingleKeyword(strKeywordArgument, tabDataVar, numDataRecordIndex, numDataKeywordIndex)
	end
	return numWeightFound
end
---- =======================================================================================

---- =======================================================================================
-- Match an argument keyword with the data table, taking into account modifiers
-- Arguments :
--    strKeywordArgument  : keyword to match
--    numWeight           : keyword weight to be matched
--    boolLess            : match if keyword weight in record is lower than numWeight ?
--    boolEqual           : match if keyword weight in record equals numWeight ?
--    boolMore            : match if keyword weight in record is higher than numWeight ?
--    tabDataVar          : data table
-- Return
--    tabMatch            : table of weighted matching strings
--      strKeystring          Keystring
--      numWeight             Keystring weight
---- =======================================================================================
local function matchModifiedKeywordOnDataTable( strKeywordArgument, numWeight, boolLess, boolEqual, boolMore, tabDataVar )
	local tabMatch = {}
	for numDataRecordIndex, _ in ipairs(tabDataVar) do
		local tabMatchRecord = { keystring = tabDataVar[numDataRecordIndex].value , weight = matchOnSingleRecord(strKeywordArgument, tabDataVar, numDataRecordIndex) }
		if ((tabMatchRecord.weight==numWeight) and boolEqual) or ((tabMatchRecord.weight<numWeight) and boolLess) or ((tabMatchRecord.weight>numWeight) and boolMore) then
			tabMatch:insert(tabMatchRecord)
		end if
	end
	return tabMatch
end
---- =======================================================================================

---- =======================================================================================
-- Match an argument keyword including built-in modifiers with the data table
-- Arguments :
--    strKeywordArgument  : keyword to match, including modifiers
--    tabDataVar          : data table
-- Return
--    tabMatch            : table of weighted matching strings
--      strKeystring          Keystring
--      numWeight             Keystring weight
---- =======================================================================================
local function matchModifiedKeywordOnDataTable( strKeywordArgument, tabDataVar )
	local numWeight       = 1
	local boolLess        = false
	local boolEqual       = True
	local boolMore        = false
	local strKeywordPlain = ""
	local tabMatch        = {}

	-- Parse boolean modifiers, if any, from input string
	local strModifiers = strKeywordArgument:sub(1, 2)
	local strKeywordWithNumber = strKeywordArgument
	if strModifiers=="+=" then
		boolLess, boolEqual, boolMore = false, true, true
		strKeywordWithNumber = strKeywordArgument:sub(3)
	elseif strModifiers=="+#" then
		boolLess, boolEqual, boolMore = false, false, true
		strKeywordWithNumber = strKeywordArgument:sub(3)
	elseif strModifiers=="-=" then
		boolLess, boolEqual, boolMore = true, true, false
		strKeywordWithNumber = strKeywordArgument:sub(3)
	elseif strModifiers=="-#" then
		boolLess, boolEqual, boolMore = true, false, false
		strKeywordWithNumber = strKeywordArgument:sub(3)
	end if

	-- Parse number, if any, from input string
	local numSeparatorPosition = strKeywordWithNumber:find("|", 1, true)
	if numSeparatorPosition == nil then
		strKeywordPlain = strKeywordArgument
	else
		strKeywordPlain = strKeywordArgument:sub(1, numSeparatorPosition-1)
		strNumber = strKeywordArgument:sub(numSeparatorPosition+1)
		numWeigth = 0+strNumber
	end if

	-- Actually get the results
	tabMatch = matchModifiedKeywordOnDataTable( strKeywordArgument, numWeight, boolLess, boolEqual, boolMore, tabDataVar )

	return tabMatch
end
---- =======================================================================================

---- =======================================================================================
-- Match an argument AND-expression with the data table
-- Arguments :
--    strExprArgument  : AND-expression to match
--    tabDataVar       : data table
-- Return
--    tabMatch         : table of weighted matching strings
--      strKeystring          Keystring
--      numWeight             Keystring weight
---- =======================================================================================
local function matchAndExpressionOnDataTable( strExprArgument, tabDataVar )
	-- If need be, strip off the parentheses
	local strStrippedAndExpr = strExprArgument
	local strParenthesisLeft  = strExprArgument:sub(1, 1)
	local strParenthesisRight = strExprArgument:sub(-1)
	if strParenthesisLeft == '(' then
		strStrippedAndExpr = strExprArgument:sub(2)
	end
	if strParenthesisRight == ')' then
		strStrippedAndExpr = strExprArgument:sub(1,-2)
	end

	-- Replace by spaces the AND from the expression
	local strExprWithoutAnd = strExprArgument:gsub(" AND ", " ")

	-- Iterates on the keywords
	for  w in string.gmatch(strExprWithoutAnd, "%a+") do
	end
end
---- =======================================================================================

---- =======================================================================================
-- Match an argument OR-expression with the data table
-- Arguments :
--    strExprArgument  : OR-expression to match
--    tabDataVar       : data table
-- Return
--    tabMatch         : table of weighted matching strings
--      strKeystring          Keystring
--      numWeight             Keystring weight
---- =======================================================================================
local function matchOrExpressionOnDataTable( strExprArgument, tabDataVar )
	-- If need be, strip off the parentheses
	local strStrippedAndExpr = strExprArgument
	local strParenthesisLeft  = strExprArgument:sub(1, 1)
	local strParenthesisRight = strExprArgument:sub(-1)
	if strParenthesisLeft == '(' then
		strStrippedAndExpr = strExprArgument:sub(2)
	end
	if strParenthesisRight == ')' then
		strStrippedAndExpr = strExprArgument:sub(1,-2)
	end

	-- Replace by spaces the AND from the expression
	local strExprWithoutAnd = strExprArgument:gsub(" AND ", " ")

	-- Iterates on the keywords
	for  w in string.gmatch(strExprWithoutAnd, "%a+") do
	end
end
---- =======================================================================================

--
-- =======================================================================================


-- =======================================================================================
--
--   Selection functions definition, hidden from the including script.
-- 
-- =======================================================================================
--
local function selectIndicesListFromKeystring(tabDataVar, strKeywords)
	-- Loop on tabDataVar records
		-- Loop on base expression with 
end
--
-- =======================================================================================


-- =======================================================================================
--
--   Function definitions available for use in the including script.
-- 
-- =======================================================================================
--
function selectStringFromKeywords(dataVar, keywordsList)
	-- Get the indices list from the keywords
	local indicesList = selectIndicesListFromKeystring(dataVar, keywordsList)

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
	indicesList = selectIndicesListFromKeystring(dataVar, keywordsList)

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
