--===========================================================================================================================================
--  Parameters for the generic functions
--===========================================================================================================================================


--[[=========================================================================================================================================
	Generic parameters for passes
		-- Parameter to compute RETURN #1 : boolean whether or not player can land
		passName      : player with one or more passes of this name can land
		-- Land message, to be issued as RETURN #2
		okMessage     : if pass, OK to land
		noPassMessage : if no pass, not allowed to land and no bribe possible
=============================================================================================================================================
--]]

landing_passes = {}
landing_passes["Eden"] = {
	passName      = "Eden Landing Pass",
	okMessage     = "Welcome to the Free Paradise of the Hekka, enjoy your stay and keep out of trouble.",
	noPassMessage = "You have no valid Landing Pass. Please register to the Hekka Council.",
}
landing_passes["Purgatoire"] = {
	passName      = "Purgatoire Landing Pass",
	okMessage     = "Welcome to Purgatoire Archeological Research Facilities, upon landing, please proceed to the visitors' registration lounge.",
	noPassMessage = "You're not authorized by the Research Council. Please return only duly accredited.",
}
landing_passes["Tuskegee Training Academy"] = {
	passName      = "Core League Military Accreditation",
	okMessage     = "Welcome to Tuskegee Training Academy, keep you badge visible at all time and stay on proper areas for your accreditation.",
	noPassMessage = "This is a military area, do not loiter there, repeat, do NOT loiter here.",
}
landing_passes["Bamara Border Station"] = {
	passName      = "Core League Military Accreditation",
	okMessage     = "Welcome to Bamara Border Station, please stay on the traders' lounge and do not try to enter military areas.",
	noPassMessage = "You have not been approved for Bamara Secure Trading Zone access. Please come back with a valid accreditation.",
}
landing_passes["Ziffel IV Quarantine Station"] = {
	passName      = "Core League Military Accreditation",
	okMessage     = "Welcome to the Ziffel IV Quarantine Enforcement Zone. By landing there, you accept to comply with any directive issued under Quarantine Authority.",
	noPassMessage = "You have not been approved for entry into the Ziffel IV Quarantine Enforcement Zone. Please come back with a valid accreditation.",
}
landing_passes["Yana"] = {
	passName      = "Yana Private Invitation",
	okMessage     = "Welcome to Yana, dear guests, Captain Salomon awaits your arrival on the docking bay.",
	noPassMessage = "This is private property, trespassers will be prosecuted.",
}
landing_passes["Ziffel IV"] = {
	passName      = "Ziffel IV Quarantine Exception",
	okMessage     = "You're leaving Core League territory and entering the Ziffel Empire. Upon landing on the designated strip, please proceed immediately to the Customs & Medical Control building.",
	noPassMessage = "Warning, the planet is under joint quarantine from the Core League and Ziffel Empire. Do not try to land! Repeat, DO NOT try to land.",
}

--[[
=========================================================================================================================================--]]
