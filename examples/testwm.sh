#!/bin/sh
# It's assumed you're running this from the ljwm clone root directory.
Xephyr :82 &
sleep 1
DISPLAY=:82
xterm &
sleep 1
./ljwm examples/testwm.lua
