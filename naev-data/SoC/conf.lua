-- START GENERATED SECTION
-- The contents of this section will be rewritten by Naev!

-- The location of Naev's data pack, usually called 'ndata'
data = "\\naev.exe"

-- Language to use. Set to the two character identifier to the language (e.g., "en" for English), and nil for autodetect.
language = "en"

-- Global difficulty to set the game to. Can be overwritten by saved game settings. Has to match one of the difficulties defined in "difficulty.xml" in the data files.
-- difficulty = nil

-- The factor to use in Full-Scene Anti-Aliasing
-- Anything lower than 2 will simply disable FSAA
fsaa = 1

-- Synchronize framebuffer updates with the vertical blanking interval
vsync = false

-- The window size or screen resolution
-- Set both of these to 0 to make Naev try the desktop resolution
width = 0
height = 0

-- Factor used to divide the above resolution with
-- This is used to lower the rendering resolution, and scale to the above
scalefactor = 1.000000

-- Scale factor for rendered nebula backgrounds.
-- Larger values can save time but lead to a blurrier appearance.
nebu_scale = 4.000000

-- Run Naev in full-screen mode
fullscreen = false

-- Use video modesetting when fullscreen is enabled
modesetting = false

-- Disable allowing resizing the window.
notresizable = false

-- Disable window decorations. Use with care and know the keyboard controls to quit and toggle fullscreen.
borderless = false

-- Minimize the game on focus loss.
minimize = true

-- Enables colourblind mode. Good for simulating colourblindness.
colorblind = false

-- Enable health bars. These show hostility/friendliness and health of pilots on screen.
healthbars = true

-- Background brightness. 1 is normal brightness while setting it to 0 would make the backgrounds pitch black.
bg_brightness = 0.500000

-- Nebula non-uniformity. 1 is normal nebula while setting it to 0 would make the nebula a solid colour.
nebu_nonuniformity = 1.000000

-- Controls the intensity to which the screen fades when jumping. 1.0 would be pure white, while 0.0 would be pure black.
jump_brightness = 1.000000

-- Gamma correction parameter. A value of 1 disables it (no curve).
gamma_correction = 1.000000

-- Expensive high quality shaders for the background. Defaults to false.
background_fancy = false

-- Display a frame rate counter
showfps = false

-- Limit the rendering frame rate
maxfps = 60

-- Show 'PAUSED' on screen while paused
showpause = true

-- Enables EFX extension for OpenAL backend.
al_efx = true

-- Disable all sound
nosound = false

-- Volume of sound effects and music, between 0.0 and 1.0
sound = 0.600000
music = 0.800000
-- Relative engine sound volume. Should be between 0.0 and 1.0
engine_vol = 0.800000

-- The name or numeric index of the joystick to use
-- Setting this to nil disables the joystick support
joystick = nil

-- Number of lines visible in the comm window.
mesg_visible = 5
-- Opacity fraction (0-1) for the overlay map.
map_overlay_opacity = 0.300000
-- Use bigger icons in the outfit, shipyard, and other lists.
big_icons = false
-- Always show the radar and don't hide it when the overlay is active.
always_radar = false

-- Delay in ms before starting to repeat (0 disables)
repeat_delay = 500
-- Delay in ms between repeats once it starts to repeat
repeat_freq = 30

-- Minimum and maximum zoom factor to use in-game
-- At 1.0, no sprites are scaled
-- zoom_far should be less then zoom_near
zoom_manual = false
zoom_far = 0.500000
zoom_near = 1.000000

-- Zooming speed in factor increments per second
zoom_speed = 0.250000

-- Zooming modulation factor for the starry background
zoom_stars = 1.000000

-- Font sizes (in pixels) for Naev
-- Warning, setting to other than the default can cause visual glitches!
-- Console default: 10
font_size_console = 10
-- Intro default: 18
font_size_intro = 18
-- Default size: 12
font_size_def = 12
-- Small size: 11
font_size_small = 11
-- Sets the velocity (px/s) to compress up to when time compression is enabled.
compression_velocity = 5000.000000

-- Sets the multiplier to compress up to when time compression is enabled.
compression_mult = 200.000000

-- Redirects log and error output to files
redirect_file = true

-- Enables compression on saved games
save_compress = false

