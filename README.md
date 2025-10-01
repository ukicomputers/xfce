# xfce
Minimal optimized XFCE desktop Docker image for interfacing virtually (thin clients and similar). It includes every required essential for normal user usage including (depending on your image build):
- Firefox
- LibreOffice
- Microsoft Office
- Python IDLE
- GIMP
- Essentials (Ristretto image viewer, Mousepad, nano, wget and similar)

It is optimised to be used remotely with X streaming software, ideally with [unicap](https://github.com/ukicomputers/unicap). You can see full usage demo on the video [here]().

![example image](https://hc-cdn.hel1.your-objectstorage.com/s/v3/d725c9457ad23e763a93158973bf6ae328b68484_img_20250728_162801.jpg)
*(picture showing running XFCE desktop environment remotely via unicap on STM32F7 series microcontroller)*

## Building image
You can set some of the *arguments* (for image build) that you like for your desktop environment. It is recommended that you see `Dockerfile` for more information about build arguments, and build defaults. Currently available are:
- `DEFAULT_USER` - sets the username of default user (recommended is "user")
- `INSTALL_ESSENTIALS` - installs Xfce GUI essentials and other importan terminal apps (note that Xfce is already included, this is dedicated image)
- `INSTALL_FIREFOX` - installs Firefox web browser
- `INSTALL_LIBREOFFICE` - installs LibreOffice office suite
- `INSTALL_MSOFFICE` - adds files on desktop and "Apps" menu for online Microsoft Office (not real installation)
- `INSTALL_IDLE` - installs IDLE, the Python's interactive GUI
- `INSTALL_GIMP` - installs GIMP from apt (may be older version)
- `CUSTOMIZE` - customizes the XFCE for much better usability and ready -sage out of box (RECOMMENDED, may set custom background, see the script)
- `SET_TIMEZONE` - sets timezone. see /usr/share/zoneinfo
- `SETUP_AUDIO` - installs PulseAudio as a client

Simply, to build our image, use `docker build` command in repository root. We'll use `zerogrid-xfce-ubuntu2404-igpu` tag here, and install LibreOffice office suite: 
```bash
docker build -t zerogrid-xfce-ubuntu2404-igpu --build-arg INSTALL_LIBREOFFICE=1 .
```

## Usage
Since we need X display, for sake of usage, we'll easily launch accelerated Xwayland server. Since we want X server communication to be encrypted on sockets from end to end, we need to generate cookies for both ends. You may use following script to generate it.
```bash
#!/bin/bash
# usage: cookie.sh <X display> <local cookie file path> <remote cookie file path>
set -e

display="$1"
localcookiefile="$2"
remotecookiefile="$3"

if [[ -z $display || -z $localcookiefile || -z $remotecookiefile ]]; then
    exit -1
fi

touch "$localcookiefile"
xauth -f "$localcookiefile" -n add "$display" . "$(mcookie)"
remotecookie="$(xauth -f "$localcookiefile" nlist "$display" | sed -e 's/^..../ffff/')"
touch "$remotecookiefile"
echo "$remotecookie" | xauth -f "$remotecookiefile" nmerge -
```
We can get the next free X display number by just looking in the `/tmp/.X11-unix`, finding the maximal X display number and choosing the next one (pseudo-code `(ls -1 /tmp/.X11-unix | max) + 1`). Then just run `cookie.sh`:
```bash
bash cookies.sh 2 local.auth remote.auth
```
The script will generate `local.auth` and `remote.auth` for X display `2`. After that, simply lanch Xwayland display locally:
```bash
Xwayland :2 -nolisten tcp +extension GLX +extension RENDER +extension RANDR -force-xrandr-emulation -auth local.auth
```
Now, **we can** launch our desktop environment with Docker, but before that it is recommended that we setup networking. Here, we'll just use bridge network (since hostname management **won't work** if we use **host** networking). We'll call it `xfce`:
```bash
docker network create --driver bridge xfce
```
Finally, launch the container. Notice that we use `/tmp/.X11-unix/X2` for our `:2` X display, we also pass our external auth file, and share the rendering device with required privileges, with using image name from above:
```bash
docker run -it --network xfce --name xfce -P -v /tmp/.X11-unix/X2:/tmp/.X11-unix/X2:ro -v remote.auth:/home/user/.Xauthority:rw --device /dev/renderD128:/dev/renderD128 --group-add $(getent group render | cut -d: -f3) zerogrid-xfce-ubuntu2404-igpu
```
Note that you need to set `LIBVA_DRIVER_NAME` if you have Intel CPU:
- add `-e LIBVA_DRIVER_NAME=iHD` if you have newer (10+ gen) Intel CPU with Iris graphics
- add `-e LIBVA_DRIVER_NAME=i915` for older Intel CPUs

Otherwise, container startup will fail.

Once we started it, you can interact with it in Xwayland window. You can also start [unicap](https://github.com/ukicomputers/unicap) and interact with remotely on the other machine on port *1234*:
```bash
XAUTHORITY=local.auth DISPLAY=:2 ./unicap-v1.0-x86_64 --port 1234
```

## License
This ready environment and Docker image can't be used within any of commerical or monetization type of projects. If used somewhere, like in open source projects, it would be nice if cited like:
```
XFCE dedicated desktop made by @ukicomputers
```

xfce is part of **ZeroGrid** project.
