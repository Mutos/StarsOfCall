-- Based on the same bricks as the regular cargo mission
include "cargo_common.lua"
include "numstring.lua"

-- A set of GLOBAL variables properly named to save the event parameters
evtSave_System = nil
evtSave_RefPlanet = nil
evtSave_CommodityName = nil
evtSave_OriginalPrice = 0
evtSave_OriginalPriceSet = true
evtSave_EventPrice = 0
evtSave_TimerMin = 0
evtSave_TimerMax = 0

lang = naev.lang()
if lang == 'es' then --not translated atm
else --default english
	events = {

		{
			{"famine", "Famine"},		--event name/type
			{3,5},				--prices begin to return to normal in 5-10 STP
			{"Food", 2.0},	--commodity and it's new price relative to the old one
			50				-- Percentage of event being selected if match
		},

		{
			{"bumper harvest", "Bumper Harvest"},
			{3,5},
			{"Food", .5},
			50
		},

		{
			{"workers' strike","Workers' Strike"},
			{3,5},
			{"Goods", 1.5},
			50
		},

		{
			{"miners' strike","Miners' Strike"},
			{3,5},
			{"Ore", 1.5},
			50
		},

		{
			{"cat convention","Cat Convention"},
			{3,5},
			{"Medicine",1.25},
			50
		},

		{
			{"disease outbreak","Disease Outbreak"},
			{3,5},
			{"Medicine",2.5},
			50
		}
	}

end

function create()
	make_event()

	evt.save(true)
end


-- Make the news event for the selected event and system
function make_article(sys, event, evtSave_CommodityName)
	-- Local variables
	local body = ""
	local title = ""
	local timer = nil

	-- Set event parameters
	title = event[1][2].." on "..sys:name()
	body = "System "..sys:name().." recently experienced a "..event[1][1]..", changing "
	timer = time.create(0,event[2][2],0)+time.get()  -- Mark maximum timer for removing the event

	-- Say how the prices have changed
	body = body.."the price of "..evtSave_CommodityName..string.format(" from %.0f credits per ton to %.0f.",math.abs(evtSave_OriginalPrice),econ.getPrice(evtSave_CommodityName, sys))
	body = body.." Prices are expected to begin to settle around "..timer:str()

	-- Make the article
	article = news.add("Generic", title, body, timer)
	article:bind("economic event")
end


