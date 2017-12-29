-----------------------------------------------------------------------------------------------------------------------
--                                                Signals config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local beautiful = require("beautiful")


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
		end
	)

	-- add missing borders to windows that get unmaximized
	client.connect_signal(
		"property::maximized",
		function(c)
			if not c.maximized then
				c.border_width = beautiful.border_width
			end
		end
	)

	-- don't let maximized windows move/resize themselves
	client.connect_signal(
		"request::geometry",
		function(c)
			if c.maximized then
				c.height = c.screen.workarea.height - 2 * c.border_width
				c.width = c.screen.workarea.width - 2 * c.border_width
				c.x = c.screen.workarea.x
				c.y = c.screen.workarea.y
			end
		end
	)

	-- enable sloppy focus, so that focus follows mouse
	if env.sloppy_focus then
		client.connect_signal("mouse::enter", do_sloppy_focus)
	end

	-- hilight border of focused window
	-- can be disabled since focus indicated by titlebars in current config
	if env.color_border_focus then
		client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
		client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
	end

	-- Awesome v4.0 introduce screen handling without restart.
	-- Since I'm using single monitor setup and I'm too lazy to rework my panel widgets for this new feature,
	-- simple adding signal to restart wm on new monitor pluging.
	-- For reference, screen-dependent widgets are
	-- redflat.widget.layoutbox, redflat.widget.taglist, redflat.widget.tasklist
	screen.connect_signal("list", awesome.restart)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return signals
