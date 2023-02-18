-- ==========================================================================
--
-- Free Adrims Shipwreck Event
-- 
-- Creates a wrecked ship that asks for help.
-- If the player boards it, he helps repair the ship and sees Adrimai.
--
-- ==========================================================================


-- ==========================================================================
-- Initializations
-- ==========================================================================
--
-- Debug facility
include "debug/debug.lua"

-- define variables
numEventOccurences = nil
strEventOccurences = "AdrimShipwreck_count"

-- Define variable to contain texts
tabMessages = {}
title = {}
textRepair = {}
textGoodbye = {}

-- Define script-wide variable with situation
strSituation = "NotRith"

-- Define broadcast timers
numBroadcastFirst  =  2000
numBroadcastRepeat = 20000
--
-- ==========================================================================


-- ==========================================================================
-- Define texts
-- ==========================================================================
--
lang = naev.lang()
if lang == "es" then
	-- not translated atm
else -- default english 

	-- Text messages constants : ship and captain's names from a list
	tabMessages["captainSurname"] = { "Relen", "Allend", "Skasshd", "Tyerth" }
	local numNames = rnd.rnd(1,4)
	tabMessages["captainName"]    = string.format( "%s im Ord", tabMessages["captainSurname"][numNames] )
	tabMessages["shipName"]       = string.format( "%s'd'rih", tabMessages["captainSurname"][numNames] )

	-- Text messages constants
	tabMessages["RithNoSee"]      = {}
	tabMessages["RithSee"]        = {}
	tabMessages["NotRith"]        = {}
	tabMessages["attacked"]       = {}

	-- Broadcast messages
	tabMessages["broadcast"]      = "This is passengers ship %s. We are shipwrecked. Requesting immediate assistance."
	tabMessages["boardTitle"]     = "Help repairing the ship"
	tabMessages["repairTitle"]    = "Repairs completed"
	tabMessages["attacked"]       = {
		"Attacking helpless refugees will be a forever stain on your honor!",
		"Honorless coward, don't you dare calling yourself a true Rith!",
		"We'll come back from the Eclipse to haunt you forever!",
		"I know true Rithai, they helped us get there!",
		"You can't stop the future from happening!",
	}

	-- Situation : you play a traditional Rith, who doesn't see Adrimai
	tabMessages["RithNoSee"]["boardText"]  = [[The airlock opens and you are greeted by a diminutive female with Arythem features. Oddly, no other crew member is present, and her tense ears, mane and tail show she's hiding a deep fear.

"I'm %s, the captain of this ship. Thank the moons you are here," she says. "I don't know how much longer we could've held out. Our main generator and life-support are dead, you know, we're on auxiliary power for now several handful hours."

You quickly learn the %s is a small passenger vessel, but see no passenger either. After a shortened, barely polite small talk, the captain asks you if you can help her to repair the ship.

As you gladly lend a hand, you sense presences around you, but to your surprise, you see no passenger at all as you stride past the ship's dimly lit corridors.]]
	tabMessages["RithNoSee"]["boardText"]  = string.format(tabMessages["RithNoSee"]["boardText"], tabMessages["captainName"], tabMessages["shipName"])
	tabMessages["RithNoSee"]["repairText"] = [[Several STU later, you find the issue in the main powerplant. As light comes back online, ghostly rithai shapes try to hide in the shadows and leave the room in haste. You suddenly realize they must be Adrimai.

The captain tries to apologize, but you notice a scar on her forehead, where the ritual mark had probably been surgically removed. She must have been an Adrim herself!

You hastily leave the ghostship as she begins to fade out of your vision, followed by eerie eyes you now only barely discerne.]]
	tabMessages["RithNoSee"]["thanksText"] = "Sorry for imposing us on you... I do hope you'll truly see us next time we meet!"

	-- Situation : you play a progressive Rith, who sees Adrimai
	tabMessages["RithSee"]["boardText"]    = [[The airlock opens and you are greeted by a diminutive female with Arythem features. Oddly, no other crew member is present, and her tense ears, mane and tail show she's hiding a deep fear.

"I'm %s, the captain of this ship. Thank the moons you are here," she says. "I don't know how much longer we could've held out. Our main generator and life-support are dead, you know, we're on auxiliary power for now several handful hours."

You quickly learn the %s is a small passenger vessel, but see no passenger either. After a shortened, barely polite small talk, the captain asks you if you can help her to repair the ship.

As you gladly agree to lend a hand and stride past the ship's dimly lit corridors, you notice rithai shapes hiding in the shadows. You understand they must be Adrimai, forced to exile outside the Rith Sphere for just being born what they are. You are helping one of the so-called "ghostship"!

Seeing your expression change, the captain tries to apologize, but you assure her all you're doing is repairing the dishonorable treatment her people suffered at the hands of traditionalists. You notice a scar on her forehead, where the ritual mark had probably been surgically removed. She must have been an Adrim herself. She expresses here gratitude with much circonlocutions and you both begin to investigate the ship's power systems.]]
	tabMessages["RithSee"]["boardText"]    = string.format(tabMessages["RithSee"]["boardText"], tabMessages["captainName"], tabMessages["shipName"])
	tabMessages["RithSee"]["repairText"]   = [[Several STU later, you find the issue in the main powerplant. As light comes back online, you see a host of d'rih-marked faces looking at you in wonder.

An elderly male pulls back his hood; revealing a wrinkled face with d'rih-colored bars tatooed on his cheeks, ears and muzzle. He comes forth before you, puts one knee to the ground and bows deeply. Your tongue unfolds with emotion as you gesture him to stand up. "By this act of kindness, your Honor will blossom like the Great Seed of the Leinth", he says, his words revealing he comes from Irilia-17.

You leave the ship deeply moved, followed by the many eyes of the Adrimai.]]
	tabMessages["RithSee"]["thanksText"]   = "May the Infinity grant your line many honorfull generations... We'll sure meet again on the Road of Perils!"

	-- Situation : you play a non-Rith
	tabMessages["NotRith"]["boardText"]    = [[The airlock opens and you are greeted by a diminutive Rith, with a strange look in her eyes.

	"I'm %s, the captain of this ship. Thank the moons you are here," she says. "I don't know how much longer we could've held out. Our main generator and life-support are dead, you know, we're on auxiliary power for now several handful hours."

You quickly learn the %s is a small passenger vessel. After much circonlocutions, the captain asks you if you can help her to repair it.

As you gladly lend a hand, you see passengers hiding in the dimly lit corridors. They all have the same strange look. You understand it: fear. It's the first time you see Rithai openly displaying fear.]]
	tabMessages["NotRith"]["boardText"]    = string.format(tabMessages["NotRith"]["boardText"], tabMessages["captainName"], tabMessages["shipName"])
	tabMessages["NotRith"]["repairText"]   = [[Several STU later, you find the issue in the main powerplant and manage to take it back online. You find yourself surrounded by rithai faces, all wearing a blue mark of some shape or another. As you look into the wrinkled face of an old Rith hidden under a hood, you understand everything: they must be Adrimai, the people who are declared dead and seen by all other Rithai as if they were actually ghosts!

As you can't repress a movement of compassion towards the poor fellows, the captain sees it and tells you: "I apologize, I should have told you. I just hope helping pariahs is no stain on your honor." You assure her that it has actually been a honor, salute the passengers and wish them good luck in their journey to freedom. They all bow down in answer, keeping perfect silence. You leave the ship followed by all their eyes.]]
	tabMessages["NotRith"]["thanksText"]   = "You've more honor than many Rithai, I hope we'll meet again under better circumstances!"
end
--
-- ==========================================================================


-- ==========================================================================
-- Generic start of event.
-- ==========================================================================
--
function create ()
	local strPrefix = "Adrim Shipwreck Event : function create()"
	local boolDebug = true

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Find how many times the event has already been played
	numEventOccurences = var.peek (strEventOccurences)
	dbg.stdOutput( strPrefix, 1, string.format( "numEventOccurences = %s", tostring(numEventOccurences) ), boolDebug )
	if (numEventOccurences == nil) then
		numEventOccurences = 1
	else
		numEventOccurences = numEventOccurences + 1
	end

	-- Get player character species and standings regarding to Free Adrimai & Gham Garri
	local strSpecies = var.peek ("pc_species")
	local numRepFA   = faction.get("Free Adrimai"):playerStanding()
	local numRepGG   = faction.get("Gham Garri"):playerStanding()

	-- Message describing the situation
	if strSpecies == "Rith" then
		if (numRepFA > 10) or (numRepGG < -10) then
			strSituation = "RithSee"
		else
			strSituation = "RithNoSee"
		end
	end

	-- Get all GG pilots
	tabGGpilots = pilot.get( { faction.get("Gham Garri") } )
	dbg.stdOutput( strPrefix, 1, "Listing Gham Garri pilots : begin", boolDebug )
	for k,v in ipairs(tabGGpilots) do
		dbg.stdOutput( strPrefix, 2, v:name(), boolDebug )
	end
	dbg.stdOutput( strPrefix, 1, "Listing Gham Garri pilots : end", boolDebug )

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format("strSituation = \"%s\"", strSituation), boolDebug )

	-- Shipwrech type
	ship = "Percheron Mk1"

	-- Create the derelict.
	local angle = rnd.rnd() * 2 * math.pi
	local dist  = rnd.rnd(3000, 4000) -- place it a way out from the center
	local pos   = vec2.new( dist * math.cos(angle), dist * math.sin(angle) )
	local p     = pilot.add(ship, "dummy", pos)
	for k,v in ipairs(p) do
		v:setFaction("Derelict")
		v:disable()
		v:rename("Shipwrecked " .. tabMessages["shipName"])
		-- Added extra visibility for big systems (A.)
		v:setVisplayer( true )
		-- v:setHilight( true )
	end

	-- Set first SOS broadcast
	bctimer = hook.timer(numBroadcastFirst, "broadcast", p[1])

	-- Set hooks for the ghostship
	hook.pilot( p[1], "board",    "rescue" )
	hook.pilot( p[1], "death",    "destroyedevent" )
	hook.pilot( p[1], "jump",     "jumpevent" )
	hook.pilot( p[1], "attacked", "attackedevent" )

	-- Set hooks for if the player ignores the ghostship
	hook.jumpout("endevent")
	hook.land("endevent")

	-- Catch-all hook, doesn't save as a valid occurence
	hook.enter("endeventNoSave")

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end
--
-- ==========================================================================


-- ==========================================================================
-- Ship broadcasts an SOS every 15 seconds, until boarded or destroyed.
-- ==========================================================================
--
function broadcast(pilot)
	local strPrefix = "Adrim Shipwreck Event : function broadcast()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	if not pilot:exists() then
		return
	end

	pilot:broadcast( string.format(tabMessages["broadcast"], tabMessages["shipName"]), true )
	bctimer = hook.timer(numBroadcastRepeat, "broadcast", pilot)

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end
--
-- ==========================================================================


-- ==========================================================================
-- Happens if the player boards the ship.
-- ==========================================================================
--
function rescue(pilot)
	local strPrefix = "Adrim Shipwreck Event : function rescue()"
	local boolDebug = true

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Before all, check if any Free Adrims ship is in the system
	-- tabFreeAdrimaiPilots = pilot.get( { faction.get("Free Adrimai") } )
	local tabFreeAdrimaiPilots = pilot.get(nil, true)
	if tabFreeAdrimaiPilots==nil then
		dbg.stdOutput( strPrefix, 1, string.format( "Before rescue : no pilot found" ), boolDebug )
	else
		dbg.stdOutput( strPrefix, 1, string.format( "Before rescue : # of pilots       : %s", tostring(#tabFreeAdrimaiPilots) ), boolDebug )
		for k,v in ipairs(tabFreeAdrimaiPilots) do
			dbg.stdOutput( strPrefix, 2, string.format( "%s : %s : %s", v:name(), v:ship():name(), v:faction():name() ), boolDebug )
		end
	end

	-- Player boards the shipwreck.
	hook.rm(bctimer)

	-- DEBUG
	dbg.stdOutput( strPrefix, 1, string.format("strSituation = \"%s\"", strSituation), boolDebug )

	tk.msg ( tabMessages["boardTitle"], tabMessages[strSituation]["boardText"] )

	tk.msg ( tabMessages["repairTitle"], tabMessages[strSituation]["repairText"] )

	-- Force immediate unboard
	player.unboard()

	-- Repair ship
	pilot:setHealth( 100, 100, 0 )
	pilot:rename(tabMessages["shipName"])
	pilot:setFaction("Free Adrimai")

	-- Make ship thank you
	pilot:broadcast( tabMessages[strSituation]["thanksText"], true )

	-- Make ship fly away, probably to Son of the Eclipse or some Free Adrims base...
	pilot:control()
	pilot:hyperspace(nil, true)

	-- Add to your standing with the Free Adrimai
	faction.get( "Free Adrimai" ):modPlayer( 5 )

	-- Before all, check if any Free Adrims ship is in the system
	-- tabFreeAdrimaiPilots = pilot.get( { faction.get("Free Adrimai") } )
	local tabFreeAdrimaiPilots = pilot.get(nil, true)
	if tabFreeAdrimaiPilots==nil then
		dbg.stdOutput( strPrefix, 1, string.format( "After rescue : no pilot found" ), boolDebug )
	else
		dbg.stdOutput( strPrefix, 1, string.format( "After rescue : # of pilots       : %s", tostring(#tabFreeAdrimaiPilots) ), boolDebug )
		for k,v in ipairs(tabFreeAdrimaiPilots) do
			dbg.stdOutput( strPrefix, 2, string.format( "%s : %s : %s", v:name(), v:ship():name(), v:faction():name() ), boolDebug )
		end
	end

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	-- Properly close the event, as it is unique.
	var.push(strEventOccurences, numEventOccurences)
	-- evt.finish(true)
end
--
-- ==========================================================================


-- ==========================================================================
-- Happens if the ship is attacked by another ship.
-- ==========================================================================
--
function attackedevent(pilot)
	local strPrefix = "Adrim Shipwreck Event : function attackedevent()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	-- Only once in 5 times probability
	if rnd.rnd()<.2 then
		pilot:broadcast( tabMessages["attacked"][rnd.rnd(1, #tabMessages["attacked"])], true )
	end

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )
end
--
-- ==========================================================================


-- ==========================================================================
-- Happens if the ship is destroyed.
-- ==========================================================================
--
function destroyedevent(pilot)
	local strPrefix = "Adrim Shipwreck Event : function destroyedevent()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	pilot:broadcast( "We are fading through the Eclipse. May the living have mercy on us!", true )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	var.push(strEventOccurences, numEventOccurences)
	evt.finish(true)
end
--
-- ==========================================================================


-- ==========================================================================
-- Happens if the ship jumps out.
-- ==========================================================================
--
function jumpevent(pilot)
	local strPrefix = "Adrim Shipwreck Event : function jumpevent()"
	local boolDebug = true

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	var.push(strEventOccurences, numEventOccurences)
	evt.finish(true)
end
--
-- ==========================================================================


-- ==========================================================================
-- Generic end of event, saves event count.
-- ==========================================================================
--
function endevent ()
	local strPrefix = "Adrim Shipwreck Event : function endevent()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	var.push(strEventOccurences, numEventOccurences)
	evt.finish()
end
--
-- ==========================================================================


-- ==========================================================================
-- Generic end of event, does not save event count.
-- ==========================================================================
--
function endeventNoSave ()
	local strPrefix = "Adrim Shipwreck Event : function endeventNoSave()"
	local boolDebug = false

	-- DEBUG
	dbg.stdOutput( strPrefix, -1, "entering", boolDebug )

	dbg.stdOutput( strPrefix, 0, "exiting", boolDebug )

	evt.finish()
end
--
-- ==========================================================================
