# MPV Dialogue Looper (`dialogue_loop`)

A lightweight MPV script tailored for **English practice, listening comprehension, and speech shadowing**. 

It allows you to mark any dialogue segment with a single keypress, loop it continuously with automatic reaction-time padding so the first words aren't clipped, and adjust playback speed in clean increments.

---

## Keybindings (Default MPV Keys)

This script prioritizes standard, default MPV keybindings so you do not need to memorize new or unnatural hotkeys:

| Key | Action | Description |
| :--- | :--- | :--- |
| **`l`** *(1st press)* | **Mark Start [A]** | Marks dialogue start. Automatically subtracts a `0.35s` buffer so reaction lag doesn't cut off the first syllable. |
| **`l`** *(2nd press)* | **Mark End [B] & Loop** | Marks dialogue finish, immediately rewinds to [A], and begins looping continuously. |
| **`l`** *(3rd press)* | **Clear Loop** | Clears the loop points and restores normal video playback. |
| **`Ctrl+l`** | **Replay Loop** | Jumps back to the start of dialogue [A] immediately without waiting for the loop to reach the end. |
| **`[`** | **Slow Down** | Decreases playback speed cleanly by `0.1x` (e.g. `1.0x` $\to$ `0.9x` $\to$ `0.8x`). |
| **`]`** | **Speed Up** | Increases playback speed cleanly by `0.1x` (e.g. `0.8x` $\to$ `0.9x` $\to$ `1.0x`). |
| **`Backspace`** | **Reset Speed** | Instantly resets playback speed to normal (`1.0x`). |

> **Note on `+` / `-` keys**: In MPV, bracket keys `[` and `]` are the standard speed controls. This ensures your existing zoom shortcuts on `+` and `-` remain untouched.

---

## Workflow for Language Learning

1. **Listen to Dialogue**: While watching an interview clip, podcast, or movie, listen to the speaker.
2. **Press `l` when phrase begins**: Point A is set. The script automatically rewinds `0.35s` before your keypress to capture the start of the speaker's sentence cleanly.
3. **Press `l` when phrase ends**: Point B is set. MPV immediately rewinds to Point A and loops the segment continuously.
4. **Shadow & Practice**:
   * If speech is too fast, press `[` to slow down (e.g. `0.8x` or `0.7x`) to catch phonemes and rhythm.
   * Speed back up to `1.0x` with `Backspace` once comfortable.
   * Press `Ctrl+l` anytime to restart the phrase from the beginning.
5. **Press `l` to continue**: Clears the loop and continues watching the video.

---

## Configuration (Optional)

You can customize default settings by creating a configuration file at:
`~/.config/mpv/script-opts/dialogue_loop.conf`

```ini
# Lead-in buffer in seconds subtracted from Point A to account for reaction time
lead_in=0.35

# Playback speed adjustment step size for '[' and ']'
speed_step=0.1

# Minimum and maximum speed limits
min_speed=0.2
max_speed=3.0

# OSD message display duration in seconds
osd_duration=2.5

# Whether to enable clean speed stepping on '[' and ']'
enable_speed_keys=yes
```

---

## Custom Keybindings (`input.conf`)

If you ever want to rebind the keys, you can bind to the script's exposed commands in `~/.config/mpv/input.conf`:

```conf
# Example custom bindings:
# Use 'a' to cycle dialogue loop
a script-binding dialogue_loop/toggle

# Use 'r' to replay loop from start
r script-binding dialogue_loop/replay

# Custom speed keys
F1 script-binding dialogue_loop/speed-down
F2 script-binding dialogue_loop/speed-up
F3 script-binding dialogue_loop/speed-reset
```

---

## Installation & File Structure

```
~/.config/mpv/
└── scripts/
    └── dialogue_loop/
        ├── main.lua     # Script implementation
        └── README.md    # Documentation
```

MPV automatically loads `main.lua` on startup.
