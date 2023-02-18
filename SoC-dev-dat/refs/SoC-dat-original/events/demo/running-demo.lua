-- This is a running demo.

include("dat/scripts/proximity.lua")
include("dat/events/tutorial/tutorial-common.lua")

-- Global variables declaration
omsg					=      0

-- Global script settings
initialDistance			=  10000
onscreenMessagesDelay	=   4000

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	titleDemo = "Running Demo"
	onscreenMessage = {
		[[
			Enter "Stars of Call", a game in the Hoshikaze 2250 universe.
			As a Free Trader, fly your ship through systems and planets.
		]],[[
			Make profit by trading numerous goods from planet to planet,
			or taking missions from many factions at hand.
			Buy and customize your ship using many available outfits.
		]],[[
			Freely choose your side between
			multiple States from six sentient species,
			numerous independant groups or even lawless pirates.
		]],[[
			Fend for yourself and your fellow Spacers
			and earn their respect by enforcing the Spacers' Code !
		]]
	}
	nextMessageIndex = 1
end

function create()
	-- Set up the player here.
	player.teleport("Sol")
	player.msgClear()

	-- Get player pilot
	pp = player:pilot()
	pp:setPos(planet.get("Mars"):pos() + vec2.new(0, initialDistance))

	-- pilot.clear()
	-- pilot.toggleSpawn(false) -- To prevent NPCs from getting targeted for now.

	-- Disable all keys, except a few basic ones
	naev.keyDisableAll ()
	enableBasicKeys()

	-- Add first message on the screen
	omsg = player.omsgAdd(onscreenMessage[nextMessageIndex], 0)
	nextMessageIndex = nextMessageIndex+1

	-- Take control of the player's pilot
	player:pilot():control(true)

	-- Set a hook to change onscreen message
	hook.timer(onscreenMessagesDelay, "ChangeOnscreenMessage")

	-- Make the ship go to Mars
	gotoMars()
end

function gotoMars()
	-- Make the ship go to Mars
	targetpos = planet.get("Mars"):pos()
	player:pilot():goto(targetpos)
	proximity({location = targetpos, radius = 150, funcname = "gotoEarth"})
end

function gotoEarth()
	-- Make the ship go to Earth
	targetpos = planet.get("Earth"):pos()
	player:pilot():goto(targetpos)
	proximity({location = targetpos, radius = 150, funcname = "proxytrigger"})
end


function ChangeOnscreenMessage()
	if nextMessageIndex <= #onscreenMessage then
		player.omsgChange(omsg, onscreenMessage[nextMessageIndex], 0)
		nextMessageIndex = nextMessageIndex+1
		hook.timer(onscreenMessagesDelay, "ChangeOnscreenMessage")
	else
		player.omsgRm(omsg)
	end
end

-- Function that runs when the player approaches the indicated coordinates.
function proxytrigger()
	system.mrkClear()
	tk.msg(titleDemo, "Mars reached")
	cleanup()
end

-- Cleanup function. Should be the exit point for the module in all cases.
function cleanup()
	if not (omsg == nil) then player.omsgRm(omsg) end
	naev.keyEnableAll()
	naev.eventStart("Tutorial")
	evt.finish(true)
end
