--[[
<?xml version='1.0' encoding='utf8'?>
<mission name="Dvaered Long Distance Recruitment">
 <unique />
 <priority>4</priority>
 <cond>faction.playerStanding("Empire") &gt;= 0</cond>
 <chance>75</chance>
 <done>Soromid Long Distance Recruitment</done>
 <location>Bar</location>
 <faction>Empire</faction>
 <notes>
  <campaign>Empire Shipping</campaign>
 </notes>
</mission>
--]]
--[[

   Second diplomatic mission to Dvaered space that opens up the Empire long-distance cargo missions.

   Author: micahmumper

]]--
local fmt = require "format"
local emp = require "common.empire"

-- Mission constants
local targetworld, targetworld_sys = spob.getS("Praxis")


function create ()
 -- Note: this mission does not make any system claims.

   misn.setNPC( _("Lieutenant"), "empire/unique/czesc.webp", _("Lieutenant Czesc, from the Empire Armada Shipping Division, is sitting at the bar.") )
end


function accept ()
   misn.markerAdd( targetworld, "low" )
   ---Intro Text
   if not tk.yesno( _("Spaceport Bar"), _([[Lieutenant Czesc waves you over when he notices you enter the bar. "I knew we would run into each other soon enough. Great job delivering that bureaucrat. We should be up and running in Soromid space in no time!" He presses a button on his wrist computer. "We're hoping to expand to Dvaered territory next. Can I count on your help?"]]) ) then
      return
   end
   -- Flavour text and mini-briefing
   tk.msg( _("Dvaered Long Distance Recruitment"), fmt.f( _([["Great!" says Lieutenant Czesc. "I'll send a message to the bureaucrat to meet you at the hanger. The Dvaered are, of course, allies of the Empire. Still, they offend easily, so try not to talk too much. Your mission is to drop the bureaucrat off on {pnt} in the {sys} system. He will take it from there and report back to me when the shipping contract has been established. Afterwards, keep an eye out for me in Empire space and we can continue the operation."]]), {pnt=targetworld, sys=targetworld_sys} ) )
   ---Accept the mission
   misn.accept()

   -- Description is visible in OSD and the onboard computer, it shouldn't be too long either.
   misn.setTitle(_("Dvaered Long Distance Recruitment"))
   misn.setReward( fmt.credits( emp.rewards.ldc2 ) )
   local misn_desc = fmt.f(_("Deliver a shipping diplomat for the Empire to {pnt} in the {sys} system"), {pnt=targetworld, sys=targetworld_sys})
   misn.setDesc( misn_desc )
   misn.osdCreate(_("Dvaered Long Distance Recruitment"), {misn_desc})
   -- Set up the goal
   hook.land("land")
   local c = commodity.new( N_("Diplomat"), N_("An Imperial trade representative.") )
   mem.person = misn.cargoAdd( c, 0 )
end


function land()

   if spob.cur() == targetworld then
         misn.cargoRm( mem.person )
         player.pay( emp.rewards.ldc2 )
         -- More flavour text
         tk.msg( _("Mission Accomplished"), fmt.f( _([[You drop the bureaucrat off on {pnt}, and he hands you a credit chip. You remember Lieutenant Czesc told you to look for him on Empire controlled planets after you finish.]]), {pnt=targetworld} ) )
         faction.modPlayerSingle( "Empire",3 )
         emp.addShippingLog( fmt.f( _([[You delivered a shipping bureaucrat to {pnt} for the Empire. Lieutenant Czesc told you to look for him on Empire controlled planets after you finish.]]), {pnt=targetworld} ) )
         misn.finish(true)
   end
end

function abort()
   misn.finish(false)
end
