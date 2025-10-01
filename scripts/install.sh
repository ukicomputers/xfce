#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# TODO: switch mirrors to region
# TODO: add xrandr server modification (OR INITIALIZE X VNC SCRAPER)

# This script sets up XFCE desktop.
# Note that some additional packages and customizations are provided (check Dockerfile).
# Also note that all "customizations" below are absolutely not required (but they are mading experience much better).

# Exit immediately on error
set -e

# remove default user
userdel -r ubuntu

# Installing the minimal required things & things for operating with terminal
export DEBIAN_FRONTEND="noninteractive"

apt update
apt install -y xfce4 \
               dbus-x11 \
               sudo

# Making the user
useradd -m -s /bin/bash $DEFAULT_USER
usermod -aG sudo $DEFAULT_USER
echo "$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd
chmod 0440 /etc/sudoers.d/nopasswd

# Installing the customizations
export DESKTOP_PATH="/home/$DEFAULT_USER/Desktop"
mkdir -p $DESKTOP_PATH
chown $DEFAULT_USER $DESKTOP_PATH

if [[ -n "$INSTALL_ESSENTIALS" && "$INSTALL_ESSENTIALS" == "1" ]]; then
    bash install/essentials.sh
fi

if [[ -n "$INSTALL_FIREFOX" && "$INSTALL_FIREFOX" == "1" ]]; then
    bash install/firefox.sh
fi

if [[ -n "$INSTALL_LIBREOFFICE" && "$INSTALL_LIBREOFFICE" == "1" ]]; then
    bash install/libreoffice.sh
fi

if [[ -n "$INSTALL_MSOFFICE" && "$INSTALL_MSOFFICE" == "1" ]]; then
    bash install/msoffice/install.sh
fi

if [[ -n "$INSTALL_IDLE" && "$INSTALL_IDLE" == "1" ]]; then
    bash install/idle.sh
fi

if [[ -n "$INSTALL_GIMP" && "$INSTALL_GIMP" == "1" ]]; then
    bash install/gimp.sh
fi

if [[ -n "$CUSTOMIZE" && "$CUSTOMIZE" == "1" ]]; then
    bash customize/customize.sh
fi

if [[ -n "$SETUP_AUDIO" && "$SETUP_AUDIO" == "1" ]]; then
    bash install/pulseaudio.sh
fi

bash help/help.sh

# Changing the timezone
if [[ -n "$SET_TIMEZONE" ]]; then
    if [[ -f "/usr/share/zoneinfo/$SET_TIMEZONE" ]]; then
        ln -sf /usr/share/zoneinfo/$SET_TIMEZONE /etc/localtime
        dpkg-reconfigure -f noninteractive tzdata
    fi
fi

# Fix polkit
PKEXEC_PATH="/usr/bin/pkexec"
mv $PKEXEC_PATH $PKEXEC_PATH.bak
mv pkexec $PKEXEC_PATH
chmod +x $PKEXEC_PATH

# Remove the remains
rm -rf /var/lib/apt/lists/*
find . -type f -name "*.sh" ! -name "run.sh" ! -name "user_run.sh" ! -name "dotdesktop_trust.sh" -exec rm {} +
find . -type f -name "*.desktop" -exec rm {} +
rm -rf customize/*.xml