-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
	-- utils
	awful.spawn.with_shell("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
	awful.spawn.with_shell("start-pulseaudio-x11")
	awful.spawn.with_shell("nm-applet")
	awful.spawn.with_shell("blueman-applet")
	awful.spawn.with_shell("system-config-printer-applet")
	-- screen locking
	awful.spawn.with_shell("mate-screensaver") -- main process
	awful.spawn.with_shell("xss-service") -- xss-lock spawner
	awful.spawn.with_shell("xset dpms 600 0 0") -- display standby
	awful.spawn.with_shell("xset s 120 0") -- lock screen trigger
	--
	awful.spawn.with_shell("killall compton; compton") -- compositor (re)start
end

-- Read and commands from file and spawn them
--------------------------------------------------------------------------------
function autostart.run_from_file(file_)
	local f = io.open(file_)
	for line in f:lines() do
		if line:sub(1, 1) ~= "#" then awful.spawn.with_shell(line) end
	end
	f:close()
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
