-- This is the tutorial: interstallar flight.

include("dat/events/tutorial/tutorial-common.lua")

-- Prepare messaging system
popupTitles = {}
popupMessages = {}
onscreenMessages = {}

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	 popupTitles ["Main Title"] = "Tutorial: Interstellar Flight"
	 popupMessages ["Welcome"] = [[Welcome to the interstellar flight tutorial.

In this tutorial you will learn how to travel from one star system to another, and how to use the galaxy map.]]

	 popupMessages ["Introduction"] = [[In this tutorial we will travel the stars from the Irmothem system, home of the rith clan of the same name.

Each star system is connected to one or more other star systems by means of "jump points". These jump points are the ONLY places where you may enter hyperspace, and once you do you will appear near the jump point leading the other way in the destination system. Jump points are shown on your overlay map as triangles with the names of the destination systems next to them.

Let's select a jump point now. You can press %s to do this.]]

	 popupMessages ["Jump Selected"] = [[Good. If you look at the bar at the bottom of the screen, you'll see that it has changed to show that you have selected a hyperspace target (next to "Nav"). Currently, the target is unknown, because you don't know anything about it yet. To actually use the jump point you've just selected you need to fly close to it and engage your hyperdrive. This is done with %s, but we're not going to do that right now, as there's an easier way.

For now, press %s to deselect your target. If you also have planets or ships targeted, you can use %s multiple times to select your most recent targets, in order.]]

	 popupMessages ["Galaxy Map"] = [[Another method of selecting a hyperspace target is by opening the galaxy map and clicking on the system you want to go to. The galaxy map is accessed by pressing %s, do so now.]]
	
	 popupMessages ["Now jump !"] = [[This is the galaxy map. It shows you a lot of information about the systems you've visited, and lets you plot jump routes to other star systems. Clicking a system will4select it as your hyperspace target.

You'll see a button in the lower right that says "Autonav". Clicking this button will automatically make your ship fly to your selected destination. You can also engage the autonav at any time during flight by pressing %s. The autonav will continue to jump until it either reaches its destination, until you run out of fuel or until you come under enemy attack, whichever comes first.

Note that the autonav can also be used to fly to a planet or station. Simply target one and engage the autonav - this has the same effect as right-clicking on it on the map overlay.

Select a hyperspace target and jump to another system.]]

	 popupMessages ["First jump done"] = [[Well done! You've successfully performed a hyperspace jump to another system. From here you can jump to yet other systems to continue your exploration.

But watch out! That jump just now has drained your fuel reserves, as the bottom bar will tell you. If you run out of fuel you can't jump anymore. You can get more fuel by refueling at a planet, by buying fuel off other ships, or by boarding disabled ships and stealing it fom them. Keep an eye on your fuel when traveling!

For the remainder of this tutorial, you will have unlimited fuel. Continue to make hyperjumps until you reach either Irmothem, Irmothem-2 or Irmothem-4.]]

	 popupMessages ["Conclusion"] = [[Excellent. You have learned how to make hyperspace jumps and explore the galaxy. You may continue jumping around if you wish. Once you're ready to move on, land on either Irmothem, Irmothem-2 or Irmothem-4. As a final tip, you can hold down %s while clicking on the galaxy map to specify a manual path for the autonav.

Congratulations! This concludes the interstellar flight tutorial.]]

	 thyperomsg = "Press %s to target a jump point"
	 clearomsg = "Press %s to deselect your target"
	 starmapomsg = "Press %s to open the galaxy map"
	 hyperomsg = "Select a hyperspace target with %s or by using the galaxy map, then press %s to engage the autonav (or jump manually with %s)"
	 hyperomsg2 = "Continue exploring until you return to Irmothem or reach either the Irmothem-2 or the Irmothem-4 system"
	 hyperomsg3 = "Land (with %s) on either Irmothem, Irmothem-2 or Irmothem-4 to complete the tutorial"
end

function create()
	 -- Set up the player here.
	 player.teleport("Irmothem")
	 player.msgClear()

	 player.pilot():setPos(planet.get("Irmothem"):pos() + vec2.new(0, 250))
	
	-- Set known only the jump point to Irm 0004
	j,r = jump.get( "Irmothem", "Irm 0004" )
	j:setKnown( true )
	r:setKnown( true )

	 tk.msg(popupTitles ["Main Title"], popupMessages ["Welcome"])
	 tkMsg(popupTitles ["Main Title"], popupMessages ["Introduction"]:format(tutGetKey"thyperspace"))
	 omsg = player.omsgAdd(thyperomsg:format(tutGetKey"thyperspace"), 0)

	 keystage = "thyperspace"
	 hinput = hook.input("input")
	 hook.jumpin("jumpin")
end

-- Input hook.
function input(inputname, inputpress)
	nav, hyp = player.pilot():nav()
	if inputname == "thyperspace" and keystage == "thyperspace" then
		keystage = "deselect"
		tkMsg(popupTitles ["Main Title"], popupMessages ["Jump Selected"]:format(tutGetKey("jump"), tutGetKey("target_clear"), tutGetKey("target_clear")))
		player.omsgChange(omsg, clearomsg:format(tutGetKey("target_clear")), 0)
	elseif hyp == nil and keystage == "deselect" then
		keystage = "map"
		player.omsgRm(omsg)
		tkMsg(popupTitles ["Main Title"], popupMessages ["Galaxy Map"]:format(tutGetKey("starmap")))
		omsg = player.omsgAdd(starmapomsg:format(tutGetKey("starmap")), 0)
	elseif inputname == "starmap" and keystage == "map" then
		keystage = nil
		hook.rm(hinput)
		tk.msg(popupTitles ["Main Title"], popupMessages ["Now jump !"]:format(tutGetKey("autonav")))
		player.omsgChange(omsg, hyperomsg:format(tutGetKey("thyperspace"), tutGetKey("autonav"), tutGetKey("jump")), 0)
		firstjump = true
	end
end

-- Jumpin hook.
function jumpin()
	 if not firstjump then
		player.refuel()
	end
	 if system.cur() == system.get("Irmothem") or system.cur() == system.get("Irmothem-2") or system.cur() == system.get("Irmothem-4") then
		  hook.land( "land_clean" )
		  hook.timer(2000, "jumpmsg", popupMessages ["Conclusion"]:format("\027bshift\0270"))
		  player.omsgChange(omsg, hyperomsg3:format(tutGetKey("land") ), 0)
	 elseif firstjump then
		j,r = jump.get( "Irm 0004", "Irm 0008" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0004", "Irm 0008" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0004", "Irm 0003" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0003", "Irmothem-4" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0003", "Irm 0006" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0003", "Irm 0007" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0006", "Irm 0007" )
		j:setKnown( true )
		r:setKnown( true )
		j,r = jump.get( "Irm 0008", "Irmothem-2" )
		j:setKnown( true )
		r:setKnown( true )
		  hook.timer(2000, "jumpmsg", popupMessages ["First jump done"])
		  firstjump = false
		  player.omsgChange(omsg, hyperomsg2, 0)
	 end
end

-- Delay this tk.msg by a bit to make the jump less jarring.
function jumpmsg(message)
	 tk.msg(popupTitles ["Main Title"], message)
end

-- Safe land function, takes off and cleans
function land_clean ()
	player.takeoff()
	hook.safe("cleanup")
end

-- Cleanup function. Should be the exit point for the module in all cases.
function cleanup()
	 if not (omsg == nil) then player.omsgRm(omsg) end
	 naev.keyEnableAll()
	 naev.eventStart("Tutorial")
	 evt.finish(true)
end
