#!/usr/bin/env bash
# Ultra-fast Native Wayland 1080p Stream (Video-Only, 2s GOP, CQP 18)

RTMP_URL="${1:-rtmp://mac.local/live/test_stream_key}"

echo "Starting native Wayland 1080p video-only stream to: ${RTMP_URL}"

exec wf-recorder \
  -F 'scale=1920:1080:flags=bicubic' \
  -c h264_nvenc \
  -p preset=p1 \
  -p tune=ull \
  -p delay=0 \
  -p rc-lookahead=0 \
  -p surfaces=1 \
  -p rc=constqp \
  -p qp=18 \
  -p g=60 \
  -p bf=0 \
  --muxer=flv \
  -f "${RTMP_URL}"
