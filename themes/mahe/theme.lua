-----------------------------------------------------------------------------------------------------------------------
--                                                 Mahe's theme                                                      --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

local theme = {}
local wa = mouse.screen.workarea

-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color = {
	main      = "#02606D",
	gray      = "#575757",  -- used for inactive elements and bar trunks
	bg        = "#161616",  -- bg used for custom widgets (e.g. appswitcher, top)
	bg_second = "#181818",  -- alternating lines for 'bg'
	wibox     = "#202020",  -- border, panel and general background color
	icon      = "#a0a0a0",  -- icons in menus
	text      = "#aaaaaa",  -- text in menus and titlebars
	urgent    = "#B25500",  -- urgent window highlight in taglist, tasklist also volume mute
	highlight = "#e0e0e0",  -- text when highlighted in menu
	empty     = "#575757",  -- circle tag empty color

	border    = "#404040",  -- tooltip border
	shadow1   = "#141414",  -- separator dark side
	shadow2   = "#313131",  -- separator bright side
	shadow3   = "#1c1c1c",  -- buttons outer border
	shadow4   = "#767676",  -- buttons inner border

	secondary = "#404040"   -- rofi secondary accent color
}

-- Color variations
-- Import your color variations here!
---------------------------------------------
-- theme = require('themes.mahe.colors.blue')

-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/mahe"
theme.homedir = os.getenv("HOME")

-- Main config
------------------------------------------------------------

theme.panel_height        = 36 -- panel height
theme.border_width        = 4  -- window border width
theme.useless_gap         = 5  -- useless gap

theme.cellnum = { x = 96, y = 58 } -- grid layout property

-- Fonts
------------------------------------------------------------
theme.fonts = {
	main     = "Roboto 13",      -- main font
	menu     = "Roboto 13",      -- main menu font
	tooltip  = "Roboto 13",      -- tooltip font
	notify   = "Play bold 14",   -- redflat notify popup font
	clock    = "Play bold 13",   -- textclock widget font
	qlaunch  = "Play bold 14",   -- quick launch key label font
	keychain = "Play bold 16",   -- key sequence tip font
	mtitle   = "Play bold 14", -- menu titles font
	title    = "Play bold 13", -- widget titles font
	titlebar = "Play bold 11", -- client titlebar font
	hotkeys  = {
		main  = "Roboto 14",             -- hotkeys helper main font
		key   = "Roboto Mono Medium 14", -- hotkeys helper key font (use monospace for align)
		title = "Play bold 16",        -- hotkeys helper group title font
	},
	player   = {
		main = "Play bold 13", -- player widget main font
		time = "Play bold 15", -- player widget current time font
	},
}

theme.cairo_fonts = {
	tag         = { font = "Play", size = 16, face = 1 }, -- tag widget font
	appswitcher = { font = "Play", size = 20, face = 1 }, -- appswitcher widget font
	monitor     = { font = "Play", size = 20, face = 1 }, -- system monitoring widget font
	navigator   = {
		title = { font = "Play", size = 28, face = 1, slant = 0 }, -- window navigation title font
		main  = { font = "Play", size = 22, face = 1, slant = 0 }  -- window navigation  main font
	},
}

-- Shared icons
--------------------------------------------------------------------------------
theme.icon = {
	check    = theme.path .. "/common/check.svg",
	blank    = theme.path .. "/common/blank.svg",
	warning  = theme.path .. "/common/warning.svg",
	awesome  = theme.path .. "/common/awesome.svg",
}

-- Widget icons
--------------------------------------------------------------------------------
theme.icon.widget = {
	battery  = theme.path .. "/widget/battery.svg",
	wireless = theme.path .. "/widget/wireless.svg",
	monitor  = theme.path .. "/widget/monitor.svg",
}

-- Service utils config
-----------------------------------------------------------------------------------------------------------------------
theme.service = {}

