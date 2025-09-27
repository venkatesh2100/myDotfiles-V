#!/bin/bash

RECORD_PID_FILE="/tmp/wf-recording.pid"

if [ -f "$RECORD_PID_FILE" ] && kill -0 "$(cat "$RECORD_PID_FILE")" 2>/dev/null; then
    echo '{"text": "⏹", "tooltip": "Recording", "class": "recording"}'
else
    echo '{"text": "\ueef8", "tooltip": "Not recording", "class": "idle"}'
fi
