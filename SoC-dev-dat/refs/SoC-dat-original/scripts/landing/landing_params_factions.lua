--===========================================================================================================================================
--  Parameters for the generic functions
--===========================================================================================================================================


--[[=========================================================================================================================================
	Generic parameters for factions
		-- Parameter to compute RETURN #1 : boolean whether or not player can land
		land_floor      : player with equal or higher reputation can land
		-- Parameter to compute whether or not player can bribe
		bribe_floor     : player with equal or higher reputation can bribe, make it equal to land_floor if no bribe possible at all
		-- Land message, to be issued as RETURN #2
		land_msg        : if OK to land with positive or zero standing
		land_warn_msg   : if Ok to land with negative standing
		land_bribe_msg  : if not allowed to land, but allowed to bribe
		land_no_msg     : if neither allowed to land nor bribe
		-- Compute bribe or issue message that can't bribe for RETURN #3
		bribe_base      : minimal bribe amount
		bribe_rate      : extra amount of bribe, to be multiplied by standing difference and ship modifier
		nobribe_msg     : message when trying to bribe but neither allowed to land nor bribe
		-- Format of messages for RETURN #4, to issue if bribe possible, uses one %s for bribe price
		bribeprice_fmsg : if not allowed to land, but allowed to bribe
		-- Bribe acceptance message for RETURN #5 if bribe possible
		bribe_ack_msg   : landing message issued when bribe accepted
=============================================================================================================================================
--]]