-- Window control mode appearance
--------------------------------------------------------------------------------
theme.service.navigator = {
	border_width = 0,
	gradstep     = 60,
	marksize     = { width = 160, height = 80, r = 20 },
	linegap      = 32,
	titlefont    = theme.cairo_fonts.navigator.title,
	font         = theme.cairo_fonts.navigator.main,
	color        = { border = theme.color.main, mark = theme.color.gray, text = theme.color.wibox,
	                 fbg1 = theme.color.main .. "60",   fbg2 = theme.color.main .. "40",
	                 hbg1 = theme.color.urgent .. "60", hbg2 = theme.color.urgent .. "40",
	                 bg1  = theme.color.gray .. "60",   bg2  = theme.color.gray .. "40" }
}

theme.service.navigator.keytip = {}
theme.service.navigator.keytip["fairv"] = { geometry = { width = 600, height = 440 }, exit = true }
theme.service.navigator.keytip["fairh"] = theme.service.navigator.keytip["fairv"]

theme.service.navigator.keytip["tile"] = { geometry = { width = 600, height = 660 }, exit = true }
theme.service.navigator.keytip["tileleft"]   = theme.service.navigator.keytip["tile"]
theme.service.navigator.keytip["tiletop"]    = theme.service.navigator.keytip["tile"]
theme.service.navigator.keytip["tilebottom"] = theme.service.navigator.keytip["tile"]

theme.service.navigator.keytip["grid"] = { geometry = { width = 1400, height = 520 }, column = 2, exit = true }
theme.service.navigator.keytip["usermap"] = { geometry = { width = 1400, height = 580 }, column = 2, exit = true }

-- Desktop file parser
--------------------------------------------------------------------------------
theme.service.dfparser = {
	desktop_file_dirs = {
		'/usr/share/applications/',
		'/usr/local/share/applications/',
		'~/.local/share/applications',
	},
	icons = {
		df_icon       = nil,
		theme         = theme.homedir .. "/.icons/ACYLS",
		custom_only   = true,
		scalable_only = true
	}
}


-- Menu config
-----------------------------------------------------------------------------------------------------------------------
theme.menu = {
	border_width = 4,
	screen_gap   = theme.useless_gap + theme.border_width,
	height       = 32,
	width        = 250,
	icon_margin  = { 4, 7, 7, 8 },
	ricon_margin = { 9, 9, 9, 9 },
	font         = theme.fonts.menu,
	keytip       = { geometry = { width = 400, height = 380 } },
	hide_timeout = 1,
	submenu_icon = theme.path .. "/common/submenu.svg"
}

theme.menu.color = {
	border       = theme.color.wibox,
	text         = theme.color.text,
	highlight    = theme.color.highlight,
	main         = theme.color.main,
	wibox        = theme.color.wibox,
	submenu_icon = theme.color.icon
}


-- Gauge style
-----------------------------------------------------------------------------------------------------------------------
theme.gauge = { tag = {}, task = {}, icon = {}, audio = {}, monitor = {}, graph = {} }

-- Separator
------------------------------------------------------------
theme.gauge.separator = {
	marginv = { 2, 2, 4, 4 },
	marginh = { 6, 6, 3, 3 },
	color  = theme.color
}

-- Icon indicator
------------------------------------------------------------
theme.gauge.icon.single = {
	color  = theme.color
}

-- Monitor
--------------------------------------------------------------
theme.gauge.monitor.double = {
	width    = 90,
	line     = { v_gap = 6 },
	dmargin  = { 10, 0, 0, 0 },
	color    = theme.color
}

theme.gauge.monitor.circle = {
	width        = 32,
	line_width   = 4,
	iradius      = 5,
	radius       = 11,
	color        = theme.color
}

-- Monitor (plain bar)
--------------------------------------------------------------
theme.gauge.monitor.plain = {
	font     = theme.cairo_fonts.tag,
	text_gap = 20,
	line     = { width = 4, v_gap = 25 },
	color    = theme.color
}

