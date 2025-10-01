#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

set -e

cp help/help.desktop $DESKTOP_PATH
chown $DEFAULT_USER $DESKTOP_PATH/help.desktop
chmod +x $DESKTOP_PATH/help.desktop

cp help/help.desktop /usr/share/applications