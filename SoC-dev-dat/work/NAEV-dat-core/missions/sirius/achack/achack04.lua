--[[
<?xml version='1.0' encoding='utf8'?>
<mission name="Sirian Truce">
 <unique />
 <priority>3</priority>
 <location>None</location>
 <notes>
   <done_evt name="Achack04 Helper">Triggers</done_evt>
   <campaign>Academy Hack</campaign>
 </notes>
</mission>
 --]]
--[[
-- This is the fourth mission in the Academy Hack minor campaign.
-- This mission is started from a helper event.
--]]

local fleet = require "fleet"
require "proximity"
local srs = require "common.sirius"
local fmt = require "format"
local achack = require "achack"

local bhfleet, harja -- Non-persistent state

local grumblings = {
   _("Where's that Harja? He should be showing up any time now."),
   _("I can't wait to pay that Harja back for the stunt he pulled."),
   _("I swear, the moment he comes out of hyperspace I'll make him wish he hadn't."),
   _("Come on, Harja, come and get it."),
   _("He should be here by now."),
   _("Harja won't know what hit him."),
   _("I've got a laser cannon with Harja's name on it, right here!")
}

-- Mission info stuff

mem.osd_msg   = {}
mem.osd_msg[1] = _("Look for Harja in Sirian bars")
mem.osd_msg[2] = _("Convince Harja to come with you")

-- Mission constants
local startplanet, startsys = spob.getS("Eenerim")
local reward = 1.5e6
local stages = {start=1, findHarja=2, killAssociates=3, fetchHarja=4, finish=5}

function create()
   -- Note: this mission does not make any system claims.
   tk.msg(_("You have mail"), fmt.f(_([[Your computer console flashes you a notice. It seems you received a message through the Sirian information exchange network. You play it.
    The message is from Joanne, the woman you've had dealings with in the past. Her recorded image looks at you from the screen. "Dear {player}," she begins. "You have helped me on several occasions in regard with my personal problem. I've given it some thought since then, and I've come to the conclusion that I want to get to the bottom of this. To do so, I will need your help yet again. I'm currently on assignment on {pnt} in the {sys} system. Please meet me there at the earliest opportunity."
    The message ends. You save it for later reference. Maybe you should swing by {pnt} to see what Joanne wants.]]), {player=player.name(), pnt=startplanet, sys=startsys}))

   mem.stage = stages.start

   -- This mission auto-accepts, but a choice will be offered to the player later. No OSD yet.
   misn.accept()
   misn.setReward(fmt.credits(reward))
   misn.setDesc(fmt.f(_("Joanne has contacted you. She wants to meet you on {pnt} ({sys})."), {pnt=startplanet, sys=startsys}))
   hook.land("land")
   hook.load("land")
   mem.mark = misn.markerAdd( startplanet, "low" )
end

