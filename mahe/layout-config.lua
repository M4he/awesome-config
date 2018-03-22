-----------------------------------------------------------------------------------------------------------------------
--                                                Layouts config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local layouts = {}


-- Build  table
-----------------------------------------------------------------------------------------------------------------------
function layouts:init(args)
	local args = args or {}

	-- layouts list
	local layset = {
		awful.layout.suit.floating,     -- 1
		awful.layout.suit.tile,         -- 2
		awful.layout.suit.magnifier,    -- 3
		awful.layout.suit.fair,         -- 4
		awful.layout.suit.tile.bottom,  -- 5
		awful.layout.suit.max,          -- 6
	}

	awful.layout.layouts = layset
end


-- End
-----------------------------------------------------------------------------------------------------------------------
return layouts
