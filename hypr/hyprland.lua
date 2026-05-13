-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- hyprlock --immediate-render || hyprctl dispatch exit")
end)

local c = require("hyprcolors")

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "HDMI-A-1",
	mode = "3440x1440@99.98Hz",
	position = "auto",
	scale = "auto",
})
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "1.5",
})

-- Alternative monitor config
-- hl.monitor({
--     output = "DP-2",
--     mode = "3840x2160@60.00Hz",
--     position = "auto",
--     scale = 1.6,
-- })

for i = 1, 10 do
	local external_mon = "HDMI-A-1"
	-- local external_mon = "DP-2"
	hl.workspace_rule({ workspace = tostring(i), monitor = i % 2 == 1 and external_mon or "eDP-1" })
end

---------------------
---- MY PROGRAMS ----
---------------------

--- @type fun(cmd: string|string[]): HL.Dispatcher
local function launch(cmd)
	if type(cmd) == "table" then
		cmd = table.concat(cmd, " && ")
	elseif type(cmd) ~= "string" then
		error("launch: expected string or array of strings")
	end

	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end
local terminal = "ghostty"

-------------------------------
---- ENVIRONMENT VARIABLES ----
---  NOTE: when using uwsm ----
--- do not use hyprland to ----
--- set env vars           ----
-------------------------------

-- hl.env("XCURSOR_THEME", "Nordzy-cursors")
-- hl.env("HYPRCURSOR_THEME", "Nordzy-cursors")
-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 2,
		border_size = 2,
		col = {
			active_border = {
				colors = { c.color11, c.color13 },
				angle = 45,
			},
			inactive_border = c.color7,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
	},

	decoration = {
		rounding = 10,
		active_opacity = 1,
		inactive_opacity = 0.98,
		fullscreen_opacity = 1,
		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			new_optimizations = true,
			ignore_opacity = true,
			xray = true,
			popups = true,
		},
		shadow = {
			enabled = false,
			range = 10,
			render_power = 5,
			color = "rgba(ffffffff)",
		},
	},

	animations = {
		enabled = true,
	},

	cursor = {
		hide_on_key_press = true,
	},

	scrolling = {
		focus_fit_method = 0,
		follow_min_visible = 1,
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	debug = {
		disable_logs = true,
	},

	group = {
		col = {
			border_active = {
				colors = { c.color11, c.color13 },
				angle = 45,
			},
			border_inactive = c.color7,
		},

		groupbar = {
			font_family = "Cascadia Mono",
			col = {
				active = c.color11,
				inactive = c.color7,
			},
			text_color = "rgb(000000)",
			gradients = true,
			gradient_rounding = 3,
			gradient_round_only_edges = false,
			indicator_height = 0,
			scrolling = false,
		},
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:swapescape,compose:ralt",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0.6,
		accel_profile = "flat",
		touchpad = {
			drag_lock = true,
			natural_scroll = true,
			scroll_factor = 0.3,
			drag_3fg = true,
		},
	},
})

hl.curve("linear", {
	type = "bezier",
	points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("swirl", {
	type = "bezier",
	points = { { 0.1, 1.4 }, { 0.3, 1 } },
})

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 2,
	bezier = "swirl",
	style = "popin 0%",
})
hl.animation({
	leaf = "fade",
	enabled = false,
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2,
	bezier = "swirl",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 2,
	bezier = "swirl",
	style = "slidevert -50%",
})

---------------
---- INPUT ----
---------------

hl.gesture({
	fingers = 2,
	mods = "SUPER",
	direction = "pinch",
	action = "cursor_zoom",
	mode = "live",
})

hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "scroll_move",
	scale = 3,
})
hl.gesture({
	fingers = 4,
	direction = "horizontal",
	mods = "SUPER",
	action = "workspace",
})

local bind = {
	---@type fun(
	---	keys: string,
	---	dispatcher: HL.Dispatcher|function,
	---	opts?: HL.BindOptions): HL.Keybind
	m = function(keys, dispatcher, opts)
		return hl.bind("SUPER + " .. keys, dispatcher, opts)
	end,
}

bind.m("return", launch(terminal .. " +new-window"))
bind.m("w", hl.dsp.window.close())
bind.m("M", launch("loginctl lock-session"))
bind.m("ALT + M", launch("wlogout"))

bind.m("E", launch(terminal .. " --class=foo.yazi -e yazi"))

bind.m("ALT + V", hl.dsp.window.float({ action = "toggle" }))

bind.m("SPACE", launch("wofi --show drun"))

bind.m("V", launch(terminal .. " --class=foo.clipse -e clipse"))

