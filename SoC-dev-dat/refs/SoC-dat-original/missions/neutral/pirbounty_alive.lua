--[[

	Alive Pirate Bounty
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

	Bounty mission where you must capture the target alive.
	Can work with any faction.

--]]

include "dat/missions/neutral/pirbounty_base.lua"

-- Localization
lang = naev.lang()
if lang == "es" then
else -- Default to English
	-- Mission details
	misn_title  = "%s Alive Bounty in %s (%s, %i jumps)"
	misn_desc   = "The pirate known as %s was recently seen in the %s system. This pirate is wanted alive."

	-- OSD message on target system
	osd_msg[2] = "Capture %s"

	-- Extra message when player killed their target
	msg[4] = "MISSION FAILURE! %s has been killed."
end


function pilot_death( p, attacker )
	fail( msg[4]:format( name ) )
end


-- Set up the ship, credits, and reputation based on the level.
function bounty_setup ()
	if level == 1 then
		ship = "Angry Bee Fighter"
		credits = 25000 + rnd.sigma() * 5000
		reputation = 0
	elseif level == 2 then
		ship = "Nelk'Tan"
		credits = 50000 + rnd.sigma() * 15000
		reputation = 1
	elseif level == 3 then
		if rnd.rnd() < 0.5 then
			ship = "Akk'Ti'Makkt"
		else
			ship = "Caravelle"
		end
		credits = 120000 + rnd.sigma() * 25000
		reputation = 3
	elseif level == 4 then
		if rnd.rnd() < 0.5 then
			ship = "Percheron Mk1"
		else
			ship = "T'Kalt Patrol"
		end
		credits = 200000 + rnd.sigma() * 60000
		reputation = 5
	elseif level == 5 then
		ship = "Bao Zheng"
		credits = 400000 + rnd.sigma() * 90000
		reputation = 7
	end
end
