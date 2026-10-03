# MPV Real-time Subtitle Downloader (`sub_search`)

An MPV script that **automatically searches, downloads, and mounts English subtitles directly into your media folder** in real time.

---

## How It Works & Where Files Are Saved

When you press **`Ctrl+Shift+S`**:
1. **Target Directory**: The subtitle is saved directly into the **exact same directory where your video file is located**.
2. **File Naming**: Saved with the exact video name: `<video_filename>.en.srt`.
3. **Language**: Downloads **English (`en`)** subtitles by default (no other languages).
4. **Real-time Mounting**: MPV immediately detects and loads the new subtitle on screen without pausing or restarting playback.
5. **Two-Stage Smart Query**:
   * **Stage 1 (Exact Match)**: Queries OpenSubtitles REST API with the clean title and year (e.g. `The Life of Chuck 2024`).
   * **Stage 2 (Year Fallback)**: If no match is found, automatically retries without the year (e.g. `The Life of Chuck`) to resolve festival/theatrical release discrepancies (e.g. 2024 vs 2025).
6. **Browser Fallback**: If no online database has the subtitle (rare personal clips), it automatically opens the pre-filled search page in your browser.

---

## Keybindings

| Key | Action | Description |
| :--- | :--- | :--- |
| **`Ctrl+Shift+S`** | **Download English Subtitle** | Searches, extracts, and loads the best English subtitle directly into the media directory. |
| **`Ctrl+Shift+R`** | **Rescan & Reload** | Re-scans the video directory to attach any newly added `.srt` files. |

*(Note: `Ctrl+S` without Shift is MPV's default shortcut for taking a window screenshot, so `Ctrl+Shift+S` avoids conflict).*

---

## Universal Title Cleaner

The script features a universal title parser that strips out metadata and junk before querying:
* **Website Watermark Domains**: Strips site domains ending with web TLDs (`.tube`, `.ngo`, `.com`, `.net`, `.org`, `.vip`, `.to`, `.in`, `.tv`, `.site`, `.xyz`, etc.) such as `MoviesMod.tube` or `Vegamovies.ngo`.
* **Resolutions & Color Depth**: `2160p`, `1080p`, `720p`, `4k`, `uhd`, `10bit`, `8bit`, `hdr`.
* **Sources & Codecs**: `WEB-DL`, `WEBRip`, `BluRay`, `HDTV`, `x264`, `x265`, `hevc`, `avc`.
* **Audio & Subtitle Tags**: `DDP5.1`, `DD5.1`, `TrueHD`, `Atmos`, `AAC`, `DTS`, `English`, `ESubs`, `Dual Audio`.

---

## Configuration (`~/.config/mpv/script-opts/sub_search.conf`)

```ini
# Subtitle language (default is English)
language=en

# Fallback search URL pattern if automatic download has no match
search_url=https://subdl.com/search/{title}

# Automatically remove year on fallback search to prevent release year mismatches (e.g. 2024 vs 2025)
strip_year_on_fallback=yes

# Optional extra custom words/tags to strip from video filenames
custom_strip_words=

# Subliminal CLI executable path (optional secondary fallback)
subliminal_path=/home/vivek/.local/bin/subliminal

# OSD notification duration in seconds
osd_duration=3.5
```

---

## Architecture & File Structure

```
~/.config/mpv/scripts/sub_search/
├── main.lua       # MPV Lua frontend, keybindings, and OSD display
├── fetch_sub.py   # REST downloader & zip/srt extraction engine
└── README.md      # Documentation
```

1. `main.lua`: Handles keybindings in MPV, cleans the video title, and dispatches background downloads asynchronously.
2. `fetch_sub.py`: Fast Python engine that queries OpenSubtitles REST API, downloads the matching archive, extracts the `.srt`, and writes it to `<video_filename>.en.srt`.

---

## Login & Account Documentation

Automatic downloads use open REST APIs and require no login or API keys.

If you ever use the browser search fallback:
* **OpenSubtitles (`opensubtitles.com`)**: Log in to your free user account in your web browser. Having an active session bypasses download wait timers and CAPTCHA screens.
* **Subdl (`subdl.com`)**: Completely free and supports direct 1-click downloads.
