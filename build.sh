set -x

#
# PEAMBLE:
#
# Before building the container, copy any local-system files
#  in to the context image so they can be copied in to the
#  container
#

#
# copy the README.md file
#
# keep a copy of the README in the docker image
#
cp README.md context/root

#
# build the docker image
#
# Everything that is in the container is found in the 'context' subfolder
#  of this project directory.  In 'context' is the Dockerfile and 
#  everything else necessary for this build.
#
echo "building docker devtools image"
docker build -t="lorimark/gnucash-devkit" context

#
# run the docker
#
# This runs the gnucash-devkit container, hooking it in to
#  the local file system for logging and other things.
#
#  docker run                             \
#    -it                                  \
#    --rm                                 \
#    --net host                           \
#    -u $(id -u ${USER}):$(id -g ${USER}) \
#    -v /etc/passwd:/etc/passwd           \
#    -v /etc/group:/etc/group             \
#    -v /home:/home                       \
#    -e "TERM=xterm-256color"             \
#    -w ${PWD}                            \
#    lorimark/gnucash-devkit



