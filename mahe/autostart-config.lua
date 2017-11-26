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
    awful.spawn.with_shell("seafile-applet")
    awful.spawn.with_shell("system-config-printer-applet")
    awful.spawn.with_shell("xset dpms 0 0 0") -- turn off display standby
    --
	awful.spawn.with_shell("killall compton; compton")
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
