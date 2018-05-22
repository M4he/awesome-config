-----------------------------------------------------------------------------------------------------------------------
--                                                Special Max Layout Config                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local maxopti = {}

local function is_max_tag(t)
    return tostring(t.layout.name) == "max"
end

local function ensure_max_layout()
    local t = awful.screen.focused().selected_tag
    if is_max_tag(t) then
        local fc = client.focus
        if fc then
            for _, c in ipairs(t.screen.clients) do
                if c == fc then
                    c.minimized = false
                elseif not c.floating and not fc.floating then
                    -- minimize any applicable non-focused clients
                    c.minimized = true
                end
            end
        end
    end
end

local function get_next_client()
    return nil
end

local function get_prev_client()
    return nil
end

-- A-B toggle between 2 most recent apps
function maxopti.focus_to_previous()
    local t = awful.screen.focused().selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        naughty.notify({text="QUIRK:focus_to_previous"})
        local fc = client.focus
        if fc then
            local s = fc.screen
            local c = awful.client.focus.history.get(s, 0)
            if c then
                naughty.notify({text="QUIRK:previous " .. tostring(c.name)})
                c.minimized = false
                client.focus = c
                c:raise()
            end
        end
    else
        -- handling for normal layouts
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end
end

-- "Alt-Tab" behavior
function maxopti.switch_app_next()
    local t = awful.screen.focused().selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        naughty.notify({text="QUIRK:switch_app_next"})
        local c = awful.client.next(-1)
        if c then
            naughty.notify({text="QUIRK:client " .. tostring(c.name)})
            c.minimized = false
            c:raise()
        end
    else
        -- handling for normal layouts
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end
end

-- "Alt-Tab" behavior reversed
function maxopti.switch_app_prev()
    local t = awful.screen.focused().selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        naughty.notify({text="QUIRK:switch_app_prev"})
        -- restore the previous client in list
        local c = awful.client.next(1)
        if c then
            naughty.notify({text="QUIRK:client " .. tostring(c.name)})
            c.minimized = false
            c:raise()
        end
    else
        -- handling for normal layouts
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end
end

-- Build table
-----------------------------------------------------------------------------------------------------------------------
function maxopti:init(args)

    client.connect_signal(
        "focus",
        function(c)
            ensure_max_layout()
        end
    )
    -- tag.connect_signal(
    --     "property::selected",
    --     function(t)
    --         if t.selected then
    --             ensure_max_layout()
    --         end
    --     end
    -- )

end

-- End
-----------------------------------------------------------------------------------------------------------------------
return maxopti
