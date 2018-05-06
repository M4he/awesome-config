local theme = {}

theme.color = {
    main      = "#2EB37B",
    gray      = "#5C696B",  -- used for inactive elements and bar trunks
    bg        = "#191A1F",  -- bg used for custom widgets (e.g. appswitcher, top)
    bg_second = "#14161A",  -- alternating lines for 'bg'
    wibox     = "#292D33",  -- border, panel and general background color
    icon      = "#EEEEEE",  -- icons in menus
    text      = "#EEEEEE",  -- text in menus and titlebars
    urgent    = "#FF4070",  -- urgent window highlight in taglist, tasklist also volume mute
    highlight = "#292D33",  -- text when highlighted in menu
    empty     = "#5C696B",  -- circle tag empty color

    border    = "#404040",  -- tooltip border
    shadow1   = "#363D47",  -- separator dark side
    shadow2   = "#363D47",  -- separator bright side
    shadow3   = "#808080",  -- buttons outer border
    shadow4   = "#5C696B",  -- buttons inner border

    secondary = "#A6A9B3",
    title_off = "#D9D9D9",   -- unfocused titlebar color
    border_normal = "#D9D9D9",
    border_focus  = "#2EB37B",
}

return theme