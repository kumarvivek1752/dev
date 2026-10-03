-- sub_search.lua
-- Real-time English subtitle downloader and search for MPV.
--
-- Keybindings:
--   Ctrl+Shift+S / Ctrl+S  : Download English subtitle directly to media directory & auto-load
--   Ctrl+Shift+R / Ctrl+R  : Rescan directory and reload subtitles

local mp = require 'mp'
local opt = require 'mp.options'

local options = {
    -- Target subtitle language (default: en / English)
    language = "en",
    -- Fallback search URL pattern ({title} is replaced by cleaned title)
    search_url = "https://subdl.com/search/{title}",
    -- Browser command (for fallback or manual search)
    browser_cmd = "xdg-open",
    -- Subliminal binary path
    subliminal_path = "/home/vivek/.local/bin/subliminal",
    -- Optional extra custom words/tags to strip
    custom_strip_words = "",
    -- Remove year from search query on fallback to avoid release year mismatches
    strip_year_on_fallback = true,
    -- OSD message duration in seconds
    osd_duration = 3.5
}
opt.read_options(options, "sub_search")

local is_downloading = false

local default_junk_words = {
    "2160p", "1080p", "720p", "480p", "4k", "uhd", "fhd", "hd",
    "bluray", "bdrip", "brrip", "remux", "webrip", "webdl", "web", "dl", "hdtv", "dvdrip",
    "x264", "x265", "h264", "h265", "hevc", "avc", "10bit", "8bit", "hdr", "hdr10", "dv",
    "aac", "ac3", "dts", "dtshd", "truehd", "atmos",
    "rarbg", "yify", "yts", "psa", "sparks", "eztv", "galaxyrg", "cmrg", "tgx", "qxr"
}

