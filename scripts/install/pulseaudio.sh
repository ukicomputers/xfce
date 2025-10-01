#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs PulseAudio and sets up TCP communication protocol @ 4713

# exit on error
set -e

# Install PulseAudio
apt install -y pulseaudio

# Enable user access
groupadd -f pulse-access
usermod -aG pulse-access $DEFAULT_USER