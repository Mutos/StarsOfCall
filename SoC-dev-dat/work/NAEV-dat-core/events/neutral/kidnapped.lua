--[[
<?xml version='1.0' encoding='utf8'?>
<event name="Kidnapped">
  <location>enter</location>
  <chance>15</chance>
  <cond>player.misnDone("Kidnapped") == false and player.misnActive("Kidnapped") == false and system.cur() == system.get("Arcturus") and player.numOutfit("Mercenary License") &gt; 0</cond>
  <notes>
   <campaign>Kidnapping</campaign>
   <tier>3</tier>
  </notes>
 </event>
--]]
--[[
--Event for kidnapped mission.
--]]

local panma, yohail -- Non-persistent state

--Create Mom and Dad in their spaceship, and have them come from the planet Brooks in Arcturus system, following the player.
function create ()
    local pnt = spob.get("Brooks")
    panma = pilot.add( "Llama", "Independent", pnt )
    panma:control()
    panma:follow(player.pilot())
    hook.pilot(panma, "jump", "finish")
    hook.pilot(panma, "death", "finish")
    hook.land("finish")
    hook.jumpout("finish")

    yohail = hook.timer( 2.0, "hailme" );
end

--Pa and Ma are hailing the player!
function hailme()
    panma:hailPlayer()
    hook.pilot(panma, "hail", "hail")
end

--Pa and Ma have been hailed. The mission can begin, and panma should land on the planet Brooks
function hail()
    panma:control(false)
    player.commClose()
    naev.missionStart("Kidnapped")
    evt.finish(true)
end

function finish()
    hook.rm(yohail)
    evt.finish()
end
