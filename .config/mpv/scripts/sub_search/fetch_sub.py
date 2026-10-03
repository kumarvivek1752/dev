#!/usr/bin/env python3
"""
fetch_sub.py
Helper script for MPV sub_search plugin.
Searches and downloads English subtitles directly into the media directory.
"""

import sys
import os
import urllib.request
import urllib.parse
import json
import zipfile
import gzip
import io
import re

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "application/json, text/plain, */*",
    "Accept-Language": "en-US,en;q=0.9"
}

def clean_title(filename):
    name = os.path.splitext(os.path.basename(filename))[0]

    # Strip web watermark domains (.tube, .ngo, .com, .net, etc.)
    tlds = ["tube", "ngo", "com", "net", "org", "vip", "to", "in", "tv", "me", "co", "cc", "site", "xyz", "club", "top"]
    for tld in tlds:
        name = re.sub(r"[\w\-_]+\." + tld + r"\b", " ", name, flags=re.I)

    # Normalize delimiters and brackets
    name = re.sub(r"[\._\+\[\]\(\)\{\}]", " ", name)
    name = re.sub(r"\s+", " ", name).strip()

    # TV Season & Episode
    tv_match = re.search(r"([sS]\d\d?[eE]\d\d?|\d\d?x\d\d?)", name)
    if tv_match:
        before = name[:tv_match.start()].strip()
        return f"{before} {tv_match.group(1)}"

    # 4-Digit Year
    year_match = re.search(r"\b(19\d\d|20\d\d)\b", name)
    if year_match:
        before = name[:year_match.end()].strip()
        return before

    # Cut markers if no year
    cut_markers = r"\b(2160p|1080p|720p|480p|4k|bluray|bdrip|web-?dl|web-?rip|hdtv|x264|x265|hevc|10bit)\b"
    cut_match = re.search(cut_markers, name, flags=re.I)
    if cut_match:
        return name[:cut_match.start()].strip()

    return name

def strip_year(title):
    return re.sub(r"\s+\b(19\d\d|20\d\d)\b", "", title).strip()

def download_from_opensubtitles(query, target_srt):
    encoded = urllib.parse.quote(query)
    api_url = f"https://api.opensubtitles.com/api/v1/subtitles?query={encoded}&languages=en"

    req = urllib.request.Request(api_url, headers=HEADERS)
    try:
        with urllib.request.urlopen(req, timeout=8) as r:
            data = json.loads(r.read().decode())
    except Exception as e:
        sys.stderr.write(f"OpenSubtitles API error for '{query}': {e}\n")
        return False

    results = data.get("data", [])
    if not results:
        return False

    # Iterate matches to find downloadable subtitle
    for sub in results[:5]:
        legacy_id = sub.get("attributes", {}).get("legacy_subtitle_id")
        if not legacy_id:
            continue

        dl_url = f"https://dl.opensubtitles.org/en/download/sub/{legacy_id}"
        dl_req = urllib.request.Request(dl_url, headers=HEADERS)
        try:
            with urllib.request.urlopen(dl_req, timeout=8) as dl_r:
                content = dl_r.read()
        except Exception as e:
            sys.stderr.write(f"Download error for id {legacy_id}: {e}\n")
            continue

        # Extract SRT
        srt_data = None
        if content.startswith(b"PK"):
            try:
                with zipfile.ZipFile(io.BytesIO(content)) as z:
                    for fname in z.namelist():
                        if fname.lower().endswith(".srt"):
                            srt_data = z.read(fname)
                            break
            except Exception as e:
                sys.stderr.write(f"Unzip error: {e}\n")
        elif content.startswith(b"\x1f\x8b"):
            try:
                srt_data = gzip.decompress(content)
            except Exception as e:
                sys.stderr.write(f"Gzip error: {e}\n")
        elif b"-->" in content:
            srt_data = content

        if srt_data and len(srt_data) > 100:
            with open(target_srt, "wb") as f:
                f.write(srt_data)
            return True

    return False

def main():
    if len(sys.argv) < 2:
        print("Usage: fetch_sub.py <video_path> [clean_title]")
        sys.exit(1)

    video_path = sys.argv[1]
    if not os.path.exists(video_path):
        sys.stderr.write(f"File does not exist: {video_path}\n")
        sys.exit(1)

    custom_title = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2].strip() else None
    title = custom_title or clean_title(video_path)

    # Destination subtitle file
    base, _ = os.path.splitext(video_path)
    target_srt = f"{base}.en.srt"

    queries = [title]
    no_year = strip_year(title)
    if no_year and no_year != title:
        queries.append(no_year)

    for q in queries:
        sys.stderr.write(f"Querying OpenSubtitles for '{q}'...\n")
        if download_from_opensubtitles(q, target_srt):
            print(f"SUCCESS:{target_srt}")
            sys.exit(0)

    # Secondary fallback: try subliminal CLI if available
    subliminal_bin = "/home/vivek/.local/bin/subliminal"
    if os.path.exists(subliminal_bin):
        sys.stderr.write(f"Trying secondary fallback with subliminal...\n")
        import subprocess
        try:
            res = subprocess.run([subliminal_bin, "download", "-l", "en", video_path],
                                 capture_output=True, text=True, timeout=12)
            if os.path.exists(target_srt) or os.path.exists(f"{base}.srt"):
                print(f"SUCCESS:{target_srt}")
                sys.exit(0)
        except Exception as e:
            sys.stderr.write(f"Subliminal error: {e}\n")

    print(f"FAIL:No subtitles found for {title}")
    sys.exit(2)

if __name__ == "__main__":
    main()