-- Make a single economic event
function make_event()
	-- Local variables
	local traveldist = 0
	local tier = 0
	local numjumps = 0
	local eventEnd = 0

	-- Debug printout
	-- print ( string.format ( "\tEconomic Event : entering make_event()" ) )

	-- Calculate the route, distance, jumps and cargo to take
	-- Seect the commodity from those sold at the target planet
	-- This way, we always use an existing good on at least one planet in the target system
	evtSave_RefPlanet, evtSave_System, numjumps, traveldist, evtSave_CommodityName, tier = cargo_calculateRoute(true)
	if evtSave_RefPlanet == nil then
		-- print ( string.format ( "\tEconomic Event : no suitable reference destination planet found" ) )
		evt.finish(false)
		return
	end
	-- print ( string.format ( "\tEconomic Event : selected system \"%s\"", evtSave_System:name() ) )

	-- Prevent a system from having multiple events
	economic_articles = news.get("economic events")
	for i=1,#economic_articles do
		if string.match( article:title(), evtSave_System:name()) then
			-- print ( string.format ( "\tEconomic Event : system \"%s\" is already taken", evtSave_System:name() ) )
			evt.finish(false)
			return
		end
	end

	-- Get the corresponding event
	local found = false
	local event = nil
	local comm_name = ""
	local multiplier = 1
	local keyword = ""

	for i=1,#events do
		event = events[i]
		for j=3,#event-1 do
			keyword = event[j][1]
			if string.match( evtSave_CommodityName, keyword ) then
				-- print ( string.format ( "\tEconomic Event : \tkeyword \"%s\" matches against comodity name \"%s\"", keyword, evtSave_CommodityName ) )
				if rnd.rnd()*100 < event[#event] then
					-- print ( string.format ( "\tEconomic Event : \t\tevent selected, chances were %i%%.", event[#event] ) )
					found = true
					comm_name = evtSave_CommodityName
					multiplier = event[j][2]
					break
				else
					-- print ( string.format ( "\tEconomic Event : \t\tevent rejected, chances were %i%%.", event[#event] ) )
				end
			else
				-- print ( string.format ( "\tEconomic Event : \tkeyword \"%s\" does not match against comodity name \"%s\"", keyword, evtSave_CommodityName ) )
			end
		end
		if found then
			break
		end
	end
	if not found then
		-- print ( string.format ( "\tEconomic Event : no event selected." ) )
		evt.finish(false)
		return
	end

	-- Debug printout
	-- print ( string.format ( "\tEconomic Event : creating event \"%s\" in system \"%s\"", event[1][1], evtSave_System:name() ) )

	-- Setup new prie, update prices and make the article
	evtSave_OriginalPrice = econ.getPrice(comm_name, evtSave_System)
	evtSave_OriginalPriceSet = econ.isPriceSet(comm_name, evtSave_System)
	evtSave_EventPrice = evtSave_OriginalPrice*multiplier
	econ.setPrice(comm_name, evtSave_System, evtSave_EventPrice)
	-- econ.updatePrices() -- Remove to prevent extra CPU usage
	make_article(evtSave_System, event, evtSave_CommodityName)

	--set up the event ending and save timer parameters
	evtSave_TimerMin = event[2][1]
	evtSave_TimerMax = event[2][2]
	local evtTimer = rnd.rnd(event[2][1], event[2][2])
	hook.date( time.create(0, evtTimer, 0), "adjustPrices", str )

	-- Debug printout
	-- print ( string.format ( "\tEconomic Event : exiting make_event()" ) )
end


-- May end the event, returning the price to its original value
-- or may only reduce prie difference to make it more progressive
function adjustPrices(str)
	-- First get all the information we'll need
	local commodity = commodity.get(evtSave_CommodityName)
	local currentPrice = econ.getPrice(commodity, evtSave_System)
	local currentPriceDiff = currentPrice - evtSave_OriginalPrice
	local originalPriceDiff = evtSave_EventPrice - evtSave_OriginalPrice

	-- Debug printout
	-- print ( string.format ( "\tEconEvent End : entering regulation hook." ) )
	-- print ( string.format ( "\tEconEvent End : \tSystem         = \"%s\".", evtSave_System:name() ) )
	-- print ( string.format ( "\tEconEvent End : \tRef Planet     = \"%s\".", evtSave_RefPlanet:name() ) )
	-- print ( string.format ( "\tEconEvent End : \tCommodity      = \"%s\"", evtSave_CommodityName ) )
	-- print ( string.format ( "\tEconEvent End : \t\tPrices :" ) )
	-- print ( string.format ( "\tEconEvent End : \t\t\tOriginal = %f.", evtSave_OriginalPrice ) )
	-- print ( string.format ( "\tEconEvent End : \t\t\tEvent    = %f.", evtSave_EventPrice ) )
	-- print ( string.format ( "\tEconEvent End : \t\t\tCurrent  = %f.", currentPrice ) )
	-- print ( string.format ( "\tEconEvent End : \t\tDiffs :" ) )
	-- print ( string.format ( "\tEconEvent End : \t\t\tOriginal = %f.", originalPriceDiff ) )
	-- print ( string.format ( "\tEconEvent End : \t\t\tCurrent  = %f.", currentPriceDiff ) )

	if math.abs(currentPriceDiff) > math.abs(originalPriceDiff)*0.1 then
		-- Set intermdiate price
		local newPriceDiff = currentPriceDiff * 0.5
		econ.setPrice(commodity, evtSave_System, evtSave_OriginalPrice+newPriceDiff)
		-- print ( string.format ( "\tEconEvent End : \thalving price difference from %f (%f-%f) to %f (%f-%f).", currentPriceDiff, currentPrice, evtSave_OriginalPrice, newPriceDiff, evtSave_OriginalPrice+newPriceDiff, evtSave_OriginalPrice ) )

		-- Set a timer for further price regulation
		local evtTimer = rnd.rnd(evtSave_TimerMin, evtSave_TimerMax)
		hook.date( time.create(0, evtTimer, 0), "adjustPrices", str )
	else
		-- Reset prices to their original states
		if evtSave_OriginalPriceSet then
			econ.unsetPrice(commodity, evtSave_System)
			-- print ( string.format ( "\tEconEvent End : unsetting price." ) )
		else
			econ.setPrice(commodity, evtSave_System, evtSave_OriginalPrice)
			-- print ( string.format ( "\tEconEvent End : restoring price." ) )
		end

		-- Finish the event
		-- print ( string.format ( "\tEconEvent End : closing and exiting regulation hook." ) )
		evt.finish()
	end

	-- print ( string.format ( "\tEconEvent End : exiting regulation hook." ) )
end
