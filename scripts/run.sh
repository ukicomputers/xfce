#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# This script prepares and starts XFCE desktop on existing X server
set -e
echo "ZeroGrid XFCE desktop v1.0"

if [ -z "$DISPLAY" ]; then
    echo "Refusing to start since external DISPLAY number isn't provided (DISPLAY_NOT_PROVIDED)"
    exit -1
fi

USER_HOME="/home/$DEFAULT_USER"
XAUTHORITY="$USER_HOME/.Xauthority"

if [ ! -f "$XAUTHORITY" ]; then
    echo "Refusing to start since display authority isn't granted (XCOOKIE_NOT_PROVIDED)"
    exit -1
fi

if [ ! -e /dev/dri/renderD128 ]; then
    echo "Rendering interface isn't provided, refusing to start (RENDER_NOT_FOUND)"
    exit -1
fi

RENDER_GID=$(stat -c "%g" /dev/dri/renderD128)
usermod -aG $RENDER_GID $DEFAULT_USER

chown $DEFAULT_USER $XAUTHORITY

# Start the dbus service
service dbus start

# Initialize the XDG_RUNTIME_DIR
XDG_RUNTIME_DIR="/run/user/$(id -u $DEFAULT_USER)"
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
chown $DEFAULT_USER $XDG_RUNTIME_DIR

# Start the desktop
ENV="XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR DISPLAY=$DISPLAY"

if grep -i "intel" /proc/cpuinfo > /dev/null; then
    if [ -z "$LIBVA_DRIVER_NAME" ]; then
        echo "Refusing to start until Intel libva driver name is provided (LIBVA_NOT_SPECIFIED)"
        exit -1
    else
        ENV+=" LIBVA_DRIVER_NAME=$LIBVA_DRIVER_NAME"
    fi
fi

if [ -n "$PULSE_SERVER" ]; then
    ENV+=" PULSE_SERVER=$PULSE_SERVER"
fi

su - $DEFAULT_USER -c "$ENV bash /scripts/user_run.sh"