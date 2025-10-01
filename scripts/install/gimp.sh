#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs GNU Image Manipulation Program (GIMP)
# Note: since AppArmor creates problems for snap and flatpak, GIMP is installed from apt
# GIMP from apt MAY BE outdated

# Exit immediately on error
set -e

# Install packages
apt install -y gimp

# Create desktop installation entry
cp /usr/share/applications/gimp.desktop $DESKTOP_PATH
chmod +x $DESKTOP_PATH/gimp.desktop
chown $DEFAULT_USER $DESKTOP_PATH/gimp.desktop