-----------------------------------------------------------------------------------------------------------------------
--                                                Signals config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local signals = {}

-- Support functions
-----------------------------------------------------------------------------------------------------------------------
local function do_sloppy_focus(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
		client.focus = c
	end
end

local function fixed_maximized_geometry(c, context)
	if c.maximized and context ~= "fullscreen" then
		c:geometry({
			x = c.screen.workarea.x,
			y = c.screen.workarea.y,
			height = c.screen.workarea.height - 2 * c.border_width,
			width = c.screen.workarea.width - 2 * c.border_width
		})
	end
end

local function border_width_check(c)
	if not c.maximized and not c.rule_borderless then
		c.border_width = beautiful.border_width
	else
		c.border_width = 0
	end
end

-- set rounded corners for non-maximized clients
local function rounded_corners_check(c)
	local border_radius = beautiful.border_radius or 0
	if not c.maximized then
		c.shape = function(cr,w,h)
			gears.shape.rounded_rect(cr, w, h, border_radius)
		end
	else
		c.shape = gears.shape.rect
	end
end

-- Build  table
-----------------------------------------------------------------------------------------------------------------------
function signals:init(args)

	local args = args or {}
	local env = args.env

	-- actions on every application start
	client.connect_signal(
		"manage",
		function(c)
			-- put client at the end of list
			if env.set_slave then awful.client.setslave(c) end

			-- startup placement
			if awesome.startup
			   and not c.size_hints.user_position
			   and not c.size_hints.program_position
			then
				awful.placement.no_offscreen(c)
			end

			border_width_check(c)
			rounded_corners_check(c)
		end
	)

	-- add missing borders to windows that get unmaximized
	client.connect_signal(
		"property::maximized",
		function(c)
			border_width_check(c)
			rounded_corners_check(c)
		end
	)

	-- don't allow maximized windows move/resize themselves
	client.connect_signal(
		"request::geometry", fixed_maximized_geometry
	)

	-- enable sloppy focus, so that focus follows mouse
	if env.sloppy_focus then
		client.connect_signal("mouse::enter", do_sloppy_focus)
	end
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return signals