-- Doubletap sensitivity (used for double tap accel for afterburner or double tap reverse for cooldown)
doubletap_sensitivity = 250

-- Whether or not clicking the middle mouse button toggles mouse flying mode.
mouse_fly = true

-- Mouse-flying thrust control
mouse_thrust = 1

-- Maximum interval to count as a double-click (0 disables).
mouse_doubleclick = 0.500000

-- Enemy distance at which autonav speed resets.
autonav_reset_dist = 5000.000000

-- Shield value at which autonav speed resets.
autonav_reset_shield = 1.000000

-- Enables developer mode (universe editor and the likes)
devmode = true

-- Automatic saving for when using the universe editor whenever an edit is done
devautosave = false

-- Enable the lua-enet library, for use by online/multiplayer mods (CAUTION: online Lua scripts may have security vulnerabilities!)
lua_enet = false
-- Enable the experimental CLI based on lua-repl.
lua_repl = false

-- Save the config every time game exits (rewriting this bit)
conf_nosave = 0

-- Indicates the last version the game has run in before
lastversion = "0.10.4+dev"

-- Indicates whether we've already warned about incomplete game translations.
translation_warning_seen = true

-- Time Naev was last played. This gets refreshed each time you exit Naev.
last_played = 1676802502

-- Enables FPU exceptions - only works on DEBUG builds
fpu_except = false

-- Paths for saving different files from the editor
dev_save_sys = "../dat/ssys/"
dev_save_map = "../dat/outfits/maps/"
dev_save_spob = "../dat/spob/"


-- Keybindings

