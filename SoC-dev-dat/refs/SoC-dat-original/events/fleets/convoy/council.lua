--[[

EVENT TITLE: Convoy
DESCRIPTION: 
	A convoy crosses the current system

	Scenario:
		The convoy enters the system by either taking off or jumping in,
		 It chooses a destination, either a planet or a jump point, different from its origin,
		 It proceeds to its destination while reacting to surrounding conditions,
		 Upon reaching its destination, it either lands or jumps out.

SOURCEFORGE:
		TODO
			FEATURE	: faction-specific behavior if need be
		r82
			CODE	: grouped all common functions for convoy module into "common.lua"
			CODE	: secured initial convoy leader selection
		r79-80-81
			CODE	: cleaned up the code
		r78
			FEATURE	: draft a new Convoy Leader when the current one is killed
			FEATURE	: first functional version from "independant.lua"

]]--

include("dat/events/fleets/convoy/common.lua")

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
	-- Nothing for now for espanol
elseif lang == "fr" then
	-- Nothing for now for français
else -- default english

-- This section stores the strings (text) for the event.
end 

-- Header variables
faction = "K'Rinn Council"
shortFaction = "K'RC"
