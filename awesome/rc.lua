-- {{{ Imports
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local ok, lain = pcall(require, "lain")
if not ok then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Missing library",
    text = lain,
  })
else
  local markup = lain.util.markup
end

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don"t go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })

        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_configuration_dir() .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
TERMINAL = "alacritty" or "x-terminal-emulator"
LAUNCHER = "sway-launcher-desktop"
EDITOR = os.getenv("EDITOR") or "vi" or "nano"
EDITOR_CMD = TERMINAL .. " -e " .. EDITOR
WALLAPAPER = os.getenv("HOME") .. "/Pictures/Wallpapers/dragon-black.jpg"

MODKEY = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
    { "hotkeys", function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end },
    { "manual", TERMINAL .. " -e man awesome" },
    { "edit config", EDITOR_CMD .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", TERMINAL }

local mymainmenu
if has_fdo then
    mymainmenu = freedesktop.menu.build {
        before = { menu_awesome },
        after = { menu_terminal },
    }
else
    mymainmenu = awful.menu {
        items = { menu_awesome, menu_terminal }
    }
end


local mylauncher = awful.widget.launcher {
    image = beautiful.awesome_icon,
    menu = mymainmenu
}

-- Menubar configuration
menubar.utils.terminal = TERMINAL -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 2, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({ }, 2, function(c) c:kill() end),
    awful.button({ }, 3, function() end),
    awful.button({ }, 4, function()
        client.focus.byidx(1)
    end),
    awful.button({ }, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local mytextclock = wibox.widget.textclock()
local mykeyboardlayout = awful.widget.keyboardlayout()
local mysystray = wibox.widget.systray()
mysystray:set_base_size(32)

local n_tags = 4
local tags = {}
for i = 1, n_tags do tags[i] = i end

awful.screen.connect_for_each_screen(function(s)
    gears.wallpaper.fit(WALLAPAPER, s)

    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we"re using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.layout.inc( 1) end),
        awful.button({ }, 3, function() awful.layout.inc(-1) end),
        awful.button({ }, 4, function() awful.layout.inc( 1) end),
        awful.button({ }, 5, function() awful.layout.inc(-1) end))
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

    -- Create the wibox
    s.mywibox = awful.wibar( { position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        { -- Middle widget
            layout = wibox.layout.flex.horizontal,
            s.mytasklist,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.layout.margin(mysystray, 0, 0, 3, 3),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local function launcher(env, args)
    local term = TERMINAL .. " --class=launcher -e"
    env = env or ""
    args = args or ""
    awful.spawn.with_shell(
        table.concat({term, env, LAUNCHER, args}, " ")
    )
end

local globalkeys = gears.table.join(
    awful.key({ MODKEY }, "p",
        function() launcher() end,
        { description = "show launcher", group = "launcher" }
    ),
    awful.key({ MODKEY }, "q",
        function() launcher("env PROVIDERS_FILE=power-menu.conf") end,
        { description = "power-menu", group = "launcher" }
    ),
    awful.key({ MODKEY }, "c",
        function() launcher("env PROVIDERS_FILE=edit-config.conf") end,
        { description = "power-menu", group = "launcher" }
    ),

    -- screenshots
    awful.key({ }, "Print",
        function()
            awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'", false)
        end,
        { description = "capture the whole screen", group = "screenshot" }
    ),

    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume",
        function()
            awful.util.spawn("amixer -q sset Master 5%-", false)
        end
    ),
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            awful.util.spawn("amixer -q sset Master 5%+", false)
        end
    ),
    awful.key({}, "XF86AudioMute",
        function()
            awful.util.spawn("amixer -q set Master 1+ toggle", false)
        end
    ),
    -- Media Keys
    awful.key({}, "XF86AudioPlay",
        function()
            awful.util.spawn("playerctl play-pause", false)
        end
    ),
    awful.key({}, "XF86AudioNext",
        function()
            awful.util.spawn("playerctl next", false)
        end
    ),
    awful.key({}, "XF86AudioPrev",
        function()
            awful.util.spawn("playerctl previous", false)
        end
    ),

    awful.key({ MODKEY }, "s",
        hotkeys_popup.show_help,
        { description="show help", group="awesome" }
    ),

    awful.key({ MODKEY }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),

    awful.key({ MODKEY }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),

    awful.key({ MODKEY }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key({ MODKEY }, "j",
        function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),

    awful.key({ MODKEY }, "k",
        function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),

    awful.key({ MODKEY }, "w",
        function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key({ MODKEY, "Shift" }, "j",
        function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),

    awful.key({ MODKEY, "Shift" }, "k",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }
    ),

    awful.key({ MODKEY }, "i",
        function() awful.screen.focus_relative( 1) end,
        { description = "focus the previous screen", group = "screen" }
    ),

    awful.key({ MODKEY }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ MODKEY }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }
    ),

    -- Standard program
    awful.key({ MODKEY }, "Return",
        function() awful.spawn(TERMINAL) end,
        { description = "open a terminal", group = "launcher" }
    ),

    awful.key({ MODKEY, "Control" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key({ MODKEY, "Control" }, "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key({ MODKEY }, "l",
        function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),

    awful.key({ MODKEY }, "h",
        function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),

    awful.key({ MODKEY, "Shift" }, "h",
        function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }
    ),

    awful.key({ MODKEY, "Shift" }, "l",
        function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),

    awful.key({ MODKEY, "Control" }, "h",
        function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),

    awful.key({ MODKEY, "Control" }, "l",
        function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),

    awful.key({ MODKEY }, "space",
        function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),

    awful.key({ MODKEY, "Shift" }, "space",
        function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
	),

    awful.key({ MODKEY, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate",
                    "key.unminimize",
                    { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }
	),

    -- Prompt
    awful.key({ MODKEY }, "r",
        function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }
	),

    awful.key({ MODKEY }, "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval",
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
	)
)

local clientkeys = gears.table.join(
    awful.key({ MODKEY }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
	),

    awful.key({ MODKEY, "Shift" }, "q",
        function(c) c:kill() end,
        { description = "close", group = "client" }
	),

    awful.key({ MODKEY, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
	),

    awful.key({ MODKEY, "Control" }, "Return",
        function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
	),

    awful.key({ MODKEY }, "o",
        function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
	),

    awful.key({ MODKEY }, "t",
        function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
	),

    awful.key({ MODKEY }, "n",
        function(c)
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
	),

    awful.key({ MODKEY }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
	),

    awful.key({ MODKEY, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }
	),

    awful.key({ MODKEY, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to n_tags.
for i = 1, n_tags do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ MODKEY }, i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   tag:view_only()
                end
            end,
            { description = "view tag #"..i, group = "tag" }
	    ),

        -- Toggle tag display.
        awful.key({ MODKEY, "Control" }, i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #"..i, group = "tag" }
	    ),

        -- Move client to tag.
        awful.key({ MODKEY, "Shift" }, i,
            function()
                if awful.client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
	    ),

        -- Toggle tag on focused client.
        awful.key({ MODKEY, "Control", "Shift" }, i,
            function()
                if awful.client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #"..i, group = "tag" }
        )
    )
end

local clientbuttons = gears.table.join(
    awful.button({ }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),

    awful.button({ MODKEY }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),

    awful.button({ MODKEY }, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    { -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    },

    { -- Launchers
        properties = {
            floating = true,
            placement = awful.placement.centered,
            skip_taskbar = true,
        },
        rule_any = {
            class = { "launcher" }
        }
    },

    { -- Floating clients.
        properties = {
            floating = true,
            placement = awful.placement.centered
        },
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            } ,
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "krunner",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird"s calendar.
                "ConfigManager", -- Thunderbird"s about:config.
                "pop-up", -- e.g. Google Chrome"s (detached) Developer Tools.
            }
        }
    },


    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    -- properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),

        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton(c),
            --awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
local commands = {
    "xinput set-prop 14 'libinput Natural Scrolling Enabled' 1",
    "picom",
    "nm-applet",
    "unclutter",
    "setxkbmap -layout pl -option 'caps:ctrl_modifier'",
}

for i = 1, #commands do
    awful.spawn.with_shell(commands[i])
end
-- }}}

-- vim:foldmethod=marker:foldlevel=0:
