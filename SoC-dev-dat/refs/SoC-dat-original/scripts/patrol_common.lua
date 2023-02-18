--[[

	Common functions for patrol missions.

]]--

include("proximity.lua")
include("numstring.lua")

-- Filter function
function filter( func, tbl )
	local ntbl = {}
	for i=1,#tbl do
		if func( tbl[i] ) then
			ntbl[ #ntbl+1 ] = tbl[i]
		end
	end
	return ntbl
end

-- Creates a target
function create_target( sys, target, type )
	return { sys = sys, data = target, type = type }
end

-- Checks to see if jump target is interesting
function check_jmp_target( jmp )
	return jmp:presences( f_dvaered ) ~= nil
end

-- Checks to see if planet target is interesting
function check_pnt_target( pnt )
	return pnt:faction() == f_dvaered or rnd.rnd() > 0.5
end

-- Compares two targets
function tgt_cmp( a, b )
	if a.type ~= b.type then
		return false
	end
	return a.data == b.data
end

-- Checks to see if a target is in a list
function tgt_inList( list, a )
	for _,v in ipairs(list) do
		if tgt_cmp( v, a ) then
			return true
		end
	end
	return false
end

-- Gets the available targets
function get_avail_targets( from, list )
	-- Get local point
	local sys   = from.sys

	-- Create possible targets
	local jumps   = filter( check_jmp_target, sys:adjacentSystems() )
	local planets = filter( check_pnt_target, sys:planets() )

	-- Create list
	local targets = {}
	for _,v in ipairs(jumps) do
		local t = create_target( sys, v, "jump" )
		if not tgt_inList( list, t ) then
			targets[ #targets+1 ] = t
		end
	end
	for _,v in ipairs(planets) do
		local t = create_target( sys, v, "planet" )
		if not tgt_inList( list, t ) then
			targets[ #targets+1 ] = t
		end
	end

	-- Special case it's a jump, we can look at the other side
	if from.type == "jump" then
		local t = create_target( from.data, sys, "jump" )
		if not tgt_inList( list, t ) then
			targets[ #targets+1 ] = t
		end
	end

	return targets
end

-- Prints a target when debugging
function tgt_print( tgt )
	print( string.format( "Target: type=%s, target=%s, sys=%s",
			tgt.type, tostring(tgt.data), tostring(tgt.sys) ) )
end

-- Gets a string for the target
function tgt_str( tgt, simple )
	local typename
	if tgt.type == "jump" then
		typename = "Jump Point to"
	else
		-- Numeric classes are for stations.
		if tonumber( tgt.data:class() ) then
			typename = "Station"
		else
			typename = "Planet"
		end
	end
	if simple then
		return string.format( "%s %s", typename, tgt.data:name() )
	else
		return string.format( "%s %s in the %s system", typename,
				tgt.data:name(), tgt.sys:name() )
	end
end

-- Creates a path, includes the starting point
function create_path( from, n )
	local list = { from }
	for i=1,n do
		local tgts = get_avail_targets( from, list )
		if #tgts == 0 then
			return list
		end
		list[ #list+1 ] = tgts[ rnd.rnd( 1, #tgts ) ]
		from = list[ #list ]
	end
	return list
end

function filter( func, tbl )
	local ntbl = {}
	for i=1,#tbl do
		if func( tbl[i] ) then
			ntbl[ #ntbl+1 ] = tbl[i]
		end
	end
	return ntbl
end

function tgt_get_sys( tgt_list )
	local tgt_sys = {}
	for _,v in ipairs(tgt_list) do
		local sys = v.sys
		local found = false
		for _,s in ipairs(tgt_sys) do
			if s == sys then
				found = true
				break
			end
		end
		if not found then
			tgt_sys[ #tgt_sys+1 ] = sys
		end
	end
	return tgt_sys
end

function tgt_getPos( tgt )
	if tgt.type == "jump" then
		return jump.pos(system.cur(), tgt.data)
	else
		return tgt.data:pos()
	end
end
