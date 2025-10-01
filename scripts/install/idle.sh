#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs Python 3 IDLE (idle3)
# Also makes sure that python3 is also installed (but should already be since deps require it)

# Exit immediately on error
set -e

# Install packages
apt install -y python3 idle3

# Create desktop installation entry
cp /usr/share/applications/idle.desktop $DESKTOP_PATH
chmod +x $DESKTOP_PATH/idle.desktop
chown $DEFAULT_USER $DESKTOP_PATH/idle.desktop