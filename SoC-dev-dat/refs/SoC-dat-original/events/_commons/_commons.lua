--[[
-- 
-- Common functions for Event and Missions scripts
-- 
--]]


-- =======================================================================================
--
-- Select a random text line from a selection
-- 
-- =======================================================================================
--

function textSelection(textList)
	if textList == nil then
		return ""
	end
	return textList[rnd.rnd(1,#textList)]
end

function textDoubleSelection(textList)
	-- At least two strings to choose for are needed
	if textList == nil or #textList == 1 then
		return ""
	end

	-- Select first strin
	rnd1 = rnd.rnd(1,#textList)

	-- Select second string to be different from the first
	repeat
		rnd2 = rnd.rnd(1,#textList)
	until rnd2 ~= rnd1

	-- Return both strings
	return textList[rnd1], textList[rnd2]
end

-- 
-- =======================================================================================


-- =======================================================================================
--
-- Compute a reputation delta from attack ratio on both sides
--    - Delta is positive if player attacked Opponent more than Reference
-- 
-- =======================================================================================
--

function getRepDelta(attacksFactionReference, attacksFactionOpponent, multiplier, limit)
	-- Check multiplier argument
	if multiplier < 0 then
		multiplier = -multiplier
	end
	if multiplier == 0 then
		multiplier = 1
	end
	
	-- Check limit argument
	if limit < 0 then
		limit = - limit
	end
	if limit == 0 then
		limit = 1
	end

	-- Compute reputation delta
	local repDelta= 0.0
	if attacksFactionOpponent>0 and attacksFactionReference>0 then
		repDelta = math.log10(attacksFactionOpponent/attacksFactionReference)
	else
		if attacksFactionOpponent>0 then
			repDelta = math.log10(attacksFactionOpponent)
		end
		if attacksFactionReference>0 then
			repDelta = -math.log10(attacksFactionReference)
		end
	end

	-- Scale to multiplier
	repDelta = repDelta * multiplier

	-- Apply limit
	if repDelta > limit then
		repDelta = limit
	end 
	if repDelta < -limit then
		repDelta = -limit
	end 

	-- Return result
	return repDelta
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Get the index of a pilot
--   - Returns the index of the pilot in the list
--   - If pilot is invalid in any way, returns nil
-- 
-- =======================================================================================
--

function getPilotIndex(actualPilot, pilotList)
	-- Check pilot validity
	if actualPilot == nil then
		-- print ( string.format( "\t(%s) : pilot is nil", time.str() ) )
		return nil
	end
	if not actualPilot:exists() then
		-- print ( string.format( "\t(%s) : pilot exists no more", time.str() ) )
		return nil
	end

	-- Find index from pilot
	local index = nil
	for i = 1,#pilotList do
		if actualPilot == pilotList[i] then
			index = i
			-- print ( string.format( "\t(%s) : found index #%i for pilot \"%s\"", time.str(), index, actualPilot:name() ) )
			break
		end
	end

	-- Return found index
	return index
end

--
-- =======================================================================================
