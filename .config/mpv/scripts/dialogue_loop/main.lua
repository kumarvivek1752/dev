-- dialogue_loop.lua
-- Language practice dialogue looper for MPV.
--
-- Default keybindings:
--   l        : Cycle Loop (1st: Mark [A], 2nd: Mark [B] & Loop, 3rd: Clear)
--   Ctrl+l   : Replay current loop immediately from [A]
--   [        : Slow down speed cleanly by 0.1x
--   ]        : Speed up cleanly by 0.1x
--   BS       : Reset speed to 1.0x (Normal)

local mp = require("mp")
local opt = require("mp.options")

local options = {
	lead_in = 2.0, -- Reaction time buffer (seconds) subtracted from [A]
	speed_step = 0.1, -- Speed adjustment step size
	min_speed = 0.2, -- Minimum playback speed limit
	max_speed = 3.0, -- Maximum playback speed limit
	osd_duration = 2.5, -- OSD display time in seconds
	enable_speed_keys = true, -- Use clean 0.1x stepping for '[' and ']'
}
opt.read_options(options, "dialogue_loop")

local state = 0 -- 0: idle, 1: A set, 2: looping A-B
local point_a = nil
local point_b = nil

local function format_time(seconds)
	if not seconds or seconds < 0 then
		return "00:00.0"
	end
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	if h > 0 then
		return string.format("%02d:%02d:%04.1f", h, m, s)
	else
		return string.format("%02d:%04.1f", m, s)
	end
end

local function format_speed(speed)
	if math.abs(speed - math.floor(speed)) < 0.001 then
		return string.format("%.1fx", speed)
	else
		return string.format("%.2fx", speed)
	end
end

local function clear_loop(show_osd)
	state = 0
	point_a = nil
	point_b = nil
	mp.set_property("ab-loop-a", "no")
	mp.set_property("ab-loop-b", "no")
	if show_osd then
		mp.osd_message("Dialogue Loop: Cleared", options.osd_duration)
	end
end

local function toggle_loop()
	local pos = mp.get_property_number("time-pos")
	if not pos then
		mp.osd_message("Dialogue Loop: No video loaded", options.osd_duration)
		return
	end

	if state == 0 then
		-- Step 1: Set Point A with lead-in buffer to catch dialogue start
		point_a = math.max(0, pos - options.lead_in)
		point_b = nil
		state = 1
		mp.set_property_number("ab-loop-a", point_a)
		mp.set_property("ab-loop-b", "no")

		local lead_text = ""
		if options.lead_in > 0 then
			lead_text = string.format(" (-%.2fs buffer)", options.lead_in)
		end
		mp.osd_message(
			string.format("Dialogue Loop: [A] Set at %s%s", format_time(point_a), lead_text),
			options.osd_duration
		)
	elseif state == 1 then
		-- Step 2: Set Point B, start looping, and seek back to Point A
		if pos <= point_a then
			-- Position was before Point A (user sought back), re-anchor Point A
			point_a = math.max(0, pos - options.lead_in)
			mp.set_property_number("ab-loop-a", point_a)
			mp.osd_message(
				string.format("Dialogue Loop: Updated [A] to %s", format_time(point_a)),
				options.osd_duration
			)
			return
		end

		point_b = pos
		state = 2
		mp.set_property_number("ab-loop-b", point_b)

		-- Seek immediately so the dialogue starts repeating without delay
		mp.commandv("seek", point_a, "absolute", "exact")

		local duration = point_b - point_a
		mp.osd_message(
			string.format(
				"Dialogue Loop: %s ➔ %s (%.1fs) | Looping",
				format_time(point_a),
				format_time(point_b),
				duration
			),
			options.osd_duration
		)
	else
		-- Step 3: Clear loop
		clear_loop(true)
	end
end

local function replay_loop()
	if point_a then
		mp.commandv("seek", point_a, "absolute", "exact")
		mp.osd_message(string.format("Dialogue Loop: Replaying from %s", format_time(point_a)), 1.5)
	else
		mp.osd_message("Dialogue Loop: No loop active", 1.5)
	end
end

local function change_speed(delta)
	local cur = mp.get_property_number("speed", 1.0)
	local step = options.speed_step
	local new_val = math.floor((cur + delta) / step + 0.5) * step
	new_val = math.max(options.min_speed, math.min(options.max_speed, new_val))
	mp.set_property_number("speed", new_val)
	mp.osd_message(string.format("Speed: %s", format_speed(new_val)), options.osd_duration)
end

local function reset_speed()
	mp.set_property_number("speed", 1.0)
	mp.osd_message("Speed: 1.0x (Normal)", options.osd_duration)
end

-- Sync state if loop points are cleared externally
mp.observe_property("ab-loop-a", "string", function(_, val)
	if val == "no" and state == 2 then
		local b_val = mp.get_property("ab-loop-b")
		if b_val == "no" then
			state = 0
			point_a = nil
			point_b = nil
		end
	end
end)

-- Reset state when file ends or changes
mp.register_event("end-file", function()
	state = 0
	point_a = nil
	point_b = nil
end)

-- Keybindings
mp.add_key_binding("l", "toggle", toggle_loop)
mp.add_key_binding("Ctrl+l", "replay", replay_loop)

if options.enable_speed_keys then
	mp.add_key_binding("[", "speed-down", function()
		change_speed(-options.speed_step)
	end, { repeatable = true })
	mp.add_key_binding("]", "speed-up", function()
		change_speed(options.speed_step)
	end, { repeatable = true })
	mp.add_key_binding("BS", "speed-reset", reset_speed)
end
