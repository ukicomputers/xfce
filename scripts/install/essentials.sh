#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs XFCE GUI essentials and some other important terminal apps
# You can see the list of installed packages below.

# Exit immediately on error
set -e

apt install -y gnome-system-monitor \
               xfce4-screenshooter \
               mousepad \
               ristretto \
               thunar-archive-plugin \
               xfce4-terminal \
               curl \
               nano \
               wget

# Make XFCE terminal as a default terminal application
sed -i "/TerminalEmulator/ s/=.*/=xfce4-terminal/" /etc/xdg/xfce4/helpers.rc