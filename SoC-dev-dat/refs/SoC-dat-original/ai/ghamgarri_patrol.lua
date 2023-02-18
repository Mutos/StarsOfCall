include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/patrol.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true

-- Finish off disabled targets
mem.atk_kill = true

function create ()
	-- Not too many credits.
	ai.setcredits( rnd.rnd(ai.pilot():ship():price()/300, ai.pilot():ship():price()/70) )

	-- Lines to annoy the player. Shouldn't be too common or high-presence systems get inundated.
	r = rnd.rnd(0,20)
	if r == 0 then
	  ai.pilot():broadcast("You are in Gham Garri space.")
	 elseif r == 1 then
		ai.pilot():broadcast("This space is all for Rithkind.")
	end

	-- Get refuel chance
	p = player.pilot()
	if p:exists() then
		standing = ai.getstanding( p ) or -1
		mem.refuel = rnd.rnd( 2000, 4000 )
		if standing < 20 then
			mem.refuel_no = "\"My fuel is property of the Warders.\""
		elseif standing < 70 then
			if rnd.rnd() > 0.2 then
				mem.refuel_no = "\"My fuel is property of the Warders.\""
			end
		else
			mem.refuel = mem.refuel * 0.6
		end
		-- Most likely no chance to refuel
		mem.refuel_msg = string.format( "\"I suppose I could spare some fuel for %d credits.\"", mem.refuel )
	end

	-- See if can be bribed
	if rnd.rnd() > 0.7 then
		mem.bribe = math.sqrt( ai.pilot():stats().mass ) * (500. * rnd.rnd() + 1750.)
		mem.bribe_prompt = string.format("\"For some %d credits I could forget about seeing you.\"", mem.bribe )
		mem.bribe_paid = "\"Now scram before I change my mind.\""
	else
	  bribe_no = {
				"\"You won't buy your way out of this one.\"",
				"\"The Warders of Honor like to make examples out of scum like you.\"",
				"\"You've made a huge mistake.\"",
				"\"Bribery is no way to Honor.\"",
				"\"I'm not interested in your blood money!\"",
				"\"All the money in the world won't save you now!\""
	  }
	  mem.bribe_no = bribe_no[ rnd.rnd(1,#bribe_no) ]
	  
	end

	mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system

	-- Finish up creation
	create_post()
end

-- taunts
function taunt ( target, offense )

	-- Only 50% of actually taunting.
	if rnd.rnd(0,1) == 0 then
		return
	end

	-- some taunts
	if offense then
		taunts = {
				"There is no room in this universe for scum like you!",
				"The Gham Garri will enjoy your death!",
				"One mark to boost my Honor!",
				"None survive the wrath of True Rithai!",
				"Enjoy your last moments, criminal!"
		}
	else
		taunts = {
				"You dare attack me!",
				"You are no match for True Rithai!",
				"The Gham Garri will have your head!",
				"You'll regret that!",
				"That was a fatal mistake!"
		}
	end

	ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end


-- Default task to run when idle
function idle ()
	local strPrefix = "ghamgarri_patrol.lua : idle()"
	local boolDebug = false

	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	dbg.stdOutput( strPrefix, 1, string.format( "Ship              : \"%s\"", ai.pilot():name() ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "Loiter            : %s", tostring(mem.loiter) ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "mem.land_planet   : %s", tostring(mem.land_planet) ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "mem.land_friendly : %s", tostring(mem.land_friendly) ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "mem.tookoff       : %s", tostring(mem.tookoff) ), boolDebug )
	dbg.stdOutput( strPrefix, 1, string.format( "mem.nojump        : %s", tostring(mem.nojump) ), boolDebug )

	-- Before all, check if any Free Adrims ship is in the system
	-- tabFreeAdrimaiPilots = pilot.get( { faction.get("Free Adrimai") } )
	local tabFreeAdrimaiPilots = pilot.get(nil, true)
	if tabFreeAdrimaiPilots==nil then
		dbg.stdOutput( strPrefix, 1, string.format( "No pilot found" ), boolDebug )
	else
		dbg.stdOutput( strPrefix, 1, string.format( "# of pilots       : %s", tostring(#tabFreeAdrimaiPilots) ), boolDebug )
		for k,v in ipairs(tabFreeAdrimaiPilots) do
			dbg.stdOutput( strPrefix, 2, string.format( "%s : %s : %s", v:name(), v:ship():name(), v:faction():name() ), boolDebug )
		end
	end

	-- Check and reset mem.loiter if need be
	if mem.loiter == nil then
		mem.loiter = 3
	end
	if mem.loiter < 0 then
		mem.loiter = 3
	end

	-- Still waypoints left : go to next one
	if mem.loiter > 0 then
		local sysrad = rnd.rnd() * system.cur():radius()
		local angle = rnd.rnd() * 2 * math.pi
		local targetPos = vec2.new(math.cos(angle) * sysrad, math.sin(angle) * sysrad)
		ai.pushtask("__goto_nobrake", targetPos)
		mem.loiter = mem.loiter - 1

		local x, y = targetPos:get()
		dbg.stdOutput( strPrefix, 1, string.format( "Setting task \"__goto_nobrake\" : [%i, %i]", x, y ), boolDebug )
		dbg.stdOutput( strPrefix, 1, string.format( "Loiter set to     : %s", tostring(mem.loiter) ), boolDebug )

		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return
	end

	-- We can land on a planet and didn't take off
	if mem.land_planet == true and not mem.tookoff then
		-- We search a planet, friendly if possible, to land
		local planet = ai.landplanet( mem.land_friendly )

		if planet ~= nil then
			mem.land = planet:pos()
			dbg.stdOutput( strPrefix, 1, "Setting task \"land\"", boolDebug )
			ai.pushtask("land")

			dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
			return
		end
	end

	-- Either took off or no friendly planet : must hyperspace if authorized
	if not mem.nojump then
		dbg.stdOutput( strPrefix, 1, "Setting task \"hyperspace\"", boolDebug )
		ai.pushtask("hyperspace")

		dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
		return
	end

	-- Neither land nor hyperspace : stay there for another round, but unmark tookoff
	ai.settimer(0, rnd.int(1000, 3000))
	ai.pushtask("enterdelay")
	dbg.stdOutput( strPrefix, 1, "Setting task \"enterdelay\"", boolDebug )

	mem.loiter = mem.loiter-1
	dbg.stdOutput( strPrefix, 1, string.format( "Loiter set to     : %s", tostring(mem.loiter) ), boolDebug )

	mem.tookoff = false
	dbg.stdOutput( strPrefix, 1, string.format( "TookOff set to    : %s", tostring(mem.tookoff) ), boolDebug )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end
