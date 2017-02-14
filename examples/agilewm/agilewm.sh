#!/bin/sh
# It's assumed you're running this from the agilewm directory.
# Xephyr supports multiple screens (useful for testing!)
# Xephyr :82 -screen 800x600 -screen 400x300 &
Xephyr :82 -screen 800x600 &
sleep 1
DISPLAY=:82.0
xterm &
sleep 1
../../ljwm agilewm.lua modules/*