-- Tag
------------------------------------------------------------
theme.gauge.tag.blue = {
	width    = 93,
	font     = theme.cairo_fonts.tag,
	point    = { width = 70, height = 3, gap = 27, dx = 5 },
	text_gap = 20,
	color    = theme.color
}

-- circle tag style (set 'widget = redflat.gauge.tag.orange.new'
-- within 'taglist.style = {...}' of the main rc-*.lua file in
-- order to switch to circled tag buttons of the redflat lib)
theme.gauge.tag.orange = {
	width        = 40,
	line_width   = theme.gauge.monitor.circle.line_width,
	iradius      = theme.gauge.monitor.circle.iradius,
	radius       = theme.gauge.monitor.circle.radius,
	hilight_min  = false,
	color        = theme.color
}

-- Task
------------------------------------------------------------
theme.gauge.task.blue = {
	width    = 70,
	show_min = true,
	font     = theme.cairo_fonts.tag,
	point    = { width = 60, height = 3, gap = 27, dx = 5 },
	text_gap = 20,
	color    = theme.color
}

-- Dotcount
------------------------------------------------------------
theme.gauge.graph.dots = {
	column_num   = { 3, 5 }, -- { min, max }
	row_num      = 3,
	dot_size     = 5,
	dot_gap_h    = 4,
	color        = theme.color
}

-- Volume indicator
------------------------------------------------------------
theme.gauge.audio.blue = {
	width   = 60,
	dash    = { bar = { num = 4, width = 4 }, color = theme.color },
	dmargin = { 10, 0, 2, 2 },
	icon    = theme.path .. "/widget/headphones.svg",
	color = { icon = theme.color.icon, mute = theme.color.urgent },
}


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------
theme.widget = {}

-- individual margins for palnel widgets
------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 10, 8, 6, 6 },
	textclock   = { 8, 8, 0, 0 },
	volume      = { 8, 8, 5, 5 },
	network     = { 10, 10, 5, 5 },
	cpuram      = { 10, 10, 5, 5 },
	ram         = { 8, 8, 0, 0 },
	cpu         = { 8, 8, 0, 0 },
	battery     = { 5, 5, 7, 7 },
	tray        = { 8, 8, 7, 7 },
	tasklist    = { 4, 0, 0, 0 }, -- centering tasklist widget
}

-- Pulseaudio volume control
------------------------------------------------------------
theme.widget.pulse = {
	notify      = { icon = theme.path .. "/widget/audio.svg" }
}

-- Brightness control
------------------------------------------------------------
theme.widget.brightness = {
	notify      = { icon = theme.path .. "/widget/brightness.svg" }
}

-- Textclock
------------------------------------------------------------
theme.widget.textclock = {
	font  = theme.fonts.clock,
	color = { text = theme.color.icon }
}

-- Keyboard layout indicator
------------------------------------------------------------
theme.widget.keyboard = {
	icon         = theme.path .. "/widget/keyboard.svg",
	micon        = theme.icon,
	layout_color = { theme.color.icon, theme.color.main }
}

theme.widget.keyboard.menu = {
	width        = 180,
	color        = { right_icon = theme.color.icon },
	nohide       = true
}

-- Upgrades
------------------------------------------------------------
theme.widget.upgrades = {
	notify      = { icon = theme.path .. "/widget/upgrades.svg" },
	color       = theme.color
}

-- Mail
------------------------------------------------------------
theme.widget.mail = {
	icon        = theme.path .. "/widget/mail.svg",
	notify      = { icon = theme.path .. "/widget/mail.svg" },
	color       = theme.color,
}

-- Minitray
------------------------------------------------------------
theme.widget.minitray = {
	border_width = 0,
	geometry     = { height = 40 },
	screen_gap   = 2 * theme.useless_gap,
	color        = { wibox = theme.color.wibox, border = theme.color.wibox },
	set_position = function()
		return { x = mouse.screen.workarea.x + mouse.screen.workarea.width,
		         y = mouse.screen.workarea.y + mouse.screen.workarea.height }
	end,
}

