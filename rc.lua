-- local rc = "rc-red"
-- local rc = "rc-blue"
-- local rc = "rc-orange"
-- local rc = "rc-green"
-- local rc = "rc-colorless"
local rc = "rc-mahe"
require(rc)

-- workaround for unmaximized clients missing their border
-- see: https://github.com/awesomeWM/awesome/issues/1692
-- local beautiful = require("beautiful")
-- client.connect_signal("request::geometry", function(c)
--     if client.focus then
--         client.focus.ignore_border_width = false
--         client.focus.border_width = beautiful.border_width or 1
--     end
-- end)
