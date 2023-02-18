-- Prepare variables
startupSystem = "Ek'In"
menuTitle = {}
menuComment = {}
menuText = {}
menuOptions = {}
ridiculousMoney = 100000000

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	-- Character species menu
	menuTitle ["Species"] = "Choose Player Character species"
	menuComment ["Species"] = "You will first have to choose a species for your character among: \n\n\027bK'Rinns\0270: pacifist arthropoids specialized in AI and trade, \n\n\027bRithai\0270: warlike feline centauroids with a deep sense of honor, \n\n\027bHumans\0270: selfish primates with a crush on technology, \n\n\027bPupeteers\0270: respectful symbiots living on gengineered animals, \n\n\027bSshaads\0270: reptilo-avian anarchs split between multiple factions, \n\n\027bShapeshifters\0270: recent spacegoers, invaded by Sshaad factions."
	menuText  ["Species"] = "Which species do you want your character to be from? Please select a species from the list below:"
	menuOptions ["Species"] = {}
	menuOptions ["Species"]["Human"] = "Humans"
	menuOptions ["Species"]["K'Rinn"] = "K'Rinns"
	menuOptions ["Species"]["Pupeteer"] = "Pupeteers"
	menuOptions ["Species"]["Rith"] = "Rithai"
	menuOptions ["Species"]["Sshaad"] = "Sshaads"
	menuOptions ["Species"]["Shapeshifter"] = "Shapeshifters"

	-- Startup location menu
	menuTitle ["Start"] = "Choose startup State"
	menuComment ["Start"] = "You will then be asked for a starting location from one of the following States: \n\n\027bK'Rinn Council\0270: the K'Rinn major State, extending its dominion over 90% of the k'rinn species, \n\n\027bPlanetarist Alliance\0270: the progressive human State that won the war against the Political Corporations, \n\n\027bCore League\0270: the traditionalist and somewhat militaristic human State that comprises Sol with Earth and Mars."
	menuText  ["Start"] = "Where do you want to start the game ? Please select a State from the list below:"
	menuOptions ["Start"] = {}
	menuOptions ["Start"]["Sol"] = "Core League"
	menuOptions ["Start"]["Sanctuary"] = "Planetarist Alliance"
	menuOptions ["Start"]["Ek'In"] = "K'Rinn Council"

	-- Ship type menu
	menuTitle ["ShipType"] = "Choose a type of ship to start with"
	menuComment ["ShipType"] = "You will now define which ship type you will begin with: \n\n\027bFighter\0270: small ship with weapons but next to no cargo space, \n\n\027bFreighter\0270: a larger ship with some cargo space, armed only in defense, \n\n\027bCourier\0270: a smaller and faster freighter made for quick runs."
	menuText  ["ShipType"] = "Which type of ship do you want your character to comandeer? Please select a ship type from the list below:"
	menuOptions ["ShipType"] = {}
	menuOptions ["ShipType"]["Fighter"] = "Fighter"
	menuOptions ["ShipType"]["Freighter"] = "Freighter"
	menuOptions ["ShipType"]["Courier"] = "Courier"


	-- Warning on Alpha menu
	menuTitle ["Alpha"] = "Alpha-testing options"
	menuComment ["Alpha"] = "\n\nAre you a Lawful Good?\n\nWill you resist temptation?\n\nWarning : next (and last) two options are cheats! \n\nThey are intended for Alpha-testing only!\n\n"

	-- Map menu
	menuTitle ["Map"] = "Startup map"
	menuText  ["Map"] = ""
	menuOptions ["Map"] = {}
	menuOptions ["Map"]["Regular"] = "Regular startup map"
	menuOptions ["Map"]["Complete"] = "DEBUG: complete map"

	-- Money amount menu
	menuTitle ["Money"] = "Startup money"
	menuText  ["Money"] = ""
	menuOptions ["Money"] = {}
	menuOptions ["Money"]["Regular"] = "Regular amount of money"
	menuOptions ["Money"]["Ridiculous"] = "DEBUG : ridiculously high sum"