-- Layoutbox
------------------------------------------------------------
theme.widget.layoutbox = {
	micon = theme.icon,
	color = theme.color
}

theme.widget.layoutbox.icon = {
	floating          = theme.path .. "/layouts/floating.svg",
	max               = theme.path .. "/layouts/max.svg",
	fullscreen        = theme.path .. "/layouts/fullscreen.svg",
	tilebottom        = theme.path .. "/layouts/tilebottom.svg",
	tileleft          = theme.path .. "/layouts/tileleft.svg",
	tile              = theme.path .. "/layouts/tile.svg",
	tiletop           = theme.path .. "/layouts/tiletop.svg",
	fairv             = theme.path .. "/layouts/fair.svg",
	fairh             = theme.path .. "/layouts/fair.svg",
	grid              = theme.path .. "/layouts/grid.svg",
	usermap           = theme.path .. "/layouts/map.svg",
	magnifier         = theme.path .. "/layouts/magnifier.svg",
	cornerne          = theme.path .. "/layouts/cornerne.svg",
	cornernw          = theme.path .. "/layouts/cornernw.svg",
	cornerse          = theme.path .. "/layouts/cornerse.svg",
	cornersw          = theme.path .. "/layouts/cornersw.svg",
	unknown           = theme.path .. "/common/unknown.svg",
}

theme.widget.layoutbox.menu = {
	icon_margin  = { 8, 12, 9, 9 },
	width        = 220,
	auto_hotkey  = true,
	nohide       = false,
	color        = { right_icon = theme.color.icon, left_icon = theme.color.icon }
}

theme.widget.layoutbox.name_alias = {
	floating          = "Floating",
	fullscreen        = "Fullscreen",
	max               = "Maximized",
	grid              = "Grid",
	usermap           = "User Map",
	tile              = "Right Tile",
	fairv             = "Fair Tile",
	tileleft          = "Left Tile",
	tiletop           = "Top Tile",
	tilebottom        = "Bottom Tile",
	magnifier         = "Magnifier",
	cornerne          = "Corner NE",
	cornernw          = "Corner NW",
	cornerse          = "Corner SE",
	cornersw          = "Corner SW",
}

-- Tasklist
------------------------------------------------------------
theme.widget.tasklist = {
	width       = 70,
	char_digit  = 5,
	task        = theme.gauge.task.blue
}

-- main
theme.widget.tasklist.winmenu = {
	micon          = theme.icon,
	titleline      = { font = theme.fonts.title, height = 25 },
	menu           = { width = 220, color = { right_icon = theme.color.icon }, ricon_margin = { 9, 9, 9, 9 } },
	state_iconsize = { width = 18, height = 18 },
	layout_icon    = theme.widget.layoutbox.icon,
	hide_action    = { min = true, move = true, max = true, add = true },
	color          = theme.color
}

-- tasktip
theme.widget.tasklist.tasktip = {
	margin = { 8, 8, 4, 4 },
	color  = theme.color
}

-- tags submenu
theme.widget.tasklist.winmenu.tagmenu = {
	width       = 180,
	icon_margin = { 9, 9, 9, 9 },
	color       = { right_icon = theme.color.icon, left_icon = theme.color.icon },
}

-- menu
theme.widget.tasklist.winmenu.icon = {
	floating             = theme.path .. "/common/window_control/floating.svg",
	sticky               = theme.path .. "/common/window_control/pin.svg",
	ontop                = theme.path .. "/common/window_control/ontop.svg",
	below                = theme.path .. "/common/window_control/below.svg",
	close                = theme.path .. "/common/window_control/close.svg",
	minimize             = theme.path .. "/common/window_control/minimize.svg",
	maximized            = theme.path .. "/common/window_control/maximized.svg",
}