local function url_encode(str)
    if not str then return "" end
    str = str:gsub("\n", "\r\n")
    str = str:gsub("([^%w %-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = str:gsub(" ", "+")
    return str
end

local function clean_title(raw_name)
    if not raw_name or raw_name == "" then return "" end

    -- 1. Strip file extension
    local name = raw_name:gsub("%.%w+$", "")

    -- 2. Remove website watermark domains (e.g. MoviesMod.tube, vegamovies.ngo, yts.mx, 1337x.to)
    local tlds = {
        "tube", "ngo", "com", "net", "org", "vip", "to", "in", "tv", "me", "co", "cc",
        "site", "xyz", "club", "top", "info", "biz", "link", "live", "ws", "mx", "wtf"
    }
    for _, tld in ipairs(tlds) do
        name = name:gsub("[%w%-_]+%." .. tld .. "%f[%W]", " ")
        name = name:gsub("[%w%-_]+%." .. tld:upper() .. "%f[%W]", " ")
    end

    -- 3. Replace common separators, brackets, and delimiters with spaces
    name = name:gsub("[%.%_%+]", " ")
    name = name:gsub("[%[%]%{%}%(%)]", " ")
    name = name:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

    -- 4. Check for Season/Episode pattern: S01E02, s01e02, 1x02
    local s_e = name:match("([sS]%d%d?%s*[eE]%d%d?)") or name:match("(%d%d?x%d%d?)")
    if s_e then
        local before = name:match("^(.-)%s*" .. s_e)
        if before and before:gsub("%s+", "") ~= "" then
            name = before .. " " .. s_e
        end
    else
        -- 5. Check for 4-digit Year between 1920 and 2099
        -- In standard movie naming, technical specs always follow the Year
        local before, year = name:match("^(.-)%s+([12]%d%d%d)%f[%D]")
        if before and before:gsub("%s+", "") ~= "" then
            name = before .. " " .. year
        else
            -- 6. If no year, cut off at the first technical specification tag
            local cut_markers = {
                "2160p", "1080p", "720p", "480p", "4k", "uhd", "fhd", "hd",
                "bluray", "bdrip", "brrip", "remux", "web%-?dl", "web%-?rip", "web", "hdtv", "dvdrip",
                "x264", "x265", "h264", "h265", "hevc", "avc", "10bit", "8bit"
            }
            local lower_name = name:lower()
            local earliest_pos = nil
            for _, marker in ipairs(cut_markers) do
                local pos = lower_name:find("%f[%w]" .. marker .. "%f[%W]")
                if pos and (earliest_pos == nil or pos < earliest_pos) then
                    earliest_pos = pos
                end
            end
            if earliest_pos and earliest_pos > 2 then
                name = name:sub(1, earliest_pos - 1):gsub("%s+$", "")
            end
        end
    end

    -- 7. Clean up any residual release keywords
    local junk_words = {
        "english", "esubs", "esub", "msubs", "msub", "subs", "sub", "dual audio", "multi audio", "multi",
        "hindi", "tamil", "telugu", "dubbed", "10bit", "8bit", "imax", "repack", "proper", "unrated"
    }
    for _, jw in ipairs(junk_words) do
        name = name:gsub("%f[%a]" .. jw .. "%f[%A]", " ")
        name = name:gsub("%f[%a]" .. jw:upper() .. "%f[%A]", " ")
    end

    name = name:gsub("%s*-%s*", " ")
    name = name:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return name
end

local function strip_year(title)
    if not title or title == "" then return "" end
    local without_year = title:gsub("%s+[12]%d%d%d%f[%D]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    return without_year
end

local function open_browser_search(cleaned_title)
    local encoded = url_encode(cleaned_title)
    local target_url = options.search_url:gsub("{title}", encoded):gsub("{query}", encoded)
    mp.command_native_async({
        name = "subprocess",
        args = {options.browser_cmd, target_url},
        playback_only = false
    }, function() end)
end

local function download_and_load_subtitles()
    local path = mp.get_property("path")
    if not path or path == "" then
        mp.osd_message("Subtitle: No video loaded", options.osd_duration)
        return
    end

    -- If playing an online stream (e.g. YouTube), open browser search
    if path:find("^https?://") or path:find("^ytdl://") then
        local raw_title = mp.get_property("media-title") or path
        local cleaned = clean_title(raw_title)
        local search_query = cleaned
        if options.strip_year_on_fallback then
            local no_year = strip_year(cleaned)
            if no_year ~= "" and no_year ~= cleaned then
                search_query = no_year
            end
        end
        mp.osd_message(string.format("Streaming video. Opening subtitle search for:\n\"%s\"", search_query), options.osd_duration)
        open_browser_search(search_query)
        return
    end

    if is_downloading then
        mp.osd_message("⏳ Subtitle download already in progress...", 2.0)
        return
    end

    local raw_title = mp.get_property("filename") or path
    local cleaned = clean_title(raw_title)

    is_downloading = true
    mp.osd_message(string.format("⏳ Downloading English subtitles into media folder...\n\"%s\"", cleaned), 3.0)

    local script_dir = mp.get_script_directory() or "/home/vivek/.config/mpv/scripts/sub_search"
    local fetch_script = script_dir .. "/fetch_sub.py"

    mp.command_native_async({
        name = "subprocess",
        args = {"python3", fetch_script, path, cleaned},
        capture_stdout = true,
        capture_stderr = true,
        playback_only = false
    }, function(success, res, err)
        is_downloading = false
        local stdout = (res and res.stdout) or ""
        local downloaded = (res and res.status == 0) or (stdout:find("SUCCESS:") ~= nil)

        if success and downloaded then
            -- Rescan directory and auto-select new subtitle
            mp.commandv("rescan-external-files", "reselect")
            mp.osd_message("✅ English subtitle downloaded & loaded!", options.osd_duration)
        else
            -- If auto-download failed to find a match, remove year and fallback to browser search
            local search_query = cleaned
            local year_removed = false
            if options.strip_year_on_fallback then
                local no_year = strip_year(cleaned)
                if no_year ~= "" and no_year ~= cleaned then
                    search_query = no_year
                    year_removed = true
                end
            end

            local notice = "⚠️ No direct match found."
            if year_removed then
                notice = notice .. "\nRetrying search without year:\n\"" .. search_query .. "\""
            else
                notice = notice .. "\nOpening browser search:\n\"" .. search_query .. "\""
            end

            mp.osd_message(notice, options.osd_duration)
            open_browser_search(search_query)
        end
    end)
end

local function rescan_subtitles()
    mp.commandv("rescan-external-files", "reselect")
    mp.osd_message("🔄 Subtitles re-scanned and loaded", options.osd_duration)
end

mp.add_key_binding("Ctrl+Shift+s", "download-subtitles", download_and_load_subtitles)
mp.add_key_binding("Ctrl+S", "download-subtitles-alias", download_and_load_subtitles)

mp.add_key_binding("Ctrl+Shift+r", "rescan-subtitles", rescan_subtitles)
mp.add_key_binding("Ctrl+R", "rescan-subtitles-alias", rescan_subtitles)
