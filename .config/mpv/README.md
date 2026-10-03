# MPV Configuration & Custom Plugins

This directory (`~/.config/mpv/`) contains custom configurations and plugins designed for **English practice, dialogue looping, and real-time subtitle downloading**.

---

## Installed Plugins

### 1. [Dialogue Looper (`dialogue_loop`)](file:///home/vivek/.config/mpv/scripts/dialogue_loop/README.md)
* **Location**: `~/.config/mpv/scripts/dialogue_loop/`
* **Purpose**: Designed for speech shadowing and dialogue repetition.
* **Keybindings**:
  * **`l`**: 3-stage A-B loop toggle:
    * 1st press: Sets Start [A] with an automatic `0.35s` reaction-time buffer.
    * 2nd press: Sets End [B], immediately rewinds to [A], and loops continuously.
    * 3rd press: Clears loop and resumes normal playback.
  * **`Ctrl+l`**: Replay current loop from Start [A] immediately.
  * **`[`** / **`]`**: Adjust playback speed in clean `0.1x` steps (`0.8x`, `0.9x`, `1.0x`, etc.).
  * **`Backspace`**: Reset playback speed to `1.0x (Normal)`.

---

### 2. [Real-time Subtitle Downloader (`sub_search`)](file:///home/vivek/.config/mpv/scripts/sub_search/README.md)
* **Location**: `~/.config/mpv/scripts/sub_search/`
* **Purpose**: Automatically downloads and mounts English subtitles directly into the media directory in real time.
* **Keybindings**:
  * **`Ctrl+Shift+S`**: Searches OpenSubtitles REST API, downloads the archive, extracts `.srt`, and attaches it in under 2 seconds.
  * **`Ctrl+Shift+R`**: Re-scans the video folder to detect any newly added subtitles.
* **Features**:
  * **Universal Title Parser**: Strips website watermarks (`MoviesMod.tube`, `Vegamovies.ngo`), codecs, resolutions, and tags.
  * **Year Fallback**: Automatically retries without the year (e.g. `The Life of Chuck`) if the initial year query returns no matches.
  * **Direct Media Directory Saving**: Saves as `<video_name>.en.srt` in the same directory as the playing file.
  * **English Only**: Restricted to English subtitles.

---

### 3. Audio & Voice Switching
* **`#`** (`Shift + 3`): Cycle between available audio tracks / languages (`cycle audio`).
* **`Ctrl + +`** / **`Ctrl + -`**: Adjust audio delay by $\pm 100\text{ms}$ for lip-sync.

---

## Directory Structure

```
~/.config/mpv/
├── input.conf                      # Custom user keybindings
├── mpv.conf                        # Core MPV options (sub-auto=fuzzy)
├── README.md                       # This file
├── script-opts/
│   └── sub_search.conf             # Subtitle search options
└── scripts/
    ├── dialogue_loop/              # Dialogue Looper plugin
    │   ├── main.lua
    │   └── README.md
    └── sub_search/                 # Real-time Subtitle Downloader plugin
        ├── main.lua
        ├── fetch_sub.py
        └── README.md
```
