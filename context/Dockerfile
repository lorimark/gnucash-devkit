# Run GnuCash in a container
#

#
#
FROM ubuntu:latest
LABEL description "gnucash-devkit"
LABEL maintainer "Mark Petryk <mark@lorimarksolutions.com>"

RUN export DEBIAN_FRONTEND=noninteractive

#
# Setup the time-zone on the server to prevent the apt installs
#  from blocking on the time-zone dialog queries
#
RUN apt-get update                                             \
 &&  apt-get -y install apt-utils                              \
 &&  apt-get -y install tzdata                                 \
 &&  ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime \
 &&  dpkg-reconfigure --frontend noninteractive tzdata

#
# Install the base tools.  These tools are not necessary, but they
#  are handy to keep in the dev container.  It makes the devkit
#  somewhat portable... take all your tools with you!
#
RUN apt-get update -q              \
 && apt-get install -y -q          \
      wget                         \
      mc                           \
      vim                          \
      wget

#
# Install the dev libraries
#
RUN apt-get update -q              \
 && apt-get install -y -q          \
      libglib2.0-dev               \
      pkg-config                   \
      cmake                        \
      git                          \
      gettext                      \
      gcc                          \
      g++                          \
      libxml2-dev                  \
      libxslt1-dev                 \
      xsltproc                     \
      webkit2gtk-4.0-dev           \
      swig                         \
      guile-2.2-dev                \
      gwenhywfar-tools             \
      build-essential              \
      libofx-dev                   \
      libgtest-dev                 \
      libdbi-dev                   \
      libxml2-utils                \
      libboost-all-dev             \
      libboost-date-time-dev       \
      libboost-filesystem-dev      \
      libboost-locale-dev          \
      libboost-regex-dev           \
      libboost-program-options-dev \
      libboost-system-dev

#
# update sources.list so we can pull the "build-dep gnucash" below
#
RUN sed -i '/^#.*deb-src/s/^#//' /etc/apt/sources.list

#
# Grab the gnucash build dependencies
#
RUN apt-get update -q \
 && apt-get -y build-dep gnucash

#
# Copy everything else out from 'root' that we want in the image.
#
COPY root /

