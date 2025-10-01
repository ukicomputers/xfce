#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs Firefox
# All commands below are fetched from Firefox's webiste.
# https://support.mozilla.org/en-US/kb/install-firefox-linux

# Exit immediately on error
set -e

# (installation script begin)
install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla 
apt update
apt install -y firefox

# Create desktop installation entry
cp /usr/share/applications/firefox.desktop $DESKTOP_PATH
chmod +x $DESKTOP_PATH/firefox.desktop
chown $DEFAULT_USER $DESKTOP_PATH/firefox.desktop

# Make Firefox default web browser
sed -i "/WebBrowser/ s/=.*/=firefox/" /etc/xdg/xfce4/helpers.rc