-- Clientmenu
------------------------------------------------------------
theme.widget.clientmenu = {
	micon          = theme.icon,
	color          = theme.color,
	actionline     = { height = 28 },
	layout_icon    = theme.widget.layoutbox.icon,
	menu           = theme.widget.tasklist.winmenu.menu,
	state_iconsize = theme.widget.tasklist.winmenu.state_iconsize,
	tagmenu        = theme.widget.tasklist.winmenu.tagmenu,
	icon           = theme.widget.tasklist.winmenu.icon,
}


-- Floating widgets
-----------------------------------------------------------------------------------------------------------------------
theme.float = { decoration = {} }

-- Audio player
------------------------------------------------------------
theme.float.player = {
	geometry     = { width = 490, height = 130 },
	screen_gap   = 2 * theme.useless_gap,
	border_gap   = { 15, 15, 15, 15 },
	elements_gap = { 15, 0, 0, 0 },
	control_gap  = { 0, 0, 14, 6 },
	line_height  = 26,
	bar_width    = 6,
	titlefont    = theme.fonts.player.main,
	artistfont   = theme.fonts.player.main,
	timefont     = theme.fonts.player.time,
	dashcontrol  = { color = theme.color, bar = { num = 7 } },
	progressbar  = { color = theme.color },
	border_width = 0,
	timeout      = 1,
	color        = theme.color
}

theme.float.player.icon = {
	cover   = theme.path .. "/common/player/cover.svg",
	next_tr = theme.path .. "/common/player/next.svg",
	prev_tr = theme.path .. "/common/player/previous.svg",
	play    = theme.path .. "/common/player/play.svg",
	pause   = theme.path .. "/common/player/pause.svg"
}

-- Application runner
------------------------------------------------------------
theme.float.apprunner = {
	itemnum       = 6,
	geometry      = { width = 620, height = 480 },
	border_margin = { 24, 24, 24, 24 },
	icon_margin   = { 8, 16, 0, 0 },
	title_height  = 48,
	prompt_height = 35,
	title_icon    = theme.path .. "/widget/search.svg",
	keytip        = { geometry = { width = 400, height = 250 } },
	border_width  = 0,
	name_font     = theme.fonts.title,
	comment_font  = theme.fonts.main,
	color         = theme.color
}

-- Application switcher
------------------------------------------------------------
theme.float.appswitcher = {
	wibox_height   = 240,
	label_height   = 28,
	title_height   = 40,
	icon_size      = 96,
	border_margin  = { 10, 10, 0, 10 },
	preview_margin = { 15, 15, 15, 15 },
	preview_format = 16 / 10,
	title_font     = theme.fonts.title,
	border_width   = 0,
	update_timeout = 1 / 12,
	keytip         = { geometry = { width = 400, height = 360 }, exit = true },
	font           = theme.cairo_fonts.appswitcher,
	color          = theme.color
}

-- additional color
theme.float.appswitcher.color.preview_bg = theme.color.main .. "12"

-- hotkeys
theme.float.appswitcher.hotkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                    "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12" }

-- Quick launcher
------------------------------------------------------------
theme.float.qlaunch = {
	geometry      = { width = 1400, height = 170 },
	border_margin = { 5, 5, 12, 15 },
	border_width  = 0,
	appline       = { iwidth = 140, im = { 5, 5, 0, 0 }, igap = { 0, 0, 5, 15 }, lheight = 26 },
	state         = { gap = 5, radius = 5, size = 10,  height = 14 },
	df_icon       = theme.path .. "/common/submenu.svg",
	no_icon       = theme.path .. "/common/unknown.svg",
	recoloring    = true,
	keytip        = { geometry = { width = 600, height = 320 } },
	label_font    = theme.fonts.qlaunch,
	color         = theme.color,
}

-- Hotkeys helper
------------------------------------------------------------
theme.float.hotkeys = {
	geometry      = { width = 1800, height = 975 },
	border_margin = { 20, 20, 8, 10 },
	border_width  = 0,
	is_align      = true,
	separator     = { marginh = { 0, 0, 3, 6 } },
	font          = theme.fonts.hotkeys.main,
	keyfont       = theme.fonts.hotkeys.key,
	titlefont     = theme.fonts.hotkeys.title,
	color         = theme.color
}

