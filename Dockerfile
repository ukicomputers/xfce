# ZeroGrid XFCE dedicated desktop
# Written by Ugljesa Lukesevic. All rights reserved.
FROM ubuntu:noble

# Build arguments
# DEFAULT_USER - sets the username of default user (recommended is "user")

# INSTALL_ESSENTIALS - installs Xfce GUI essentials and other important terminal apps (note that Xfce is already included, this is dedicated image)
# INSTALL_FIREFOX - installs Firefox web browser
# INSTALL_LIBREOFFICE - installs LibreOffice office suite
# INSTALL_MSOFFICE - adds files on desktop and "Apps" menu for online Microsoft Office (not real installation)
# INSTALL_IDLE - installs IDLE, the Python's interactive GUI
# INSTALL_GIMP - installs GIMP from apt (may be older version)
# CUSTOMIZE - customizes the XFCE for much better usability and ready usage out of box (RECOMMENDED, may set custom background, see the script)

# SET_TIMEZONE - sets timezone. see /usr/share/zoneinfo

# SETUP_AUDIO - installs PulseAudio as a client

ARG DEFAULT_USER="user"
ARG INSTALL_ESSENTIALS=1
ARG INSTALL_FIREFOX=1
ARG INSTALL_LIBREOFFICE=0
ARG INSTALL_MSOFFICE=0
ARG INSTALL_IDLE=0
ARG INSTALL_GIMP=0
ARG CUSTOMIZE=1
ARG SET_TIMEZONE="Europe/Belgrade"
ARG SETUP_AUDIO=1

ENV DEFAULT_USER=$DEFAULT_USER

# Install process
COPY scripts /scripts
WORKDIR /scripts
RUN bash install.sh

# Use home by newly created user
WORKDIR /home/$DEFAULT_USER

# Start the desktop by executing run script
CMD ["bash", "/scripts/run.sh"]