include("dat/ai/personality/raider.lua")

--[[

	Gham Garri raider AI : raider with parameters

--]]

-- Script-specific settings
numKillProba        = 0.3
numBribeProba       = 0.5
numTauntProba       = 1.0
strNoBribe          = "\"You won't be able to slide out of this one!\""
numMoneyRatio       = {30,80}
numBribeParams      = {300,850}
numRefuelPay        = {2500, 5000}
numRefuelStanding   = 60
numRefuelMult       = 0.5
strRefuelMsg        = "\"For you, only %d credits for a hundred units of fuel.\""

-- Message tables
tabBribePrompt = {
	"\"It'll cost you %d credits for me to ignore your pile of rubbish.\"",
	"\"I'm in a good mood so I'll let you go for %d credits.\"",
	"\"Send me %d credits or you're dead.\"",
	"\"Pay up %d credits or it's the end of the line.\"",
	"\"Your money or your life. %d credits and make the choice quickly.\"",
	"\"Money talks bub. %d up front or get off my channel.\"",
	"\"Shut up and give me your money! %d credits now.\"",
	"\"You're either really stupid to be chatting or really rich. %d or shut up.\"",
	"\"If you're willing to negotiate I'll gladly take %d credits to not kill you.\"",
	"\"You give me %d credits and I'll act like I never saw you.\"",
	"\"So this is the part where you pay up or get shot up. Your choice. What'll be, %d or...\"",
	"\"Pay up or don't. %d credits now just means I'll wait till later to collect the rest.\"",
	"\"This is a toll road, pay up %d credits or die.\"",
}
tabBribePaid = {
	"\"You're lucky I'm so kind.\"",
	"\"Life doesn't get easier than this.\"",
	"\"Pleasure doing business.\"",
	"\"See you again, real soon.\"",
	"\"I'll be around if you get generous again.\"",
	"\"Lucky day, lucky day!\"",
	"\"And I didn't even have to kill anyone!\"",
	"\"See, this is how we become friends.\"",
	"\"Now if I kill you it'll be just for fun!\"",
	"\"You just made a good financial decision today.\"",
	"\"Know what? I won't kill you.\"",
	"\"Something feels strange. It's almost as if my urge to kill you has completely dissipated.\"",
	"\"Can I keep shooting you anyhow? No? You sure? Fine.\"",
	"\"And it only cost you an arm and a leg.\"",
}
tabOffenseTaunts = {
	"Prepare to be boarded!",
	"Ssshhh!",
	"What's a ship like you doing in a place like this?",
	"Prepare to have your booty plundered!",
	"Give me your credits or die!",
	"Your ship's mine!",
	"You may want to send that distress signal now.",
	"It's time to die.",
	"Nothing personal, just business.",
	"How else am I going to earn may mastery?",
	"Seems you're being shot at.",
	"I'm trying to kill you. Is it working?",
	"We Gham Garri just take back what is ours!",
	"Sorry, you just happen to own Rith property!",
}
tabNoOffenseTaunts = {
	"You dare attack me?!",
	"You think that you can take me on?",
	"You'll regret this!",
	"Game over, you're dead!",
	"Shooting back isn't allowed!",
	"Now you're in for it!",
	"Did you really think you would get away with that?",
	"I just painted this thing!",
	"Just. Stop. Moving.",
	"Tell you what, if you can keep dodging for 20 minutes I'll let you live.",
	"You owe me a new mark on my hull!",
	"Nice mark on my hull, will show it for Mastery!",
	"Hail to True Rithai!",
	"Thhhhink you can beat a True Rith?",
}
