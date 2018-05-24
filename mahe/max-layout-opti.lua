-----------------------------------------------------------------------------------------------------------------------
--                                                Special Max Layout Config                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- TODO
--- on tag enter/leave, save/restore minimized states per screen
--- proper multiscreen handling
--- maxopti switch: optional class sort (like tasklist)
--- genuine history buffer, + as optional switch alternative
---- if history.get() does not return valid client, go further back in history, remove invalid clients
------ (scenaria: Thunderbird compose new msg, send -> sending popup, popup closes, compose window closes
------  BUT main should be restored!)

-- Grab environment
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

-- determines whether a tag is applicable for the special handling of this module
local function is_max_tag(t)
    return tostring(t.layout.name) == "max"
end

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local maxopti = {history = {state = {}}}

-- focus handling reference: https://github.com/awesomeWM/awesome/blob/master/lib/awful/client/focus.lua

-- filter to exclude clients from focus history
function maxopti.history.filter(c)
    if c.type == "desktop"
        or c.type == "dock"
        or c.type == "splash"
        or not c.focusable then
        return nil
    end
    return c
end

-- update focus history for newly focused client
function maxopti.history.update(c)
    if not maxopti.history.filter(c) then return end
    local t = c.screen.selected_tag
    if is_max_tag(t) then
        if not maxopti.history.state[t] then maxopti.history.state[t] = {} end
        if not maxopti.history.state[t].active then
            maxopti.history.state[t].last = c
            maxopti.history.state[t].active = c
        elseif c ~= maxopti.history.state[t].active then
            maxopti.history.state[t].last = maxopti.history.state[t].active
            maxopti.history.state[t].active = c
        end
    end
end

-- get the previously focused client from history
function maxopti.history.get(t)
    if not is_max_tag(t) then return nil end
    return maxopti.history.state[t].last or nil
end

-- minimizes all clients except the focused one
local function trigger_unfocused_minimize()
    local fc = client.focus
    if fc then
        local t = fc.screen.selected_tag
        if is_max_tag(t) then
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

-- 'inspired' by awful.client.next()
-- i = index distance to 'sel', may be negative for reverse traversal
-- sel = selected client
-- t = selected tag
--
-- TODO
--- if multiple tags selected, also switch through their clients
---- (use screen.selected_tags(), iterate and merge client tables?)
function maxopti.switch(i, sel, t)
    -- Get currently focused client
    sel = sel or client.focus
    if sel then
        -- Get all visible clients
        local cls = t:clients()
        local fcls = {}
        -- Remove all non-normal clients
        for _, c in ipairs(cls) do
            if maxopti.history.filter(c) or c == sel then
                table.insert(fcls, c)
            end
        end
        cls = fcls
        -- Loop upon each client
        for idx, c in ipairs(cls) do
            if c == sel then
                -- Cycle
                return cls[gears.math.cycle(#cls, idx + i)]
            end
        end
    end
end

function maxopti.raise_previous(t, focus)
    local c = maxopti.history.get(t)
    if c and c.valid and maxopti.history.filter(c) then
    -- naughty.notify({text="client: " .. tostring(c.name)})
        c.minimized = false
        if focus then
            client.focus = c
        end
        c:raise()
    end
end

-- A-B toggle between 2 most recent apps
function maxopti.focus_to_previous()
    local fc = client.focus
    if not fc then return end
    local t = fc.screen.selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        -- naughty.notify({text="QUIRK:focus_to_previous"})
        maxopti.raise_previous(t, true)
    else
        -- handling for normal layouts
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end
end

-- "Alt-Tab" behavior
function maxopti.switch_app_next()
    local fc = client.focus
    if not fc then return end
    local t = fc.screen.selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        -- naughty.notify({text="QUIRK:switch_app_next"})
        local c = maxopti.switch(1, fc, t)
        if c then
            -- naughty.notify({text="QUIRK:client " .. tostring(c.name)})
            c.minimized = false
            client.focus = c
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

-- "Alt-Tab" behavior (reversed)
function maxopti.switch_app_prev()
    local fc = client.focus
    if not fc then return end
    local t = fc.screen.selected_tag
    if is_max_tag(t) then
        -- special handling for max layout
        -- naughty.notify({text="QUIRK:switch_app_prev"})
        -- restore the previous client in list
        local c = maxopti.switch(-1, fc, t)
        if c then
            -- naughty.notify({text="QUIRK:client " .. tostring(c.name)})
            c.minimized = false
            client.focus = c
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
            maxopti.history.update(c)
            trigger_unfocused_minimize()
        end
    )
    -- client.connect_signal(
    --     "unmanage",
    --     function(c)
    --         naughty.notify({text="unmanage"})
    --         local t = c.screen.selected_tag
    --         -- TODO, check if screen has focus, set focus in raise_previous accordingly
    --         if t and is_max_tag(t) then maxopti.raise_previous(t) end
    --     end
    -- )
    tag.connect_signal(
        "untagged",
        function(t)
            -- naughty.notify({text="untagged"})
            if t and is_max_tag(t) and t.selected then maxopti.raise_previous(t) end
        end
    )

    -- TODO
    --- trigger raise_previous() when client gets dragged away from screen
    ---- (also concerns taglist bug! +untagged_signal)


    -- tag.connect_signal(
    --     "property::selected",
    --     function(t)
    --         if t.selected then
    --             trigger_unfocused_minimize()
    --         end
    --     end
    -- )

end

-- End
-----------------------------------------------------------------------------------------------------------------------
return maxopti
