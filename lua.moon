-----------------------------------------------------------------
-- muun - moonscript compatible class implementation
-- Copyright 2019 megagrump@pm.me
-- License: MIT. See LICENSE for details
-----------------------------------------------------------------

setup = (__name, __parent, __base) ->
	mt =
		__call: (...) =>
			obj = setmetatable({}, __base)
			@.__init(obj, ...)
			obj
		__newindex: (key, value) => __base[key] = value
	__base.new or= =>

	setmetatable({
		:__name, :__base, :__parent, __init: (...) -> __base.new(...)
	}, mt), mt

extend = (name, parent, base) ->
	setmetatable(base, parent.__base)

	cls, mt = setup(name, parent, base)
	base.__class, base.__index = cls, base

	mt.__index = (key) =>
			val = rawget(base, key)

			if val ~= nil 
				return val
			else 
				return parent[key]

	parent.__inherited(parent, cls) if parent.__inherited
	cls

muun =
	super: (...) => @.__class.__parent.__init(@, ...)

setmetatable(muun, {
	__call: (name, parentOrBase, base) =>
		error("Invalid class name") if type(name) ~= 'string'

		parent = parentOrBase if type(parentOrBase) == 'table' and parentOrBase.__class
		base = not parent and parentOrBase or base or {}
		return extend(name, parent, base) if parent

		cls, mt = setup(name, nil, base)
		mt.__index, base.__class, base.__index = base, cls, base
		cls
})
