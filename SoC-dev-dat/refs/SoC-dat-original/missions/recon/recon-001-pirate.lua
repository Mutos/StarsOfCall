--[[
	These are recon missions proposed by the mission computer.
	They consist of going to a specific system, finding a pirate base and returning with the scan info. 
--]]

-- =======================================================================================
--
-- Script-global parameters
-- 
-- =======================================================================================
--

-- Mission prefix for variables
msnPrefix = "msn_Recon_001_"

--
-- =======================================================================================


-- =======================================================================================
--
-- Declare script-global variables
-- to avoid declaration errors at procedure level
-- 
-- =======================================================================================
--

-- Parameters
-- Declared local to not be saved, as they are reinitialized each time the script is invoked.
local distanceMin           =     1
local distanceMax           =     3
local rewardPerJump         = 15000
local rewardVariancePercent =    10
local scanTime              =    10

-- Variables
-- Declared global to be saved, only numbers and strings 
systemOrigin                = nil
planetOrigin                = nil
systemTarget                = nil
planetTarget                = nil
reward                      = 0
currentPhase                = 0
scanned = false

-- Hooks
timerWaitHook = nil

--
-- =======================================================================================


-- =======================================================================================
--
-- Setup strings
-- 
-- =======================================================================================
--

lang = naev.lang()