bind.m("n", launch("swaync-client -t -sw"))

bind.m("b", launch("pkill -SIGUSR1 waybar"))

bind.m("SHIFT + c", launch("hyprpicker -a -f hex"))

bind.m("f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind("Print", launch('grim -g "$(slurp)" - | satty --filename -'))

hl.bind("Insert", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "initialtitle:Discord" }))
hl.bind("ALT + Insert", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "D", window = "initialtitle:Discord" }))

-- Scrolling layout focus
bind.m("h", hl.dsp.layout("focus l"))
bind.m("l", hl.dsp.layout("focus r"))

-- Scrolling layout movement
bind.m("ALT + h", hl.dsp.layout("swapcol l"))
bind.m("ALT + k", hl.dsp.layout("promote"))
bind.m("ALT + l", hl.dsp.layout("swapcol r"))

-- stylua: ignore
local workspaceKeymap = {
	{ "1", "2", "3", "4", "5",     "6", "7", "8", "9", "0" },
	{  10,  6,   2,   4,   8,       7,   3,   1,   5,   9 },
}
for i = 1, 10 do
	local key = workspaceKeymap[1][i]
	local ws = workspaceKeymap[2][i]

	bind.m(key, hl.dsp.focus({ workspace = ws }))
	bind.m("SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

bind.m("S", hl.dsp.workspace.toggle_special("magic"))
bind.m("SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("ALT + tab", hl.dsp.group.next())

bind.m("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind.m("ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

bind.m("ALT + t", hl.dsp.group.toggle())

hl.bind(
	"XF86AudioRaiseVolume",
	launch("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	launch("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", launch("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", launch("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

bind.m("XF86AudioRaiseVolume", launch({ "brightnessctl s 75%", "ddcutil setvcp 10 80" }), { locked = true })
bind.m("XF86AudioLowerVolume", launch({ "brightnessctl s 15%", "ddcutil setvcp 10 0" }), { locked = true })
hl.bind("XF86MonBrightnessUp", launch({ "brightnessctl s 75%", "ddcutil setvcp 10 80" }), { locked = true })
hl.bind("XF86MonBrightnessDown", launch({ "brightnessctl s 15%", "ddcutil setvcp 10 0" }), { locked = true })

hl.bind("XF86AudioNext", launch("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", launch("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", launch("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", launch("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "ripdrag-follow-cursor",
	match = { class = "it\\.catboy\\.ripdrag" },
	move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5))",
})

hl.window_rule({
	name = "passbolt-float",
	match = { title = "Passbolt" },
	float = true,
})
hl.window_rule({
	name = "passbolt-size",
	match = { title = "Passbolt" },
	size = "380 350",
})
hl.window_rule({
	name = "passbolt-move",
	match = { title = "Passbolt" },
	move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5))",
})

local file_pickers = { "yazi", "termfilechooser" }
for _, f in ipairs(file_pickers) do
	hl.window_rule({
		name = f .. "-float",
		match = { class = "foo\\." .. f },
		float = true,
	})
	hl.window_rule({
		name = f .. "-size",
		match = { class = "foo\\." .. f },
		size = "1000 1000",
	})
	hl.window_rule({
		name = f .. "-center",
		match = { class = "foo\\." .. f },
		center = true,
	})
end

local tui_utils = { "clipse", "impala", "bluetui" }
for _, t in ipairs(tui_utils) do
	hl.window_rule({
		name = t .. "-float",
		match = { class = "foo\\." .. t },
		float = true,
	})
	hl.window_rule({
		name = t .. "-size",
		match = { class = "foo\\." .. t },
		size = "600 660",
	})
	hl.window_rule({
		name = t .. "-center",
		match = { class = "foo\\." .. t },
		center = true,
	})
end

hl.window_rule({
	name = "r-x11-workspace",
	match = { class = "R_x11" },
	tile = true,
	workspace = "10 silent",
})

local layers = { "wofi", "waybar", "swaync-control-center", "swaync-notification-window" }
for _, l in ipairs(layers) do
	hl.layer_rule({
		name = l .. "-layer-effects",
		match = { namespace = l },
		blur = true,
		ignore_alpha = 0.2,
	})
end

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "anydesk-float",
	match = {
		class = "^(Anydesk)$",
		title = "^(anydesk)$",
	},
	float = true,
})

hl.window_rule({
	name = "discord-workspace",
	match = { initial_title = "Discord" },
	workspace = "4",
})
hl.window_rule({
	name = "whatsapp-workspace",
	match = { initial_title = "WhatsApp Web" },
	workspace = "4",
})
