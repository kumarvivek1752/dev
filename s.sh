#!/usr/bin/env bash

RTMP_URL="${1:-rtmp://mac.local/live/test_stream_key}"

echo "$RTMP_URL"

wf-recorder \
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
  -p g=30 \
  -p forced-idr=1 \
  --muxer=flv \
  -f "$RTMP_URL"
