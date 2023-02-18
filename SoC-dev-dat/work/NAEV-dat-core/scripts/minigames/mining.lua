--[[
   Wrapper for the Sokoban minigame
--]]
local love = require "love"
local vn = require "vn"
local mcore = require "minigames.mining.core"
local mining = {}

local function setup( params, standalone )
   params = params or {}
   local c = naev.cache()
   c.mining = {}
   c.mining.params = params
   c.mining.standalone = standalone
   c.mining.difficulty = params.difficulty
   c.mining.reward_func = params.reward_func
   c.mining.speed = params.speed
   c.mining.shots_max = params.shots_max
end

--[[
   Runs the Mining minigame as a standalone
--]]
function mining.love( params )
   setup( params, true )
   love.exec( 'scripts/minigames/mining' )
end

--[[
   Runs the Mining minigame from the VN
--]]
function mining.vn( params )
   local s = vn.custom()
   s._init = function ()
      setup( params, false )
      return mcore.load()
   end
   s._draw = function ()
      naev.gfx.clearDepth()
      return mcore.draw()
   end
   s._keypressed = function( _self, key )
      return mcore.keypressed( key )
   end
   s._update = function( self, dt )
      if mcore.update( dt ) then
         self.done = true
      end
   end
   return s
end

return mining
