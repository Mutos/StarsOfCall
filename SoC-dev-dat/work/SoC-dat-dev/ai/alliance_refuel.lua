require 'ai.alliance_idle'

-- Settings
mem.aggressive = false
mem.defensive  = false
mem.distressmsg = _("Alliance Navy refuelling ship under attack!")

function create ()
   create_pre()

   -- Broke
   ai.setcredits( 0 )

   -- Finish up creation
   create_post()
end

function hail ()
   if mem.setuphail then return end

   -- Doesn't make sense to bribe
   mem.bribe_no = _([["I'm out of here."]])

   -- Override refuel chance
   mem.refuel = 0
   mem.refuel_msg = _([["Sure thing."]])

   mem.setuphail = true
end
