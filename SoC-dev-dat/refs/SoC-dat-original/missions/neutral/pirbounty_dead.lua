--[[

	Dead or Alive Pirate Bounty
	Copyright 2014 Julian Marchant, modifed 2016 by Benoît 'Mutos' Robin

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

--

	Generalized replacement for bobbens' Empire Pirate Bounty mission.
	Can work with any faction.

--]]

include "dat/missions/neutral/pirbounty_base.lua"

-- Localization
lang = naev.lang()
if lang == "es" then
else -- Default to English
	-- Mission details
	misn_title  = "%s Dead or Alive Bounty in %s (%s, %i jumps)"
	misn_desc   = "The pirate known as %s was recently seen in the %s system. This pirate is wanted dead or alive."

	-- OSD message on target system
	osd_msg[2] = "Kill or capture %s"

	-- Extra message when player handles the pirate to the officer
	pay_capture_text[4] = "The officer seems to think your decision to capture %s alive was insane. He carefully takes the pirate off your hands, taking precautions you think are completely unnecessary, and then hands you your pay"
end


function pilot_death( p, attacker )
	if attacker == player.pilot() then
		succeed()
		target_killed = true
	else
		fail( msg[2]:format( name ) )
	end
end


-- Set up the ship, credits, and reputation based on the level.
function bounty_setup ()
	if level == 1 then
		ship = "Angry Bee Fighter"
		credits = 20000 + rnd.sigma() * 5000
		reputation = 1
	elseif level == 2 then
		ship = "Nelk'Tan"
		credits = 40000 + rnd.sigma() * 15000
		reputation = 2
	elseif level == 3 then
		if rnd.rnd() < 0.5 then
			ship = "Akk'Ti'Makkt"
		else
			ship = "Caravelle"
		end
		credits = 100000 + rnd.sigma() * 25000
		reputation = 2
	elseif level == 4 then
		if rnd.rnd() < 0.5 then
			ship = "Percheron Mk1"
		else
			ship = "T'Kalt Patrol"
		end
		credits = 150000 + rnd.sigma() * 60000
		reputation = 3
	elseif level == 5 then
		ship = "Bao Zheng"
		credits = 300000 + rnd.sigma() * 90000
		reputation = 5
	end
end


-- Spawn the ship at the location param.
function spawn_pirate( param )
	if not job_done and system.cur() == missys then
		if jumps_permitted >= 0 then
			misn.osdActive( 2 )
			target_ship = pilot.add( ship, "pirate", param )[1]
			target_ship:rename( name )
			target_ship:setFaction( "Pirate" )
			target_ship:setHilight( true )
			hook.pilot( target_ship, "board", "pilot_board" )
			death_hook = hook.pilot( target_ship, "death", "pilot_death" )
			pir_jump_hook = hook.pilot( target_ship, "jump", "pilot_jump" )
		else
			fail( msg[1]:format( name ) )
		end
	end
end
