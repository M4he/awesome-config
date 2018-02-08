-----------------------------------------------------------------------------------------------------------------------
--                                                  Environment config                                               --
-----------------------------------------------------------------------------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")

local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local env = {}

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function env:init(args)

	-- init vars
	local args = args or {}
	local theme = args.theme or "red"

	local oblogout = "oblogout -c " .. awful.util.get_configuration_dir() .. "mahe/oblogout.conf"

	-- environment vars
	self.terminal = args.terminal or "tilix"
	self.screenlock = args.screenlock or "mate-screensaver-command --lock"
	self.screenshot = "xfce4-screenshooter -d 0 -f"
	self.logout = args.logout or oblogout
	self.mod = args.mod or "Mod1"
	self.fm = args.fm or "nautilus -w"
	self.mail = args.mail or "thunderbird"
	self.player = args.player or "audacious"
	self.upgrades = args.upgrades or "echo 'FIXME'"
	self.home = os.getenv("HOME")
	self.themedir = awful.util.get_configuration_dir() .. "themes/" .. theme

	self.sloppy_focus = false  -- focus follows mouse?
	self.set_slave = false     -- whether new clients will enter the slave stack instead of master

	-- theme setup
	beautiful.init(env.themedir .. "/theme.lua")

	-- rofi command building
	--
	rofi_cmd = "rofi -no-config" -- ignore config, we setup everything here
	-- rofi color adjustment
	rofi_accent_color = beautiful.color.secondary or beautiful.color.main
	--
	-- SYNTAX: -color-window background, border_color, separator_color
	rofi_cmd = rofi_cmd .. " -color-window '" .. beautiful.color.wibox .. "," .. beautiful.color.gray .. "," .. rofi_accent_color .. "'"
	--
	-- SYNTAX: -color-normal background, foreground, background_alt, highlight_background, highlight_foreground
	rofi_cmd = rofi_cmd .. " -color-normal '" .. beautiful.color.wibox .. "," .. beautiful.color.text .. "," .. beautiful.color.wibox .. "," .. beautiful.color.main .. "," .. beautiful.color.highlight .. "'"
	--
	-- SYNTAX: color-urgent background, foreground, background_alt, highlight_background, highlight_foreground
	rofi_cmd = rofi_cmd .. " -color-urgent '" .. beautiful.color.wibox .. "," .. beautiful.color.urgent .. "," .. beautiful.color.wibox .. "," .. beautiful.color.urgent .. "," .. beautiful.color.highlight .. "'"
	--
	-- SYNTAX: color-active background, foreground, background_alt, highlight_background, highlight_foreground
	rofi_cmd = rofi_cmd .. " -color-active '" .. beautiful.color.wibox .. "," .. rofi_accent_color .. "," .. beautiful.color.wibox .. "," .. rofi_accent_color .. "," .. beautiful.color.highlight .. "'"
	--
	-- generic styling
	rofi_cmd = rofi_cmd .. " -bw 2 -lines 10 -separator-style solid -padding 5 -scrollbar-width 5 -line-margin 5 -line-padding 2 -sidebar-mode true"
	rofi_cmd = rofi_cmd .. " -font 'Roboto mono medium 13'"
	-- rofi keybindings
	rofi_cmd = rofi_cmd .. " -kb-mode-next Tab -kb-mode-previous Shift+Tab -kb-move-front Home -kb-move-end End"
	rofi_cmd = rofi_cmd .. " -display-ssh SSH -display-drun APP -display-run RUN -display-window WIN"
	rofi_cmd = rofi_cmd .. " -terminal " .. self.terminal .. " -modi 'drun,window,run,ssh' -show"
	self.rofi = rofi_cmd

	-- naughty config
	naughty.config.padding = beautiful.useless_gap and 2 * beautiful.useless_gap or 0

	if beautiful.naughty then
		naughty.config.defaults         = redflat.util.table.merge(naughty.config.defaults, beautiful.naughty.base)
		naughty.config.presets.normal   = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.normal)
		naughty.config.presets.critical = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.critical)
		naughty.config.presets.low      = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.low)
	end
end


-- Common functions
----------------------------------------------------------------------------------------------------------------------

-- Tag tooltip text generation
--------------------------------------------------------------------------------
env.tagtip = function(t)
	local layname = awful.layout.getname(awful.tag.getproperty(t, "layout"))
	if redflat.util.table.check(beautiful, "widget.layoutbox.name_alias") then
		layname = beautiful.widget.layoutbox.name_alias[layname] or layname
	end
	return string.format("%s (%d apps) [%s]", t.name, #(t:clients()), layname)
end

-- Panel widgets wrapper
--------------------------------------------------------------------------------
env.wrapper = function(widget, name, buttons)
	local margin = { 0, 0, 0, 0 }

	if redflat.util.table.check(beautiful, "widget.wrapper") and beautiful.widget.wrapper[name] then
		margin = beautiful.widget.wrapper[name]
	end
	if buttons then
		widget:buttons(buttons)
	end

	return wibox.container.margin(widget, unpack(margin))
end


-- End
-----------------------------------------------------------------------------------------------------------------------
return env
