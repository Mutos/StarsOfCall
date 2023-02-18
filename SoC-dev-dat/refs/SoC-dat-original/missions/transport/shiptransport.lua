--[[

	MISSION: Ship transporter
	DESCRIPTION: Transport a ship from one Planet to another

	how your ship travel from shipyard to shipyard?
	now you are one of the shiptransporters.
	NOTE: codes from cargo.lua and cargo_common.lua
--]]

include "cargo_common.lua"
include "jumpdist.lua"
include "numstring.lua"
include "nextjump.lua"

lang = naev.lang()
if lang == "es" then
else -- default english
	misn_desc = "%s in the %s system needs a delivery of %d tons of %s."
	misn_reward = "%s credits"
	
	desc = {}
	desc[1] = "Fighter delivery to %s"
	desc[2] = "Fighter transport to %s"
	desc[3] = "Fighter move to %s"
	desc[4] = "Small ship delivery to %s"
	desc[5] = "Personnal ship transport to %s"
	desc[6] = "Single-crew ship delivery to %s"

	title_p1 = {}
	title_p1[1] = "Fighter delivery to %s in the %s system"
	title_p1[2] = "Fighter transport to %s in the %s system"
	title_p1[3] = "Fighter move to %s in the %s system"
	title_p1[4] = "Small ship delivery to %s in the %s system"
	title_p1[5] = "Personnal ship transport to %s in the %s system"
	title_p1[6] = "Single-crew ship delivery to %s in the %s system"
	
	-- Note: please leave the trailing space on the line below! Needed to make the newline show up.
	title_p2 = [[ 
Cargo: %s (%d tons)
Jumps: %d
Travel distance: %d]]

	full = {}
	full[1] = "No room in ship"
	full[2] = "You don't have enough cargo space to accept this mission. You need %d tons of free space (%d more)."

	--=Landing=--
	cargo_land_title = "Delivery success!"

	cargo_land_p1 = {}
	cargo_land_p1[1] = "The container holding the "
	cargo_land_p1[2] = "The transported "
	cargo_land_p1[3] = "The carefully packed "
	cargo_land_p1[4] = "The "

	cargo_land_p2 = {}
	cargo_land_p2[1] = " is carried out of your ship by a sullen group of workers, hustled by the quite angry pilot. The job takes inordinately long to complete. Once finished, the pilot pays you without speaking a word."
	cargo_land_p2[2] = " is pulled out by a busy team shortly after you land. Before you can even collect your thoughts, one of them presses a credit chip in your hand and departs."
	cargo_land_p2[3] = " is unloaded by an exhausted-looking bunch of dockworkers. Still, they make fairly good time, delivering your pay upon completion of the job."
	cargo_land_p2[4] = " is unloaded by a team of robotic drones supervised by a sentient overseer, who hands you your pay when they finish."
	cargo_land_p2[5] = " is quickly unloaded by the pilot and his two mechanics. After examining the fighter, they turn to you, congratulate you and hand you a credit chip."
	cargo_land_p2[6] = " is pulled out by a busy team under direct supervision of the pilot, who quickly hands a credit chip once the container has been checked."

	accept_title = "Mission Accepted"
	
	osd_title = "Ship Transport mission"
	osd_msg = "Fly to %s in the %s system."

	-- Tonnage depends on cargo
	-- TODO : devise a way to get that automatically from ship characteristics
	cargoes = {
		{"Angry Bee",		10},
		{"Akk'Ti'Makkt",	30},
		{"Nelk'Tan",		25}
	}
end

function ship_calculateRoute ()
	origin_p, origin_s = planet.cur()
	local routesys = origin_s
	local routepos = origin_p:pos()
	
	-- Select a random distance
	local missdist = cargo_selectMissionDistance(5,9)

	-- Find a possible planet at that distance
	local planets = cargo_selectPlanets(missdist, routepos)
	if #planets == 0 then
		return
	end

	local index	  = rnd.rnd(1, #planets)
	local destplanet = planets[index][1]
	local destsys	= planets[index][2]
	
	-- We have a destination, now we need to calculate how far away it is by simulating the journey there.
	-- Assume shortest route with no interruptions.
	-- This is used to calculate the reward.

	local numjumps   = origin_s:jumpDist(destsys)
	local traveldist = cargo_calculateDistance(routesys, routepos, destsys, destplanet)
	
	-- We now know where. But we don't know what yet. Randomly choose a ship type.
	-- Also choose amount of cargo based on the fighter's size
	local seed = rnd.rnd(1, #cargoes)
	local cargo = cargoes[seed][1]
	local amount = cargoes[seed][2]

	-- Return lots of stuff
	return destplanet, destsys, numjumps, traveldist, cargo, amount
end


-- Create the mission
function create()
	-- Note: this mission does not make any system claims.
	-- print ( string.format( "\tShip Transport : entering create()" ) )

	-- The more presence in the system, the more chances the mission has to be generated
	local seed = rnd.rnd(1,1000)
	local presence = system.cur():presence("all")
	if ( seed > presence ) then
		-- print ( string.format( "\tShip Transport : \tpresence check failed  (rnd=%i > presence=%i in system \"%s\")", seed, presence, system.cur():name() ) )
		misn.finish(false)
	else
		-- print ( string.format( "\tShip Transport : \tpresence check success (rnd=%i < presence=%i in system \"%s\")", seed, presence, system.cur():name() ) )
	end

	-- Calculate the route, distance, jumps and cargo to take
	destplanet, destsys, numjumps, traveldist, cargo, amount = ship_calculateRoute()
	if destplanet == nil then
		misn.finish(false)
		-- print ( string.format( "\tShip Transport : \tno suitable planet found (origin system \"%s\")", system.cur():name() ) )
	end
	
	-- Choose mission reward. Mission is assumed to be Tier 1 (Reward x1.5) when compared to regular cargo missions.
	-- Note: Pay is independent from amount by design! Not all deals are equally attractive!
	finished_mod = 2.0 -- Modifier that should tend towards 1.0 as naev is finished as a game
	jumpreward = 300
	distreward = 0.09
	reward = 1.5 * (numjumps * jumpreward + traveldist * distreward) * finished_mod * (1. + 0.05*rnd.twosigma())
	
	misn.setTitle(buildCargoMissionDescription( desc, nil, amount, cargo, destplanet, destsys ))
	misn.markerAdd(destsys, "computer")
	misn.setDesc(title_p1[rnd.rnd(1, #title_p1)]:format(destplanet:name(), destsys:name()) .. title_p2:format(cargo, amount, numjumps, traveldist))
	misn.setReward(misn_reward:format(numstring(reward)))
	
	-- print ( string.format( "\tShip Transport : exiting create()" ) )
end

-- Mission is accepted
function accept()
	if player.pilot():cargoFree() < amount then -- No free cargo space
		tk.msg(full[1], full[2]:format(amount, amount - player.pilot():cargoFree()))
		misn.finish()
	end
	misn.accept()
	misn.cargoAdd(cargo, amount) -- TODO: change to jettisonable cargo once custom commodities are in. For piracy purposes.
	misn.osdCreate(osd_title, {osd_msg:format(destplanet:name(), destsys:name())})
	hook.land("land")
end

-- Land hook
function land()
	if planet.cur() == destplanet then
		-- Semi-random message.
		tk.msg(cargo_land_title, cargo_land_p1[rnd.rnd(1, #cargo_land_p1)] .. cargo .. cargo_land_p2[rnd.rnd(1, #cargo_land_p2)])
		player.pay(reward)
		misn.finish(true)
	end
end

function abort ()
	misn.finish(false)
end

