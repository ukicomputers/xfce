#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# This script places .desktop files for Microsoft 365 Office to default user's desktop and sets it as a application in the "Apps" menu
# https://office.com

set -e
apps=("word.desktop" "powerpoint.desktop" "excel.desktop")

for app in "${apps[@]}"; do
    path="install/msoffice/$app"
    cp $path $DESKTOP_PATH
    cp $path /usr/share/applications
    chmod +x $DESKTOP_PATH/$app
    chown $DEFAULT_USER $DESKTOP_PATH/$app
done