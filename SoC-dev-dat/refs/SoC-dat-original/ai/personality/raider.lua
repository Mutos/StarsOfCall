include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")

--[[

	Raider AI : patrols points, and if a target is found, attacks it and disables it, then docks and loots

--]]

-- Base settings
mem.aggressive      = true
mem.safe_distance   = 500
mem.armour_run      = 80
mem.armour_return   = 100
mem.atk_board       = true
mem.atk_kill        = false
mem.careful         = true
mem.loiter          = 3        -- This is the amount of waypoints the pilot will pass through before leaving the system

function create ()
	local strPrefix = "AI raider script create()"
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Some raiders do kill
	if rnd.rnd() < numKillProba then
		mem.atk_kill = true
	end

	-- Money from the ship's price
	ai.setcredits( rnd.int(ai.pilot():ship():price()/numMoneyRatio[2] , ai.pilot():ship():price()/numMoneyRatio[1]) )

	-- Deal with bribeability
	if rnd.rnd() < numBribeProba then
		mem.bribe_no = strNoBribe
	else
		-- Bribe from the ship's mass
		mem.bribe = math.sqrt( ai.pilot():stats().mass ) * (numBribeParams[1] * rnd.rnd() + numBribeParams[2])
		mem.bribe_prompt = string.format(tabBribePrompt[ rnd.rnd(1,#tabBribePrompt) ], mem.bribe)
		mem.bribe_paid = tabBribePaid[ rnd.rnd(1,#tabBribePaid) ]
	end

	-- Deal with refueling
	p = player.pilot()
	if p:exists() then
		standing = ai.getstanding( p ) or -1
		mem.refuel = rnd.rnd( numRefuelPay[1], numRefuelPay[2] )
		if standing > numRefuelStanding then
			mem.refuel = mem.refuel * numRefuelMult
		end
		mem.refuel_msg = string.format( strRefuelMsg, mem.refuel);
	end

	-- Finish up creation
	create_post()

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end


function taunt ( target, offense )
	if rnd.rnd() < numTauntProba then
		return
	end

	if offense then
		tabTaunts = tabOffenseTaunts
	else
		tabTaunts = tabNoOffenseTaunts
	end
	ai.pilot():comm(target, tabTaunts[ rnd.rnd(1,#tabTaunts) ])
end
