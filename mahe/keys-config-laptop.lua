-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local table = table
local awful = require("awful")
local beautiful = require("beautiful")

local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { mouse = {}, raw = {}, keys = {}, fake = {} }

-- key aliases
local apprunner = redflat.float.apprunner
local appswitcher = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local redtip = redflat.float.hotkeys
local laycom = redflat.layout.common
local grid = redflat.layout.grid
local map = redflat.layout.map
local redtitle = redflat.titlebar
local qlaunch = redflat.float.qlaunch
local clientmenu = redflat.float.clientmenu
local naughty = require("naughty")

-- Key support functions
-----------------------------------------------------------------------------------------------------------------------

-- change window focus by history
local function focus_to_previous()
	awful.client.focus.history.previous()
	if client.focus then client.focus:raise() end
end

-- change window focus by direction
local focus_switch_byd = function(dir)
	return function()
		awful.client.focus.bydirection(dir)
		if client.focus then client.focus:raise() end
	end
end

-- minimize and restore windows
local function minimize_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) then c.minimized = true end
	end
end

local function minimize_all_except_focused()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c ~= client.focus then c.minimized = true end
	end
end

local function restore_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c.minimized then c.minimized = false end
	end
end

local function restore_client()
	local c = awful.client.restore()
	if c then client.focus = c; c:raise() end
end

-- close window
local function kill_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and not c.sticky then c:kill() end
	end
end

-- new clients placement
local function toggle_placement(env)
	env.set_slave = not env.set_slave
	redflat.float.notify:show({ text = (env.set_slave and "Slave" or "Master") .. " placement" })
end

-- numeric keys function builders
local function tag_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then action(tag) end
		end
	)
end

local function client_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then action(tag) end
			end
		end
	)
end

-- volume functions
local volume_raise = function() redflat.widget.pulse:change_volume({ show_notify = true })              end
local volume_lower = function() redflat.widget.pulse:change_volume({ show_notify = true, down = true }) end
local volume_mute  = function() redflat.widget.pulse:mute() end

-- right bottom corner position
local rb_corner = function()
	return { x = screen[mouse.screen].workarea.x + screen[mouse.screen].workarea.width,
	         y = screen[mouse.screen].workarea.y + screen[mouse.screen].workarea.height }