-- Makes your ship accelerate forward.
accel = { type = "keyboard", mod = "none", key = "Up" }
-- Makes your ship turn left.
left = { type = "keyboard", mod = "none", key = "Left" }
-- Makes your ship turn right.
right = { type = "keyboard", mod = "none", key = "Right" }
-- Makes your ship face the direction you're moving from. Useful for braking.
reverse = { type = "keyboard", mod = "none", key = "Down" }
-- Tries to enter stealth mode.
stealth = { type = "keyboard", mod = "none", key = "F" }
-- Cycles through ship targets.
target_next = { type = "keyboard", mod = "ctrl", key = "E" }
-- Cycles backwards through ship targets.
target_prev = { type = "keyboard", mod = "ctrl", key = "Q" }
-- Targets the nearest non-disabled ship.
target_nearest = { type = "keyboard", mod = "any", key = "T" }
-- Cycles through hostile ship targets.
target_nextHostile = "none"
-- Cycles backwards through hostile ship targets.
target_prevHostile = "none"
-- Targets the nearest hostile ship.
target_hostile = { type = "keyboard", mod = "any", key = "R" }
-- Clears the currently-targeted ship, spob or jump point.
target_clear = { type = "keyboard", mod = "any", key = "C" }
-- Fires primary weapons.
primary = { type = "keyboard", mod = "any", key = "Space" }
-- Faces the targeted ship if one is targeted, otherwise faces targeted spob or jump point.
face = { type = "keyboard", mod = "none", key = "Q" }
-- Attempts to board the targeted ship.
board = { type = "keyboard", mod = "none", key = "B" }
-- Fires secondary weapons.
secondary = { type = "keyboard", mod = "any", key = "Left Shift" }
-- Activates weapon set 1.
weapset1 = { type = "keyboard", mod = "any", key = "1" }
-- Activates weapon set 2.
weapset2 = { type = "keyboard", mod = "any", key = "2" }
-- Activates weapon set 3.
weapset3 = { type = "keyboard", mod = "any", key = "3" }
-- Activates weapon set 4.
weapset4 = { type = "keyboard", mod = "any", key = "4" }
-- Activates weapon set 5.
weapset5 = { type = "keyboard", mod = "any", key = "5" }
-- Activates weapon set 6.
weapset6 = { type = "keyboard", mod = "any", key = "6" }
-- Activates weapon set 7.
weapset7 = { type = "keyboard", mod = "any", key = "7" }
-- Activates weapon set 8.
weapset8 = { type = "keyboard", mod = "any", key = "8" }
-- Activates weapon set 9.
weapset9 = { type = "keyboard", mod = "any", key = "9" }
-- Activates weapon set 0.
weapset0 = { type = "keyboard", mod = "any", key = "0" }
-- Cycles through your escorts.
e_targetNext = "none"
-- Cycles backwards through your escorts.
e_targetPrev = "none"
-- Orders escorts to attack your target.
e_attack = { type = "keyboard", mod = "any", key = "End" }
-- Orders escorts to hold their formation.
e_hold = { type = "keyboard", mod = "any", key = "Insert" }
-- Orders escorts to return to your ship hangars.
e_return = { type = "keyboard", mod = "any", key = "Delete" }
-- Clears your escorts of commands.
e_clear = { type = "keyboard", mod = "any", key = "Home" }
-- Initializes the autonavigation system.
autonav = { type = "keyboard", mod = "ctrl", key = "J" }
-- Cycles through spob targets.
target_spob = { type = "keyboard", mod = "none", key = "P" }
-- Attempts to land on the targeted spob or targets the nearest landable spob. Requests permission if necessary.
land = { type = "keyboard", mod = "none", key = "L" }
-- Cycles through jump points.
thyperspace = { type = "keyboard", mod = "none", key = "H" }
-- Opens the star map.
starmap = { type = "keyboard", mod = "none", key = "M" }
-- Attempts to jump via a jump point.
jump = { type = "keyboard", mod = "none", key = "J" }
-- Opens the in-system overlay map.
overlay = { type = "keyboard", mod = "any", key = "Tab" }
-- Toggles mouse flying.
mousefly = { type = "keyboard", mod = "ctrl", key = "X" }
-- Begins active cooldown.
cooldown = { type = "keyboard", mod = "ctrl", key = "S" }
-- Scrolls the log upwards.
log_up = { type = "keyboard", mod = "any", key = "PageUp" }
-- Scrolls the log downwards.
log_down = { type = "keyboard", mod = "any", key = "PageDown" }
-- Attempts to initialize communication with the targeted ship.
hail = { type = "keyboard", mod = "none", key = "Y" }
-- Automatically initialize communication with a ship that is hailing you.
autohail = { type = "keyboard", mod = "ctrl", key = "Y" }
-- Zooms in on the radar.
mapzoomin = { type = "keyboard", mod = "any", key = "Keypad +" }
-- Zooms out on the radar.
mapzoomout = { type = "keyboard", mod = "any", key = "Keypad -" }
-- Takes a screenshot.
screenshot = { type = "keyboard", mod = "any", key = "Keypad *" }
-- Toggles between windowed and fullscreen mode.
togglefullscreen = { type = "keyboard", mod = "any", key = "F11" }
-- Pauses the game.
pause = { type = "keyboard", mod = "any", key = "Pause" }
-- Toggles speed modifier.
speed = { type = "keyboard", mod = "any", key = "`" }
-- Opens the small in-game menu.
menu = { type = "keyboard", mod = "any", key = "Escape" }
-- Opens the information menu.
info = { type = "keyboard", mod = "none", key = "I" }
-- Opens the Lua console.
console = { type = "keyboard", mod = "any", key = "F2" }
-- Switches to tab 1.
switchtab1 = { type = "keyboard", mod = "alt", key = "1" }
-- Switches to tab 2.
switchtab2 = { type = "keyboard", mod = "alt", key = "2" }
-- Switches to tab 3.
switchtab3 = { type = "keyboard", mod = "alt", key = "3" }
-- Switches to tab 4.
switchtab4 = { type = "keyboard", mod = "alt", key = "4" }
-- Switches to tab 5.
switchtab5 = { type = "keyboard", mod = "alt", key = "5" }
-- Switches to tab 6.
switchtab6 = { type = "keyboard", mod = "alt", key = "6" }
-- Switches to tab 7.
switchtab7 = { type = "keyboard", mod = "alt", key = "7" }
-- Switches to tab 8.
switchtab8 = { type = "keyboard", mod = "alt", key = "8" }
-- Switches to tab 9.
switchtab9 = { type = "keyboard", mod = "alt", key = "9" }
-- Switches to tab 0.
switchtab0 = { type = "keyboard", mod = "alt", key = "0" }
-- Paste from the operating system's clipboard.
paste = { type = "keyboard", mod = "ctrl", key = "V" }

-- END GENERATED SECTION
