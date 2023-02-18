--[[
<?xml version='1.0' encoding='utf8'?>
<mission name="Pirate Patrol">
 <priority>4</priority>
 <chance>560</chance>
 <location>Computer</location>
 <faction>Wild Ones</faction>
 <faction>Black Lotus</faction>
 <faction>Raven Clan</faction>
 <faction>Dreamer Clan</faction>
 <faction>Pirate</faction>
 <notes>
  <tier>3</tier>
 </notes>
</mission>
--]]
--[[

   Pirate Patrol

   Pirate version of the patrol mission.

--]]
local pir = require "common.pirate"
require "missions.neutral.patrol"

-- luacheck: globals abandon_text msg pay_text (from base mission neutral.patrol)

pay_text = {
   _("The crime boss grins and hands you your pay."),
   _("The local crime boss pays what you were promised, though not before trying (and failing) to pick your pocket."),
   _("You are hit in the face with something and glare in the direction it came from, only to see the crime boss waving at you. When you look down, you see that it is your agreed-upon payment, so you take it and manage a grin."),
   _("You are handed your pay in what seems to be a million different credit chips by the crime boss, but sure enough, it adds up to exactly the amount promised."),
}

abandon_text = {
   _("You are sent a message informing you that landing in the middle of the job is considered to be abandonment. As such, your contract is void and you will not receive payment."),
}


-- Messages
msg = {
   _("Point secure."),
   _("Outsiders detected. Eliminate all outsiders."),
   _("Outsiders eliminated."),
   _("Patrol complete. You can now collect your pay."),
   _("You showed up too late."),
   _("You have left the {sys} system."),
}

mem.osd_msg = {
   _("Fly to the {sys} system"),
   "(null)",
   _("Eliminate outsiders"),
   _("Land in {fct} territory to collect your pay"),
}

mem.use_hidden_jumps = true

local create_original = create
function create ()
   mem.paying_faction = pir.systemClanP()
   mem.misn_title  = pir.prefix(mem.paying_faction).._("Patrol of the {sys} System")
   mem.misn_desc   = _("A local crime boss has offered a job to patrol the {sys} system in an effort to keep outsiders from discovering this Pirate stronghold. You will be tasked with checking various points and eliminating any outsiders along the way.")
   if pir.factionIsClan( mem.paying_faction ) then
      -- mem.misn_desc gets fmt.f'd in the main script
      mem.misn_desc = mem.misn_desc..pir.reputationMessage( mem.paying_faction )
   end

   create_original()
end
