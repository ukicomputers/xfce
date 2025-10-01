#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# This script prepares and starts XFCE desktop (as user because of requirements)
set -e

# Initialize the dbus variables
eval $(dbus-launch --sh-syntax --exit-with-session)

# Launch PulseAudio
if [ -d /etc/pulse ]; then
    pulseaudio --daemonize=no --exit-idle-time=-1 &
fi

# Launch VNC (with XFCE)
startxfce4

# closing end
if [ -d /etc/pulse ]; then
    pulseaudio --kill || true
fi