land_factions = {}
land_factions["default"] = {
	land_floor      = -10,
	bribe_floor     = -30,
	land_msg        = "Permission to land granted.",
	land_warn_msg   = "Landing permission granted, but given your reputation, you'd better behave.",
	land_bribe_msg  = "I'm sorry, I can't allow you to land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  3000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with dangerous criminals like you!",
	bribeprice_fmsg = "I'll let you land for the modest price of %s credits.",
	bribe_ack_msg   = "Make it quick."
}
land_factions["Core League"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "You are welcome on Core territory.",
	land_warn_msg   = "You can land, but you'd better behave.",
	land_bribe_msg  = "Sorry, I'm not allowed to let you land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  5000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with dangerous criminals like you!",
	bribeprice_fmsg = "I'll let you land for %s credits.",
	bribe_ack_msg   = "Hurry while the patrol is not watching."
}
land_factions["Pirate"] = {
	land_floor      =   0,
	bribe_floor     = -30,
	land_msg        = "Clear to land, Brethren!",
	land_warn_msg   = "It's OK for this time, but you stay clean...",
	land_bribe_msg  = "I'm sorry, with your reputation, you can't land here.",
	land_no_msg     = "No way you could land here!",
	bribe_base      =  5000,
	bribe_rate      =  2000,
	nobribe_msg     = "We know you, damn fink!",
	bribeprice_fmsg = "%s credits will give you access to the place.",
	bribe_ack_msg   = "Make it quick, anyway I don't know you..."
}
land_factions["Joint Peacekeepers Corps"] = {
	land_floor      =   0,
	bribe_floor     = -10,
	land_msg        = "Permission to land granted.",
	land_warn_msg   = "Permission to land granted, but we'll keep an eye on you.",
	land_bribe_msg  = "Sorry, I can't allow you to land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  4000,
	bribe_rate      =  3000,
	nobribe_msg     = "Get away before our patrol locks on you!",
	bribeprice_fmsg = "I'll let you land for the modest price of %s credits.",
	bribe_ack_msg   = "Make it quick."
}
land_factions["K'Rinn Council"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "Welcome to Council land, traveller!",
	land_warn_msg   = "You are welcome to Council land, but we advise you not to disturb this peaceful resort.",
	land_bribe_msg  = "We are sorry to deny you entrance, but your clearance level is not yet up to this place's par.",
	land_no_msg     = "We are sorry, but we just cannot afford visitors with your disreputation.",
	bribe_base      =  7000,
	bribe_rate      =  1000,
	nobribe_msg     = "Keep behaving like this and you'll meet our Defenders!",
	bribeprice_fmsg = "Maybe a small contribution for this place's maintenance would do. Try with %s credits.",
	bribe_ack_msg   = "By exceptional permission, you are allowed to land, but do the slightest misbehavior and you'll be expulsed."
}
land_factions["Ka'Ralt Secession"] = {
	land_floor      =  -5,
	bribe_floor     = -10,
	land_msg        = "Welcome to the Secession, traveller!",
	land_warn_msg   = "You are welcome to the Secession, but be aware, we defend our lands against any troublemaker.",
	land_bribe_msg  = "Sorry to deny you entrance, but you need a higher clearance level.",
	land_no_msg     = "Sorry, you're not authorized to land here.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "Keep behaving like this and you'll meet our Defenders!",
	bribeprice_fmsg = "A small contribution of %s credits for this place's maintenance would be appreciated.",
	bribe_ack_msg   = "By exceptional permission, you are allowed to land, but remember, to misbehave is to be expulsed."
}
land_factions["Rithai Kemae"] = {
	land_floor      =   0,
	bribe_floor     = -10,
	land_msg        = "Welcome to the Common Ground of the Idrimarai, may the moons shine on your ancestors' glory.",
	land_warn_msg   = "Welcome to the Common Ground of the Idrimarai, we trust you to keep your honor clean.",
	land_bribe_msg  = "Your honor doesn't stand high enough to get you in the presence of the Idrimarai.",
	land_no_msg     = "We don't allow beings with no honor on our land.",
	bribe_base      = 10000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "Swear you will behave honorably during your stay, and I can let you in for %s credits.",
	bribe_ack_msg   = "It's a pleasure to give you the occasion to show your honor to the Idrimarai."
}
land_factions["Irilia Clan"] = {
	land_floor      = -15,
	bribe_floor     = -20,
	land_msg        = "You are welcome to Irilia territory, may the moons shine on your ancestors' glory.",
	land_warn_msg   = "We admit you to land, but keep your honor clean at all time.",
	land_bribe_msg  = "I don't want to insult your honor, but regulations don't allow me to grant you landing permission.",
	land_no_msg     = "Beings with no honor are not authorized on our land.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "I can close my eyes a moment for %s credits, but before, you must swear you will behave with honor during your stay.",
	bribe_ack_msg   = "It's a pleasure to give you the occasion to show your honor on Irilia land."
}
land_factions["Irmothem Clan"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "Welcome to Irmothem, may your ancestors' glory shine on your stay with us.",
	land_warn_msg   = "We admit you to land, but keep your honor clean at all time.",
	land_bribe_msg  = "I don't want to insult your honor, but regulations don't allow me to grant you landing permission.",
	land_no_msg     = "Beings with no honor are not authorized on our land.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "I can close my eyes a moment for %s credits, but before, you must swear you will behave with honor during your stay.",
	bribe_ack_msg   = "It's a pleasure to allow you to show your honor on Irmothem land."
}
land_factions["Erdil Clan"] = {
	land_floor      = -20,
	bribe_floor     = -30,
	land_msg        = "Welcome to this Erdil settlement, may your ancestors' glory shine on your stay with us.",
	land_warn_msg   = "We admit you to land, but keep your honor clean at all time.",
	land_bribe_msg  = "I don't want to insult your honor, but regulations don't allow me to grant you landing permission.",
	land_no_msg     = "Beings with no honor are not authorized on our land.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "I can close my eyes a moment for %s credits, but before, you must swear you will behave with honor during your stay.",
	bribe_ack_msg   = "It's a pleasure to allow you to show your honor on Erdil land."
}
land_factions["Arythem Clan"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "Welcome to this Arythem land, may your honor shine on your stay with us.",
	land_warn_msg   = "We admit you to land, but keep your honor clean at all time.",
	land_bribe_msg  = "I'm honestly sorry, but your reputation doesn't allow me to grant you access here.",
	land_no_msg     = "Beings with no honor have nothing to do on Arythem land.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "With %s credits and an oath of honorable behavior, I may give you my backing with the landing authorities.",
	bribe_ack_msg   = "It's a pleasure to allow you to show your honor on Arythem land."
}
land_factions["JnI"] = {
	land_floor      =   0,
	bribe_floor     =   0,
	land_msg        = "Welcome to the land of the Pure, honorable ally.",
	land_warn_msg   = "",
	land_bribe_msg  = "",
	land_no_msg     = "Honorless beings like you have nothing to do on the Lands of Revenge.",
	bribe_base      =     0,
	bribe_rate      =     0,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "",
	bribe_ack_msg   = ""
}
land_factions["Free Adrimai"] = {
	land_floor      =  -5,
	bribe_floor     = -10,
	land_msg        = "Welcome traveller, to this Land of the Eclipsees.",
	land_warn_msg   = "We admit you to land, but understand we keep an eye on you during your stay.",
	land_bribe_msg  = "I don't want to insult your honor, but regulations don't allow me to grant you landing permission.",
	land_no_msg     = "Beings with no honor are not authorized on our land.",
	bribe_base      =  5000,
	bribe_rate      =   500,
	nobribe_msg     = "I'm not dealing with honorless beings like you!",
	bribeprice_fmsg = "I can close my eyes a moment for %s credits, but before, I need an oath of honor from you.",
	bribe_ack_msg   = "It's a pleasure to allow you to show your honor to the Eclipsees."
}
land_factions["Alliance"] = {
	land_floor      = -15,
	bribe_floor     = -30,
	land_msg        = "Permission to land granted.",
	land_warn_msg   = "Permission to land, but we'll keep an eye on you.",
	land_bribe_msg  = "Sorry, you broke too many Alliance regulations, I can't allow you to land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  3000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with outlaws like you!",
	bribeprice_fmsg = "%s credits and a promise to be quiet, and you're in.",
	bribe_ack_msg   = "Just make it quick and discreet."
}
land_factions["Aragwedyr Clan"] = {
	land_floor      =   0,
	bribe_floor     =   0,
	land_msg        = "You're allowed on the Land of the Exilees.",
	land_warn_msg   = "",
	land_bribe_msg  = "",
	land_no_msg     = "Landing request denied.",
	bribe_base      =     0,
	bribe_rate      =     0,
	nobribe_msg     = "I'm not dealing with outlaws like you!",
	bribeprice_fmsg = "",
	bribe_ack_msg   = ""
}
land_factions["Pei Clan-Family"] = {
	land_floor      = -20,
	bribe_floor     = -35,
	land_msg        = "Permission to land granted.",
	land_warn_msg   = "You seem to know people here, but Security will keep an eye on you.",
	land_bribe_msg  = "Sorry, you're not welcome here.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  2000,
	bribe_rate      =   500,
	nobribe_msg     = "I'm not dealing with scum like you!",
	bribeprice_fmsg = "%s credits and a promise to be quiet, and you're in.",
	bribe_ack_msg   = "I'll look elsewhere, but be quick."
}
land_factions["Stellar Police"] = {
	land_floor      =  -5,
	bribe_floor     = -10,
	land_msg        = "Permission to land granted.",
	land_warn_msg   = "Landing permission granted, keep to yourself.",
	land_bribe_msg  = "I'm sorry, you are forbidden to land here.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  4000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with criminals!",
	bribeprice_fmsg = "For %s credits of donation to our charities, I could secure a landing pad for you.",
	bribe_ack_msg   = "I don't know you, make it quick."
}
land_factions["Banthory Autarcy"] = {
	land_floor      =  -5,
	bribe_floor     = -10,
	land_msg        = "Permission to land granted, visitor.",
	land_warn_msg   = "You can land land, but we'll keep an eye on you.",
	land_bribe_msg  = "I'm sorry, I'm not allowed to make you land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  3000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with Spacer scums like you!",
	bribeprice_fmsg = "%s credits and a promise to be quiet, and you're in.",
	bribe_ack_msg   = "Don't show you're a Spacer and it'll be fine."
}
land_factions["Purple Trail"] = {
	land_floor      = -15,
	bribe_floor     = -25,
	land_msg        = "You are welcome in the Purple Trail.",
	land_warn_msg   = "Our regulations permit you to land, but you'd better behave.",
	land_bribe_msg  = "Sorry, our regulations forbid you to land.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with rebel individuals like you!",
	bribeprice_fmsg = "A small fee of %s credits will secure your landing.",
	bribe_ack_msg   = "Hurry while the controllers aren't watching."
}
land_factions["Core League"] = {
	land_floor      = -10,
	bribe_floor     = -40,
	land_msg        = "You are welcome in the Land of True Mankind.",
	land_warn_msg   = "You're permitted to land, but we keep an eye on you.",
	land_bribe_msg  = "Sorry, our rules forbid your landing.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  5000,
	bribe_rate      =  1500,
	nobribe_msg     = "I'm not dealing with beings like you!",
	bribeprice_fmsg = "A small fee of %s credits will secure your landing.",
	bribe_ack_msg   = "Be quick and discreet."
}
land_factions["HnH"] = {
	land_floor      = -15,
	bribe_floor     = -50,
	land_msg        = "Welcome to the Hekka jurisdiction.",
	land_warn_msg   = "The Hekka Rules allow you to land, but we'll keep an eye on you.",
	land_bribe_msg  = "Sorry, I'm only applying the Rules of the Hekka.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  4000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with scums like you!",
	bribeprice_fmsg = "A small fee of %s credits and I'll let you land.",
	bribe_ack_msg   = "Please make it quiet."
}
land_factions["Shadow Complex"] = {
	land_floor      = -15,
	bribe_floor     = -30,
	land_msg        = "Welcome to the Land of Peace.",
	land_warn_msg   = "The Complex Rules allow to land, but don't spoil the peace of this resort.",
	land_bribe_msg  = "Sorry, I'm only applying the Complex Rules.",
	land_no_msg     = "Landing request denied.",
	bribe_base      =  4000,
	bribe_rate      =  1000,
	nobribe_msg     = "I'm not dealing with warmongers like you!",
	bribeprice_fmsg = "A small contribution of %s credits will get you a landing pad.",
	bribe_ack_msg   = "Please don't disturb the peace of this palce, or I'll report you myself."
}
land_factions["Ashioto Cluster"] = {
	land_floor      =   0,
	bribe_floor     = -10,
	land_msg        = "Welcome to Cluster land.",
	land_warn_msg   = "The Cluster Rules allow to land, but keep your eyes to yourself.",
	land_bribe_msg  = "Sorry, I'm only applying Cluster Rules.",
	land_no_msg     = "Landing request denied.",
	bribe_base      = 10000,
	bribe_rate      =  3000,
	nobribe_msg     = "I'm not dealing with vile smugglers like you!",
	bribeprice_fmsg = "A small contribution of %s credits will get you a landing place.",
	bribe_ack_msg   = "Try to steal anything and I'll report you myself."
}
land_factions["Thirteen Planets League"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "Welcome to the League territory.",
	land_warn_msg   = "The Thirteen Planets grant you landing permission, but be quiet.",
	land_bribe_msg  = "Sorry, I'm only applying League Rules.",
	land_no_msg     = "You can't land there, please get off.",
	bribe_base      =  5000,
	bribe_rate      =  2000,
	nobribe_msg     = "I'm not dealing with people like you!",
	bribeprice_fmsg = "A small contribution of %s credits will get you a landing place.",
	bribe_ack_msg   = "Disturb the peace of this place and I'll report you myself."
}
land_factions["Red Quadrant League"] = {
	land_floor      =   0,
	bribe_floor     = -10,
	land_msg        = "Welcome to the League territory.",
	land_warn_msg   = "The Red Quadrant grant you landing permission, but be quiet.",
	land_bribe_msg  = "Sorry, I'm only applying League Rules.",
	land_no_msg     = "You can't land there, please get off.",
	bribe_base      =  3000,
	bribe_rate      =  2500,
	nobribe_msg     = "I'm not dealing with people like you!",
	bribeprice_fmsg = "A small contribution of %s credits will get you a landing place.",
	bribe_ack_msg   = "Disturb the peace of this place and I'll report you myself."
}
land_factions["Instrumentality Company"] = {
	land_floor      = -15,
	bribe_floor     = -40,
	land_msg        = "You are welcome on a Instrumentality associate land.",
	land_warn_msg   = "You can land, but be warned : any misbehavior will be reported and severely punished.",
	land_bribe_msg  = "Sorry, Instrumentality rules normally won't allow me to let you land.",
	land_no_msg     = "Stay clear of any Instrumentality settlements.",
	bribe_base      =  2000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "I'll make a deal for the modest amount of %s credits, but keep clean while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Shoden Clusters"] = {
	land_floor      =   0,
	bribe_floor     = -10,
	land_msg        = "You are welcome on the True Sshaads' land.",
	land_warn_msg   = "",
	land_bribe_msg  = "Sorry, Shoden rules normally won't allow me to let you land.",
	land_no_msg     = "Stay clear of any Shoden settlements.",
	bribe_base      =  2000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "I'll make a deal for the modest amount of %s credits, but make no fuss while landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Baartish Intersystems"] = {
	land_floor      = -15,
	bribe_floor     = -40,
	land_msg        = "You are welcome on a Baartish Intersystems associate land.",
	land_warn_msg   = "You can land, but be warned : any misbehavior will be reported and severely punished.",
	land_bribe_msg  = "Sorry, Baartish rules normally won't allow me to let you land.",
	land_no_msg     = "Stay clear of Baartish Intersystems settlements.",
	bribe_base      =  2000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "I'll make a deal for the modest amount of %s credits, but keep clean while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Daneb Anarchs"] = {
	land_floor      = -20,
	bribe_floor     = -50,
	land_msg        = "You are welcome on this Land of Freedom.",
	land_warn_msg   = "You can land, but don't make any trouble.",
	land_bribe_msg  = "Sorry, our rules won't allow me to let you land.",
	land_no_msg     = "Stay clear of any Daneb Anarchs settlements.",
	bribe_base      =  2500,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "I'll make a deal for %s credits, but behave responsible while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Complementarist Protectorate"] = {
	land_floor      = -20,
	bribe_floor     = -30,
	land_msg        = "Welcome visitor, on this land of peace.",
	land_warn_msg   = "You can land if you swear not to make any trouble.",
	land_bribe_msg  = "Sorry, our rules won't allow me to let you land.",
	land_no_msg     = "Stay clear of any Complementarist settlements.",
	bribe_base      =  3000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "We'll make a deal for %s credits, but behave responsible while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Candidate Systems"] = {
	land_floor      = -20,
	bribe_floor     = -30,
	land_msg        = "Welcome visitor, on this land of peace.",
	land_warn_msg   = "You can land if you swear not to make any trouble.",
	land_bribe_msg  = "Sorry, our rules won't allow me to let you land.",
	land_no_msg     = "Stay clear of any Candidate Systems settlements.",
	bribe_base      =  3000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "We'll make a deal for %s credits, but behave responsible while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Ren'sh Planetary Council"] = {
	land_floor      = -20,
	bribe_floor     = -30,
	land_msg        = "Welcome to this Ren'sh Council settlement.",
	land_warn_msg   = "You can land if you swear not to make any trouble.",
	land_bribe_msg  = "Sorry, Planetary Council rules won't allow me to let you land.",
	land_no_msg     = "Be warned, stay clear of Ren'sh or you'll run into trouble.",
	bribe_base      =  3000,
	bribe_rate      =  1500,
	nobribe_msg     = "Get lost or you'll feed our youngpacks.",
	bribeprice_fmsg = "We'll make a deal for %s credits, but behave responsible while you're landed.",
	bribe_ack_msg   = "If anything goes wrong, don't come telling me I didn't warn you!."
}
land_factions["Proteous Resistance"] = {
	land_floor      = -10,
	bribe_floor     = -20,
	land_msg        = "Welcome visitor, on this Land of the True Shapeshifters.",
	land_warn_msg   = "We allow you to land, but be warned, we'll not tolerate any trouble.",
	land_bribe_msg  = "Sorry, our rules won't allow me to let you land.",
	land_no_msg     = "Be warned, stay clear of Ren'sh or you'll run into trouble.",
	bribe_base      =  4000,
	bribe_rate      =  1000,
	nobribe_msg     = "Go feed your masters' youngpacks!",
	bribeprice_fmsg = "We'll make a deal for %s credits, but I'll personally keep an eye on you.",
	bribe_ack_msg   = "Make it quick and soft, or I'll personnally bring you into custody!"
}
land_factions["Independent Stars"] = {
	land_floor      =   0,
	bribe_floor     =  -5,
	land_msg        = "Welcome visitor, on this Land of the True Pupeteers.",
	land_warn_msg   = "We allow you to land, but be warned, we'll not tolerate any trouble.",
	land_bribe_msg  = "Sorry, our rules won't allow me to let you land.",
	land_no_msg     = "Be warned, stay clear of our settlements or you'll run into trouble.",
	bribe_base      =  8000,
	bribe_rate      =  2000,
	nobribe_msg     = "Go away, filthy scum!",
	bribeprice_fmsg = "I could use %s credits, but I'll personally keep an eye on you.",
	bribe_ack_msg   = "Don't even dare look on our Bearers!"
}

--[[
=========================================================================================================================================--]]