if lang == "es" then
else -- default english
	-- Mission description and reward
	misn_desc = "Recon pirate base in system %s and return here with scan information."
	misn_reward = "%d cr."

	-- NPC - first taken from Joanne
	merchantGFX  = "human/neutral/unique/joanne"
	merchantName = "A merchant"
	merchantDesc = "A merchant sits here, enjoying a drink by herself."

	-- Dialogue with the NPC
	titleAsk = "A merchant who knows your name"
	textAsk  = [["Hello there %s," the merchant greets you. "You're quite famous here. I may have a job for you. A simple thing. Informers told us there's a pirate base called %s, hidden somewhere in the system %s. You'll have to approach it, scan it and return there to deliver the information. No engaging enemy ships, just sneaking in and out. Pay is good at %i credits, risks are low, what do you say ?"]]

	-- Mission accepted
	accept_title = "Mission Accepted"

	-- On-Screen-Display title and lines
	osd_title = "Recon pirate base"
	osd_msg =	{	"Go to system %s",
							"Find and approach %s",
							"Keep position until scan is complete",
							"Go back to system %s",
							"Land at %s"
						}

	-- Messages
	msgTitle = "Pirate base scan Mission"
	msgScanning = [[Your scanning equipment does a quick sweep of the pirate base. It reveals too many fighters for your safety, and you decide to break as soon as the equipment says it's got enough data.]]
	msgScanBegin = "In range, scanning beginning..."
	msgScanEnd = "Scanning completed..."
	msgScanBack = "Back into range, resuming scanning..."
	msgScanStray = "Warning, straying out of scanning range..."
	msgSuccess = [[    The merchant who gave you the mission meets you at the space dock. "Hello again guv," she greets you. "Made a good job ! Good luck out there!"
With that, she walks back into the spaceport complex.]]
	msgFailure = [[    The merchant who gave you the mission meets you at the space dock. "Hello again guv," she greets you. "So you couldn't stay close to that base for enough time ? I'm sorry, I'll have to get another pilot... Anyway, good luck out there!"
With that, she walks back into the spaceport complex.]]

	-- Reward text
	textReward = {}
	textReward[true]  = "Thanks for the informaiton"
	textReward[false] = "Sorry you didn't find out that base, I'll have to send someone else..."
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Helper functions
-- 
-- =======================================================================================
--

-- Include helper functions
include "jumpdist.lua"
include "jumpdist_filters.lua"
include "cargo_common.lua"
include "patrol_common.lua"
include "numstring.lua"
include("proximity.lua")

-- Include helper functions
include ("dat/events/_commons/_commons.lua")

--
-- =======================================================================================


-- =======================================================================================
--
-- Mission standard functions, called by the engine
--	create()	From mission.xml, when landing, creates display in the Missions panel
--	accept()	"Accept" button from Mission Computer
--	abort()	"Abort" button from Mission tab of the Information window
-- 
-- =======================================================================================
--

-- Create the mission
function create()
	-- print ( string.format( "\nRecon pirate base : entering create()" ) )

	-- Get the current system and planet
	planetOrigin, systemOrigin = planet.cur()
	local systems = {}

	-- Get a list of systems with pirate base
	systems = getsysatdistance( systemOrigin, distanceMin, distanceMax,
		function(s)
			return (
				filters.IsNotSystem(s)
					and
				filters.HasLandable(s, "Pirate", false)
			)
		end
	)
	if systems==nil or #systems==0 then
		-- print ( string.format( "\tNo suitable target system found." ) )
		-- print ( string.format( "Recon pirate base : exiting create()" ) )
		misn.finish()
	end
	-- print ( string.format( "\t%i systems selected :", #systems ) )
	for key,sys in ipairs ( systems ) do
		-- print ( string.format( "\t\t%s",  sys:name() ) )
	end
	systemTarget=systems[rnd.rnd(1, #systems)]

	-- Debug : print system
	-- print ( string.format( "\tTarget system : %s", systemTarget:name() ) )

	-- Set the planet target
	for key, v in ipairs(systemTarget:planets()) do
		local strPlanetName = v:name()
		-- -- print ( string.format( "\t\ttesting planet \"%s\"", strPlanetName ) )
		if v:services().land and v:faction():name() == "Pirate" then
			planetTarget = v
		end
	end

	-- Debug : print planet
	-- print ( string.format( "\tTarget planet : %s", planetTarget:name() ) )

	-- Compute a reward
	reward = systemTarget:jumpDist() * rewardPerJump
	reward = rnd.rnd( reward*(1-rewardVariancePercent/100), reward*(1+rewardVariancePercent/100) )

	-- Create a NPC - Taken from Joanne's chain of missions - accept() is trigerred when (A)pproaching the NPC
	misn.setNPC(merchantName, merchantGFX)
	misn.setDesc(merchantDesc)

	-- print ( string.format( "Recon pirate base : exiting create()" ) )
end


-- Mission is accepted
function accept()
	-- print ( string.format( "\r\nRecon pirate base : entering accept()" ) )

	-- Ask the player - If no, then nothing is to be done, misn.finish() ends the script
	if not tk.yesno(titleAsk, textAsk:format( player.name(), planetTarget:name(), systemTarget:name(), reward )) then
	  misn.finish()
	end

	-- Actually accept the mission
	misn.accept()

	-- Set description and reward
	misn.setDesc(misn_desc:format( systemTarget:name() ))
	misn.setReward(misn_reward:format( reward ) )

	-- Set system markers
	systemTargetMarker = misn.markerAdd(systemTarget, "high")

	-- Setup the OSD
	misn.osdCreate(
		osd_title, 
		{
			osd_msg[1]:format( systemTarget:name() ), 
			osd_msg[2]:format( planetTarget:name() ), 
			osd_msg[3], 
			osd_msg[4]:format( systemOrigin:name() ), 
			osd_msg[5]:format( planetOrigin:name() )
		}
	)

	-- Set Phase 1
	currentPhase = 1

	-- Setup hook for checking if the player is in the firt system
	systemTargetHook = hook.enter("enterSystem")
	landOriginHook = hook.land("land")

	-- print ( string.format( "\nRecon pirate base : exiting accept()" ) )
end


-- Mission is aborted
function abort ()
	-- print ( string.format( "\nRecon pirate base : entering abort()" ) )

	-- Close the mission
	misn.finish(false)

	-- print ( string.format( "\nRecon pirate base : exiting abort()" ) )
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Main events sequence (hook in currentPhase) :
--	1/ Player enters first rendez-vous sytem : enterSystem()
--	2/ Player approaches target base
--	3/ Player ends scan
--	4/ Player enters origin system : enterSystem()
--	5/ Player lands on original planet : land()
--		End mission.
-- 
-- =======================================================================================
--
-- Enter target system hook
-- Phases : 1
function enterSystem()
	-- Debug printout
	-- print ( string.format( "\r\nRecon pirate base : entering enterSystem()" ) )

	-- Local variables
	local systemTest = nil

	-- Setup tests according to phase
	-- print ( string.format( "\tCurrent system : \"%s\"", system:cur():name() ) )
	if currentPhase == 1 or currentPhase == 2 then
		systemTest = systemTarget
		-- print ( string.format( "\tCurrent Phase (%d) : checking for target system \"%s\"", currentPhase, systemTest:name() ) )
	elseif currentPhase == 3 then
		systemTest = systemOrigin
		-- print ( string.format( "\tCurrent Phase (%d) : checking for origin system \"%s\"", currentPhase, systemTest:name() ) )
	else
		-- print ( string.format( "\tCurrent Phase (%d) : error, neither 1, 2 or 3", currentPhase ) )
		-- print ( string.format( "Recon pirate base : exiting enterSystem()" ) )
		return
	end

	-- Not the rendez-vous system : exit function
	if system.cur():name() ~= systemTest:name() then
		-- print ( string.format( "\tNot rendez-vous system" ) )
		-- print ( string.format( "Recon pirate base : exiting enterSystem()" ) )
		return
	end

	-- This is the rendez-vous system : wait for the contact with the base
	-- print ( string.format( "\tRendez-vous system found!" ) )

	if currentPhase == 1 or currentPhase == 2 then
		-- Change the OSD, set a proximity hook and increment the phase
		misn.osdActive(2)
		proximity( {location = planetTarget:pos(), radius = 400, funcname = "closingPirateStation"} )
		currentPhase = 2
		inrange = 0
	elseif currentPhase == 3 then
		-- Change the OSD and increment the phase
		-- print ( string.format( "\tCurrent Phase (%d) : setting OSD", currentPhase ) )
		misn.osdActive(5)
		currentPhase = 4
	end

	-- Debug printout for normal end
	-- print ( string.format( "Recon pirate base : exiting enterSystem()" ) )
end


function closingPirateStation()
	-- Debug printout for beginning
	-- print ( string.format( "\r\nRecon pirate base : entering closingPirateStation()" ) )

	if currentPhase == 2 then
		local pp = player.pilot()
		-- print ( string.format( "\tCurrent Phase (%d) is OK, found target Pirate Base", currentPhase ) )
		misn.osdActive(3)
		inrange = inrange + 1
		if inrange == 7 then
			-- print ( string.format( "\tScanning OK" ) )
			player.msg(msgScanEnd)
			misn.markerMove(systemTargetMarker, systemOrigin)
			scanned = true
			misn.osdActive(4)
			currentPhase = 3
			-- print ( string.format( "Recon pirate base : exiting closingPirateStation()" ) )
			return
		end
		if pp:pos():dist(planetTarget:pos()) <= 400 and pp:vel():mod() < 50 then
			-- print ( string.format( "\tComing into scanning range" ) )
			if inrange == 0 then
				player.msg(msgScanBegin)
			end
			misn.osdActive(3)
			hook.timer(500, "closingPirateStation")
		else
			-- print ( string.format( "\tStrayed out of range too soon" ) )
			if inrange ~= 1 then
				player.msg(msgScanStray)
			end
			inrange = 0
			misn.osdActive(2)
			hook.timer(500, "proximity", {location = planetTarget:pos(), radius = 400, funcname = "closingPirateStation"})
		end
	else
		-- print ( string.format( "\tCurrent Phase (%d) : error, not 2", currentPhase ) )
		-- print ( string.format( "Recon pirate base : exiting closingPirateStation()" ) )
		return
	end

	-- Debug printout for normal end
	-- print ( string.format( "Recon pirate base : exiting closingPirateStation()" ) )
end

-- Land hook for ending the mission, with reward or not depending on the scan.
function land()
	if planet.cur() == planetOrigin then
		if scanned then
			tk.msg(msgTitle, msgSuccess)
			player.pay(reward)
		else
			tk.msg(msgTitle, msgFailure)
		end
		misn.finish(true)
	end
end

--
-- =======================================================================================


-- =======================================================================================
--
-- Off-sequence events
--  a/ 
-- 
-- =======================================================================================
--
--
-- =======================================================================================

