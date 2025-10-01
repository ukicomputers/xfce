#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# This script customizes the default look of XFCE for better usability via VNC connection
# - changes the xfce4-panel (see panel.xml)
# - modifies the desktop icons and background
# - switches workspaces number to 1
# - sets default keyboard layout (defined in keyboard.xml)

set -e

# Change the default keyboard settings
cp customize/keyboard.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml

# Change the default panel config
cp customize/panel.xml /etc/xdg/xfce4/panel/default.xml

# Modify the desktop configuration
cp customize/desktop.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

# Switch workspaces to 1
sed -i "/workspace_count/ s/=.*/=1/" /usr/share/xfwm4/defaults