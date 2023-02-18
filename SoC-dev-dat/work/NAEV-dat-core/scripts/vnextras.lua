--[[

   Extra functionality for the VN

--]]
local vn = require "vn"
local love_shaders = require "love_shaders"
local lg = require 'love.graphics'

local extras = {}

-- Used to restore values
local textbox_bg_alpha, textbox_font, textbox_h, textbox_w, textbox_x, textbox_y

local function fullscreenStart( func, params )
   params = params or {}
   local nw, nh = naev.gfx.dim()
   vn.func( function ()
      if func then
         func()
      end
      -- Store old values
      textbox_bg_alpha = vn.textbox_bg_alpha
      textbox_h = vn.textbox_h
      textbox_w = vn.textbox_w
      textbox_x = vn.textbox_x
      textbox_y = vn.textbox_y
      textbox_font = vn.textbox_font
      -- New values
      if params.font then
         vn.textbox_font = params.font
      end
      vn.textbox_bg_alpha = 0
      vn.textbox_h = math.min(0.7*nh, 800 )
      vn.textbox_y = (nh-vn.textbox_h)/2
      vn.textbox_w = math.min( 0.8*nw, 1200 )
      vn.textbox_x = (nw-vn.textbox_w)/2
      vn.show_options = false
   end )
   vn.scene()
   local name = params.name or _("Notebook")
   local colour = params.textcolour or {1, 1, 1}
   local log = vn.newCharacter( name, { color=colour, hidetitle=true } )
   vn.transition()
   return log
end

local function fullscreenEnd( done, transition, length )
   vn.scene()
   vn.func( function ()
      vn.setBackground()
      vn.textbox_bg_alpha = textbox_bg_alpha
      vn.textbox_h = textbox_h
      vn.textbox_w = textbox_w
      vn.textbox_x = textbox_x
      vn.textbox_y = textbox_y
      vn.textbox_font = textbox_font
      vn.show_options = true
      if done then
         vn.textbox_bg_alpha = 0
         vn.show_options = false
      end
   end )
   vn.transition( transition, length )
end

--[[--
Converts the VN to behave like a notebook with hand-written text.

   @tparam[opt=_("Notebook")] string Name to give the "notebook" vn character.
   @treturn vn.Character The new character to use for the notebook.
--]]
function extras.notebookStart( name )
   local nw, nh = naev.gfx.dim()
   local paperbg = love_shaders.paper( nw, nh )
   local oldify = love_shaders.oldify()
   return fullscreenStart( function ()
      vn.setBackground( function ()
         vn.setColor( {1, 1, 1, 1} )
         lg.rectangle("fill", 0, 0, nw, nh )
         vn.setColor( {1, 1, 1, 0.3} )
         lg.setShader( oldify )
         paperbg:draw( 0, 0 )
         lg.setShader()
      end )
   end, {
      name = name or _("Notebook"),
      textcolour = {0, 0, 0},
      font = lg.newFont( _("fonts/CoveredByYourGrace-Regular.ttf"), 24 )
   } )
end
extras.notebookEnd = fullscreenEnd

--[[--
Converts the VN to behave like a grainy flashback.

   @tparam[opt=_("Notebook")] string Name to give the "notebook" vn character.
   @treturn vn.Character The new character to use for the notebook.
--]]
function extras.flashbackTextStart( name )
   local nw, nh = naev.gfx.dim()
   return fullscreenStart( function ()
      --ft_oldify.shader:addPPShader( "final" )
      vn.setBackground( function ()
         vn.setColor( {0, 0, 0, 1} )
         lg.rectangle("fill", 0, 0, nw, nh )
      end )
   end, {
      name = name or _("Flashback"),
      textcolour = {0.8, 0.8, 0.8},
      font = lg.newFont( 18 )
   } )
end
extras.flashbackTextEnd = fullscreenEnd

return extras
