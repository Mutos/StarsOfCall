--[[
<?xml version='1.0' encoding='utf8'?>
<mission name="Sirius Rehabilitation">
 <priority>10</priority>
 <cond>faction.playerStanding("Sirius") &lt; 0</cond>
 <chance>100</chance>
 <location>Computer</location>
</mission>
 --]]
--[[
--
-- Rehabilitation Mission
--
--]]

require "missions.rehab_common"

mem.fac = faction.get("Sirius")