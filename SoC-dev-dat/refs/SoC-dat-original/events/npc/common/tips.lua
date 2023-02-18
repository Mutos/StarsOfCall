--[[
-- Include file for npc.lua
-- Defines the messages related to gameplay tips
--]]

if lang == 'es' then --not translated atm
else --default english
	-- Gameplay tip messages.
	-- ALL NPCs have a chance to say one of these lines instead of a lore message.
	-- So, make sure the tips are always faction neutral.
	msg_tip =                  {"I heard you can set your weapons to only fire when your target is in range, or just let them fire when you pull the trigger. Sounds handy!",
										 "Did you know that if a planet doesn't like you, you can often bribe the spaceport operators and land anyway? Just hail the planet with " .. tutGetKey("hail") .. ", and click the bribe button! Careful though, it doesn't always work.",
										 "Many factions offer rehabilitation programs to criminals through the mission computer, giving them a chance to get back into their good graces. It can get really expensive for serious offenders though!",
										 "These new-fangled missile systems! You can't even fire them unless you get a target lock first! But the same thing goes for your opponents. You can actually make it harder for them to lock on to your ship by equipping scramblers or jammers. Scout class ships are also harder to target.",
										 "Your equipment travels with you from planet to planet, but your ships don't! Nobody knows why, it's just life, I guess.",
										 "You know how you can't change your ship or your equipment on some planets? Well, it seems you need an outfitter to change equipment, and a shipyard to change ships! Bet you didn't know that.",
										 "Are you buying missiles? You can hold down \027bctrl\0270 to buy 5 of them at a time, and \027bshift\0270 to buy 10. And if you press them both at once, you can buy 50 at a time! It actually works for everything, but why would you want to buy 50 laser cannons?",
										 "If you're on a mission you just can't beat, you can open the information panel and abort the mission. There's no penalty for doing it, so don't hesitate to try the mission again later.",
										 "Don't forget that you can revisit the tutorial modules at any time from the main menu. I know I do.",
										 "Some weapons have a different effect on shields than they do on armour. Keep that in mind when equipping your ship.",
										 "Afterburners can speed you up a lot, but when they get hot they don't work as well anymore. Don't use them carelessly!",
										 "There are passive outfits and active outfits. The passive ones modify your ship continuously, but the active ones only work if you turn them on. You usually can't keep an active outfit on all the time, so you need to be careful only to use it when you need it.",
										 "If you're new to the galaxy, I recommend you buy a map or two. It can make exploration a bit easier.",
										 "Missile jammers slow down missiles close to your ship. If your enemies are using missiles, it can be very helpful to have one on board.",
										 "If you're having trouble with overheating weapons or outfits, you can use Active Cooldown. First press " .. tutGetKey("autobrake") .. " to stop your ship, then press it a second time to put it into Active Cooldown. Careful though, your energy and shields won't recharge while you do it!",
										}
end