end

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

	-- Init vars
	local args = args or {}
	local env = args.env
	local mainmenu = args.menu

	-- Desktop right-click
	self.mouse.root = (awful.util.table.join(
		awful.button({ }, 3, function () mainmenu:toggle() end)
	))

	-- Init widgets
	redflat.float.qlaunch:init()

	-- Keys for widgets
	--------------------------------------------------------------------------------

	-- Apprunner widget
	------------------------------------------------------------
	local apprunner_keys_move = {
		{
			{ env.mod }, "s", function() apprunner:down() end,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "w", function() apprunner:up() end,
			{ description = "Select previous item", group = "Navigation" }
		},
	}

	-- apprunner:set_keys(awful.util.table.join(apprunner.keys.move, apprunner_keys_move), "move")
	apprunner:set_keys(apprunner_keys_move, "move")

	-- Menu widget
	------------------------------------------------------------
	local menu_keys_move = {
		-- MENU WASD NAVIGATION
		{
			{ env.mod }, "s", redflat.menu.action.down,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "w", redflat.menu.action.up,
			{ description = "Select previous item", group = "Navigation" }
		},
		{
			{ env.mod }, "a", redflat.menu.action.back,
			{ description = "Go back", group = "Navigation" }
		},
		{
			{ env.mod }, "d", redflat.menu.action.enter,
			{ description = "Open submenu", group = "Navigation" }
		},
	}

	-- redflat.menu:set_keys(awful.util.table.join(redflat.menu.keys.move, menu_keys_move), "move")
	redflat.menu:set_keys(menu_keys_move, "move")

	-- Appswitcher widget
	------------------------------------------------------------
	appswitcher_keys = {
		{
			{}, "Right", function() appswitcher:switch() end,
			{ description = "Select next app", group = "Navigation" }
		},
		{
			{}, "Tab", function() appswitcher:switch() end,
			{} -- hidden key
		},
		{
			{}, "Left", function() appswitcher:switch({ reverse = true }) end,
			{ description = "Select previous app", group = "Navigation" }
		},
		{
			{}, "XF86LaunchA", function() appswitcher:hide() end,
			{} -- hidden key
		},
		{
			{}, "Return", function() appswitcher:hide() end,
			{ description = "Activate and exit", group = "Action" }
		},
		{
			-- TODO: why does this not work?
			{}, "space", function() appswitcher:hide() end,
			{} -- hidden key
		},
		{
			{}, "Escape", function() appswitcher:hide(true) end,
			{ description = "Exit", group = "Action" }
		},
		{
			{ env.mod }, "Escape", function() appswitcher:hide(true) end,
			{} -- hidden key
		},
		{
			{ env.mod }, "F1", function() redtip:show()  end,
			{ description = "Show hotkeys helper", group = "Action" }
		},
	}

	appswitcher:set_keys(appswitcher_keys)

	-- Emacs like key sequences
	--------------------------------------------------------------------------------

	-- initial key
	local keyseq = { { env.mod }, "c", {}, {} }

	-- group
	keyseq[3] = {
		{ {}, "k", {}, {} }, -- application kill group
		{ {}, "c", {}, {} }, -- client managment group
		{ {}, "r", {}, {} }, -- client managment group
		{ {}, "n", {}, {} }, -- client managment group
		{ {}, "g", {}, {} }, -- run or rise group
		{ {}, "f", {}, {} }, -- launch application group
		{ {}, "m", {}, {} }, -- monitor setting group
		{ {}, "b", {}, {} }, -- monitor brightness group
	}

	-- quick launch key sequence actions
	for i = 1, 9 do
		local ik = tostring(i)
		table.insert(keyseq[3][5][3], {
			{}, ik, function() qlaunch:run_or_raise(ik) end,
			{ description = "Run or rise application №" .. ik, group = "Run or Rise", keyset = { ik } }
		})
		table.insert(keyseq[3][6][3], {
			{}, ik, function() qlaunch:run_or_raise(ik, true) end,
			{ description = "Launch application №".. ik, group = "Quick Launch", keyset = { ik } }
		})
	end

	-- external monitor brightness
	for i = 0, 9 do
		local ik = tostring(i)
		table.insert(keyseq[3][8][3], {
			{}, ik, function()
				local br = "1.0" 
				if i == 0 then
					br = "1.0"
				else
					br = "0." .. ik
				end
				awful.spawn("xrandr --output HDMI1 --brightness " .. br)
			end,
			{ description = "Set external monitor brightness level to " .. ik, group = "Monitor management", keyset = { ik } }
		})
	end

	-- application kill sequence actions
	keyseq[3][1][3] = {
		{
			{}, "f", function() if client.focus then client.focus:kill() end end,
			{ description = "Kill focused client", group = "Kill application", keyset = { "f" } }
		},
		{
			{}, "a", kill_all,
			{ description = "Kill all clients with current tag", group = "Kill application", keyset = { "a" } }
		},
	}

	-- client managment sequence actions
	keyseq[3][2][3] = {
		{
			{}, "p", function () toggle_placement(env) end,
			{ description = "Switch master/slave window placement", group = "Clients managment", keyset = { "p" } }
		},
	}

	keyseq[3][3][3] = {
		{
			{}, "f", restore_client,
			{ description = "Restore minimized client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", restore_all,
			{ description = "Restore all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
	}

	keyseq[3][4][3] = {
		{
			{}, "f", function() if client.focus then client.focus.minimized = true end end,
			{ description = "Minimized focused client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", minimize_all,
			{ description = "Minimized all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
		{
			{}, "e", minimize_all_except_focused,
			{ description = "Minimized all clients except focused", group = "Clients managment", keyset = { "e" } }
		},
	}

	-- monitor handling
	keyseq[3][7][3] = {
		{
			{}, "p", function() awful.spawn.with_shell("bash " .. awful.util.get_configuration_dir() .. "scripts/monitor.sh primary") end,
			{ description = "Only activate PRIMARY screen", group = "Monitor management", keyset = { "p" } }
		},
		{
			{}, "s", function() awful.spawn.with_shell("bash " .. awful.util.get_configuration_dir() .. "scripts/monitor.sh secondary") end,
			{ description = "Only activate SECONDARY screen", group = "Monitor management", keyset = { "s" } }
		},
		{
			{}, "e", function() awful.spawn.with_shell("bash " .. awful.util.get_configuration_dir() .. "scripts/monitor.sh extend") end,
			{ description = "Extend the internal screen to the right", group = "Monitor management", keyset = { "e" } }
		},
		{
			{}, "m", function() awful.spawn.with_shell("bash " .. awful.util.get_configuration_dir() .. "scripts/monitor.sh mirror") end,
			{ description = "Mirror both screens", group = "Monitor management", keyset = { "m" } }
		},
		{
			{}, "o", function() awful.spawn.with_shell("bash " .. awful.util.get_configuration_dir() .. "scripts/monitor.sh ontop") end,
			{ description = "Set the external screen ontop", group = "Monitor management", keyset = { "o" } }
		},
		
	}


	-- Layouts
	--------------------------------------------------------------------------------

	-- shared layout keys
	local layout_tile = {
		{
			{}, "d", function () awful.tag.incmwfact( 0.05) end,
			{ description = "Increase master width factor", group = "Layout" }
		},
		{
			{}, "a", function () awful.tag.incmwfact(-0.05) end,
			{ description = "Decrease master width factor", group = "Layout" }
		},
		{
			{}, "w", function () awful.client.incwfact( 0.075) end,
			{ description = "Increase window factor of a client", group = "Layout" }
		},
		{
			{}, "s", function () awful.client.incwfact(-0.075) end,
			{ description = "Decrease window factor of a client", group = "Layout" }
		},
		{
			{}, "y", function () awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Decrease the number of master clients", group = "Layout" }
		},
		{
			{}, "x", function () awful.tag.incnmaster( 1, nil, true) end,
			{ description = "Increase the number of master clients", group = "Layout" }
		},
		{
			{}, "+", function () awful.tag.incnmaster( 1, nil, true) end,
			{ description = "Increase the number of master clients", group = "Layout" }
		},
		{
			{}, "-", function () awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Decrease the number of master clients", group = "Layout" }
		},
		{
			{}, "e", function () awful.tag.incncol( 1, nil, true) end,
			{ description = "Increase the number of columns", group = "Layout" }
		},
		{
			{}, "q", function () awful.tag.incncol(-1, nil, true) end,
			{ description = "Decrease the number of columns", group = "Layout" }
		},
	}

	laycom:set_keys(layout_tile, "tile")

	-- grid layout keys
	local layout_grid_move = {
		{
			{}, "w", function() grid.move_to("up") end,
			{ description = "Move window up", group = "Movement" }
		},
		{
			{}, "s", function() grid.move_to("down") end,
			{ description = "Move window down", group = "Movement" }
		},
		{
			{}, "a", function() grid.move_to("left") end,
			{ description = "Move window left", group = "Movement" }
		},
		{
			{}, "d", function() grid.move_to("right") end,
			{ description = "Move window right", group = "Movement" }
		},
		{
			{ "Control" }, "w", function() grid.move_to("up", true) end,
			{ description = "Move window up by bound", group = "Movement" }
		},
		{
			{ "Control" }, "s", function() grid.move_to("down", true) end,
			{ description = "Move window down by bound", group = "Movement" }
		},
		{
			{ "Control" }, "a", function() grid.move_to("left", true) end,
			{ description = "Move window left by bound", group = "Movement" }
		},
		{
			{ "Control" }, "d", function() grid.move_to("right", true) end,
			{ description = "Move window right by bound", group = "Movement" }
		},
	}

	local layout_grid_resize = {
		{
			{ env.mod }, "w", function() grid.resize_to("up") end,
			{ description = "Inrease window size to the up", group = "Resize" }
		},
		{
			{ env.mod }, "s", function() grid.resize_to("down") end,
			{ description = "Inrease window size to the down", group = "Resize" }
		},
		{
			{ env.mod }, "a", function() grid.resize_to("left") end,
			{ description = "Inrease window size to the left", group = "Resize" }
		},
		{
			{ env.mod }, "d", function() grid.resize_to("right") end,
			{ description = "Inrease window size to the right", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "w", function() grid.resize_to("up", nil, true) end,
			{ description = "Decrease window size from the up", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "s", function() grid.resize_to("down", nil, true) end,
			{ description = "Decrease window size from the down", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "a", function() grid.resize_to("left", nil, true) end,
			{ description = "Decrease window size from the left", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "d", function() grid.resize_to("right", nil, true) end,
			{ description = "Decrease window size from the right", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "w", function() grid.resize_to("up", true) end,
			{ description = "Increase window size to the up by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "s", function() grid.resize_to("down", true) end,
			{ description = "Increase window size to the down by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "a", function() grid.resize_to("left", true) end,
			{ description = "Increase window size to the left by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "d", function() grid.resize_to("right", true) end,
			{ description = "Increase window size to the right by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "w", function() grid.resize_to("up", true, true) end,
			{ description = "Decrease window size from the up by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "s", function() grid.resize_to("down", true, true) end,
			{ description = "Decrease window size from the down by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "a", function() grid.resize_to("left", true, true) end,
			{ description = "Decrease window size from the left by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "d", function() grid.resize_to("right", true, true) end,
			{ description = "Decrease window size from the right by bound ", group = "Resize" }
		},
	}

	redflat.layout.grid:set_keys(layout_grid_move, "move")
	redflat.layout.grid:set_keys(layout_grid_resize, "resize")

	-- user map layout keys
	local layout_map_layout = {
		{
			{ env.mod }, "s", function() map.swap_group() end,
			{ description = "Change placement direction for group", group = "Layout" }
		},
		{
			{ env.mod }, "v", function() map.new_group(true) end,
			{ description = "Create new vertical group", group = "Layout" }
		},
		{
			{ env.mod }, "h", function() map.new_group(false) end,
			{ description = "Create new horizontal group", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "v", function() map.insert_group(true) end,
			{ description = "Insert new vertical group before active", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "h", function() map.insert_group(false) end,
			{ description = "Insert new horizontal group before active", group = "Layout" }
		},
		{
			{ env.mod }, "d", function() map.delete_group() end,
			{ description = "Destroy group", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "d", function() map.clean_groups() end,
			{ description = "Destroy all empty groups", group = "Layout" }
		},
		{
			{ env.mod }, "f", function() map.set_active() end,
			{ description = "Set active group", group = "Layout" }
		},
		{
			{ env.mod }, "g", function() map.move_to_active() end,
			{ description = "Move focused client to active group", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "f", function() map.hilight_active() end,
			{ description = "Hilight active group", group = "Layout" }
		},
		{
			{ env.mod }, "a", function() map.switch_active(1) end,
			{ description = "Activate next group", group = "Layout" }
		},
		{
			{ env.mod }, "q", function() map.switch_active(-1) end,
			{ description = "Activate previous group", group = "Layout" }
		},
		{
			{ env.mod }, "]", function() map.move_group(1) end,
			{ description = "Move active group to the top", group = "Layout" }
		},
		{
			{ env.mod }, "[", function() map.move_group(-1) end,
			{ description = "Move active group to the bottom", group = "Layout" }
		},
		{
			{ env.mod }, "r", function() map.reset_tree() end,
			{ description = "Reset layout structure", group = "Layout" }
		},
	}

	local layout_map_resize = {
		{
			{ env.mod }, "j", function() map.incfactor(nil, 0.1, false) end,
			{ description = "Increase window horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod }, "l", function() map.incfactor(nil, -0.1, false) end,
			{ description = "Decrease window horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod }, "i", function() map.incfactor(nil, 0.1, true) end,
			{ description = "Increase window vertical size factor", group = "Resize" }
		},
		{
			{ env.mod }, "k", function() map.incfactor(nil, -0.1, true) end,
			{ description = "Decrease window vertical size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "j", function() map.incfactor(nil, 0.1, false, true) end,
			{ description = "Increase group horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "l", function() map.incfactor(nil, -0.1, false, true) end,
			{ description = "Decrease group horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "i", function() map.incfactor(nil, 0.1, true, true) end,
			{ description = "Increase group vertical size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "k", function() map.incfactor(nil, -0.1, true, true) end,
			{ description = "Decrease group vertical size factor", group = "Resize" }
		},
	}

	redflat.layout.map:set_keys(layout_map_layout, "layout")
	redflat.layout.map:set_keys(layout_map_resize, "resize")


	-- Global keys
	--------------------------------------------------------------------------------
	self.raw.root = {
		{
			{ env.mod }, "F1", function() redtip:show() end,
			{ description = "Show hotkeys helper", group = "Main" }
		},
		{
			{ "Mod4" }, "l", function() awful.spawn(env.screenlock) end,
			{ description = "Lock screen", group = "Main" }
		},
		{
			{ "Control" }, "space", function() awful.spawn(env.rofi) end,
			{ description = "Show Application Launcher", group = "Main" }
		},
		{
			{}, "XF86LaunchB", function () redflat.service.navigator:run() end,
			{ description = "Window control mode", group = "Main" }
		},
		{
			{ env.mod, "Control" }, "r", awesome.restart,
			{ description = "Reload awesome", group = "Main" }
		},
		{
			{ env.mod }, "c", function() redflat.float.keychain:activate(keyseq, "User") end,
			{ description = "User key sequence", group = "Main" }
		},
		{
			{ env.mod }, "Return", function() awful.spawn(env.terminal) end,
			{ description = "Open a terminal", group = "Applications" }
		},
		{
			{ env.mod, "Shift" }, "Return", function() awful.spawn(env.fm) end,
			{ description = "Open a file manager", group = "Applications" }
		},
		{
			{ env.mod }, "x", function() mainmenu:show() end,
			{ description = "Show main menu", group = "Widgets" }
		},
		{
			{ env.mod }, "F2", function() redflat.float.prompt:run() end,
			{ description = "Show the prompt box", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "i", function() redflat.widget.minitray:toggle() end,
			{ description = "Show minitray", group = "Widgets" }
		},
		{
			{ env.mod }, "F3", function() qlaunch:show() end,
			{ description = "Application quick launcher", group = "Widgets" }
		},
		{
			{}, "XF86AudioRaiseVolume", volume_raise,
			{ description = "Increase volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioLowerVolume", volume_lower,
			{ description = "Reduce volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioMute", volume_mute,
			{ description = "Toggle mute", group = "Volume control" }
		},
		{
			{}, "XF86PowerOff", function() awful.spawn(env.logout) end,
			{ description = "Show logout / power control prompt", group = "Main" }
		},
		{
			{ env.mod }, "e", function() redflat.float.player:show(rb_corner()) end,
			{ description = "Show/hide widget", group = "Audio player" }
		},
		{
			{ env.mod }, "less", function() laybox:toggle_menu(mouse.screen.selected_tag) end,
			{ description = "Show layout menu", group = "Layouts" }
		},
		{
			{}, "XF86LaunchA", nil, function() awful.spawn(env.rofi .. " window") end,
			{ description = "Show Rofi window selection", group = "Main" }
		},
		--- SFW MODES
		{
			{ "Mod4" }, "s", function() awful.spawn(env.home .. "/.descot/toggle_sfw.sh") end,
			{} -- hidden key
		},
		{
			{ "Mod4", "Shift" }, "s", function() awful.spawn(env.home .. "/.styles/stylechanger.py SFW") end,
			{} -- hidden key
		},
		{
			{ "Mod4", "Shift", "Control" }, "s", function() awful.spawn(env.home .. "/.styles/stylechanger.py") end,
			{} -- hidden key
		},
		-- WINDOW NAVIGATION
		{
			{ env.mod }, "d", focus_switch_byd("right"),
			{ description = "Go to right client", group = "Client focus" }
		},
		{
			{ env.mod }, "a", focus_switch_byd("left"),
			{ description = "Go to left client", group = "Client focus" }
		},
		{
			{ env.mod }, "w", focus_switch_byd("up"),
			{ description = "Go to upper client", group = "Client focus" }
		},
		{
			{ env.mod }, "s", focus_switch_byd("down"),
			{ description = "Go to lower client", group = "Client focus" }
		},
		{
			{ env.mod }, "u", awful.client.urgent.jumpto,
			{ description = "Go to urgent client", group = "Client focus" }
		},
		{
			{ env.mod }, "dead_circumflex", focus_to_previous,
			{ description = "Go to previous client", group = "Client focus" }
		},
		{
			-- window cycle with autoraise
			{ env.mod }, "Tab", function() awful.client.focus.byidx(-1); if client.focus then client.focus:raise(); end; end,
			{ description = "Go to previous client", group = "Client focus" }
		},
		{
			-- reverse window cycle with autoraise
			{ env.mod, "Shift" }, "Tab", function() awful.client.focus.byidx(1); if client.focus then client.focus:raise(); end; end,
			{ description = "Go to next client", group = "Client focus" }
		},
		-- TAG NAVIGATION
		{
			{ env.mod }, "Escape", awful.tag.history.restore,
			{ description = "Go previous tag", group = "Tag navigation" }
		},
		{
			{ env.mod, "Control" }, "Right", awful.tag.viewnext,
			{ description = "View next tag", group = "Tag navigation" }
		},
		{
			{ env.mod, "Control" }, "Left", awful.tag.viewprev,
			{ description = "View previous tag", group = "Tag navigation" }
		},
		{
			{ env.mod}, "space", function() awful.layout.inc(1) end,
			{ description = "Select next layout", group = "Layouts" }
		},
		{
			{ env.mod, "Shift" }, "space", function() awful.layout.inc(-1) end,
			{ description = "Select previous layout", group = "Layouts" }
		},
		-- WINDOW TITLEBAR TOGGLING
		{
			{ env.mod }, "t", function() redtitle.toggle(client.focus) end,
			{ description = "Show/hide titlebar for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Control" }, "t", function() redtitle.switch(client.focus) end,
			{ description = "Switch titlebar view for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Shift" }, "t", function() redtitle.toggle_all() end,
			{ description = "Show/hide titlebar for all clients", group = "Titlebar" }
		},
		{
			{ env.mod, "Control", "Shift" }, "t", function() redtitle.switch_all() end,
			{ description = "Switch titlebar view for all clients", group = "Titlebar" }
		},
	}

	-- Client keys
	--------------------------------------------------------------------------------
	self.raw.client = {
		{
			{ env.mod }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
			{ description = "Toggle fullscreen", group = "Client keys" }
		},
		{
			{ env.mod }, "q", function(c) c:kill() end,
			{ description = "Close", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "f", awful.client.floating.toggle,
			{ description = "Toggle floating", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "o", function(c) c.ontop = not c.ontop end,
			{ description = "Toggle keep on top", group = "Client keys" }
		},
		{
			{ env.mod }, "n", function(c) c.minimized = true end,
			{ description = "Minimize", group = "Client keys" }
		},
		{
			{ env.mod }, "y", function(c) c.minimized = true end,
			{} -- hidden key
		},
		{
			{ env.mod }, "m", function(c) c.maximized = not c.maximized; c:raise() end,
			{ description = "Maximize", group = "Client keys" }
		}
	}

	self.keys.root = redflat.util.key.build(self.raw.root)
	self.keys.client = redflat.util.key.build(self.raw.client)

	-- Numkeys
	--------------------------------------------------------------------------------

	-- add real keys without description here
	for i = 1, 9 do
		self.keys.root = awful.util.table.join(
			self.keys.root,
			tag_numkey(i,    { env.mod },                     function(t) t:view_only()               end),
			tag_numkey(i,    { env.mod, "Control" },          function(t) awful.tag.viewtoggle(t)     end),
			client_numkey(i, { env.mod, "Shift" },            function(t) client.focus:move_to_tag(t) end),
			client_numkey(i, { env.mod, "Control", "Shift" }, function(t) client.focus:toggle_tag(t)  end)
		)
	end

	-- make fake keys with description special for key helper widget
	local numkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

	self.fake.numkeys = {
		{
			{ env.mod }, "1..9", nil,
			{ description = "Switch to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control" }, "1..9", nil,
			{ description = "Toggle tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Shift" }, "1..9", nil,
			{ description = "Move focused client to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control", "Shift" }, "1..9", nil,
			{ description = "Toggle focused client on tag", group = "Numeric keys", keyset = numkeys }
		},
	}

	-- Hotkeys helper setup
	--------------------------------------------------------------------------------
	redflat.float.hotkeys:set_pack("Main", awful.util.table.join(self.raw.root, self.raw.client, self.fake.numkeys), 2)

	-- Mouse buttons
	--------------------------------------------------------------------------------
	self.mouse.client = awful.util.table.join(
		awful.button({}, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ env.mod }, 1, function (c) client.focus = c; c:raise(); awful.mouse.client.move(c) end),
		awful.button({ env.mod }, 2, function (c)
			clientmenu:show(c)
			-- the redflat.float.clientmenu's redflat.menu will start a
			-- awful.keygrabber upon show(). It seems that an
			-- awful.keygrabber.start() command within an awful.button()
			-- here will prevent any subsequent mouse hover/click,
			-- rendering Awesome unusable, so we need to quickly stop it
			-- here (Awesome bug?)
			-- This prevents Esc close for the menu sadly.
			awful.keygrabber.stop(clientmenu.menu._keygrabber)
		end),
		awful.button({ env.mod }, 3, function (c)
			-- only enable right-click resizing for floating clients and layouts
			if c.floating or (c.screen.selected_tag.layout == redflat.layout.grid) or (c.screen.selected_tag.layout == awful.layout.suit.floating) then
				awful.mouse.client.resize(c)
			end
		end)
	)

	-- Set root hotkeys
	--------------------------------------------------------------------------------
	root.keys(self.keys.root)
	root.buttons(self.mouse.root)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
