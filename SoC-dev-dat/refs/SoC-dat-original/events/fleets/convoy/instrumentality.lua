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
		DONE
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
faction = "Instrumentality Company"
shortFaction = "IC"
