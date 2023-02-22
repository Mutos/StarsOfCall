local head = {
   _("Welcome to the Planetarist Alliance News Centre."),
}
local greeting = {
   _("Fresh news from around the Alliance."),
   _("Keeping you informed."),
}
local articles = {
   --[[
      Science and technology
   --]]
   {
      head = N_([[Terraforming advances thanks to pupeteer help]]),
      body = _([[An agreement between the Alliance and the 13 Planets will soon allow bridge species gengineering to progress, making for 60% faster terraforming.]])
   },
   --[[
      Business
   --]]
   {
      head = N_([[The Alliance Keeping Traders Safe]]),
      body = _([[Recent studies show that reports of piracy on Trader vessels have gone down by up to 40% in some sectors. This is a demonstration of the Alliance's commitment to eradicating piracy.]])
   },
   {
      head = N_([[Core League rearms]]),
      body = _([[The Core League agreed to terms with shipbuilder Nexus for a new generation of military craft. Core League authorities have assured Alliance diplomats, that these new ships will be available to the joint Stellar Police.]])
   },
   --[[
      Politics
   --]]
   {
      head = N_([[New Navy Recruits]]),
      body = _([[The Alliance Navy is announcing a new recruiting campaign from all its constituent planets.]])
   },
   {
      head = N_([[Alliance Parliament Opens Doors]]),
      body = _([[The legislative body invited undergraduates from every constituent planet to sit in on a day's deliberations. Topics required biodiversity strategy.]])
   },
   --[[
      Human interest.
   --]]
   {
      head = N_([[A cat in the Presidential Family]]),
      body = _([[The President's daughter was recently gifted a cat. Cat could be named "Garfield" and seems to be all ginger-colored.]])
   },
}

return function ()
   return "Alliance", head, greeting, articles
end
