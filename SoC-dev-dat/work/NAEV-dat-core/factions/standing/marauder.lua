-- Marauder faction standing script
local spir = require "factions.standing.lib.pirate"

standing = spir.newPirateStanding{
   fct            = faction.get("Marauder"),
   friendly_at    = 101, -- Can't get friendly
   text = {
      [0]  = _("Ignored"),
      [-1] = _("Potential Victim"),
   },
}

function standing.hit( _self, current, _amount, _source, _secondary )
   return current -- Doesn't change through hits
end
