local function count_classes( pilots )
   local class_count = {}
   for i, p in ipairs(pilots) do
      local pc = p:ship():class()
      if class_count[pc] == nil then
         class_count[pc] = 1
      else
         class_count[pc] = class_count[pc] + 1
      end
   end
   return class_count
end

local formations = {}
local keys = {}
local names = {}

keys[#keys + 1] = "cross"
names[#names + 1] = p_("formation", "Cross")
formations[keys[#keys]] = function (leader)
   local pilots = leader:followers()
   -- Cross logic. Forms an X.
   local angle = math.pi/4 -- Spokes start rotated at a 45 degree angle.
   local radius = 100 -- First ship distance.
   for i, p in ipairs(pilots) do
      leader:msg(p, "form-pos", {angle, radius})
      angle = math.fmod(angle + math.pi/2, 2*math.pi) -- Rotate spokes by 90 degrees.
      radius = 100 * (math.floor(i / 4) + 1) -- Increase the radius every 4 positions.
   end
end

keys[#keys + 1] = "buffer"
names[#names + 1] = p_("formation", "Buffer")
formations[keys[#keys]] = function (leader)
   -- Buffer logic. Consecutive arcs emanating from the fleader. Stored as polar coordinates.
   local pilots = leader:followers()
   local class_count = count_classes(pilots)
   local angle, radius

   local radii = {["Yacht"] = -300,
                  ["Courier"] = -250,
                  ["Freighter"] = -100,
                  ["Bulk Freighter"] = -100,
                  ["Armoured Transport"] = -200,
                  ["Carrier"] = 100,
                  ["Battleship"] = 100,
                  ["Cruiser"] = 200,
                  ["Destroyer"] = 300,
                  ["Corvette"] = 400,
                  ["Bomber"] = 500,
                  ["Fighter"] = 700,
                  ["Interceptor"] = 800,
                  ["Scout"] = 900 } -- Different radii for each class.
   local count = {["Yacht"] = 1,
                  ["Courier"] = 1,
                  ["Freighter"] = 1,
                  ["Bulk Freighter"] = 1,
                  ["Armoured Transport"] = 1,
                  ["Carrier"] = 1,
                  ["Battleship"] = 1,
                  ["Cruiser"] = 1,
                  ["Destroyer"] = 1,
                  ["Corvette"] = 1,
                  ["Bomber"] = 1,
                  ["Fighter"] = 1,
                  ["Interceptor"] = 1,
                  ["Scout"] = 1 } -- Need to keep track of positions already iterated through.
   for i, p in ipairs(pilots) do
      local ship_class = p:ship():class() -- For readability.
      if class_count[ship_class] == 1 then -- If there's only one ship in this specific class...
         angle = 0 --The angle needs to be zero.
      else -- If there's more than one ship in each class...
         angle = ((count[ship_class]-1)/(class_count[ship_class]-1))*math.pi/2 - math.pi/4 -- ..the angle rotates from -45 degrees to 45 degrees, assigning coordinates at even intervals.
         count[ship_class] = count[ship_class] + 1 --Update the count
      end
      radius = radii[ship_class] --Assign the radius, defined above.
      leader:msg(p, "form-pos", {angle, radius})
   end
end

keys[#keys + 1] = "vee"
names[#names + 1] = p_("formation", "Vee")
formations[keys[#keys]] = function (leader)
   -- The vee formation forms a v, with the fleader at the apex, and the arms extending in front.
   local pilots = leader:followers()
   local angle = math.pi/4 -- Arms start at a 45 degree angle.
   local radius = 100 -- First ship distance.
   for i, p in ipairs(pilots) do
      leader:msg(p, "form-pos", {angle, radius})
      angle = angle * -1 -- Flip the arms between -45 and 45 degrees.
      radius = 100 * (math.floor(i / 2) + 1) -- Increase the radius every 2 positions.
   end
end

keys[#keys + 1] = "wedge"
names[#names + 1] = p_("formation", "Wedge")
formations[keys[#keys]] = function (leader)
   -- The wedge formation forms a v, with the fleader at the apex, and the arms extending out back.
   local pilots = leader:followers()
   local flip = -1
   local angle
   local radius = 100 -- First ship distance.
   for i, p in ipairs(pilots) do
      angle = (flip * math.pi/4) + math.pi -- Flip the arms between 135 and 225 degrees.
      leader:msg(p, "form-pos", {angle, radius})
      flip = flip * -1
      radius = 100 * (math.floor(i / 2) + 1) -- Increase the radius every 2 positions.
   end
end

keys[#keys + 1] = "echelon_left"
names[#names + 1] = p_("formation", "Echelon Left")
formations[keys[#keys]] = function (leader)
   --This formation forms a "/", with the fleader in the middle.
   local pilots = leader:followers()
   local radius = 100
   local flip = -1
   local angle
   for i, p in ipairs(pilots) do
      angle = math.rad(135 + (90 * flip))  --Flip between 45 degrees and 225 degrees.
      leader:msg(p, "form-pos", {angle, radius})
      flip = flip * -1
      radius = 100 * (math.ceil((i+1) / 2)) -- Increase the radius every 2 positions
   end
end

keys[#keys + 1] = "echelon_right"
names[#names + 1] = p_("formation", "Echelon Right")
formations[keys[#keys]] = function (leader)
   --This formation forms a "\", with the fleader in the middle.
   local pilots = leader:followers()
   local radius = 100
   local flip = 1
   local angle
   for i, p in ipairs(pilots) do
      angle = math.rad(225 + (90 * flip)) --Flip between 315 degrees, and 135 degrees
      leader:msg(p, "form-pos", {angle, radius})
      flip = flip * -1
      radius = 100 * (math.ceil((i+1) / 2))
   end
end

keys[#keys + 1] = "column"
names[#names + 1] = p_("formation", "Column")
formations[keys[#keys]] = function (leader)
   --This formation is a simple "|", with fleader in the middle.
   local pilots = leader:followers()
   local radius = 100
   local flip = -1
   local angle
   for i, p in ipairs(pilots) do
      angle = math.pi * (1+flip)/2  --flip between 0 degrees and 180 degrees
      leader:msg(p, "form-pos", {angle, radius})
      flip = flip * -1
      radius = 100 * (math.ceil((i+1)/2)) --Increase the radius every 2 ships.
   end
end

keys[#keys + 1] = "wall"
names[#names + 1] = p_("formation", "Wall")
formations[keys[#keys]] = function (leader)
   --This formation is a "-", with the fleader in the middle.
   local pilots = leader:followers()
   local radius = 100
   local flip = -1
   local angle
   for i, p in ipairs(pilots) do
      angle = math.pi + (math.pi/2 * flip) --flip between 90 degrees and 270 degrees
      leader:msg(p, "form-pos", {angle, radius})
      flip = flip * -1
      radius = 100 * (math.ceil((i+1)/2)) --Increase the radius every 2 ships.
   end
end

keys[#keys + 1] = "fishbone"
names[#names + 1] = p_("formation", "Fishbone")
formations[keys[#keys]] = function (leader)
   local pilots = leader:followers()
   local radius = 500
   local flip = -1
   local orig_radius = radius
   local angle
   for i, p in ipairs(pilots) do
      angle = math.rad(22.5 * flip) / (radius / orig_radius)
      leader:msg(p, "form-pos", {angle, radius})
      if flip == 0 then
         flip = -1
         radius = (orig_radius * (math.ceil((i+1)/3))) + ((orig_radius * (math.ceil((i+1)/3))) / 30)
      elseif flip == -1 then
         flip = 1
      elseif flip == 1 then
         flip = 0
         radius = orig_radius * (math.ceil((i+1)/3))
      end
   end
end

keys[#keys + 1] = "chevron"
names[#names + 1] = p_("formation", "Chevron")
formations[keys[#keys]] = function (leader)
   local pilots = leader:followers()
   local radius = 500
   local flip = -1
   local orig_radius = radius
   local angle
   for i, p in ipairs(pilots) do
      angle = math.rad(22.5 * flip) / (radius / orig_radius)
      leader:msg(p, "form-pos", {angle, radius})
      if flip == 0 then
         flip = -1
         radius = (orig_radius * (math.ceil((i+1)/3))) - ((orig_radius * (math.ceil((i+1)/3))) / 20)
      elseif flip == -1 then
         flip = 1
      elseif flip == 1 then
         flip = 0
         radius = orig_radius * (math.ceil((i+1)/3))
      end
   end
end

keys[#keys + 1] = "circle"
names[#names + 1] = p_("formation", "Circle")
formations[keys[#keys]] = function (leader)
   -- Default to circle.
   local pilots = leader:followers()
   local angle = 2*math.pi / #pilots -- The angle between each ship, in radians.
   local radius = 80 + #pilots * 25 -- Pulling these numbers out of my ass. The point being that more ships mean a bigger circle.
   for i, p in ipairs(pilots) do
      leader:msg(p, "form-pos", {angle * i, radius, "absolute"})
   end
end

formations.keys = keys
formations.names = names
if #keys ~= #names then
   warn(_("The size of formation.keys doesn't match the size of formation.names!"))
end

-- Clear formation; not really a 'formation' so it is not in keys
function formations.clear(leader)
   leader:msg(leader:followers(), "form-pos", nil)
end

function formations.random_key()
   return keys[rnd.rnd(1, #keys)]
end


-- Custom formation, used only in missions go there

-- Custom large circle
function formations.circleLarge(leader)
   local pilots = leader:followers()
   local angle = 2*math.pi / #pilots -- The angle between each ship, in radians.
   local radius = 1500
   for i, p in ipairs(pilots) do
      leader:msg(p, "form-pos", {angle * i, radius, "absolute"})
   end
end


return formations
