#
# This runs the gnucash-devkit container as root.
#  This is useful is something needs to be done
#  inside the container as 'root'.
#
#

docker run                             \
  -it                                  \
  --rm                                 \
  --net host                           \
  -v /home:/home                       \
  -e "TERM=xterm-256color"             \
  -w ${PWD}                            \
  lorimark/gnucash-devkit              \
  /bin/bash

