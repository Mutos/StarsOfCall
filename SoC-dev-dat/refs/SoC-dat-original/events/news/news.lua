--[[
-- Event for creating newsfeed depending on local faction
--]]

-- Get langage
lang = naev.lang()

-- Initi void tables
header_table={}
greet_table={}
articles={}

-- Include generic and faction-specific newsfeeds
include("dat/events/news/generic.lua")
include("dat/events/news/factions/alliance.lua")
include("dat/events/news/factions/baartish.lua")
include("dat/events/news/factions/coreleague.lua")
include("dat/events/news/factions/hoshinohekka.lua")
include("dat/events/news/factions/independent.lua")
include("dat/events/news/factions/pirate.lua")

	-- create generic news
function create()
	-- print ( "\nBegin news create()" )

	-- Get local faction
	local faction = planet.cur():faction()
	if faction == nil then
		return
	end

	-- Get faction name
	local factionName = faction:name()
	-- print ( string.format ( "\tFaction : \"%s\"" , factionName ) )

	remove_header(factionName)

	rm_genericarticles("Generic")
	rm_genericarticles(factionName)

	add_header(factionName)
	add_articles("Generic",math.random(2,5))
	add_articles(factionName,math.random(1,3))

	-- print ( "End news create()" )
end

function add_header(faction)
	remove_header('Generic')

	if header_table[faction] == nil then
		warn( 'News: Faction \''..faction..'\' does not have entry in faction table!' )
		faction = 'Generic'
	end

	header=header_table[faction][1]
	-- print ( string.format ( "\tHeader : \"%s\"" , header ) )
	-- print ( string.format ( "\t#Greets : \"%i\"" , #greet_table[faction] ) )
	desc=greet_table[faction][math.random(#greet_table[faction])]

	news.add(faction,header,desc,50000000000005,50000000000005)
end

function remove_header(faction)
	local news_table=news.get(faction)

	for _,v in ipairs(news.get(faction)) do

		for _,v0 in ipairs(header_table[faction]) do
			if v:title()==v0 then
				v:rm()
			end
		end

	end

	return 0
end


function add_articles(faction,num)

	if articles[faction]==nil then
		return 0
	end

	num=math.min(num,#articles[faction])
	news_table=articles[faction]

	local header
	local desc
	local rnum

	for i=1,num do

		rnum=math.random(#news_table)
		header=news_table[rnum]["title"]
		desc=news_table[rnum]["desc"]

		news.add(faction,header,desc,500000000000000,0)

		table.remove(news_table,rnum)

	end

end

function rm_genericarticles(faction)

	local news_table=news.get(faction)

	if articles[faction]==nil then return 0 end

	for _,v in ipairs(news_table) do

		for _,v0 in ipairs(articles[faction]) do
			if v:title()==v0["title"] then
				v:rm()
				break
			end
		end
	
	end


end
