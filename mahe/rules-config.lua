-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")
local redtitle = require("redflat.titlebar")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
	border_width     = beautiful.border_width,
	border_color     = beautiful.border_normal,
	focus            = awful.client.focus.filter,
	raise            = true,
	size_hints_honor = false,
	screen           = awful.screen.preferred,
}

rules.floating_any = {
	class = {
		"Clipflap", "Run.py",
	},
	role = { "AlarmWindow", "pop-up", },
	type = { "dialog" }
}

rules.titlebar_exeptions = {
	class = { "Cavalcade", "Clipflap", "Steam" }
}

rules.maximized = {
	class = { "Emacs24" }
}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

	local args = args or {}
	self.base_properties.keys = args.hotkeys.keys.client
	self.base_properties.buttons = args.hotkeys.mouse.client


	-- Build rules
	--------------------------------------------------------------------------------
	self.rules = {
		{
			rule       = {},
			properties = args.base_properties or self.base_properties
		},
		{
			rule_any   = args.floating_any or self.floating_any,
			properties = { floating = true }
		},
		{
			rule_any   = self.maximized,
			callback = function(c)
				c.maximized = true
				redtitle.cut_all({ c })
				c.height = c.screen.workarea.height - 2 * c.border_width
			end
		},
		{
			rule_any   = { type = { "normal", "dialog" }},
			except_any = self.titlebar_exeptions,
			properties = { titlebars_enabled = true }
		},
		{
			rule_any   = { type = { "normal" }},
			properties = { placement = awful.placement.no_overlap + awful.placement.no_offscreen }
		},
		-- custom rules
		{
			rule = { class = "Gsimplecal" },
      		properties = { placement = awful.placement.bottom_right }
		},
		{
			-- set Firefox to always map on tags number 2 of screen 1.
			rule = { class = "Firefox-esr" },
      		properties = { screen = 1, tag = "Comm" }
		},
		{
			rule = { class = "Pidgin" },
      		properties = { screen = 1, tag = "Comm" }
		},
		{
			rule = { class = "Thunderbird" },
      		properties = { screen = 1, tag = "Comm" }
		},
		{
			rule = { class = "Audacious" },
      		properties = { screen = 1, tag = "Free" }
		},
		{
			rule = { class = "albert" },
      		properties = { border_width = 0 }
		},
		{
			-- hacky hack for LO Impress presentations
			-- the Impress are split in presentator view and presentation slides
			-- the latter is identified by its WM_NAME being "LibreOffice 5.2"
			-- whereas the former has the opened file prepended to its name
			--
			-- this is a very dirty way and may break at any new update of LO
			-- sadly there seems to be no cleaner way to do this
			-- NOTE: the presentation slides will always be on the second screen
			-- whereas the presentator view will always be on the first here
			rule = { name = "LibreOffice 5.2", class = "Soffice" },
			properties = { screen = screen.count()>1 and 2 or 1 }
		}
	}


	-- Set rules
	--------------------------------------------------------------------------------
	awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
