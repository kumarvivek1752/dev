#!/usr/bin/env bash
# RTMP Stream Benchmark Script for mac.local

RTMP_URL="${1:-rtmp://localhost/live/test_stream_key}"
SSH_HOST="${2:-mac.local}"

echo "=========================================================="
echo " 📡 RTMP Stream Benchmark Analysis"
echo " Target Host: ${SSH_HOST}"
echo " Stream URL : ${RTMP_URL}"
echo "=========================================================="
echo ""

echo "Fetching stream metadata via ffprobe on ${SSH_HOST}..."

PROBE_JSON=$(ssh "${SSH_HOST}" "export PATH=/opt/homebrew/bin:/usr/local/bin:\$PATH; ffprobe -v quiet -print_format json -show_format -show_streams '${RTMP_URL}'" 2>/dev/null)

if [ -z "${PROBE_JSON}" ]; then
  echo "❌ Error: Could not reach RTMP stream at ${RTMP_URL} on ${SSH_HOST}."
  echo "Make sure your stream is running and the RTMP server is active."
  exit 1
fi

python3 - <<EOF
import json, sys

data = json.loads('''${PROBE_JSON}''')
streams = data.get("streams", [])
if not streams:
    print("❌ No active video streams found!")
    sys.exit(1)

vstream = streams[0]
width = vstream.get("width", 0)
height = vstream.get("height", 0)
codec = vstream.get("codec_name", "unknown")
profile = vstream.get("profile", "unknown")
pix_fmt = vstream.get("pix_fmt", "unknown")
b_frames = vstream.get("has_b_frames", 0)
r_fps = vstream.get("r_frame_rate", "0/1")

num, den = map(float, r_fps.split('/'))
fps = round(num / den, 2) if den > 0 else 0

print("🎥 STREAM SPECIFICATIONS:")
print(f"  • Resolution   : {width}x{height}")
print(f"  • Codec/Profile: {codec.upper()} ({profile})")
print(f"  • Pixel Format : {pix_fmt}")
print(f"  • Frame Rate   : {fps} FPS")
print(f"  • B-Frames     : {b_frames}")
print("\n📋 TWITCH / YOUTUBE INGEST COMPLIANCE:")

# Resolution Check
if width == 1920 and height == 1080:
    print("  [PASS] Resolution  : 1080p (1920x1080)")
else:
    print(f"  [WARN] Resolution  : {width}x{height} (Expected 1920x1080)")

# Pixel Format Check
if pix_fmt in ["yuv420p", "nv12"]:
    print(f"  [PASS] Pixel Format: {pix_fmt} (Broadcast Standard)")
else:
    print(f"  [FAIL] Pixel Format: {pix_fmt} (Twitch/YouTube require yuv420p/nv12)")

# Codec Check
if codec.lower() == "h264":
    print("  [PASS] Codec       : H.264")
else:
    print(f"  [FAIL] Codec       : {codec}")

# B-Frames Check
if b_frames == 0:
    print("  [PASS] Latency     : 0 B-Frames (Zero Latency Enabled)")
else:
    print(f"  [INFO] B-Frames    : {b_frames}")

print("==========================================================")
EOF
