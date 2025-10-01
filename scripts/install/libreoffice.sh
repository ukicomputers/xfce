#!/bin/bash

# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.

# Installs LibreOffice office suite
# Contains: 
# - LibreOffice Writer (similar to Microsoft Word)
# - LibreOffice Impress (similar to Microsoft PowerPoint)
# - LibreOffice Calc (similar to Microsoft Excel)

# Exit immediately on error
set -e

apt install -y libreoffice-writer \
               libreoffice-impress \
               libreoffice-calc

# Create desktop installation entries
apps=("libreoffice-writer.desktop" "libreoffice-impress.desktop" "libreoffice-calc.desktop")

for app in "${apps[@]}"; do
    cp /usr/share/applications/$app $DESKTOP_PATH
    chmod +x $DESKTOP_PATH/$app
    chown $DEFAULT_USER $DESKTOP_PATH/$app
done
