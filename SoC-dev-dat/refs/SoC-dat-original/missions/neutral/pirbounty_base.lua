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

include "numstring.lua"
include "jumpdist.lua"
include "pilot/pirate.lua"

-- Localization
lang = naev.lang()
if lang == "es" then
else -- Default to English
	subdue_title   = "Captured Alive"
	subdue_text    = {}
	subdue_text[1] = [[You and your crew infiltrate the ship's pathetic security and subdue %s. You transport the pirate to your ship.]]
	subdue_text[2] = [[Your crew has a surprisingly difficult time getting past the ship's security, but eventually succeeds and subdues %s.]]

	pay_title   = "Mission Completed"

	pay_kill_text    = {}
	pay_kill_text[1] = "After verifying that you killed %s, an officer hands you your pay."
	pay_kill_text[2] = "After verifying that %s is indeed dead, the tired-looking officer smiles and hands you your pay."
	pay_kill_text[3] = "The officer seems pleased that %s is finally dead. He thanks you and promptly hands you your pay."
	pay_kill_text[4] = "The paraoid-looking officer takes you into a locked room, where he quietly verifies the death of %s. He then pays you and sends you off."

	pay_capture_text    = {}
	pay_capture_text[1] = "An officer takes %s into custody and hands you your pay."
	pay_capture_text[2] = "The officer you deal with seems to especially dislike %s. He takes the pirate off your hands and hands you your pay without speaking a word."
	pay_capture_text[3] = "A fearful-looking officer rushes %s into a secure hold, pays you the appropriate bounty, and then hurries off."

	-- Mission details : will be defined in _dead and _alive specific files
	misn_title  = ""
	misn_desc   = ""
	misn_reward = "%s credits"

	misn_level    = {}
	misn_level[1] = "Tiny"      -- Pirate Angry Bee
	misn_level[2] = "Small"     -- Pirate Nelk'Tan
	misn_level[3] = "Moderate"  -- Pirate Akk'Ti'Makt or Pirate Caravelle
	misn_level[4] = "High"      -- Pirate Percheron or Pirate T'Kalt Patrol
	misn_level[5] = "Dangerous" -- Pirate Bao Zheng

	-- Messages
	msg    = {}
	msg[1] = "MISSION FAILURE! %s got away."
	msg[2] = "MISSION FAILURE! Somebody else eliminated %s."
	msg[3] = "MISSION FAILURE! You have left the %s system."

	-- OSD messages : #2 message will be defined in _dead and _alive specific files
	osd_title = "Bounty Hunt"
	osd_msg    = {}
	osd_msg[1] = "Fly to the %s system"
	osd_msg[2] = ""
	osd_msg[3] = "Land on the nearest %s planet and collect your bounty"
	osd_msg["__save"] = true
end


function create ()
	paying_faction = planet.cur():faction()

	local systems = getsysatdistance( system.cur(), 0, 3,
		function(s) return s:presences()["Pirate"] end )

	if #systems == 0 then
		-- No pirates nearby
		misn.finish( false )
	end

	missys = systems[ rnd.rnd( 1, #systems ) ]
	if not misn.claim( missys ) then misn.finish( false ) end

	jumps_permitted = missys:jumpDist() + rnd.rnd( 5 )
	if rnd.rnd() < 0.05 then
		jumps_permitted = jumps_permitted - 1
	end

	local num_pirates = missys:presences()["Pirate"]
	if num_pirates <= 15 then
		level = 1
	elseif num_pirates <= 25 then
		level = rnd.rnd( 1, 2 )
	elseif num_pirates <= 35 then
		level = rnd.rnd( 2, 3 )
	elseif num_pirates <= 50 then
		level = rnd.rnd( 3, 4 )
	else
		level = rnd.rnd( 4, #misn_level )
	end

	name = pirate_name()
	ship = "Angry Bee Fighter"
	credits = 50000
	reputation = level
	bounty_setup()

	-- Set mission details
	misn.setTitle( misn_title:format( misn_level[level], missys:name(), paying_faction:name(), missys:jumpDist() ) )
	misn.setDesc( misn_desc:format( name, missys:name() ) )
	misn.setReward( misn_reward:format( numstring( credits ) ) )
	marker = misn.markerAdd( missys, "computer" )
end


function accept ()
	misn.accept()

	osd_msg[1] = osd_msg[1]:format( missys:name() )
	osd_msg[2] = osd_msg[2]:format( name )
	osd_msg[3] = osd_msg[3]:format( paying_faction:name() )
	misn.osdCreate( osd_title, osd_msg )

	last_sys = system.cur()
	job_done = false
	target_killed = false

	hook.jumpin( "jumpin" )
	hook.jumpout( "jumpout" )
	hook.takeoff( "takeoff" )
	hook.land( "land" )
end


function jumpin ()
	local pos = jump.pos( system.cur(), last_sys )
	local offset_ranges = { { -2500, -1500 }, { 1500, 2500 } }
	local xrange = offset_ranges[ rnd.rnd( 1, #offset_ranges ) ]
	local yrange = offset_ranges[ rnd.rnd( 1, #offset_ranges ) ]
	pos = pos + vec2.new( rnd.rnd( xrange[1], xrange[2] ), rnd.rnd( yrange[1], yrange[2] ) )
	spawn_pirate( pos )
end


function jumpout ()
	jumps_permitted = jumps_permitted - 1
	last_sys = system.cur()
	if not job_done and last_sys == missys then
		fail( msg[3]:format( last_sys:name() ) )
	end
end


function takeoff ()
	spawn_pirate()
end


function land ()
	jumps_permitted = jumps_permitted - 1
	if job_done and planet.cur():faction() == paying_faction then
		local pay_text
		if target_killed then
			pay_text = pay_kill_text[ rnd.rnd( 1, #pay_kill_text ) ]
		else
			pay_text = pay_capture_text[ rnd.rnd( 1, #pay_capture_text ) ]
		end
		tk.msg( pay_title, pay_text:format( name ) )
		player.pay( credits )
		paying_faction:modPlayerSingle( reputation )
		misn.finish( true )
	end
end


function pilot_board ()
	player.unboard()
	local t = subdue_text[ rnd.rnd( 1, #subdue_text ) ]:format( name )
	tk.msg( subdue_title, t )
	succeed()
	target_killed = false
	target_ship:changeAI( "dummy" )
	target_ship:setHilight( false )
	target_ship:disable() -- Stop it from coming back
	if death_hook ~= nil then hook.rm( death_hook ) end
end


function pilot_jump ()
	fail( msg[1]:format( name ) )
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


-- Succeed the mission, make the player head to a planet for pay
function succeed ()
	job_done = true
	misn.osdActive( 3 )
	if marker ~= nil then
		misn.markerRm( marker )
	end
	if pir_jump_hook ~= nil then
		hook.rm( pir_jump_hook )
	end
end


-- Fail the mission, showing message to the player.
function fail( message )
	if message ~= nil then
		player.msg( message )
	end
	misn.finish( false )
end
