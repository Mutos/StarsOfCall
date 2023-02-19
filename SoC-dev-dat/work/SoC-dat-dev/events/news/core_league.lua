local head = {
   _("Welcome to the Core League News Centre."),
}
local greeting = {
   _("Fresh news from around the Core League."),
   _("Keeping you informed."),
}
local articles = {
   --[[
      Science and technology
   --]]
   {
      head = N_([[New terraforming techniques]]),
      body = _([[New bleeding-edge terraforming techniques to be tried on next colony. Studies on a new way of adapting T-bacts to local conditions could speed up the terraforming process by as much as 40%.]])
   },
   --[[
      Business
   --]]
   {
      head = N_([[Core League Keeping Traders Safe]]),
      body = _([[Recent studies show that reports of piracy on Trader vessels have gone down by up to 40% in some sectors. This is a demonstration of the Core League's commitment to eradicating piracy.]])
   },
   {
      head = N_([[Nexus Contract Finalised]]),
      body = _([[The Core League agreed to terms with shipbuilder Nexus for a new generation of military craft. The deal extends the partnership with the government for another 10 cycles.]])
   },
   --[[
      Politics
   --]]
   {
      head = N_([[New Core League Recruits]]),
      body = _([[Core League's recruiting strategy a success. Many new soldiers joining the Navy. "We haven't had such a successful campaign in ages!" - Raid Steele, spokesman for recruiting campaign.]])
   },
   {
      head = N_([[Governor Helmer Jailed]]),
      body = _([[Central Auditors arrested governor Rex Helmer of New Earth on charges of corruption. He has been removed from office and transported to a holding facility awaiting trial.]])
   },
   {
      head = N_([[Core Council Opens Doors]]),
      body = _([[The supreme advisory body invited undergraduates from six top schools to sit in on a day's deliberations. Topics required biodiversity strategy.]])
   },
   --[[
      Human interest.
   --]]
   {
      head = N_([[New Cat in the Presidential Family]]),
      body = _([[The President's daughter was recently gifted a cat. Cat could be named "Snuggles" and seems to be all white.]])
   },
   {
      head = N_([[President's Aid Gets Hitched]]),
      body = _([[Presidential secretary Karil Lorenze married long time fiancee Rachid Baouda in a newly reconstructed palace of Beijing Forbidden City. His Eminence the Purohita of Bao performed the ceremony.]])
   },
}

return function ()
   return "Core League", head, greeting, articles
end