-- Land hook.
function land()
   mem.enter_src = spob.cur()
   local harjadesc = _("You've found Harja. He's sourly watching the galactic news, and hasn't noticed you yet.")

   if spob.cur() == startplanet and mem.stage == stages.start then
      mem.joanne_npc = misn.npcAdd("talkJoanne", _("Joanne"), "sirius/unique/joanne.webp", _("Joanne the Serra military officer is here, enjoying a drink by herself."), 4)
   elseif spob.cur() == mem.harjaplanet and mem.stage <= stages.fetchHarja then
      mem.harja_npc = misn.npcAdd("talkHarja", _("Harja"), "sirius/unique/harja.webp", harjadesc, 4)
   elseif spob.cur() ~= startplanet and mem.stage == stages.findHarja then
      -- Harja appears randomly in the spaceport bar.
      -- TODO: Add checks for planet metadata. Harja must not appear on military installations and such.
      if rnd.rnd() < 0.25 then
         mem.harja_npc = misn.npcAdd("talkHarja", _("Harja"), "sirius/unique/harja.webp", harjadesc, 4)
         mem.harjaplanet, mem.harjasys = spob.cur() -- Harja, once he spawns, stays put.
      end
   elseif spob.cur() == startplanet and mem.stage == stages.finish then
      tk.msg(_("Building a bridge"), fmt.f(_([[You and Harja finish the post-landing protocol and meet up at the terminal. Harja seems a little apprehensive - he clearly doesn't like the idea of meeting Joanne face to face much. But he doesn't complain. In this, he really does appear to be a man of his word. Together, you make your way to a small conference room Joanne booked for the occasion.
    Joanne greets you, and Harja somewhat more stiffly. You notice she looks a bit tired. "My apologies," she says when she notices your glance. "I just came off my shift, and my work can be a bit taxing at times. But never mind that, we're not here to talk about my job today." She turns to Harja. "There's something I want to ask you, Harja. Last time we both had dealings with {player} here, I was told that you swore your innocence, by Sirichana's name." Harja doesn't respond. He doesn't even meet Joanne's gaze. She continues regardless. "If this is true, then I want you to repeat that oath, here and now, at me directly."
    There is silence for a few moments, but then Harja makes up his mind. He looks at Joanne and speaks. "Very well. I did not do the things I have been accused of. I did not tamper in any way with the central computer of the High Academy. By the grace of the Touched and the Word of Sirichana, I so swear."]]), {player=player.name()}))
      tk.msg(_("Building a bridge"), fmt.f(_([[There is silence again. Harja's oath sounded practiced and formal, but despite that you feel he was being very sincere when he spoke it.
    Joanne takes a few breaths. She repeats Harja's oath, almost word for word, claiming that she, too, is innocent of the deeds Harja suspects her of having committed. You get the feeling you've just been witness to something unusual, some sort of demonstration of faith that only true Sirians could hope to comprehend. It certainly has an impact on the two in front of you. Both struggle with the reality of the situation, each finding their personal convictions conflicting with a shared belief that runs much deeper.
    Joanne is the one to break the silence. "Alright," she says. "From one Sirian to another, I accept your oath. I believe that it wasn't you."
    Harja inclines his head. "From one Sirian to another. You didn't do it." After a few moments, he adds, "But someone did."
    Joanne nods. "Someone did. But who? Who could possibly have had any interest in making it happen? It makes no sense."
    After that, there's little more to say for either of them. Joanne turns to you, and tells you that this will be all for now. "This has put a great emotional strain on me, and no doubt on Harja as well. I thank you for your help, {player}. I have arranged for some funds to be transferred to your account. It's the least I can do. I will probably call for you again when I've figured out how to proceed from here. I wouldn't dream of leaving you out of this, not after all you've done."
    You take your leave, and head back to the spaceport. Though on the surface it might seem like you accomplished little, you get the feeling this was an important step toward the conclusion of the whole affair.]]), {player=player.name()}))
      player.pay(reward)
      var.pop("achack04repeat")
      srs.addAcHackLog( _([[You were hired by Joanne to deliver an invitation to Harja to talk with her. He agreed on the condition that you first deal with associates of his that were coming after him. When Joanne and Harja met, they came to an agreement that neither of them were responsible for the hack of the High Academy main computer which was the source of their feud. Joanne said that she will probably call for you again when she's figured out how to proceed.]]) )
      misn.finish(true)
   end
end

-- Talking to Joanne.
function talkJoanne()
   if var.peek("achack04repeat") then
      tk.msg(_("Joanne"), fmt.f(_([["Hello again, {player}," Joanne says. "I still require your help to solve the mystery of the academy computer hack. Let me tell you again what I need from you."]]), {player=player.name()}))
   else
      tk.msg(_("Joanne"), fmt.f(_([[Joanne greets you warmly. She is clearly glad to see you again. "Thank you for coming, {player}," she says. "As I already mentioned in my message, I've decided that I want to clear up this whole mess with Harja and the academy incident. Too much has happened for me to just forget about it, and whatever my opinion of Harja may be, I cannot ignore his oath as a follower of Sirichana. This matter has evolved from an old grudge to a mystery."]]), {player=player.name()}))
   end
   if not tk.yesno(_("Joanne"), _([[Joanne reaches into her briefcase and takes out a data storage unit, which she then puts on the table. "This data unit contains an invitation from me to Harja. I'm asking him to meet me here. I would send it to him directly, but unfortunately I have no way of reaching him other than through you. You've found him twice before, I'm sure you can do it again. Undoubtedly, he will be in Sirius space, frequenting the spaceport bars. All I ask is that you keep an eye out for him in your travels, and when you see him, give him my message." She hesitates, but then continues. "You've met him, so you know he's a bit temperamental these days. Please convince him to accept my invitation. Without violence, if you can. Could you do this for me?"]])) then
      -- rejected
      abort()
   else
      -- accepted
      mem.stage = mem.stage + 1
      tk.msg(_("Once more, with feeling"), fmt.f(_([[You pocket the data unit and tell Joanne you will see what you can do. "Thank you, {player}," she says. "I'm still pretty busy with my job, so I won't be here all the time, but just ping me on the information exchange when you've found Harja, and I'll make sure to be here when you arrive."
    When Joanne is gone, you take a moment to reflect that you're going to have to deal with Harja again. Joanne wanted no violence, but will Harja leave room for that? You'll find out when you catch him.]]), {player=player.name()}))
      mem.osd_msg[3] = fmt.f(_("Return to {pnt} ({sys})"), {pnt=startplanet, sys=startsys})
      misn.markerRm(mem.mark)
      misn.osdCreate(_("Sirian Truce"), mem.osd_msg)
      misn.setDesc(_("Joanne wants you to find Harja and convince him to meet her in person."))
      misn.npcRm(mem.joanne_npc)
   end
end

-- Talking to Harja.
function talkHarja()
   if mem.stage == stages.findHarja then
      tk.msg(_("Remember me?"), _([[You tap Harja on the shoulder. He irritably turns to you, no doubt with the intention to tell you to go away in no uncertain terms, but then he recognizes you. His face goes pale, and he starts shouting at you to leave him alone, even threatening you. He is clearly very nervous though, and he fails to make much of an impression on you. It takes a little time and an offer to get him a drink, but you manage to convince him that you're not here to cause trouble for him.
    "Well, what do you want this time then?" Harja asks when he's a little calmer. "Let's just get it over with so you can go. Nothing good ever comes from being around you." You show him the data unit you got from Joanne, and he reluctantly takes it. He reads out the contents, which doesn't take long. Joanne's invitation must be short and to the point. Harja ponders it for a moment, and then looks back to you.
    "Normally I would laugh in your face for showing me this. But you're not going to take no for an answer, are you? We went over that last time. So I guess I might as well skip that bit. Fine, I'll go and see her, it's not like this can get any worse anyway. However, there's a problem."]]))
      tk.msg(_("Remember me?"), _([["You see, those bounty hunters I hired and that you so helpfully shot holes in had some friends, friends who don't like me very much at the moment, what a surprise. I've been lying low, staying planetside as much as I can to avoid running into them. I'm not going anywhere until they get off my back."
    You sit back, motioning for Harja to keep talking. You can sort of tell where this is going, though.
    "Okay, so this is the deal," Harja continues. "I want you to go talk to these guys, and convince them to leave me alone in the future. You know. A bit of diplomacy. Tact. Excessive violence. I'm sure you'll succeed with at least one of those."
    You ignore his cynicism and ask him where to find these bounty hunters.
    "They move about a lot, which is why I'm not risking going into space myself, but if you want to be sure to catch them, head to Suna. You know, where the Wringer is. I'll send a badly-encrypted message to one of the thugs there, saying that I'm coming to find him. No doubt those bounty hunters will intercept it and lie in wait just outside the jump point. They'll be expecting me, but they'll be getting you. Jump in, do what you have to do, get back here. Then we can talk about going to see that... to see Joanne," he finishes. He seems to have his temper under control a little better now, at least.
    You leave Harja's table, since it's clear that he's not going to cooperate until you take care of his problem. Why can't it ever just be quick and easy?]]))
      hook.jumpin("jumpin")

      mem.destsys = system.get("Suna")
      mem.marker = misn.markerAdd(mem.destsys, "high")

      mem.osd_msg[2] = fmt.f(_("Go to {sys} and deal with Harja's associates"), {sys=mem.destsys})
      misn.osdCreate(_("Sirian Truce"), mem.osd_msg)
      misn.osdActive(2)

      mem.stage = mem.stage + 1
   elseif mem.stage == stages.fetchHarja then
      mem.harjaplanet = nil
      tk.msg(_("Harja joins you"), fmt.f(_([[Harja raises an eyebrow when he's confronted with you again. "Well well, back are we? Does that mean you've taken care of my little problem?"
    You recount the fight you had with the bounty hunters. Harja seems quite pleased with the outcome. "Okay {player}, I'll admit it, you're one hell of a pilot," he smiles. "I still think you picked the wrong side, but that doesn't matter right now. I said I would come with you, and I intend to honor that promise. I'll go and prep my ship for takeoff right away. When you're ready to leave, I'll launch as well."
    Harja leaves in the direction of the spaceport hangars. It seems you're finally making some progress. You take a minute to key in a message to Joanne, letting her know you're on your way with Harja in tow. Now you just have to hope it doesn't all fall to pieces again when you get back to {pnt}.]]), {player=player.name(), pnt=startplanet}))

      misn.osdActive(3)
      misn.npcRm(mem.harja_npc)
      misn.markerMove(mem.marker, startplanet)

      hook.enter("enter")
      hook.jumpout("jumpout")
      mem.stage = mem.stage + 1
   else
      tk.msg(_("Harja stays put"), _([["I'm not going anywhere until I'm sure those bounty hunters aren't after me any more."]]))
   end
end

-- Jumpin hook.
function jumpin()
   if system.cur() == mem.destsys and mem.stage == stages.killAssociates then
      local bhships = {"Pirate Vendetta", "Pacifier", "Lancelot", "Hyena"}
      bhfleet = fleet.add(1, bhships, achack.fct_thugs(), vec2.new(-3000, -7000), _("Bounty Hunter"))
      mem.alive = #bhfleet
      for i, j in ipairs(bhfleet) do
         j:control()
         j:setHilight(true)
         mem.hailhook = hook.pilot(j, "hail", "hail")
         mem.attackhook = hook.pilot(j, "attacked", "attacked")
      end
      mem.grumblehook = hook.timer(5.0, "grumble")
   end
end

-- Jump-out hook.
function jumpout()
   mem.enter_src = system.cur()
end

-- Enter hook.
function enter()
   if mem.stage == stages.finish then
      -- Remember, Harja will be with you. Always. Well, until the mission ends.
      harja = pilot.add("Shark", achack.fct_sirius(), mem.enter_src, _("Harja's Shark"), {ai="trader"})
      harja:control()
      harja:setInvincible(true)
      harja:follow(player.pilot())
   end
end

-- Makes the mercenaries grumble occasionally, until the player opens fire.
function grumble()
   -- Randomville!!
   bhfleet[rnd.rnd(1, #bhfleet)]:broadcast(grumblings[rnd.rnd(1, #grumblings)])
   mem.grumblehook = hook.timer(rnd.uniform(3.0, 8.0), "grumble")
end

-- Attacked hook for mercenaries.
function attacked()
   hook.rm(mem.grumblehook)
   for _, j in ipairs(bhfleet) do
      j:setHostile()
      j:hookClear()
      mem.deathhook = hook.pilot(j, "death", "death")
      j:control(false)
   end
   bhfleet[1]:broadcast(_("We've been set up! Harja isn't coming! Get that guy!"))
end

-- Death hook for mercenaries.
function death()
   mem.alive = mem.alive - 1
   if mem.alive == 0 then
      mem.stage = mem.stage + 1

      misn.markerMove(mem.marker, mem.harjasys)

      mem.osd_msg[2] = _("Convince Harja to come with you")
      misn.osdCreate(_("Sirian Truce"), mem.osd_msg)
      misn.osdActive(2)
   end
end

-- Hail hook for mercenaries. Just makes it so you can't hail them.
function hail()
   player.commClose()
end

function abort()
   var.push("achack04repeat", true)
   misn.finish(false)
end
