#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# This script trusts all *.desktop files on desktop (~/Desktop)
# Note that it DOESN'T change the mod to executable
# Script can only be run after the XFCE had a first start
# NOTE: this is only utility script, for user interaction

# Exit on error
set -e

for file in ~/Desktop/*.desktop; do
    echo "$file"
    sha256sum=$(sha256sum "$file" | awk '{print $1}')
    gio set "$file" metadata::xfce-exe-checksum "$sha256sum"
    chmod +x "$file"
done