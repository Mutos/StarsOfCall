local wormhole = require "spob.lua.lib.wormhole"

function init( p )
   return wormhole.init( p, "Wormhole NGC-4087" )
end

load     = wormhole.load
unload   = wormhole.unload
update   = wormhole.update
render   = wormhole.render
can_land = wormhole.can_land
land     = wormhole.land
