#!/usr/bin/env bash
# Ultra-fast Native Wayland 1080p 60FPS Screen Recording directly to OBS via SRT

SRT_URL="${1:-srt://192.168.1.43:8890?mode=caller&pkt_size=1316}"

echo "Streaming 1080p 60FPS screen directly to OBS at: ${SRT_URL}"

exec wf-recorder \
  -r 60 \
  -F 'scale=1920:1080:flags=fast_bilinear' \
  -c h264_nvenc \
  -p preset=p1 \
  -p tune=ull \
  -p rc=constqp \
  -p qp=20 \
  -p zerolatency=1 \
  -p bf=0 \
  -p rc-lookahead=0 \
  -p delay=0 \
  -p surfaces=2 \
  -p g=60 \
  -p forced-idr=1 \
  --muxer=mpegts \
  -f "${SRT_URL}"
