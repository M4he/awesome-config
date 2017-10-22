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
	awful.spawn.with_shell("dispwin -d1 ~/.config/color/CustomMacRumors.icc")
	-- awful.spawn.with_shell("pulseaudio")
	-- awful.spawn.with_shell("nm-applet")
	awful.spawn.with_shell("albert")
	awful.spawn.with_shell("gnome-screensaver-helper 2")
	awful.spawn.with_shell("sleep 1; compton")
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
