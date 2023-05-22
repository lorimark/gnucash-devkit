#
# This runs the gnucash-devkit container, hooking it in to
#  the local file system for logging and other things.
#
#

docker run                               \
  -it                                    \
  --rm                                   \
  --net host                             \
  -u $(id -u ${USER}):$(id -g ${USER})   \
  -v /etc/passwd:/etc/passwd             \
  -v /etc/group:/etc/group               \
  -v /home:/home                         \
  -v /tmp/.X11-unix:/tmp/.X11-unix       \
  -v $HOME/.Xauthority:$HOME/.Xauthority \
  -e "TERM=xterm-256color"               \
  -e "DISPLAY=$DISPLAY"                  \
  -w ${PWD}                              \
  lsus1:5000/gnucash-devkit              \
  /bin/bash

