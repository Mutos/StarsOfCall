--[[
-- Shipwreck Event
-- 
-- Creates a wrecked ship that asks for help. If the player boards it, the event switches to a people transport mission
--   For now, the only one such mission is the Space Family.
-- See dat/missions/shipwreck/spacefamily.lua
-- 
-- 12/02/2010 - Added visibility/highlight options for use in bigsystems (Anatolis)
--]]

include "select/selectShipType.lua"
include "select/selectShipName.lua"

lang = naev.lang()
if lang == "es" then
	 -- not translated atm
else -- default english 

-- Text
	 broadcastmsg = "SOS. This is %s. We are shipwrecked. Requesting immediate assistance."
end

-- The shipwrech will be a random trader vessel.
strShipName = selectShipName({"+civilian"})
strShipType = selectShipType({"+cargo"})

function create ()
	 -- Create the derelict.
	 angle = rnd.rnd() * 2 * math.pi
	 dist  = rnd.rnd(2000, 3000) -- place it a ways out
	 pos   = vec2.new( dist * math.cos(angle), dist * math.sin(angle) )
	 p     = pilot.add(strShipType, "dummy", pos)
	 for k,v in ipairs(p) do
		  v:setFaction("Derelict")
		  v:disable()
		  v:rename("Shipwrecked " .. strShipName)
		  -- Added extra visibility for big systems (A.)
		  v:setVisplayer( true )
		  -- v:setHilight( true )
	 end

	 hook.timer(3000, "broadcast")
	
	 -- Set hooks
	 hook.pilot( p[1], "board", "rescue" )
	 hook.pilot( p[1], "death", "destroyevent" )
	 hook.enter("endevent")
	 hook.land("norescue")
	 hook.jumpout("norescue")
end

function broadcast()
	 -- Ship broadcasts an SOS every 15 seconds, until boarded or destroyed.
	 if not p[1]:exists() then
		 return
	 end
	 p[1]:broadcast( string.format(broadcastmsg, strShipName), true )
	 bctimer = hook.timer(15000, "broadcast")
end

function rescue()
	 -- Player boards the shipwreck and rescues the crew, this spawns a new mission.
	-- There should be a random choice of missions, some one-shot, others repeatable
	 hook.rm(bctimer)
	 naev.missionStart("The Space Family")
	 evt.finish(true)
end

function norescue()
	 -- Player jumps out or land without bothering to rescue the stranded crew.
	 hook.rm(bctimer)
	local objCurrentSystem = system.cur()
	local objCurrentFaction = objCurrentSystem:faction()
	local strMessage = ""
	if objCurrentFaction == nil then
		strMessage = "You did not rescue a spacer broadcasting a distress call, but no-one saw you as there is no dominant faction in current system"
	else
		strMessage = string.format("You did not rescue a spacer broadcasting a distress call : losing reputation with dominant faction : %s", objCurrentFaction:name())
		objCurrentFaction:modPlayerRaw( -5 )
	end
	player.msg (strMessage)
	 evt.finish()
end

function destroyevent ()
	 evt.finish(true)
 end

function endevent ()
	 evt.finish()
end
