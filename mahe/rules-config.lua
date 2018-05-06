-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
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
	role = { "AlarmWindow", "pop-up", },
	type = { "dialog" }
}

rules.opacity_any = {
	class = { "Sublime_text", "Tilix" }
}

rules.messaging_apps = {
	class = {
		"Firefox-esr",
		"Pidgin",
		"Thunderbird",
		"Rocket.Chat+",
		"Hexchat"
	}
}

rules.opacity_val = beautiful.client_opacity or 1.0

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
			properties = { titlebars_enabled = true }
		},
		{
			rule_any   = { type = { "normal" }},
			properties = { placement = awful.placement.no_overlap + awful.placement.no_offscreen }
		},
		{
			rule_any = self.opacity_any,
			properties = {
				opacity = self.opacity_val
			}
		},
		-- custom rules
		{
			rule = { class = "Gsimplecal" },
			properties = { placement = awful.placement.bottom_right }
		},
		{
			rule_any = self.messaging_apps,
			properties = { screen = 1, tag = screen.primary.tags[2] }
		},
		{
			rule_any = { class = { "Audacious", "mpv" } },
			properties = {
				size_hints_honor = true,
			}
		},
		{
			rule = { class = "Wine" },
			properties = {
				floating = true,
			}
		},
		{
			rule = { class = "TeamSpeak 3" },
			properties = {
				floating = true,
				sticky = true,
				ontop = true,
				size_hints_honor = true,
			}
		},
		{
			rule = { class = "Covergloobus.py" },
			properties = {
				floating = true,
				sticky = true,
				size_hints_honor = true,
				border_width = 0,
			}
		},
		{
			rule = { class = "Oblogout" },
			properties = {
				floating = true,
				sticky = true,
				ontop = true,
				maximized = true,
				border_width = 0,
				titlebars_enabled = false
			}
		},
		{
			rule = { role = "descot" },
			-- enable click-through: this allows to reach desktop menus
			-- (and the like) by clicking the mascot
			callback = function(c)
				local cairo = require("lgi").cairo
				local img = cairo.ImageSurface(cairo.Format.A1, 0, 0)
				c.shape_input = img._native img:finish()
			end,
			properties = {
				floating = true,
				below = true,
				sticky = true,
				border_width = 0,
				focusable = false,
				rule_borderless = true
			}
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
