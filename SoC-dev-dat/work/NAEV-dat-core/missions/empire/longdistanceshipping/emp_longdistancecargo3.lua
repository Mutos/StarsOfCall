--[[
<?xml version='1.0' encoding='utf8'?>
<mission name="Za'lek Long Distance Recruitment">
 <unique />
 <priority>4</priority>
 <cond>faction.playerStanding("Empire") &gt;= 0</cond>
 <chance>75</chance>
 <done>Dvaered Long Distance Recruitment</done>
 <location>Bar</location>
 <faction>Empire</faction>
 <notes>
  <campaign>Empire Shipping</campaign>
 </notes>
</mission>
--]]
--[[

   Third diplomatic mission to Za'lek space that opens up the Empire long-distance cargo missions.

   Author: micahmumper

]]--
local fmt = require "format"
local emp = require "common.empire"

-- Mission constants
local targetworld, targetworld_sys = spob.getS("Gerhart Station")


function create ()
 -- Note: this mission does not make any system claims.

   misn.setNPC( _("Lieutenant"), "empire/unique/czesc.webp", _("Lieutenant Czesc, from the Empire Armada Shipping Division, is sitting at the bar.") )
end


function accept ()
   misn.markerAdd( targetworld, "low" )
   ---Intro Text
   if not tk.yesno( _("Spaceport Bar"), _([[Lieutenant Czesc sits at the bar. He really does seem to handle business all across the Empire. You take the seat next to him. "Thanks to your help, the Empire Armada Shipping Division will soon operate across the galaxy. Our next mission is to get House Za'lek on board. Interested in helping out again?"]]) ) then
      return
   end
   -- Flavour text and mini-briefing
   tk.msg( _("Za'lek Long Distance Recruitment"), fmt.f( _([["I had a feeling you would!" says Lieutenant Czesc. "I've got another bureaucrat ready to establish trade ties. The Za'lek are rather mysterious, so keep your wits about you. The diplomat only needs to go to the {pnt} in the {sys} system. He will let me know when trade relations have been established. There is still more work to be done, so I expect to see you again soon."]]), {pnt=targetworld, sys=targetworld_sys} ) )
   ---Accept the mission
   misn.accept()

   -- Description is visible in OSD and the onboard computer, it shouldn't be too long either.
   misn.setTitle(_("Za'lek Long Distance Recruitment"))
   misn.setReward( fmt.credits( emp.rewards.ldc3 ) )
   local misn_desc = fmt.f(_("Deliver a shipping diplomat for the Empire to {pnt} in the {sys} system"), {pnt=targetworld, sys=targetworld_sys})
   misn.setDesc( misn_desc )
   misn.osdCreate(_("Za'lek Long Distance Recruitment"), {misn_desc})
   -- Set up the goal
   hook.land("land")
   local c = commodity.new( N_("Diplomat"), N_("An Imperial trade representative.") )
   mem.person = misn.cargoAdd( c, 0 )
end


function land()

   if spob.cur() == targetworld then
         misn.cargoRm( mem.person )
         player.pay( emp.rewards.ldc3 )
         -- More flavour text
         tk.msg( _("Mission Accomplished"), fmt.f( _([[You drop the diplomat off on {pnt}, and she hands you a credit chip. Lieutenant Czesc mentioned more work, so you figure you'll run into him at a bar again soon.]]), {pnt=targetworld} ) )
         faction.modPlayerSingle( "Empire",3 )
         emp.addShippingLog( fmt.f( _([[You delivered a shipping bureaucrat to {pnt} for the Empire. Lieutenant Czesc mentioned more work, so you figure you'll run into him at a bar again soon.]]), {pnt=targetworld} ) )
         misn.finish(true)
   end
end

function abort()
   misn.finish(false)
end
