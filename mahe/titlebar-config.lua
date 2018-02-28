-----------------------------------------------------------------------------------------------------------------------
--                                               Titlebar config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local wibox = require("wibox")

-- local redflat = require("redflat")
local redtitle = require("redflat.titlebar")
local clientmenu = require("redflat.float.clientmenu")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local titlebar = {}

-- Support functions
-----------------------------------------------------------------------------------------------------------------------
local function title_buttons(c)
	return awful.util.table.join(
		awful.button(
			{ }, 1,
			function()
				client.focus = c;  c:raise()
				awful.mouse.client.move(c)
			end
		),
		awful.button(
			{ }, 2,
			function()
				c.minimized = true
			end
		),
		awful.button(
			{ }, 3,
			function()
				client.focus = c;  c:raise()
				clientmenu:show(c)
			end
		)
	)
end

local function on_maximize(c)
	-- hide/show title bar
	local is_max = c.maximized_vertical or c.maximized
	local action = is_max and "cut_all" or "restore_all"
	redtitle[action]({ c })

	-- dirty size correction
	local model = redtitle.get_model(c)
	if model and not model.hidden then
		c.height = c:geometry().height + (is_max and model.size or -model.size)
		if is_max then c.y = c.screen.workarea.y end
	end
end

-- Connect titlebar building signal
-----------------------------------------------------------------------------------------------------------------------
function titlebar:init(args)

	local args = args or {}
	local style = {}

	style.light = args.light or redtitle.get_style()
	style.full = args.full or { size = 22, icon = { size = 4, gap = 4, angle = 0.0 } }

	clientmenu:init()

	client.connect_signal(
		"request::titlebars",
		function(c)
			-- build titlebar and mouse buttons for it
			local buttons = title_buttons(c)
			local bar = redtitle(c)

			-- build light titlebar model
			local light = wibox.widget({
					redtitle.icon.focus(c),
					layout = wibox.container.margin,
					buttons = buttons,
			})

			-- build full titlebar model
			local full = wibox.widget({
				{
					redtitle.icon.focus(c, style.full),
					right = style.full.icon.gap,
					layout  = wibox.container.margin,
				},
				redtitle.icon.label(c, style.full),
				{
					redtitle.icon.focus(c, style.full),
					left = style.full.icon.gap,
					layout  = wibox.container.margin,
				},
				buttons = buttons,
				layout  = wibox.layout.align.horizontal,
			})

			-- Set both models to titlebar
			redtitle.add_layout(c, nil, full, style.full.size)
			redtitle.add_layout(c, nil, light)

			-- hide titlebar when window maximized
			if c.maximized_vertical or c.maximized then on_maximize(c) end

			c:connect_signal("property::maximized_vertical", on_maximize)
			c:connect_signal("property::maximized", on_maximize)
		end
	)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return titlebar
