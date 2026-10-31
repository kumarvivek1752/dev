---@module 'hl'

-------------------
----  MONITORS  ---
-------------------

hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "0x0", scale = 1.25 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })

-- Unscale XWayland so X11 apps are not pixelated under the 1.25 scale
hl.config({ xwayland = { force_zero_scaling = true } })

-------------------
----  PROGRAMS  --
-------------------

local terminal = "ghostty"
local fileManager = "thunar"
local menu = "rofi -show drun"

-----------------------
----  LOOK AND FEEL  --
-----------------------

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 2,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
		col = {
			active_border = { colors = { "rgba(3F4553ee)", "rgba(9EA7A2ee)" }, angle = 45 },
			inactive_border = "rgba(9EA7A2aa)",
		},
	},
})

hl.config({
	decoration = {
		rounding = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		blur = { enabled = true, size = 3, passes = 1, vibrancy = 0.1696 },
	},
})

hl.config({ dwindle = { preserve_split = true } })
hl.config({ master = { new_status = "master" } })
hl.config({ misc = { force_default_wallpaper = 0, disable_hyprland_logo = true } })

-------------------
----  ANIMATION  --
-------------------

hl.config({ animations = { enabled = false } })

-- Inert while animations.enabled is false, but kept so flipping that one flag
-- back to true restores the previous behaviour exactly.
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-------------------
----  INPUT  ------
-------------------

hl.config({
	input = {
		kb_layout = "us",
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 0,
		repeat_rate = 60,
		touchpad = { natural_scroll = true },
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

hl.env("bitdepth", 10)

-------------------
----  KEYBINDS  --
-------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Let logind own the lock so hypridle handles it, with no brightness side effect.
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Offline speech-to-text dictation (Whisper)
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("/home/vivek/.local/bin/dictate-toggle"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------
----  MEDIA KEYS  -
-------------------

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 2%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 2%-"))
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-------------------
----  SCREENSHOT  -
-------------------

hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename -'))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim && grim - | wl-copy"))

---------------------
----  WINDOW RULES  -
---------------------

-- Every rule needs its own unique `name`: the Lua API keys rules by name, so
-- two rules sharing one name collapse into a single rule and the earlier one
-- is silently lost. Find a class with: xprop | grep WM_CLASS
-- Class matching is an anchored RE2 regex, so these are exact matches.

hl.window_rule({ name = "ws2-firefox-dev", match = { class = "firefox-developer-edition" }, workspace = 2 })

hl.window_rule({ name = "ws3-google-chrome", match = { class = "google-chrome" }, workspace = 3 })
hl.window_rule({ name = "ws3-firefox", match = { class = "firefox" }, workspace = 3 })

hl.window_rule({ name = "ws4-brave", match = { class = "brave-browser" }, workspace = 4 })
hl.window_rule({ name = "ws4-edge", match = { class = "microsoft-edge" }, workspace = 4 })
hl.window_rule({ name = "ws4-vscode", match = { class = "Code" }, workspace = 4 })

hl.window_rule({ name = "ws5-postman", match = { class = "Postman" }, workspace = 5 })

hl.window_rule({ name = "ws6-obs", match = { class = "com.obsproject.Studio" }, workspace = 6 })

hl.window_rule({ name = "ws8-abdm", match = { class = "com-abdownloadmanager-desktop-AppKt" }, workspace = 8 })
hl.window_rule({ name = "ws8-qbittorrent", match = { class = "org.qbittorrent.qBittorrent" }, workspace = 8 })
hl.window_rule({
	name = "ws8-jdownloader",
	match = { class = "install4j-org-jdownloader-update-launcher-JDLauncher" },
	workspace = 8,
})

hl.window_rule({ name = "ws9-protonvpn", match = { class = "protonvpn-app" }, workspace = 9 })
hl.window_rule({ name = "ws9-nordvpn", match = { class = "nordvpn-gui" }, workspace = 9 })

hl.window_rule({
	name = "satty-float",
	match = { class = "com.gabm.satty" },
	float = true,
	size = "50% 50%",
	move = "onscreen 50% 0%",
})

hl.window_rule({
	name = "kitty-float",
	match = { class = "kitty" },
	float = true,
	size = "50% 50%",
	move = "onscreen 50% 0%",
})

-- Debug Neovim window from scripts/nvim-debug-window.sh (nvim-dap). Only float
-- here: a fresh window reports fullscreen=1 (maximized) and size/move are
-- ignored while that is set, so the script clears it and sets geometry by address.
hl.window_rule({ name = "nvim-debug-float", match = { class = "nvim-debug" }, float = true })

-------------------
----  AUTOSTART  --
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("[workspace 8 silent] /home/vivek/.local/bin/ABDownloadManager")
	hl.exec_cmd("[workspace 8 silent] /usr/bin/jdownloader")
	hl.exec_cmd("brightnessctl s 10")
	hl.exec_cmd("~/.local/bin/battery_notify.sh")
	hl.exec_cmd("~/.local/bin/setup_backlight.sh")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("python3 ~/.local/bin/hypr-workspace-bridge.py")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("wl-paste --type text --watch cliphist -max-items 10000 store")
	hl.exec_cmd("wl-paste --type image --watch cliphist -max-items 10000 store")
	hl.exec_cmd("kdeconnect-indicator &")
	hl.exec_cmd("bluetoothctl connect 30:63:71:58:F6:64")
	hl.exec_cmd(
		"sleep 1.5 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start hyprpolkitagent"
	)
	hl.exec_cmd("dunst")
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh &")
	hl.exec_cmd("export QT_QPA_PLATFORM=wayland")
end)