end

function name()
	local names = {
	  "Pathfinder",
	  "Death Trap",
	  "Little Rascal",
	  "Gunboat Diplomat",
	  "Attitude Adjuster",
	  "Vagabond",
	  "Sky Cutter",
	  "Blind Jump",
	  "Terminal Velocity",
	  "Eclipse",
	  "Windjammer",
	  "Icarus",
	  "Heart of Lead",
	  "Exitprise",
	  "Commuter",
	  "Serendipity",
	  "Aluminum Mallard", -- Because we might as well allude to an existing parody. Proper spelling would be "Aluminium", by the way.
	  "Titanic MLXVII",
	  "Planet Jumper",
	  "Outward Bound",
	  "Shove Off",
	  "Opportunity",
	  "Myrmidon",
	  "Fire Hazard",
	  "Jord-Maogan",
	  "Armchair Traveller"
	}
	return names[rnd.rnd(1,#names)]
end


function create()
	-- Ask the player with which species they want to play
	tk.msg ( menuTitle ["Species"], menuComment ["Species"], "dialogues/startup/001-SpaceGoingSpecies.png" )
	_, speciesSelection = tk.choice(menuTitle ["Species"], menuText ["Species"], menuOptions ["Species"]["K'Rinn"], menuOptions ["Species"]["Rith"], menuOptions ["Species"]["Human"], menuOptions ["Species"]["Pupeteer"], menuOptions ["Species"]["Sshaad"], menuOptions ["Species"]["Shapeshifter"])

	-- Ask the player in which State they wish to begin the game
	tk.msg ( menuTitle ["Start"], menuComment ["Start"], "dialogues/startup/002-States.png" )
	_, selection = tk.choice(menuTitle ["Start"], menuText ["Start"], menuOptions ["Start"]["Ek'In"], menuOptions ["Start"]["Sanctuary"], menuOptions ["Start"]["Sol"])

	-- Ask the player with which ship type they want
	tk.msg ( menuTitle ["ShipType"], menuComment ["ShipType"], "dialogues/startup/003-Ships.png" )
	_, shipType = tk.choice(menuTitle ["ShipType"], menuText ["ShipType"], menuOptions ["ShipType"]["Fighter"], menuOptions ["ShipType"]["Freighter"], menuOptions ["ShipType"]["Courier"])

	-- Alpha-test choices: Money and Map
	tk.msg ( menuTitle ["Alpha"], menuComment ["Alpha"], "dialogues/startup/004-LawfulGood.png" )
	_, moneyAmount = tk.choice(menuTitle ["Money"], menuText ["Money"], menuOptions ["Money"]["Regular"], menuOptions ["Money"]["Ridiculous"])
	_, mapType = tk.choice(menuTitle ["Map"], menuText ["Map"], menuOptions ["Map"]["Regular"], menuOptions ["Map"]["Complete"])

	-- Store the player character's species
	if (speciesSelection == menuOptions ["Species"]["Human"]) then
		var.push ("pc_species", "Human")
	elseif (speciesSelection == menuOptions ["Species"]["K'Rinn"]) then
		var.push ("pc_species", "K'Rinn")
	elseif (speciesSelection == menuOptions ["Species"]["Pupeteer"]) then
		var.push ("pc_species", "Pupeteer")
	elseif (speciesSelection == menuOptions ["Species"]["Rith"]) then
		var.push ("pc_species", "Rith")
	elseif (speciesSelection == menuOptions ["Species"]["Shapeshifter"]) then
		var.push ("pc_species", "Shapeshifter")
	elseif (speciesSelection == menuOptions ["Species"]["Sshaad"]) then
		var.push ("pc_species", "Sshaad")
	end

	-- DEBUG : display the resulting parameters
	-- tk.msg( "Selections", "Species: " .. var.peek("pc_species") .. " ; Ship type: " .. shipType .. " ; Money: " .. moneyAmount ) 

	-- Select the starting faction and system
	if (selection == menuOptions ["Start"]["Sol"]) then
		stellarSystem = "Sol"
		faction.get("Core League"):modPlayer( 25 )
	elseif (selection == menuOptions ["Start"]["Sanctuary"]) then
		stellarSystem = "Sanctuary"
		faction.get("Alliance"):modPlayer( 25 )
	elseif (selection == menuOptions ["Start"]["Ek'In"]) then
		stellarSystem = "Ek'In"
		faction.get("K'Rinn Council"):modPlayer( 25 )
	end

	-- Set the default startup system unknown
	system.get( startupSystem ):setKnown( false )

	-- Drop the pilot in the chosen stellar system
	player.teleport(stellarSystem)
	system.get(stellarSystem):setKnown(true, true)

	-- Assign a random name to the player's ship.
	player.pilot():rename( name() )

	-- Assign a ship of the chosen ship type, in default configuration
	--   Standard core systems,
	--   Reduced loadout modified from the species:
	--     Reload weapons by hand to configure weapons groups,
	--   No utilities installed.
	if (shipType == menuOptions ["ShipType"]["Fighter"]) then
		-- Fighter : small, fast and armed, but near to no cargo space
		if (var.peek("pc_species") == "Pupeteer") then
			player.swapShip("Valiant Drone", "Valiant Drone", "Earth", true, true)
		else
			player.swapShip("Nelk'Tan", "Nelk'Tan", "Earth", true, true)
		end
		player.pilot():rmOutfit("all")
		player.pilot():addOutfit("Small Fuel Pod", 1)
		player.pilot():addOutfit("Fighter Ion Cannon", 2)
	elseif (shipType == menuOptions ["ShipType"]["Freighter"]) then
		-- Freighter : good cargo space, but minimal flak defense, slow and high fuel consumption
		if (var.peek("pc_species") == "Pupeteer") then
			player.swapShip("Fast Shell", "Fast Shell", "Earth", true, true)
		else
			player.swapShip("Eresslih", "Eresslih", "Earth", true, true)
		end
		player.pilot():rmOutfit("all")
		player.pilot():addOutfit("Small Fuel Pod", 1)
		player.pilot():addOutfit("Small Ion Flak Turret", 1)
	elseif (shipType == menuOptions ["ShipType"]["Courier"]) then
		-- Courier : fast cargo with no flak and less cargo, but more speed
		if (var.peek("pc_species") == "Pupeteer") then
			player.swapShip("Faithful", "Faithful", "Earth", true, true)
			player.pilot():rmOutfit("all")
			player.pilot():addOutfit("Small Fuel Pod", 1)
		else
			player.swapShip("Alaith", "Alaith", "Earth", true, true)
			player.pilot():rmOutfit("all")
			player.pilot():addOutfit("Small Fuel Tank", 1)
		end
	end


	-- Give the player a ridiculous amount of money if they choose so
	if (moneyAmount == menuOptions ["Money"]["Ridiculous"]) then
		player.pay(ridiculousMoney-player.credits())
	end

	-- Add the prices on maps
	player.addOutfit( "Prices Info" )

	-- Add map of the startup State
	if (mapType == menuOptions ["Map"]["Complete"]) then
		player.addOutfit( "All Systems Map" )
	else
		if     (stellarSystem == "Sol") then
			player.addOutfit( "Core League - Main Routes" )
		elseif (stellarSystem == "Sanctuary") then
			player.addOutfit( "Planetarist Alliance - Main Routes" )
		elseif (stellarSystem == "Ek'In") then
			player.addOutfit( "K'Rinn Council - Main Routes" )
		end
	end

	-- Terminate the event
	evt.finish( true )
end