-- Tooltip
------------------------------------------------------------
theme.float.tooltip = {
	margin       = { 6, 6, 3, 3 },
	timeout      = 0,
	font         = theme.fonts.tooltip,
	border_width = 2,
	color        = theme.color
}

-- Floating prompt
------------------------------------------------------------
theme.float.prompt = {
	border_width = 0,
	color        = theme.color
}

-- Top processes
------------------------------------------------------------
theme.float.top = {
	geometry      = { width = 460, height = 400 },
	screen_gap    = 2 * theme.useless_gap,
	border_margin = { 20, 20, 10, 0 },
	button_margin = { 140, 140, 18, 18 },
	title_height  = 40,
	border_width  = 0,
	bottom_height = 70,
	title_font    = theme.fonts.title,
	color         = theme.color,
	set_position  = function()
		return { x = mouse.screen.workarea.x + mouse.screen.workarea.width,
		         y = mouse.screen.workarea.y + mouse.screen.workarea.height }
	end,
}

-- Key sequence tip
------------------------------------------------------------
theme.float.keychain = {
	geometry        = { width = 250, height = 56 },
	font            = theme.fonts.keychain,
	border_width    = 0,
	keytip          = { geometry = { width = 1200, height = 580 }, column = 2 },
	color           = theme.color,
}

-- Notify
------------------------------------------------------------
theme.float.notify = {
	geometry     = { width = 484, height = 106 },
	screen_gap   = 2 * theme.useless_gap,
	font         = theme.fonts.notify,
	border_width = 0,
	icon         = theme.icon.warning,
	color        = theme.color,
	progressbar  = { color = theme.color },
	set_position = function()
		return { x = mouse.screen.workarea.x + mouse.screen.workarea.width, y = mouse.screen.workarea.y }
	end,
}

-- Decoration elements
------------------------------------------------------------
theme.float.decoration.button = {
	color = {
		shadow3 = theme.color.shadow3,
		shadow4 = theme.color.shadow4,
		gray    = theme.color.gray,
		text    = "#cccccc"
	},
}

theme.float.decoration.field = {
	color = theme.color
}


-- Titlebar
-----------------------------------------------------------------------------------------------------------------------
theme.titlebar = {
	size          = 8,
	position      = "top",
	font          = theme.fonts.titlebar,
	icon          = { size = 30, gap = 5 },
	border_margin = { 0, 0, 0, 4 },
	color         = theme.color,
}

-- Naughty config
-----------------------------------------------------------------------------------------------------------------------
theme.naughty = {}

theme.naughty.base = {
	timeout      = 10,
	margin       = 12,
	icon_size    = 80,
	font         = theme.fonts.main,
	bg           = theme.color.wibox,
	fg           = theme.color.text,
	height       = theme.float.notify.geometry.height,
	width        = theme.float.notify.geometry.width,
	border_width = theme.border_width,
	border_color = theme.color.main
}

theme.naughty.normal = theme.naughty.base
theme.naughty.critical = { timeout = 0, border_color = theme.color.main }
theme.naughty.low = { timeout = 5 }

-- Default awesome theme vars
-----------------------------------------------------------------------------------------------------------------------

-- colors
theme.bg_normal     = theme.color.wibox
theme.bg_focus      = theme.color.main
theme.bg_urgent     = theme.color.urgent
theme.bg_minimize   = theme.color.gray

theme.fg_normal     = theme.color.text
theme.fg_focus      = theme.color.highlight
theme.fg_urgent     = theme.color.highlight
theme.fg_minimize   = theme.color.highlight

theme.border_normal = theme.color.wibox
theme.border_focus  = theme.color.wibox
theme.border_marked = theme.color.main

-- font
theme.font = theme.fonts.main

-- prevent master from filling entire screen when slave stack is empty
theme.master_fill_policy = "master_width_factor"

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
