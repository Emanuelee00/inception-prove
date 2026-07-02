#!/bin/bash
set -e  # exit immediately if any command fails

export SDL_AUDIODRIVER=dummy  # no real audio device in the container, avoid SDL init error

Xvfb :99 -screen 0 1200x900x24 &  # match the game's window size (SCREEN_WIDTH/HEIGHT in settings.py), or it gets cropped
sleep 1  # give Xvfb time to be ready before anything connects to it

x11vnc -display :99 -forever -shared -nopw -rfbport 5900 -bg
# share display ":99" over VNC on port 5900 (internal only, so -nopw is fine)
# -forever: keep running after a client disconnects, -shared: allow multiple viewers
# -bg: daemonizes itself, no trailing "&" needed

websockify --web=/usr/share/novnc 6080 localhost:5900 &
# bridge VNC (TCP) to WebSocket so browsers can connect, on port 6080
# also serves the noVNC HTML/JS client via --web

cd /pacman  # the game repo, cloned here by the Dockerfile
export DISPLAY=:99  # tell pygame/SDL to draw on our virtual display
exec uv run python3 pac-man.py
# "exec" makes the game PID 1: if it crashes, the container exits and restarts
