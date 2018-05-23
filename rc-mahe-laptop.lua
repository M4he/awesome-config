-----------------------------------------------------------------------------------------------------------------------
--                                                    Blue config                                                    --
-----------------------------------------------------------------------------------------------------------------------

-- Load modules
-----------------------------------------------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("awful.autofocus")

-- User modules
------------------------------------------------------------
local redflat = require("redflat")

-- global module
timestamp = require("redflat.timestamp")

-- Error handling
-----------------------------------------------------------------------------------------------------------------------
require("mahe.ercheck-config") -- load file with error handling


-- Setup theme and environment vars
-----------------------------------------------------------------------------------------------------------------------
local env = require("mahe.env-config") -- load file with environment
env:init({ theme = "mahe" })


-- Layouts setup
-----------------------------------------------------------------------------------------------------------------------
local layouts = require("mahe.layout-config") -- load file with tile layouts setup
layouts:init()


-- Main menu configuration
-----------------------------------------------------------------------------------------------------------------------
local mymenu = require("mahe.menu-config") -- load file with menu configuration
mymenu:init({ env = env })


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- Separator
--------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

-- load list of app name aliases from files and set it as part of tasklist theme
tasklist.style = { appnames = require("mahe.alias-config")}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	awful.button({}, 2, redflat.widget.tasklist.action.close),
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { separator = separator, widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
	awful.button({         }, 1, function(t) t:view_only() end),
	awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
	awful.button({         }, 2, awful.tag.viewtoggle),
	awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
	awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
	awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock({ timeformat = "%d. %b %H:%M", dateformat = "%d. %b %a" })

textclock.buttons = awful.util.table.join(
	awful.button({}, 1, function() awful.spawn("gsimplecal") end)
)

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
	awful.button({ }, 1, function () mymenu.mainmenu:toggle() end),
	awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
	awful.button({ }, 4, function () awful.layout.inc( 1) end),
	awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray({ timeout = 10 })

tray.buttons = awful.util.table.join(
	awful.button({}, 1, function() redflat.widget.minitray:toggle() end)
)

-- PA volume control
--------------------------------------------------------------------------------
local volume = {}
volume.widget = redflat.widget.pulse({ timeout = 3, autoupdate = true }, { widget = redflat.gauge.audio.blue.new })

-- right bottom corner position
local rb_corner = function()
	return { x = screen[mouse.screen].workarea.x + screen[mouse.screen].workarea.width,
	         y = screen[mouse.screen].workarea.y + screen[mouse.screen].workarea.height }
end

-- activate player widget
redflat.float.player:init({ name = env.player })

volume.buttons = awful.util.table.join(
	awful.button({}, 4, function() redflat.widget.pulse:change_volume()                end),
	awful.button({}, 5, function() redflat.widget.pulse:change_volume({ down = true }) end),
	awful.button({}, 2, function() redflat.widget.pulse:mute()                         end),
	awful.button({}, 3, function() redflat.float.player:show(rb_corner())                         end),
	awful.button({}, 1, function() redflat.float.player:action("PlayPause")            end),
	awful.button({}, 8, function() redflat.float.player:action("Previous")             end),
	awful.button({}, 9, function() redflat.float.player:action("Next")                 end)
)


-- System resource monitoring widgets
--------------------------------------------------------------------------------
local sysmon = { widget = {}, buttons = {}, icon = {} }

-- icons
sysmon.icon.battery = redflat.util.table.check(beautiful, "icon.widget.battery")
sysmon.icon.network = redflat.util.table.check(beautiful, "icon.widget.wireless")
sysmon.icon.cpuram = redflat.util.table.check(beautiful, "icon.widget.monitor")

-- battery
sysmon.widget.battery = redflat.widget.sysmon(
	{ func = redflat.system.pformatted.bat(25), arg = "BAT0" },
	{ timeout = 60, widget = redflat.gauge.icon.single, monitor = { is_vertical = true, icon = sysmon.icon.battery } }
)

-- CPU usage
sysmon.widget.cpu = redflat.widget.sysmon(
	{ func = redflat.system.pformatted.cpu(80) },
	{ timeout = 2, monitor = { label = "CPU" } }
)

sysmon.buttons.cpu = awful.util.table.join(
	awful.button({ }, 1, function() redflat.float.top:show("cpu") end)
)

-- RAM usage
sysmon.widget.ram = redflat.widget.sysmon(
	{ func = redflat.system.pformatted.mem(80) },
	{ timeout = 10, monitor = { label = "RAM" } }
)

sysmon.buttons.ram = awful.util.table.join(
	awful.button({ }, 1, function() redflat.float.top:show("mem") end)
)



-- Wallpaper setup
-----------------------------------------------------------------------------------------------------------------------

-- redraw the wallpaper(s) on the root window according to the current layout
local function draw_wallpaper()
	awful.spawn.with_shell("nitrogen --restore")
end

-- draw wallpaper initially after startup
draw_wallpaper()

-- redraw wallpaper if screen layout/size changes
screen.connect_signal("property::geometry", function()
	draw_wallpaper()
end)


-- Screen setup
-----------------------------------------------------------------------------------------------------------------------

-- aliases for setup
local al = awful.layout.layouts

-- panel opacity
local wibar_opacity = beautiful.panel_opacity or 1.0

-- setup
awful.screen.connect_for_each_screen(
	function(s)
		-- wallpaper (DEPRECATED in favor of nitrogen)
		-- env.wallpaper(s)

		-- tags
		if screen.primary.index == s.index then
			-- PRIMARY SCREEN
			awful.tag({ "Main", "Com", "Code", "Tile", "Free" }, s, { al[2], al[6], al[2], al[2], al[1] })

			-- layoutbox widget
			layoutbox[s] = redflat.widget.layoutbox({ screen = s })

			-- taglist widget
			taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

			-- tasklist widget
			tasklist[s] = redflat.widget.tasklist({ screen = s, buttons = tasklist.buttons }, tasklist.style)

			-- panel wibox
			s.panel = awful.wibar({ opacity = wibar_opacity, position = "bottom", ontop = true, screen = s, height = beautiful.panel_height or 36 })

			-- add widgets to the wibox
			s.panel:setup {
				layout = wibox.layout.align.horizontal,
				{ -- left widgets
					layout = wibox.layout.fixed.horizontal,

					env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
					separator,
					env.wrapper(taglist[s], "taglist"),
					separator,
				},
				{ -- middle widget
					layout = wibox.layout.align.horizontal,
					expand = "outside",
					nil,
					env.wrapper(tasklist[s], "tasklist"),
				},
				{ -- right widgets
					layout = wibox.layout.fixed.horizontal,

					separator,
					env.wrapper(volume.widget, "volume", volume.buttons),
					separator,
					env.wrapper(sysmon.widget.cpu, "cpu", sysmon.buttons.cpu),
					separator,
					env.wrapper(sysmon.widget.ram, "ram", sysmon.buttons.ram),
					separator,
					env.wrapper(tray.widget, "tray", tray.buttons),
					separator,
					env.wrapper(sysmon.widget.battery, "battery"),
					separator,
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				},
			}
		else
			-- ANY NON-PRIMARY SCREEN

			awful.tag({ "Main", "Sub" }, s, { al[2], al[1] })

			-- layoutbox widget
			layoutbox[s] = redflat.widget.layoutbox({ screen = s })

			-- taglist widget
			taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

			-- tasklist widget
			tasklist[s] = redflat.widget.tasklist({ screen = s, buttons = tasklist.buttons }, tasklist.style)

			-- panel wibox
			s.panel = awful.wibar({ opacity = wibar_opacity, position = "bottom", ontop = true, screen = s, height = beautiful.panel_height or 36 })

			-- add widgets to the wibox
			s.panel:setup {
				layout = wibox.layout.align.horizontal,
				{ -- left widgets
					layout = wibox.layout.fixed.horizontal,

					env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
					separator,
					env.wrapper(taglist[s], "taglist"),
					separator,
				},
				{ -- middle widget
					layout = wibox.layout.align.horizontal,
					expand = "outside",
					nil,
					env.wrapper(tasklist[s], "tasklist"),
				},
				{ -- right widgets
					layout = wibox.layout.fixed.horizontal,

					separator,
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				},
			}
		end

	end
)

-- ONTOP WIBOX WORKAROUND
-- temporary abandons the panel's ontop property for fullscreen windows
for s=1, screen.count() do
	screen[s]:connect_signal("arrange", function()
		local wibox_ontop = true
		-- check for fullscreen layout
		if awful.layout.get(screen[s]).name == "fullscreen" then
			wibox_ontop = false
		else
		-- check for any fullscreen client
			for _, c in pairs(awful.client.visible(s)) do
				if c.fullscreen then
					wibox_ontop = false
					break
				end
			end
		end
		screen[s].panel.ontop = wibox_ontop
	end)
end


-- Active screen edges
-----------------------------------------------------------------------------------------------------------------------
local edges = require("mahe.edges-config") -- load file with edges configuration
edges:init()


-- Maximized layout optimization
-----------------------------------------------------------------------------------------------------------------------
local maxopti = require("mahe.max-layout-opti")
maxopti:init()


-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = require("mahe.keys-config-laptop") -- load file with hotkeys configuration
hotkeys:init({ env = env, menu = mymenu.mainmenu, quirks = maxopti })


-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require("mahe.rules-config") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})


-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require("mahe.titlebar-config-laptop") -- load file with titlebar configuration
titlebar:init()


-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require("mahe.signals-config") -- load file with signals configuration
signals:init({ env = env })


-- Autostart user applications
-----------------------------------------------------------------------------------------------------------------------
local autostart = require("mahe.autostart-config") -- load file with autostart application list

if timestamp.is_startup() then
	local auto_file = awful.util.get_configuration_dir() .. "mahe/autostart.laptop"
	autostart.run_from_file(auto_file)
	autostart.run()
end

-- we disable aero snap for now
awful.mouse.snap.edge_enabled = false

-- disable the annoying 'busy' mouse cursor when awful.spawn* is used
beautiful.enable_spawn_cursor = false