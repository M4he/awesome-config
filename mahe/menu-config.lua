-----------------------------------------------------------------------------------------------------------------------
--                                                  Menu config                                                      --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local redflat = require("redflat")
local awful = require("awful")
local naughty = require("naughty")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local menu = {}


-- Build function
-----------------------------------------------------------------------------------------------------------------------
function menu:init(args)

	-- vars
	local args = args or {}
	local env = args.env or {} -- fix this?
	local separator = args.separator or { widget = redflat.gauge.separator.horizontal() }
	local theme = args.theme or { auto_hotkey = true }
	local icon_style = args.icon_style or {}

	-- theme vars
	local deficon = redflat.util.base.placeholder()
	local icon = redflat.util.table.check(beautiful, "icon.awesome") and beautiful.icon.awesome or deficon
	local color = redflat.util.table.check(beautiful, "color.icon") and beautiful.color.icon or nil

	-- icon finder
	local function micon(name)
		return nil
	end

	-- Application submenu
	------------------------------------------------------------
	local appmenu = redflat.service.dfparser.menu({ icons = icon_style, wm_name = "awesome" })

	-- Awesome submenu
	------------------------------------------------------------
	local awesomemenu = {
		{ "Restart",         awesome.restart },
		{ "Exit",            awesome.quit },
	}

	-- Places submenu
	------------------------------------------------------------
	local placesmenu = {
		{ "Documents",   env.fm .. " Documents" },
		{ "Downloads",   env.fm .. " Downloads"  },
		{ "Music",       env.fm .. " Music"     },
		{ "Pictures",    env.fm .. " Pictures"  },
		{ "Videos",      env.fm .. " Videos"    },
	}

	-- Exit submenu
	------------------------------------------------------------
	local exitmenu = {
		{ "Reboot",          "reboot"  },
		{ "Switch user",     "dm-tool switch-to-greeter"  },
		{ "Suspend",         "systemctl suspend"  },
		{ "Log out",         awesome.quit                },
	}

	-- Main menu
	------------------------------------------------------------
	theme.width = 150 -- adjust width
	self.mainmenu = redflat.menu({ theme = theme,
		items = {
			{ "Applications",  appmenu },
			{ "Places",        placesmenu, key = "c" },
			separator,
			{ "Terminal", "tilix" },
			{ "Sublime",   "subl" },
			{ "Files",    "thunar" },
			separator,
			{ "Awesome",       awesomemenu },
			{ "Disconnect",     "xfce4-session-logout" },
		}
	})

	-- Menu panel widget
	------------------------------------------------------------

	self.widget = redflat.gauge.svgbox(icon, nil, color)
	self.buttons = awful.util.table.join(
		awful.button({ }, 1, function () self.mainmenu:toggle() end)
	)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return menu
